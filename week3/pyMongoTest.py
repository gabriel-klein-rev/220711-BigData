from pymongo import MongoClient 
import json

def main():
    client = MongoClient()

    db = client.get_database("220711_w3")

    collection = db.Employees

    newEmployee = {'name' : 'Fred', 'age' : 28}

    collection.insert_one(newEmployee)


    newEmployeesLst = [
        {'name' : 'Greg', 'age' : 35},
        {'name' : 'Rachel', 'age' : 22},
        {'name' : 'Stacy', 'age' : 47},
        {'name' : 'George', 'age' : 34}
    ]

    #collection.insert_many(newEmployeesLst)


    
    with open("employees.json") as f:
        file_data = json.load(f)

    collection.insert_many(file_data)

    allEmployees = collection.find()

    for employee in allEmployees:
        print(employee)





if __name__ == '__main__':
    main()