CREATE DATABASE TableRelations

USE TableRelations

--One-To-One Relationship

CREATE TABLE Persons(
	PersonID INT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	Salary DECIMAL(7,2) NOT NULL,
	PassportID INT NOT NULL UNIQUE);

CREATE TABLE Passports(
	PassportID INT PRIMARY KEY,
	PassportNumber CHAR(8) NOT NULL);

INSERT INTO Passports
	VALUES
		(101, 'N34FG21B'),
		(102, 'K65LO4R7'),
		(103, 'ZE657QP2');

INSERT INTO Persons
	VALUES
		(1,'Roberto', 43300.00, 102),
		(2, 'Tom', 56100.00, 103),
		(3, 'Yana', 60200.00, 101);

ALTER TABLE Persons
	ADD PRIMARY KEY (PersonID);

ALTER TABLE Persons
	ADD CONSTRAINT FK_Persons_Passports
	FOREIGN KEY (PassportID) REFERENCES Passports(PassportID);

--One-To-Many Relationship

CREATE TABLE Manufacturers
	(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(20) NOT NULL,
	EstablishedOn DATETIME2
	);

CREATE TABLE Models(
	ModelID INT PRIMARY KEY IDENTITY (101 , 1),
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT NOT NULL);

INSERT INTO Manufacturers
	VALUES
			('BMW', '07/03/1916'),
			('Tesla' , '01/01/2003'),
			('Lada' , '01/05/1966');

INSERT INTO Models
	VALUES
		('X1' , 1),
		('i6' , 1),
		('Model S' , 2),
		('Model X' , 2),
		('Model 3' , 2),
		('Nova' , 3);

ALTER TABLE Models
	ADD CONSTRAINT FK_Models_Manufacturers
	FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers (ManufacturerID);

--Many-To-Many Relationship

CREATE TABLE Students(
	StudentID INT NOT NULL,
	[Name] NVARCHAR(100) NOT NULL);

CREATE TABLE Exams(
	ExamID INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL);

CREATE TABLE StudentsExams(
	StudentID INT NOT NULL,
	ExamID INT NOT NULL);

INSERT INTO Students
	VALUES
		(1, 'Mila'),
		(2, 'Toni'),
		(3, 'Ron');

INSERT INTO Exams
	VALUES
		(101, 'SpringMVC'),
		(102, 'Neo4j'),
		(103, 'Oracle 11g');

INSERT INTO StudentsExams
	VALUES
		(1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103);

ALTER TABLE Students
	ADD PRIMARY KEY (StudentID);

ALTER TABLE Exams
	ADD PRIMARY KEY (ExamID);

ALTER TABLE StudentsExams
	ADD PRIMARY KEY (StudentID , ExamID);

ALTER TABLE StudentsExams
	ADD CONSTRAINT FK_StudentExams_Students
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID);

ALTER TABLE StudentsExams
	ADD CONSTRAINT FK_StudentExams_Exams
	FOREIGN KEY (ExamID) REFERENCES Exams(ExamID);

--Self-Referencing

CREATE TABLE Teachers(
	TeacherID INT IDENTITY (101 , 1),
	[Name] NVARCHAR(100) NOT NULL,
	ManagerID INT);

ALTER TABLE Teachers
	ADD PRIMARY KEY (TeacherID);

INSERT INTO Teachers
	VALUES
		('John', NULL),
		('Maya' , 106),
		('Silvia' , 106),
		('Ted' , 105),
		('Mark' , 101),
		('Greta' , 101);

ALTER TABLE Teachers
	ADD CONSTRAINT FK_Teachers_Teachers
	FOREIGN KEY (ManagerID) REFERENCES Teachers (TeacherID);

--Online Store Database. Create a new database and design the following the given structure.

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY,
	CustomerID INT NOT NULL);

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	Birthday DATE,
	CityID INT NOT NULL);

CREATE TABLE Cities(
	CityID INT PRIMARY KEY,
	[Name] VARCHAR(50));

ALTER TABLE Orders
	ADD CONSTRAINT FK_Orders_Customers
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

ALTER TABLE Customers
	ADD CONSTRAINT FK_Customers_Cities
	FOREIGN KEY (CityID) REFERENCES Cities(CityID);

CREATE TABLE OrderItems(
	OrderID INT,
	ItemID INT
	PRIMARY KEY (OrderID, ItemID));

CREATE TABLE Items(
	ItemID INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT);

CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL);

ALTER TABLE OrderItems
	ADD CONSTRAINT FK_ItemTypes_Items
	FOREIGN KEY (ItemID) REFERENCES Items(ItemID);

ALTER TABLE OrderItems
	ADD CONSTRAINT FK_OrderItems_Orders
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

ALTER TABLE Items
	ADD CONSTRAINT FK_Items_ItemTypes
	FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID);
