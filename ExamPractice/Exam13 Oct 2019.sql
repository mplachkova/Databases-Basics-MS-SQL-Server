CREATE DATABASE Bitbucket

USE Bitbucket

--Section 1. DDL

CREATE TABLE Users (
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] NVARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
	);

CREATE TABLE Repositories (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
	);

CREATE TABLE RepositoriesContributors (
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	CONSTRAINT
	PK_RepositoriesUSers PRIMARY KEY (RepositoryId, ContributorId)
	);

CREATE TABLE Issues (
	Id INT PRIMARY KEY IDENTITY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus CHAR(6) NOT NULL,
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
	);

CREATE TABLE Commits (
	Id INT PRIMARY KEY IDENTITY,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT FOREIGN KEY REFERENCES Issues (Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
	);

CREATE TABLE Files (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL (12,2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id) NOT NULL
	);

--Section 2. DML

--Insert

INSERT INTO Files
	VALUES
		('Trade.idk', 2598.0, 1, 1),
		('menu.net', 9238.31, 2, 2),
		('Administrate.soshy', 1246.93, 3, 3),
		('Controller.php', 7353.15, 4, 4),
		('Find.java', 9957.86, 5, 5),
		('Controller.json', 14034.87, 3, 6),
		('Operate.xix', 7662.92, 7, 7);

INSERT INTO Issues
	VALUES
		('Critical Problem with HomeController.cs file', 'open', 1 ,4),
		('Typo fix in Judge.html', 'open', 4, 3),
		('Implement documentation for UsersService.cs', 'closed', 8, 2),
		('Unreachable code in Index.cs', 'open', 9, 8);

--Update

UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6;

--Delete

DELETE FROM RepositoriesContributors
WHERE RepositoryId IN
(SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork');

DELETE FROM Issues
WHERE RepositoryId IN
(SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork');

--Section 3. Querying

SELECT Id, [Message], RepositoryId, ContributorId
FROM Commits
ORDER BY Id, [Message], RepositoryId, ContributorId;

SELECT Id, [Name], Size
FROM Files
WHERE Size > 1000.00
AND [Name] LIKE '%html%'
ORDER BY Size DESC, Id, [Name];

SELECT i.Id, CONCAT(u.Username,' : ', i.Title) AS IssueAssignee
FROM Issues AS i
JOIN Users AS u ON i.AssigneeId = u.Id
ORDER BY i.Id DESC, IssueAssignee;

SELECT f.Id, f.[Name], CONCAT(f.Size,'KB')
FROM Files AS f
LEFT JOIN Files as p ON f.Id = p.ParentId
WHERE p.Id IS NULL
ORDER BY f.Id, f.[Name], f.Size DESC;

SELECT TOP(5)r.Id, r.[Name], COUNT(c.RepositoryId) AS Commits
FROM Repositories AS r
JOIN Commits AS c ON r.Id = c.RepositoryId
JOIN RepositoriesContributors AS rc ON rc.RepositoryId = r.Id
GROUP BY r.Id, r.[Name]
ORDER BY Commits DESC, r.Id, r.[Name]

SELECT u.Username, AVG(f.Size) AS Size
FROM Users AS u
JOIN Commits AS c ON c.ContributorId = u.Id
JOIN Files AS f ON f.CommitId = c.Id
GROUP BY u.Username
ORDER BY Size DESC, u.Username;

--Section 4. Programmability (20 pts)

GO

CREATE FUNCTION udf_UserTotalCommits(@username VARCHAR(30))
RETURNS INT
AS
	BEGIN
		DECLARE @Result INT;

		SET @Result =
		(SELECT COUNT(ContributorId)
		FROM Commits AS c
		WHERE ContributorId IN
		(SELECT Id
		FROM Users
		WHERE Username = @username));
		RETURN @Result
	END

GO

SELECT dbo.udf_UserTotalCommits('UnderSinduxrein')

GO

CREATE OR ALTER PROC usp_FindByExtension(@extension VARCHAR(max))
AS
	SELECT Id, [Name],CONCAT(Size,'KB') AS Size
	FROM Files
	WHERE RIGHT([Name],LEN(@extension)) = @extension
	ORDER BY Id, [Name], Size DESC

	GO

--variant 2
CREATE OR ALTER PROC usp_FindByExtension(@extension VARCHAR(max))
AS
	SELECT Id, [Name], CONCAT(Size,'KB') AS Size
	FROM Files
	WHERE [Name] LIKE '%' + @extension
	ORDER BY Id, [Name], Size DESC

EXEC usp_FindByExtension 'txt'