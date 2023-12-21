CREATE DATABASE ECommerce;
USE ECommerce;

CREATE TABLE CUSTOMERS (
    customerID INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(40) unique,
    address VARCHAR(255)
);


CREATE TABLE PRODUCTS (
    productID INT PRIMARY KEY,
    name VARCHAR(40),
	description VARCHAR(255),
    price DECIMAL(10, 2),
    stockQuantity INT
);

CREATE TABLE CART (
    cartID INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customerID) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(productID) ON DELETE CASCADE
);

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customerID) ON DELETE CASCADE
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
	itemAmount DECIMAL(8, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(productID) ON DELETE CASCADE
);



INSERT INTO CUSTOMERS(customerID, name, email, address) VALUES 
(1,'John Doe','johndoe@example.com','123 Main St, City'),
(2,'Jane Smith','janesmith@example.com','456 Elm St, Town'),
(3,'Robert Johnson','robert@example.com','789 Oak St, Village'),
(4,'Sarah Brown','sarah@example.com','101 Pine St, Suburb'),
(5,'David Lee','david@example.com','234 Cedar St, District'),
(6,'Laura Hall','laura@example.com','567 Birch St, County'),
(7,'Michael Davis','michael@example.com','890 Maple St, State'),
(8,'Emma Wilson','emma@example.com','321 Redwood St, Country'),
(9,'William Taylor','william@example.com','432 Spruce St, Province'),
(10,'Olivia Adams','olivia@example.com','765 Fir St, Territory');

	SELECT * FROM CUSTOMERS;


INSERT INTO PRODUCTS (productID, name, price, description, stockQuantity)
VALUES (1,'Laptop',800.00,'High-performance laptop',10),(2,'Smartphone',600.00,'Latest smartphone',15),
    (3,'Tablet',300.00,'Portable tablet',20),(4,'Headphones',150.00,'Noise-canceling',30),
    (5,'TV',900.00, '4K Smart TV',30),(6,'Coffee Maker',150.00,'Noise-canceling',10),
    (7,'Refrigerator',700.00,'Energy-efficient',25),(8,'Microwave Oven',80.00,'Countertop microwave',15),
	(9,'Blender',70.00,'High-speed blender',20),(10,'Vacuum Cleaner',120.00,'Bagless vacuum cleaner',10);

SELECT * FROM PRODUCTS;


INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES (1,1,'2023-01-05',1200.00), (2,2,'2023-02-10',900.00),
    (3,3,'2023-03-15',300.00),(4,4,'2023-04-20',150.00),(5,5,'2023-05-25',1800.00),
    (6,6,'2023-06-30',400.00),(7,7,'2023-07-05',700.00),(8,8,'2023-08-10',160.00),
    (9,9,'2023-09-15',140.00),(10,10,'2023-10-20',1400.00);

SELECT * FROM orders;


INSERT INTO order_items (order_item_id, order_id, product_id, quantity,itemAmount)
VALUES (1,1,1,2,1600.00), (2,1,3,1,300.00),(3,2,2,3,1800.00),(4,3,5,2,1800.00),
    (5,4,4,4,600.00),(6,4,6,1,50.00),(7,5,1,1, 800.00),(8,5,2,2,1200.00),(9,6,10,2,240.00),
    (10,6,9,3,210.00);

SELECT * FROM	order_items;


INSERT INTO CART (cartID, customer_id, product_id, quantity)
VALUES (1,1,1,2),(2,1,3,1),(3,2,2,3),(4,3,4,4),(5,3,5,2),(6,4,6,1),
    (7,5,1,1),(8,6,10,2),(9,6,9,3),(10,7,7,2);

SELECT * FROM CART;

-- questions
--1)
UPDATE PRODUCTS SET price = 800.00 WHERE (name='Refrigerator');

--2)
DELETE FROM CART WHERE (customer_id=2);

--3)
SELECT * FROM PRODUCTS WHERE (price<100.00);

--4)
SELECT * FROM PRODUCTS
WHERE (stockQuantity>5);

--5)
SELECT * FROM ORDERS
WHERE total_price BETWEEN 500.00 AND 1000.00;

--6)
SELECT *FROM PRODUCTS WHERE (name LIKE '%r');

--7)
SELECT * FROM CART WHERE (customer_id=5);

--8)

SELECT DISTINCT CUSTOMERS.name, ORDERS.order_date FROM CUSTOMERS INNER JOIN ORDERS ON 
CUSTOMERS.customerID = ORDERS.customer_id WHERE YEAR(ORDERS.order_date) = 2023;

--9)
--NO category is given so we used the product name for grouping data
SELECT [name], MIN(stockQuantity) AS min_stock FROM PRODUCTS GROUP BY [name];

--10)
SELECT CUSTOMERS.customerID, CUSTOMERS.name, SUM(ORDERS.total_price) AS total_amount_spent
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.customerID = ORDERS.customer_id
GROUP BY CUSTOMERS.customerID, CUSTOMERS.name;

--11)
SELECT CUSTOMERS.customerID, CUSTOMERS.name, avg(ORDERS.total_price) AS total_amount_spent FROM CUSTOMERS
LEFT JOIN ORDERS ON CUSTOMERS.customerID = ORDERS.customer_id
GROUP BY CUSTOMERS.customerID, CUSTOMERS.name;

--12)
SELECT CUSTOMERS.customerID, CUSTOMERS.name, COUNT(ORDERS.order_id) AS order_count
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.customerID = ORDERS.customer_id
GROUP BY CUSTOMERS.customerID, CUSTOMERS.name;

--13)

SELECT CUSTOMERS.customerID, CUSTOMERS.name, MAX(ORDERS.total_price) AS max_order_amount
FROM CUSTOMERS LEFT JOIN ORDERS ON CUSTOMERS.customerID = ORDERS.customer_id
GROUP BY CUSTOMERS.customerID, CUSTOMERS.name;

--14)
SELECT CUSTOMERS.customerID, CUSTOMERS.name, SUM(ORDERS.total_price) as Total_Order_Amount
FROM CUSTOMERS INNER JOIN ORDERS ON CUSTOMERS.customerID = ORDERS.customer_id
GROUP BY CUSTOMERS.customerID, CUSTOMERS.name HAVING SUM(ORDERS.total_price) > 1000.00;

--15)
SELECT * FROM PRODUCTS WHERE productID NOT IN (SELECT DISTINCT product_id FROM CART);

--16)
--Every customer placed order
SELECT * FROM CUSTOMERS
WHERE customerID NOT IN (SELECT DISTINCT customer_id FROM ORDERS);

--17)
SELECT PRODUCTS.productID, PRODUCTS.name, 
(SUM(order_items.itemAmount) / (SELECT SUM(order_items.itemAmount) FROM order_items)) * 100 AS percent_Revenue
FROM PRODUCTS LEFT JOIN order_items ON PRODUCTS.productID = order_items.product_id
GROUP BY PRODUCTS.productID, PRODUCTS.name;

--18)
SELECT *  FROM PRODUCTS
WHERE [stockQuantity]=(SELECT MIN(stockQuantity) FROM PRODUCTS);

--19)

SELECT * FROM [dbo].[CUSTOMERS] WHERE [customerID]=(SELECT [customer_id] FROM [ORDERS] 
WHERE [total_price]=(SELECT MAX([total_price]) FROM [ORDERS])
);