CREATE DATABASE Movies

USE Movies
	
CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
	)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
	);

CREATE TABLE MOVIES(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear DATETIME2 NOT NULL,
	[Length] INT,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating TINYINT,
	Notes NVARCHAR(MAX)
	);

INSERT INTO Directors(DirectorName)
	VALUES
			('Ivanov'),
			('Ivanov1'),
			('Ivanov2'),
			('Ivanov3'),
			('Ivanov4')

INSERT INTO Genres(GenreName)
	VALUES
			('Comedy'),
			('Drama'),
			('Triller'),
			('Action'),
			('Romance')

INSERT INTO Categories(CategoryName)
	VALUES
			('Category1'),
			('Category2'),
			('Category3'),
			('Category4'),
			('Category5')

INSERT INTO MOVIES(Title, CopyrightYear)
	VALUES
			('Title1', '02.12.2001'),
			('Title2', '02.08.2001'),
			('Title3', '07.23.2004'),
			('Title4', '03.09.2010'),
			('Title5', '08.15.2014')
