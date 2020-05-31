CREATE DATABASE TableRelationsAlter

USE TableRelationsAlter

-- University Database. Create a new database and design the following the given structure.

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY,
	[Name] VARCHAR(50));

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT NOT NULL);

CREATE TABLE Agenda(
	StudentID INT NOT NULL,
	SubjectID INT NOT NULL,
	PRIMARY KEY (StudentID, SubjectID));

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY,
	SubjectName VARCHAR(100) UNIQUE);

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY,
	PaymentDate DATE NOT NULL,
	PaymentAmount DECIMAL (5,2),
	StudentID INT NOT NULL);

ALTER TABLE Payments
	ADD CONSTRAINT FK_Payments_Students
	FOREIGN KEY (StudentID) REFERENCES Students (StudentID);

ALTER TABLE Agenda
	ADD CONSTRAINT FK_Agenda_Students
	FOREIGN KEY (StudentID) REFERENCES Students (StudentID);

ALTER TABLE Agenda
	ADD CONSTRAINT FK_Agenda_Subjects
	FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID);

ALTER TABLE Students
	ADD CONSTRAINT FK_Students_Majors
	FOREIGN KEY (MajorID) REFERENCES Majors (MajorID);