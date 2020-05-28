CREATE DATABASE Hotel;

USE Hotel;

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Title NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName NVARCHAR(50),
	EmergencyNumber INT,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE RoomStatus (
	Id INT PRIMARY KEY IDENTITY,
	RoomStatus BIT NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE RoomTypes (
	Id INT PRIMARY KEY IDENTITY,
	RoomType NVARCHAR(10) CHECK(RoomType IN ('Single', 'Double', 'Appartment')) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE BedTypes (
	Id INT PRIMARY KEY IDENTITY,
	BedType NVARCHAR(10) CHECK(BedType IN ('Single', 'Double')) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY,
	RoomType INT FOREIGN KEY REFERENCES RoomTypes(Id),
	BedType INT FOREIGN KEY REFERENCES BedTypes(Id),
	Rate INT NOT NULL,
	RoomStatus INT FOREIGN KEY REFERENCES RoomStatus(Id),
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATETIME2 NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATETIME2 NOT NULL,
	LastDateOccupied DATETIME2 NOT NULL, 
	TotalDays AS DATEDIFF(DAY,FirstDateOccupied,LastDateOccupied),
	AmountCharged DECIMAL(5,2) NOT NULL,
	TaxRate DECIMAL(3,2) NOT NULL, 
	TaxAmount DECIMAL(3,2) NOT NULL,
	PaymentTotal DECIMAL(5,2),
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATETIME2 NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL, 
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL(3,2) NOT NULL,
	PhoneCharge DECIMAL(3,2) NOT NULL,
	Notes NVARCHAR(MAX)
	)

INSERT INTO Employees(FirstName,LastName,Title)
	VALUES
			('Ivan','Ivanov','manager'),
			('Dragan','Draganov','waiter'),
			('Petkan','Petkanov','waiter')

INSERT INTO Customers(AccountNumber, FirstName,LastName, PhoneNumber)
	VALUES
			(12345,'Pencho', 'Penchev', 123456789),
			(23456, 'Gencho', 'Genchev', 987654321),
			(34567, 'Toshko', 'Toshchev', 112233445)

INSERT INTO RoomStatus (RoomStatus)
	VALUES
		(1),
		(0),
		(1)

INSERT INTO RoomTypes(RoomType)
	VALUES
			('Single'),
			('Double'),
			('Appartment')

INSERT INTO BedTypes(BedType)
	VALUES
			('Single'),
			('Double'),
			('Double')

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus)
	VALUES
			(1, 1, 1, 5, 1),
			(2, 2, 2, 4, 2),
			(3, 3, 3, 3, 3)

INSERT INTO Payments(EmployeeId, PaymentDate,AccountNumber,FirstDateOccupied,LastDateOccupied,AmountCharged,TaxRate,TaxAmount,PaymentTotal)
	VALUES
			(1,'12.04.2020',12345, '12.04.2020', '12.08.2020',50.5,0.2,3.5,450),
			(2,'10.04.2020',12345, '10.04.2020', '10.08.2020',50.5,0.2,3.5,450),
			(3,'09.04.2020',12345, '09.04.2020', '09.08.2020',50.5,0.2,3.5,450)

INSERT INTO Occupancies (EmployeeId,DateOccupied,AccountNumber,RoomNumber,RateApplied,PhoneCharge)
	VALUES
			(1, '12.04.2020', 12345, 1, 1.5, 2.5),
			(2, '12.04.2020', 12345, 2, 2.5, 5.5),
			(3, '12.04.2020', 12345, 3, 3.5, 1.5)

UPDATE Payments
	SET TaxRate = 0.97 * TaxRate;
SELECT TaxRate FROM Payments;

TRUNCATE TABLE Occupancies;