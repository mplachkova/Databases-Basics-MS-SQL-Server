-- Problem 14 Using SQL queries create CarRental database with the following entities:
-- Categories, Cars, Employees, Customers, RentalOrders

CREATE DATABASE CarRentals

USE CarRentals

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NCHAR(10) NOT NULL
	CHECK (CategoryName IN ('Sport', 'Family', 'Cargo')),
	DailyRate DECIMAL (4,2) NOT NULL,
	WeeklyRate DECIMAL (5,2) NOT NULL,
	MonthlyRate DECIMAL (5,2) NOT NULL,
	WeekendRate DECIMAL (5,2) NOT NULL
	)

CREATE TABLE Cars(
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber NVARCHAR (8) NOT NULL,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	CarYear DATETIME2,
	CategoryId INT FOREIGN KEY REFERENCES Categories (Id),
	Doors INT NOT NULL,
	Picture VARBINARY,
	Condition NVARCHAR(8) NOT NULL
	CHECK (Condition IN ('Good', 'Average', 'Exellent')),
	Available BIT NOT NULL
	)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NCHAR (50) NOT NULL,
	LastName NCHAR (50) NOT NULL,
	Title NCHAR (50) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Customers (
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber NCHAR (20) NOT NULL,
	FullName NVARCHAR (100) NOT NULL,
	[Address] NVARCHAR (MAX) NOT NULL,
	City NCHAR (20) NOT NULL,
	ZIPCode INT NOT NULL
	CHECK (ZIPCode <= 9999),
	Notes NVARCHAR (MAX)
	)

CREATE TABLE RentalOrders (
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees (Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers (Id),
	CarId INT FOREIGN KEY REFERENCES Cars (Id),
	TankLevel INT NOT NULL,
	KilometrageStart FLOAT NOT NULL,
	KilometrageEnd FLOAT NOT NULL, 
	TotalKilometrage AS KilometrageEnd - KilometrageStart,
	StartDate DATETIME2,
	EndDate DATETIME2,
	TotalDays AS DATEDIFF(Day, StartDate,EndDate),
	RateApplied DECIMAL (3,2) NOT NULL
	CHECK (RateApplied BETWEEN 0 AND 1),
	TaxRate DECIMAL (3,2) NOT NULL
	CHECK (TaxRate BETWEEN 0 AND 1),
	OrderStatus BIT NOT NULL,
	Notes NVARCHAR(MAX)
	)

INSERT INTO Categories
	VALUES
			('Sport', 12.5, 80,350, 20),
			('Family', 7.5, 40,200, 12),
			('Cargo', 15, 90,400, 20)

INSERT INTO Cars(PlateNumber, Manufacturer, Model,CategoryId, Doors, Condition, Available)
	VALUES
			('CO2345AB', 'Opel', 'Astra', 1 , 5, 'Exellent', 1),
			('CO3498ST', 'Ford', 'Focus', 2 , 5, 'Good', 0),
			('CO0783RD', 'WV', 'Golf', 3 , 3, 'Average', 1)

INSERT INTO Employees(FirstName, LastName,Title)
	VALUES
			('Ivan', 'Ivanov', 'Seller'),
			('Dragan', 'Draganov', 'Seller'),
			('Petkan', 'Petkanov', 'Seller')

INSERT INTO Customers(DriverLicenceNumber,FullName,[Address],City,ZIPCode)
	VALUES
			(123456, 'Vesko Veskov', 'Rakovski 80 str, entr. A','Sofia', 1000),
			(124562, 'Toshko Toshkov', 'Mladost 2,bl. 102, entr. A','Sofia', 1000),
			(654234, 'Lisko Liskov', 'Obelia 2, bl. 205, entr. G', 'Sofia', 1000)

INSERT INTO RentalOrders
	VALUES
			(1,1,1,15,850,950,'05.19.2020','05.21.2020',0.2,0.05,1, 'Notes1'),
			(1,2,3,25,1000,1300,'05.19.2020','05.21.2020',0.2,0.05,1, 'Notes2'),
			(1,3,2,30,2300,2370,'05.19.2020','05.21.2020',0.2,0.05,1, 'Notes3')