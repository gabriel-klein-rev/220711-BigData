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

# JOINS
# INNER - Retrieve records where values of joined column are present in both tables
# LEFT OUTER - Retrieve all records from left table and records from right table where the values of 
#              the joined column are present in the left. 
# RIGHT OUTER - Retrieve all records from right table and records from left table where the values of 
#               the joined column are present in the right. 
# CROSS/CARTESIAN -

# Want to display all orders with orderid, customer name, and price

SELECT OrderID, CustomerName, Price FROM customers 
	JOIN orders ON customers.customerID = orders.customerID ORDER BY Price;
    
CREATE TABLE a (name int, val int);
CREATE TABLE b (name int, val int);

INSERT INTO a (name, val) VALUES
	(1, 11),
    (2, 22),
    (3, 33),
    (4, 44),
    (5, 55);

INSERT INTO b (name, val) VALUES
	(3, 333),
    (4, 444),
    (5, 555),
    (6, 666),
    (7, 777);
    
SELECT * FROM a;
SELECT * FROM b;

SELECT * FROM a JOIN b ON b.name = a.name;

SELECT * FROM a LEFT JOIN b on b.name=a.name;

SELECT * FROM a RIGHT JOIN b on b.name=a.name;

# To emulate a FULL OUTER JOIN, UNION together a LEFT JOIN and a RIGHT JOIN
SELECT * FROM a LEFT JOIN b on b.name=a.name
	UNION
    SELECT * FROM a RIGHT JOIN b on b.name=a.name;
    
SELECT * FROM a CROSS JOIN b;

CREATE TABLE die (val int);
INSERT INTO die (val) VALUES (1), (2), (3), (4), (5), (6);

CREATE TABLE die2 (val int);
INSERT INTO die2 (val) VALUES (1), (2), (3), (4), (5), (6);

SELECT * FROM die;

CREATE TABLE dice_rolls AS
	SELECT die.val AS d1_val, die2.val AS d2_val, die.val + die2.val AS Result FROM die CROSS JOIN die2 ORDER BY Result;
    
SELECT * FROM dice_rolls;

##### THURSDAY #####

USE sakila;
SHOW TABLES;

SELECT * FROM film;

SELECT title, rental_rate, rating, replacement_cost FROM film;
SELECT title, rental_rate, rating, replacement_cost FROM film WHERE rating IN ("G", "PG");

SELECT title, rental_rate, rating, replacement_cost FROM film WHERE rating = "PG-13" AND rental_rate < 3;
SELECT title FROM film WHERE title LIKE "V%";

# FUNCTIONS
#    AGGREGATE FUNCTIONS - Describe a summary of the data in some way. (Take in multiple values and return one)
#    SCALAR FUNCTIONS - Modify each field individually (Take in one value and return one value)

SELECT Rating, ROUND(AVG(length), 1) AS Average_Length FROM film GROUP BY rating 
	HAVING Average_Length < (SELECT AVG(length) AS Average_Length FROM film) ORDER BY Average_Length;
    
SELECT AVG(length) AS Average_Length FROM film;



-- CREATE TABLE average_length_film (Rating varchar(255), Average_Length float);
-- INSERT INTO average_length_film (rating, average_length) VALUES 
-- 	()

CREATE TABLE average_length_film AS
	SELECT Rating, AVG(length) AS Average_Length FROM film GROUP BY rating ORDER BY Average_Length;
    
SELECT * FROM average_length_film;

SELECT title, length FROM film WHERE length = (SELECT MAX(length) FROM film);
SELECT MAX(length) FROM film;

# Constraints
#    - NOT NULL
#    - UNIQUE
#    - PRIMARY KEY
#    - FOREIGN KEY
#    - DEFAULT - Provide a default value for a record if no value is given
#    - CREATE INDEX - Create a bst on column. Increases query speed on that column, decreases insert speed.
#    - CHECK - Defines a condition that values in column must have

CREATE TABLE prices (
	item varchar(255), 
    price float, 
    CHECK (price > 0));
ALTER TABLE prices ADD CHECK (price < 100);

INSERT INTO prices (item, price) VALUES ("Vacuum", 105);
DROP TABLE prices;
SELECT * FROM prices;

SELECT * FROM actor;

SELECT DISTINCT(first_name) FROM actor;

SELECT * FROM city;

SELECT COUNT(*) / COUNT(DISTINCT(country_id)) AS Cities_per_Country FROM city;

# DROP vs TRUNCATE vs DELETE
# DELETE - Deletes rows in a table. Remove data
# DROP - Remove all data in a table and remove the schema of the table from the database
# TRUNCATE - Remove all data in a table, but keeps the schema.

SELECT * FROM average_length_film;

INSERT INTO average_length_film 
	(SELECT Rating, AVG(length) AS Average_Length FROM film GROUP BY rating ORDER BY Average_Length);


DELETE FROM average_length_film;
TRUNCATE TABLE average_length_film;
DROP TABLE average_length_film;


# Multiplicity
# 	1(or 0)-to-1 - One record in a table references one record in another
#   1-to-many/many-to-one - Many records in a table reference one record in another table
#   many-to-many - Many records in a table reference many records in another (Need a third table)

USE 220711_w2;


DROP TABLE colors;
DROP TABLE people;

#   1-to-many/many-to-one - Many records in a table reference one record in another table

CREATE TABLE colors (
	colorID int, 
    color_name varchar(255),
    PRIMARY KEY (colorID));
    
INSERT INTO colors (colorID, color_name) VALUES
	(1, "Red"),
    (2, "Orange"),
    (3, "Yellow"),
    (4, "Green"),
    (5, "Blue"),
    (6, "Purple");
SELECT * FROM colors;

CREATE TABLE people (
	ID int, 
	name varchar(255), 
	fav_color int,
	PRIMARY KEY (ID),
    FOREIGN KEY (fav_color) REFERENCES colors (colorID)); 
    
INSERT INTO people (id, name, fav_color) VALUES
	(1, "Fred", 5),
    (2, "Stacy", 5),
    (3, "Bob", 1),
    (4, "Leah", 6),
    (5, "Tom", 3);
    
SELECT * FROM people;

SELECT name, color_name FROM people JOIN colors ON fav_color=colorID;

# 1 (or 0)-to-1 Relationship

CREATE TABLE colors (
	colorID int, 
    color_name varchar(255),
    PRIMARY KEY (colorID));
    
INSERT INTO colors (colorID, color_name) VALUES
	(1, "Red"),
    (2, "Orange"),
    (3, "Yellow"),
    (4, "Green"),
    (5, "Blue"),
    (6, "Purple");
SELECT * FROM colors;

CREATE TABLE people (
	ID int, 
	name varchar(255), 
	fav_color int UNIQUE,
	PRIMARY KEY (ID),
    FOREIGN KEY (fav_color) REFERENCES colors (colorID)); 
    
INSERT INTO people (id, name, fav_color) VALUES
	(1, "Fred", 5),
    (2, "Stacy", 2),
    (3, "Bob", 1),
    (4, "Leah", 6),
    (5, "Tom", 3);
    
SELECT * FROM people;

SELECT name, color_name FROM people JOIN colors ON fav_color=colorID;

#   many-to-many - Many records in a table reference many records in another (Need a third table)

CREATE TABLE colors (
	colorID int, 
    color_name varchar(255),
    PRIMARY KEY (colorID));
    
INSERT INTO colors (colorID, color_name) VALUES
	(1, "Red"),
    (2, "Orange"),
    (3, "Yellow"),
    (4, "Green"),
    (5, "Blue"),
    (6, "Purple");
SELECT * FROM colors;

CREATE TABLE people (
	ID int, 
	name varchar(255), 
	PRIMARY KEY (ID)
); 
    
INSERT INTO people (id, name) VALUES
	(1, "Fred"),
    (2, "Stacy"),
    (3, "Bob"),
    (4, "Leah"),
    (5, "Tom");
    
SELECT * FROM people;

CREATE TABLE color_likes (
	personID int, 
    colorID int,
    FOREIGN KEY (personID) REFERENCES people(id),
    FOREIGN KEY (colorID) REFERENCES colors(colorID)
);

INSERT INTO color_likes (personID, colorID) VALUES
	(1, 2),
    (1, 4),
    (2, 4),
    (2, 5),
    (3, 1),
    (4, 6),
    (4, 5),
    (4, 3),
    (4, 1);
SELECT * FROM color_likes;

SELECT name, color_name FROM people JOIN color_likes ON id=personID
	JOIN colors ON color_likes.colorID=colors.colorID;
    
    
    