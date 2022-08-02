from pymongo import MongoClient 
import json

def main():
    client = MongoClient()

    db = client.get_database("220711_w3")

    collection = db.Orders

    '''
    with open("orders.json", 'r') as f:
        file_data = json.load(f)

    collection.insert_many(file_data)
    '''

    sumAllOrders = collection.aggregate([{ "$group" : {"_id" : "$customerName", "total_orders" : {"$sum" : 1}}}])
    # SELECT customerName, SUM(amount) AS total_amount FROM Orders GROUP BY customerName;

    for elem in sumAllOrders:
        print(f"The total number of orders we recieved from {elem['_id']} is {elem['total_orders']}")
        #print(elem)


if __name__ == "__main__":
    main()