CREATE DATABASE Airport

USE Airport

--Section 1. DDL

CREATE TABLE Planes (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	Seats INT NOT NULL,
	[Range] INT NOT NULL
	);

CREATE TABLE Flights (
	Id INT PRIMARY KEY IDENTITY,
	DepartureTime DATETIME,
	ArrivalTime DATETIME,
	Origin VARCHAR(50) NOT NULL,
	Destination VARCHAR(50) NOT NULL,
	PlaneId INT FOREIGN KEY REFERENCES Planes(Id) NOT NULL
	);

CREATE TABLE Passengers (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Age INT NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	PassportId VARCHAR(11) NOT NULL
	);

CREATE TABLE LuggageTypes (
	Id INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(30) NOT NULL
	);

CREATE TABLE Luggages (
	Id INT PRIMARY KEY IDENTITY,
	LuggageTypeId INT FOREIGN KEY REFERENCES LuggageTypes(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	);

CREATE TABLE Tickets (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	FlightId INT FOREIGN KEY REFERENCES Flights(Id) NOT NULL,
	LuggageId INT FOREIGN KEY REFERENCES Luggages(Id) NOT NULL,
	Price DECIMAL(6,2) NOT NULL
	);

	--Section 2. DML 

INSERT INTO Planes
	VALUES
		('Airbus 336', 112, 5132),
		('Airbus 330', 432, 5325),
		('Boeing 369', 231, 2355),
		('Stelt 297', 254, 2143),
		('Boeing 338', 165, 5111),
		('Airbus 558', 387, 1342),
		('Boeing 128', 345, 5541);

INSERT INTO LuggageTypes
	VALUES
		('Crossbody Bag'),
		('School Backpack'),
		('Shoulder Bag');

UPDATE Tickets
SET Price = 1.13 * Price
WHERE FlightId =
(SELECT Id FROM Flights
 WHERE Destination = 'Carlsbad');


DELETE Tickets
WHERE FlightId =
(SELECT Id FROM Flights
 WHERE Destination = 'Ayn Halagim');
 
 DELETE FROM Flights
 WHERE Destination = 'Ayn Halagim';

 -- Section 3. Querying

 --The "Tr" Planes

 SELECT * FROM Planes
 WHERE [Name] LIKE '%tr%'
 ORDER BY Id, [Name], Seats, [Range];

 --Flight Profits

 SELECT f.Id, SUM(Price) AS Price
 FROM Flights AS f
 JOIN Planes AS p ON p.Id = f.PlaneId
 JOIN Tickets AS t ON t.FlightId = f.Id
 GROUP BY f.Id
 ORDER BY Price DESC, Id ASC;

 --Passenger Trips

 SELECT CONCAT(FirstName,' ', LastName) AS [Full Name], Origin, Destination
 FROM Passengers AS p
 JOIN Tickets AS t ON p.Id = t.PassengerId
 JOIN Flights AS f ON f.Id = t.FlightId
 ORDER BY [Full Name], Origin, Destination

 --Non Adventures People

 SELECT FirstName, LastName, Age
 FROM Passengers AS p
 LEFT JOIN Tickets AS t ON p.Id = t.PassengerId
 WHERE PassengerId IS NULL
 ORDER BY Age DESC, FirstName, LastName;

 --Full Info

 SELECT CONCAT(FirstName,' ', LastName) AS [Full Name],
	Planes.[Name] AS [Plane Name],
	CONCAT(Origin,' - ', Destination) AS Trip,
	lt.[Type] AS [Luggage Type]
 FROM Passengers AS p
 JOIN Tickets AS t ON p.Id = t.PassengerId
 JOIN Flights AS f ON f.Id = t.FlightId
 JOIN Planes ON Planes.Id = f.PlaneId
 JOIN Luggages AS l ON l.Id = t.LuggageId
 JOIN LuggageTypes AS lt ON lt.Id = l.LuggageTypeId
 ORDER BY [Full Name], [Plane Name], Origin, Destination, [Luggage Type];

 GO

 --Section 4. Programmability

 CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(50), @destination VARCHAR(50), @peopleCount INT)
 RETURNS VARCHAR(MAX)
 AS
	BEGIN
		IF(@peopleCount <= 0)
			BEGIN
				RETURN ('Invalid people count!');
			END

		DECLARE @validFlight INT = 
			(SELECT TOP(1) Id
			FROM Flights
			WHERE (Origin = @origin AND Destination = @destination));
		
		IF(@validFlight IS NULL)
			BEGIN
				RETURN ('Invalid flight!');
			END
		
		DECLARE	@ticketsTotal DECIMAL(6,2);
		SET @ticketsTotal = @peopleCount *
		(SELECT Price
		FROM Tickets
		WHERE FlightId = @validFlight);
		RETURN ('Total price ' + CAST(@ticketsTotal AS varchar));
	END

GO

--SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)
