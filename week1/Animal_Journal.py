from Animals import Animal, Dog, Cat, Horse
import re
import logging

# For mysql connection. mysql_config is for my personal login information
import mysql.connector
import mysql_config as c


# TODO: When we insert animal to csv, insert into db as well, Exception handling
# Stretch goal: Be able to modify animals, call methods


def main():

    try:
        cnx = mysql.connector.connect(user=c.user, password=c.password, host=c.host, database="220711_w2")
        cursor = cnx.cursor()
    except mysql.connector.Error as mce:
        print(mce.msg)
        return
    except Exception as e:
        print("ERROR: Exiting program")
        return


    logging.basicConfig(filename="Animal_Journal.log", level=logging.DEBUG, format='%(asctime)s :: %(message)s')

    print("*** WELCOME TO THE ANIMAL JOURNAL! ***")

    fname = "all_animals.csv"
    '''
        lst_animals = []
        lst_animals = load_animals(fname)

    '''
    lst_animals = load_animals_db(cursor)

    logging.info("Loaded animals into lst_animals...")

    while(True):
        animal = insert_animal(cursor)
        if animal == 1:
            cnx.commit()
            lst_animals = load_animals_db(cursor)
            continue

        if animal == None:
            break
        logging.info("Inserted a new animal...")        
        lst_animals.append(animal)
        if type(animal) == Cat:
            add_animal_db = f"INSERT INTO animals (name, age, color, type) VALUES ('{animal._name}', {animal._age}, '{animal._color}', 'Cat')"
        elif type(animal) == Dog:
            add_animal_db = f"INSERT INTO animals (name, age, color, type) VALUES ('{animal._name}', {animal._age}, '{animal._color}', 'Dog')"
        else:
            add_animal_db = f"INSERT INTO animals (name, age, color, type) VALUES ('{animal._name}', {animal._age}, '{animal._color}', 'Horse')"
        
        cursor.execute(add_animal_db)

    print("\n\n***** All animals *****")
    for elem in lst_animals:
        print(elem)

    save_animals(fname, lst_animals)
    logging.info("Saved animals to " + fname)
    print("\n\n")

    cnx.commit()
    cursor.close()
    cnx.close()



def load_animals_db(cursor) -> list:
    '''
    This function grabs data from our mySQL server which holds
    a record of animals we have inserted. Returns a list of animals
    contained in our animals table
    '''
    query = "SELECT animalID, name, age, type, color FROM animals"

    cursor.execute(query)
    lst_animals = []

    for record in cursor:
        animal = None
        if record[3] == "Cat":
            animal = Cat(record[1], record[2], record[4])
        elif record[3] == "Dog":
            animal = Dog(record[1], record[2], record[4])
        elif record[3] == "Horse":
            animal = Horse(record[1], record[2], record[4])
        else:
            raise Exception("INVALID ANIMAL!")
        
        lst_animals.append(animal)
    
    return lst_animals


def save_animals(fname, lst_animals):
    '''
    save_animals

    This function will take in a list of animals and save them to a csv file.

    Returns None
    '''
    with open(fname, "w") as f:
        for animal in lst_animals:
            if type(animal) == Cat:
                f.write("Cat," + animal._name + "," + str(animal._age) + "," + animal._color + ",\n")
            elif type(animal) == Dog:
                f.write("Dog," + animal._name + "," + str(animal._age) + "," + animal._color + ",\n")
            elif type(animal) == Horse:
                f.write("Horse," + animal._name + "," + str(animal._age) + "," + animal._color + ",\n")
            else:
                pass



def load_animals(fname) -> list:
    '''
    load_animals

    This function will take in a file name representing a csv file of animals to 
    load into an animal list.

    Returns list of Animals
    '''
    lst_animals = []

    with open(fname, "r") as f:
        for line in f:
            info = line.split(',')
            if info[0] == "Cat":
                animal = Cat(info[1], info[2], info[3])
            elif info[0] == "Dog":
                animal = Dog(info[1], info[2], info[3])
            elif info[0] == "Horse":
                animal = Horse(info[1], info[2], info[3])
            else:
                animal = None

            if animal != None:
                lst_animals.append(animal)

    return lst_animals

    
def modify_animal(cursor):
    # If we modify an animal, make sure to reload lst_animals
    query = "SELECT animalID, name, age, type, color FROM animals"

    cursor.execute(query)

    for record in cursor:
        print(f"\t{record[0]}: {record[1]}, age: {record[2]}, color: {record[4]}")

    animal_to_modify = input("Select a record to modify (use animal ID): ")
    col_to_modify = input("Select an attribute to modify (name, age, color): ")
    modified_value = input(f"What do you want to change {col_to_modify} to?")

    if col_to_modify == 'age':
        update_statement = f"UPDATE animals SET {col_to_modify}={modified_value} WHERE animalID={animal_to_modify}"
    else:
        update_statement = f"UPDATE animals SET {col_to_modify}='{modified_value}' WHERE animalID={animal_to_modify}"

    cursor.execute(update_statement)


def insert_animal(cursor) -> Animal:
    '''
    insert_animal

    This function prompts the user for information about what animal 
    to insert into the journal

    Returns Animal
    Returns None if user wants to quit
    '''
    print("\nPlease select which animal you want to enter into the journal:")
    print("\t1) Cat")
    print("\t2) Dog")
    print("\t3) Horse")
    print("\t4) quit")
    print("\t5) Edit record")
    animal_type = input(">>> ")

    if animal_type == "5":
        modify_animal(cursor)
        # If this if statement runs, make sure to reload lst_animals
        return 1


    # Break out of function if user wants to quit
    if animal_type not in ["1", "2", "3"]:
        return None

    while True:
        try:
            name = input("\nEnter animal's name:\n>>>")
            check = re.search(',', name)

            if check != None:
                raise ValueError
        except ValueError as ve:
            print("\nCANNOT HAVE COMMAS IN NAME!\n")
            logging.error("Tried to enter a comma for name, trying again...")
        else:
            break

    while True:
        try:
            age = int(input("\nEnter animal's age:\n>>>"))
        except ValueError as ve:
            print("\nCANNOT ENTER A STRING FOR AGE! PLEASE ENTER AN INTEGER!\n")
            logging.error("Tried to enter a string for age, trying again...")
        else:
            break

    while True:   
        try:
            color = input("\nEnter animal's color:\n>>>")
            check = re.search(',', color)

            if check != None:
                raise ValueError
        except ValueError as ve:
            print("\nCANNOT HAVE COMMAS IN COLOR!\n")
            logging.error("Tried to enter a comma for color, trying again...")
        else:
            break

    if animal_type == "1":
        animal = Cat(name, age, color)
    elif animal_type == "2":
        animal = Dog(name, age, color)
    elif animal_type == "3":
        animal = Horse(name, age, color)
    else:
        animal = None

    return animal


if __name__ == "__main__":
    main()