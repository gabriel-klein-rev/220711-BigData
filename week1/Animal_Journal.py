from Animals import Animal, Dog, Cat, Horse

# # a1 = Animal("fred", 13, "blue")
# # a1.move()

# d1 = Dog("Fido", 10, "brown")
# c1 = Cat("Garfield", 15, "orange")

# lst_Animals = [d1, c1]

# for animal in lst_Animals:
#     animal.sleep()
#     animal.move()
#     animal.getOlder(3)
#     print(animal)

# # c1._name = "asdf"
# c1.setName(5)
# print(c1)

# TODO: Exception handling
# Stretch goal: Be able to modify animals, call methods


def main():

    print("*** WELCOME TO THE ANIMAL JOURNAL! ***")

    fname = "all_animals.csv"
    lst_animals = []
    lst_animals = load_animals(fname)

    while(True):
        animal = insert_animal()
        if animal == None:
            break
        
        lst_animals.append(animal)
    
    print("\n\n***** All animals *****")
    for elem in lst_animals:
        print(elem)

    save_animals(fname, lst_animals)
    print("\n\n")

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

    
def insert_animal() -> Animal:
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
    animal_type = input(">>> ")

    # Break out of function if user wants to quit
    if animal_type == "4":
        return None

    name = input("\nEnter animal's name:\n>>>")
    age = int(input("\nEnter animal's age:\n>>>"))
    color = input("\nEnter animal's color:\n>>>")

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