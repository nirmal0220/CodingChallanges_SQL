CREATE DATABASE CAR_RENTAL_SYSTEM;
USE CAR_RENTAL_SYSTEM;

-- CREATE THE TABLES 

CREATE TABLE Vehicle 
(    vehicleID INT PRIMARY KEY,
    make VARCHAR(15),
    model VARCHAR(15),
    year INT,
    dailyRate DECIMAL(10, 2),
    available INT CHECK(available IN(0,1)),
    passengerCapacity INT,
    engineCapacity INT
);

CREATE TABLE Customer
(
    customerID INT PRIMARY KEY,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phoneNumber VARCHAR(15) UNIQUE
);

CREATE TABLE Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    leaseType VARCHAR(10) CHECK(leaseType IN('Daily','Monthly')),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID) ON DELETE CASCADE,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE
);

CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT,
    paymentDate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) on delete cascade
);


INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, available, passengerCapacity, engineCapacity)
VALUES (1,'Toyota','Camry',2022,50.00,1,4,1450), (2,'Honda','Civic',2023,45.00, 1,7,1500),
    (3,'Ford','Focus',2022,48.00, 0,4,1400), (4,'Nissan','Altima',2023,52.00, 1,7,1200), (5,'Chevrolet','Malibu',2022,47.00,1,4,1800),
    (6,'Hyundai','Sonata',2023,49.00,0,7,1400),(7,'BMW','3 Series',2023,60.00, 1,7,2499), 
 (8,'Mercedes','C-Class',2022,58.00,1,8,2499),(9,'Audi','A4', 2022,55.00,0,4,2599), (10,'Lexus','ES', 2023,54.00,1,4,2500);

SELECT * FROM [dbo].[Vehicle];


INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES (1,'John','Doe','johndoe@example.com','555-555-5555'),
    (2,'Jane','Smith','janesmith@example.com','555-123-4567'),
    (3,'Robert','Johnson','robert@example.com','555-789-1234'),
    (4,'Sarah','Brown','sarah@example.com','555-456-7890'),
    (5,'David','Lee','david@example.com','555-987-6543'),
    (6,'Laura','Hall','laura@example.com','555-234-5678'),
    (7,'Michael','Davis','michael@example.com','555-876-5432'),
    (8,'Emma','Wilson','emma@example.com','555-432-1098'),
    (9,'William','Taylor','william@example.com','555-321-6547'),
    (10,'Olivia','Adams','olivia@example.com','555-765-4321');

SELECT * FROM [dbo].[Customer];

INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType)
VALUES(1,1,1,'2023-01-01','2023-01-05','Daily'),(2,2,2,'2023-02-15','2023-02-28','Monthly'),
 (3,3,3,'2023-03-10','2023-03-15','Daily'),(4,4,4,'2023-04-20','2023-04-30','Monthly'),
 (5,5,5,'2023-05-05','2023-05-10','Daily'),(6,4,3,'2023-06-15','2023-06-30','Monthly'),
 (7,7,7,'2023-07-01','2023-07-10','Daily'),(8,8,8,'2023-08-12','2023-08-15','Monthly'),
 (9,3,3,'2023-09-07','2023-09-10','Daily'),(10,10,10,'2023-10-10','2023-10-31','Monthly');

SELECT * FROM [dbo].[Lease];



INSERT INTO Payment (paymentID, leaseID, paymentDate, amount)
VALUES(1,1,'2023-01-03',200.00),(2,2,'2023-02-20',1000.00),
  (3,3,'2023-03-12',75.00),(4,4,'2023-04-25',900.00),(5,5,'2023-05-07',60.00),
  (6,6,'2023-06-18',1200.00),(7,7,'2023-07-03',40.00),
  (8,8,'2023-08-14',1100.00),(9,9,'2023-09-09',80.00),(10,10,'2023-10-25',1500.00);

SELECT * FROM [dbo].[Payment];

-- QUESTIONS
--1)
UPDATE Vehicle SET dailyRate = 68
WHERE make = 'Mercedes'; 
SELECT * FROM [dbo].[Vehicle];

--2) 
-- HERE I USED ON DELETE CASCADE SO REFERENTIAL INTEGRITY WILL BE MAINTAIN AUTOMATICALLY
DELETE FROM Customer WHERE customerID = 1;

SELECT * FROM [dbo].[Customer];
SELECT * FROM [dbo].[Lease];
SELECT * FROM [dbo].[Payment];

--3)
ALTER TABLE Payment
ALTER COLUMN paymentDate TO transactionDate;

--4)
SELECT * FROM Customer
WHERE email = 'michael@example.com';

--5)
SELECT * FROM Lease WHERE customerID = 8 AND endDate >= GETDATE();

--6)
SELECT Payment.paymentID,Payment.paymentDate,Payment.amount FROM Payment
JOIN Lease ON Payment.leaseID = Lease.leaseID
JOIN Customer ON Lease.customerID = Customer.customerID
WHERE Customer.phoneNumber = '555-789-1234';

--7)
SELECT AVG(dailyRate) AS avgDailyRate FROM Vehicle WHERE available = 1;

--8)
SELECT * FROM Vehicle
WHERE dailyRate = (SELECT MAX(dailyRate) FROM Vehicle);

--9)
SELECT *
FROM Vehicle
WHERE vehicleID IN (SELECT vehicleID FROM Lease WHERE customerID = 10);

--10)
SELECT * FROM Lease ORDER BY startDate DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--11)
SELECT * FROM Payment WHERE YEAR(paymentDate) = 2023;

--12)
SELECT * FROM Customer WHERE customerID NOT IN (SELECT customerID FROM Payment);

--13)
SELECT Vehicle.vehicleID, Vehicle.make, Vehicle.model, ISNULL(SUM(Payment.amount), 0) AS TotalPayments
FROM Vehicle LEFT JOIN Lease  ON Vehicle.vehicleID = Lease.vehicleID
LEFT JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY Vehicle.vehicleID, Vehicle.make, Vehicle.model;

--14)
SELECT Customer.*, ISNULL(SUM(Payment.amount), 0) AS TotalPayments FROM Customer
LEFT JOIN Lease ON Customer.customerID = Lease.customerID
LEFT JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY Customer.customerID, Customer.firstName, Customer.lastName, Customer.email, Customer.phoneNumber;

--15)
SELECT Lease.*, Vehicle.* FROM Lease JOIN Vehicle
ON Lease.vehicleID = Vehicle.vehicleID;

--16)
DECLARE @tD DATE = '2023-06-21'
SELECT Lease.*, Customer.firstName, Customer.lastName, Vehicle.make, Vehicle.model
FROM Lease, Customer, Vehicle
WHERE Lease.customerID = Customer.customerID
AND Lease.vehicleID = Vehicle.vehicleID
AND Lease.endDate >= @tD;

--17)
SELECT TOP 1 Customer.customerID, Customer.firstName, Customer.lastName
FROM Customer, Lease, Payment
WHERE Customer.customerID = Lease.customerID
AND Lease.leaseID = Payment.leaseID
GROUP BY Customer.customerID, Customer.firstName, Customer.lastName
ORDER BY SUM(Payment.amount) DESC;

--18)
SELECT Vehicle.vehicleID, Vehicle.make, Vehicle.model, Lease.startDate, Lease.endDate, Lease.leaseType
FROM Vehicle, Lease
WHERE Vehicle.vehicleID = Lease.vehicleID




