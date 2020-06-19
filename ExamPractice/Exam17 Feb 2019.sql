CREATE DATABASE School

USE School

--Section 1. DDL

CREATE TABLE Students (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age TINYINT CHECK(Age > 0),
	[Address] NVARCHAR(50),
	Phone NCHAR(10)
	);

CREATE TABLE Subjects (
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	Lessons TINYINT NOT NULL
	);

CREATE TABLE StudentsSubjects (
	Id INT PRIMARY KEY IDENTITY,
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
	Grade DECIMAL(3,2) CHECK (Grade BETWEEN 2 AND 6) NOT NULL
	);

CREATE TABLE Exams (
	Id INT PRIMARY KEY IDENTITY,
	[Date] DATETIME,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
	);

CREATE TABLE StudentsExams (
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	ExamId INT FOREIGN KEY REFERENCES Exams(Id) NOT NULL,
	Grade DECIMAL(3,2) CHECK (Grade BETWEEN 2 AND 6) NOT NULL,
	CONSTRAINT
	PK_StudentsExams PRIMARY KEY (StudentId, ExamId)
	);

CREATE TABLE Teachers (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	[Address] NVARCHAR(20) NOT NULL,
	Phone NCHAR(10),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
	);

CREATE TABLE StudentsTeachers (
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	TeacherId INT FOREIGN KEY REFERENCES Teachers(Id) NOT NULL,
	CONSTRAINT
	PK_StudensTeachers PRIMARY KEY(StudentId, TeacherId) 
	);

--Section 2. DML

INSERT INTO Teachers
	VALUES
		('Ruthanne', 'Bamb', '84948 Mesta Junction','3105500146', 6),
		('Gerrard', 'Lowin','370 Talisman Plaza', '3324874824', 2),
		('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
		('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4);

INSERT INTO Subjects
	VALUES
		('Geometry', 12),
		('Health', 10),
		('Drama', 7),
		('Sports', 9);

UPDATE StudentsSubjects
SET Grade = 6
WHERE Grade >= 5.5 AND SubjectId IN (1, 2);

DELETE FROM StudentsTeachers
WHERE TeacherId IN
(SELECT Teachers.Id 
FROM Teachers
WHERE Teachers.Phone LIKE '%72%');

DELETE FROM Teachers
WHERE Phone LIKE '%72%';

--Section 3. Querying 

SELECT FirstName, LastName, Age
FROM Students
WHERE Age >= 12
ORDER BY FirstName, LastName;

SELECT s.FirstName, s.LastName, COUNT(st.TeacherId) AS TeachersCount
FROM Students AS s
JOIN StudentsTeachers AS st ON st.StudentId = s.Id
GROUP BY s.FirstName, s.LastName;

SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsExams AS se ON s.Id = se.StudentId
WHERE se.ExamId IS NULL
ORDER BY [Full Name];

SELECT TOP(10) FirstName, LastName, FORMAT(ROUND(AVG(Grade),2),'N2') AS Grade
FROM Students AS s
JOIN StudentsExams AS se ON s.Id = se.StudentId
GROUP BY s.FirstName, s.LastName
ORDER BY Grade DESC, FirstName, LastName;

SELECT 
	CASE
		WHEN MiddleName IS NULL THEN CONCAT(FirstName,' ', LastName)
		ELSE CONCAT(FirstName,' ', MiddleName,' ', LastName)
	END AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsSubjects AS ss ON s.Id = ss.StudentId
WHERE ss.SubjectId IS NULL
ORDER BY [Full Name];

SELECT s.[Name], AVG(ss.Grade) AS AverageGrade
FROM Subjects AS s
JOIN StudentsSubjects AS ss ON ss.SubjectId = s.Id
GROUP BY s.[Name],ss.SubjectId
ORDER BY ss.SubjectId;

GO

--Section 4. Programmability

CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(3,2))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @studentExist INT = (SELECT TOP(1) StudentId FROM StudentsExams WHERE StudentId = @studentId);
	
	IF(@studentExist IS NULL)
		BEGIN
			RETURN 'The student with provided id does not exist in the school!';
		END
	
	ELSE IF (@grade > 6.00)
		BEGIN
			RETURN 'Grade cannot be above 6.00!';
		END
	DECLARE @studentFirstName NVARCHAR(20) = (SELECT TOP(1) FirstName FROM Students WHERE Id = @studentId);
	DECLARE @biggestGrade DECIMAL(15,2) = @grade + 0.50;
	DECLARE @count INT = (SELECT Count(Grade) FROM StudentsExams
	WHERE StudentId = @studentId AND Grade >= @grade AND Grade <= @biggestGrade)
	RETURN ('You have to update ' + CAST(@count AS nvarchar(10)) + ' grades for the student ' + @studentFirstName);
END

GO

CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS
	DECLARE @TargetStudentId INT = (SELECT Id FROM Students WHERE Id = @StudentId);

IF (@TargetStudentId IS NULL)
BEGIN
	RAISERROR('This school has no student with the provided id!', 16, 1);
	RETURN
END

DELETE FROM StudentsExams
WHERE StudentId = @StudentId;

DELETE FROM StudentsSubjects
WHERE StudentId = @StudentId;

DELETE FROM StudentsTeachers
WHERE StudentId = @StudentId;

DELETE FROM Students
WHERE Id = @StudentId;