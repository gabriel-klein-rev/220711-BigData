/***********************************************************************
***** Week 2 Content (SQL commands may be scattered) *******************
***********************************************************************/

##### Tuesday #####

USE 220711_w2;

SELECT * FROM persons;

DROP TABLE persons;

CREATE TABLE persons (
	PersonID int,
    lastname varchar(255),
    firstname varchar(255),
    Address varchar(255) UNIQUE,
    city varchar(255)
);

ALTER TABLE persons ADD PRIMARY KEY (personid);


INSERT INTO persons (personid, lastname, firstname, address, city) VALUES
(1, "Hansen", "Ola", "234 E Broadway", "Minneapolis");


# Primary Key 
#    - Constraint that specifies column can only contain unique, non NULL values

DROP TABLE persons_pk;

CREATE TABLE persons_pk (
	PersonID int,
    lastname varchar(255),
    firstname varchar(255),
    address varchar(255),
    city varchar(255),
    PRIMARY KEY(PersonID),
    PRIMARY KEY(city)
);

INSERT INTO persons_pk (personid, lastname, firstname, address, city) VALUES
(2, "Johnson", "Fred", "1234 E Sesame", "Detroit");

SELECT * FROM persons_pk WHERE personid = 2;

##### WEDNESDAY #####

# Foreign key
#    - Refers to a primary key from another table
#    - This will insure referential integrity

CREATE TABLE customers (
	CustomerID int, 
    CustomerName varchar(255), 
    PRIMARY KEY(CustomerID)
);

INSERT INTO customers (CustomerID, CustomerName) VALUES
	(1, "Fred"),
    (2, "Stacy"),
    (3, "John"),
    (4, "Leah"),
    (5, "Tom"); 

SELECT * FROM customers;

CREATE TABLE orders (
	OrderID int, 
    CustomerID int, 
    price float,
    PRIMARY KEY(OrderID),
    FOREIGN KEY(CustomerID) REFERENCES customers(CustomerID)
);

INSERT INTO orders (OrderID, CustomerID, price) VALUES
	(1, 3, 5.50),
    (2, 2, 12.00),
    (3, 4, 54.50),
    (4, 5, 12.00),
    (5, 3, 4.50),
    (6, 2, 6.50),
    (7, 5, 24.00),
    (8, 4, 34.50),
    (9, 5, 12.50),
    (10, 3, 24.00);
    
SELECT * FROM orders;

INSERT INTO orders (OrderID, CustomerID, price) VALUES
	(11, 6, 5.50);
    
DELETE FROM customers WHERE CustomerID = 5;
DELETE FROM orders WHERE CustomerID = 3;

DROP TABLE customers;
DROP TABLE orders;

# SELECT [col names] FROM [table_name] WHERE [condition] GROUP BY [col names] HAVING [condition] ORDER BY [col names];

SELECT CustomerID, AVG(price) FROM orders WHERE OrderID > 1 GROUP BY CustomerID HAVING AVG(price) > 3 ORDER BY AVG(price) DESC;

SELECT * FROM orders WHERE price > 10;

SELECT * FROM orders WHERE customerID = 2 OR customerID = 3;

