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
    
CREATE TABLE transactions (sender int, receiver int, amount int, transaction_date varchar(255));
INSERT INTO transactions (sender, receiver, amount, transaction_date) VALUES
	(5, 2, 10, "2-12-20"),
	(1, 3, 15, "2-13-20"),
	(2, 1, 20, "2-13-20"),
	(2, 3, 25, "2-14-20"),
	(3, 1, 20, "2-15-20"),
	(3, 2, 15, "2-15-20"),
	(1, 4, 5, "2-16-20");
    
SELECT * FROM transactions;

# COLUMNS TO GET:
#	user - JOIN between sender/receiver
#	net_change - amount_received - amount_sent for each user
DROP TABLE sent;


CREATE TABLE sent AS SELECT sender, SUM(amount) AS sent FROM transactions GROUP BY sender;
SELECT * FROM sent;

CREATE TABLE received AS SELECT receiver, SUM(amount) AS received FROM transactions GROUP BY receiver;
SELECT * FROM received;
    
    
SELECT sender AS user, COALESCE(received, 0) - COALESCE(sent, 0) AS net_change FROM sent 
	LEFT JOIN received ON sender=receiver
	UNION
    SELECT receiver AS user, COALESCE(received, 0) - COALESCE(sent, 0) AS net_change FROM sent 
    RIGHT JOIN received ON sender=receiver ORDER BY net_change DESC;
    
    
# WEEK 3

# CARDINALITY
#    - The "uniqueness" of a column
#    - The more unique elements we have in a column, the higher the cardinality

# INDEX
#    - Something we put on a column to improve query speed
#    - Data in an indexed column is stored in some order, in a separate location called the index
#    - Primary keys are automatically indexed (bst)
#    - Can slow down insertion speed
#    - To utilize indices to their fullest potential, use indices on columns with high cardinality
#    - Can have multi-column indices (indexes)

CREATE TABLE US_People (
	firstName varchar(255), 
	ssn int, 
    state varchar(255));
    
INSERT INTO US_People (firstName, ssn, state) VALUES
	("Fred", 123456789, "Texas"),
    ("Stacy", 234567890, "Texas"),
    ("Tom", 345678910, "Texas"),
    ("Leah", 456789012, "Texas"),
    ("Rachel", 198765432, "Texas"),
    ("Tom", 987654321, "Alabama"),
    ("Fred", 908765442, "Alabama"),
    ("Bob", 543678123, "Alabama");
    
SELECT FirstName AS "First Name", SSN AS "Social Security Number", State FROM US_PEOPLE;

SELECT * FROM US_People WHERE ssn = 198765432;
SELECT * FROM US_People WHERE firstname = "Tom";

SELECT * FROM US_People WHERE ssn > 500000000 OR firstName = "Tom";
SELECT * FROM US_People WHERE firstname LIKE "_o%" AND state = "Alabama";

CREATE INDEX idx_ssn ON US_People(ssn);

CREATE INDEX idx_firstName ON US_People(firstName);

CREATE INDEX idx_firstNameState ON US_PEOPLE(firstName, state);

SELECT * FROM US_People;

# VIEWS
#    - Stored query with a name assigned to it
#    - "Virtual table"


SELECT * FROM US_People WHERE ssn > 500000000 OR firstName = "Tom";

CREATE TABLE US_People_Filtered AS 
	SELECT * FROM US_People WHERE ssn > 500000000 OR firstName = "Tom";
    
SELECT * FROM US_People_Filtered WHERE firstName != "Tom";
    
SELECT * FROM US_People_Filtered;

CREATE VIEW US_People_Filtered_View AS
	SELECT * FROM US_People WHERE ssn > 500000000 OR firstName = "Tom";
    
SELECT * FROM US_People_Filtered_View;

SELECT * FROM US_People_Filtered_View WHERE firstName != "Tom";

# CTE
#    - Common Table Expression
#    - Temporary result set that only exists within the scope of a single statement

WITH t1 AS (SELECT * FROM US_People WHERE ssn > 500000000 OR firstName = "Tom")
	SELECT * FROM t1 WHERE firstName != "Tom";
SELECT * FROM t1;


# SET OPERATORS - Combine result of one or more result set into one result set
#               - Result sets must have same number of columns, same data type
#     - UNION - Combine all the results that are in either result set, removing duplicates
#     - UNION ALL - Combine all the results that are in either result set, keeping duplicates
#     - INTERSECT - Combine results that are in both result sets
#     - EXCEPT - Results from the first result set, minus the ones present in the second result set

CREATE TABLE a (val int);
CREATE TABLE b (val int);

INSERT INTO a (val) VALUES (1), (2), (3), (4), (5);
INSERT INTO b (val) VALUES (3), (4), (5), (6), (7);

SELECT * FROM a;
SELECT * FROM b;



SELECT * FROM a UNION SELECT * FROM b;
SELECT * FROM a UNION ALL SELECT * FROM b;

# To emulate INTERSECT
SELECT * FROM a WHERE val IN (SELECT * FROM b);

# To emulate EXCEPT
SELECT * FROM a WHERE val NOT IN (SELECT * FROM b);

SELECT * FROM a LEFT JOIN b ON a.val = b.val;
SELECT * FROM a RIGHT JOIN b ON a.val = b.val;

SELECT * FROM a LEFT JOIN b ON a.val = b.val
	UNION
    SELECT * FROM a RIGHT JOIN b ON a.val = b.val;

# NORMALIZATION
#    - Process of reducing data redundancy and improving data integrety
#    - Problems we may face without normalization
#        - Insertion anomoly
#        - Update anomoly
#        - Deletion anomoly

CREATE TABLE movie_store_0nf (
	FullName varchar(255), 
    Address varchar(255), 
    MoviesRented varchar(255), 
    FavoriteGenre varchar(255)
);

INSERT INTO movie_store_0nf (fullname, address, moviesrented, favoritegenre) VALUES
	("Janet Jones", "255 1st St", "Pirates of the Caribbean, Clash of the Titans", "Action"),
    ("Robert Phil", "123 3rd Ave", "Sherlock Holmes, Clash of the Titans", "Mystery"),
    ("Robert Phil", "456 E Broadway", "Sherlock Holmes", "Mystery");
    
/*
UPDATE movie_store_0nf SET 
	moviesrented="Sherlock Holmes, Clash of the Titans, Piratres of the Carribean" 
    WHERE firstName="Robert Phil" AND address="123 3rd Ave";
*/
    
SELECT * FROM movie_store_0nf;

# 1NF
#    - Each table cell should contain a single value
#    - Each record needs to be unique

CREATE TABLE movie_store_1nf (
	FullName varchar(255), 
    Address varchar(255), 
    MoviesRented varchar(255), 
    FavoriteGenre varchar(255)
);

INSERT INTO movie_store_1nf (fullname, address, moviesrented, favoritegenre) VALUES
	("Janet Jones", "255 1st St", "Pirates of the Caribbean", "Action"),
    ("Janet Jones", "255 1st St", "Clash of the Titans", "Action"),
    ("Robert Phil", "123 3rd Ave", "Sherlock Holmes", "Mystery"),
    ("Robert Phil", "123 3rd Ave", "Clash of the Titans", "Mystery"),
    ("Robert Phil", "456 E Broadway", "Sherlock Holmes", "Mystery");
SELECT * FROM movie_store_1nf;

SELECT * FROM movie_store_1nf WHERE fullname ="Robert Phil" AND address = "456 E Broadway" AND moviesrented = "Sherlock Holmes";

# 2NF
#    - Be in 1NF
#    - Single Column Primary Key that is not functionally dependant on any subset of candidate key relation
#    - Table should not contain partial dependancy. Proper subset of candidate key should not determine a non-prime attribute

CREATE TABLE members_2nf (
	memberID int AUTO_INCREMENT, 
    FullName varchar(255), 
    address varchar(255), 
    favoriteGenre varchar(255),
    PRIMARY KEY (memberID)
);

INSERT INTO members_2nf (FullName, address, favoritegenre) VALUES
	("Janet Jones", "255 1st St", "Action"),
    ("Robert Phil", "123 3rd Ave", "Mystery"),
    ("Robert Phil", "456 E Broadway", "Mystery");

SELECT * FROM members_2nf;

DROP TABLE rentals_2nf;
CREATE TABLE rentals_2nf (
	rentalID int AUTO_INCREMENT,
    memberID int,
    movie varchar(255),
    PRIMARY KEY (rentalID),
    FOREIGN KEY (memberID) REFERENCES members_2nf(memberID)
);

INSERT INTO rentals_2nf (memberID, movie) VALUES
	(1, "Pirates of the Caribbean"),
    (1, "Clash of the Titans"),
    (2, "Sherlock Holmes"),
	(2, "Clash of the Titans"),
    (3, "Sherlock Holmes");
SELECT * FROM rentals_2nf;

# 3NF
#    - 2NF
#    - Tables have no transitive functional dependencies

CREATE TABLE employees (
	empID int auto_increment, 
    name varchar(255),
    state varchar(255),
    country varchar(255),
    zipcode int,
    PRIMARY KEY (empID)
);

INSERT INTO employees (name, state, country, zipcode) VALUES
	("Fred", "Texas", "USA", 45094),
    ("Stacy", "Arizona", "USA", 84905),
    ("Leah", "Virginia", "USA", 39476);
SELECT * FROM employees;
    
CREATE TABLE employees_3nf AS SELECT empID, name, zipcode FROM employees;
SELECT * FROM employees_3nf;
ALTER TABLE employees_3nf ADD PRIMARY KEY(empID);
ALTER TABLE employees_3nf ADD FOREIGN KEY(zipcode) REFERENCES locations_3nf(zipcode);

CREATE TABLE locations_3nf AS SELECT zipcode, state, country FROM employees;
SELECT * FROM locations_3nf;

# START TRANSACTION;
ALTER TABLE locations_3nf ADD PRIMARY KEY(zipcode);
# COMMIT;






# TRANSACTION
#    - A single, logical unit of work that accesses/modifies the contents of a database
#    - Can start a transaction that consists of multiple commands with 'START TRANSACTION;'
#    - When transaction starts, we can either COMMIT all of our commands, or ROLLBACK to start of transaction.
#    - By default, every statement/command in MySQL is SET to autocommit.
#    - Changes to a db do not occur until we COMMIT after STARTing a TRANSACTION

# Properties of TRANSACTIONs
#    - ACID
#    - Atomicity
#        - "All or nothing"
#        - TRANSACTION either occurs fully, or not at all
#    - Consistency
#        - Database is consistent before and after the transaction
#        - Any corruption/error that occurs will not create any inconsistencies
#    - Isolation
#        - Any transaction cannot interfere with another transaction running concurrently
#    - Durability
#        - If a transaction has been fully committed, the updates to the db are stored and 
#          persisted to disk, even if a system failure occurs



#   X : 200           Y : 400
#   x = +100          Y = -100
-- -------------------------------
#   X : 300           Y = 300

###############################################################
START TRANSACTION;

INSERT INTO locations_3nf (zipcode, state, country) VALUES 
	(84091, "Arizona", "USA");

INSERT INTO employees_3nf (empid, name, zipcode) VALUES
	(4, "Tom", 84091);
    
COMMIT;
#################################################################

START TRANSACTION;
INSERT INTO locations_3nf (zipcode, state, country) VALUES 
	(840913245, "AriZONA", "USA");

ROLLBACK;





USE sakila;
SELECT * FROM film;
SELECT * FROM film JOIN language ON film.language_id=language.language_id;


    