USE SoftUni

GO

/*Create stored procedure usp_GetEmployeesSalaryAbove35000 that returns all employees’ first and last names for whose salary is above 35000.
*/

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary > 35000

GO

--EXEC usp_GetEmployeesSalaryAbove35000

/*
Create stored procedure usp_GetEmployeesSalaryAboveNumber that accept a number (of type DECIMAL(18,4)) as parameter and
returns all employees’ first and last names whose salary is above or equal to the given number.
*/

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@MinSalary DECIMAL(18,4))
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @MinSalary
GO

--EXEC usp_GetEmployeesSalaryAboveNumber 48100

/*
Write a stored procedure usp_GetTownsStartingWith that accept string as parameter and returns all town names starting with that string.
*/

/*
CREATE PROC usp_GetTownsStartingWith(@StartingString VARCHAR(50))
AS
	SELECT [Name]
	FROM Towns
	WHERE [Name] LIKE @StartingString + '%'
GO
*/

CREATE PROC usp_GetTownsStartingWith(@StartingString VARCHAR(50))
AS
	SELECT [Name]
	FROM Towns
	WHERE LEFT([Name], LEN(@StartingString)) = @StartingString

--EXEC usp_GetTownsStartingWith B

GO;

/*
Write a stored procedure usp_GetEmployeesFromTown that accepts town name as parameter and
return the employees’ first and last name that live in the given town. 
*/

CREATE PROC usp_GetEmployeesFromTown(@TownName VARCHAR(50))
AS
	SELECT FirstName, LastName
	FROM Employees AS e
	JOIN Addresses AS a ON a.AddressID = e.AddressID
	JOIN Towns AS t ON t.TownID = a.TownID
	WHERE t.[Name] = @TownName
GO

/*
Write a function ufn_GetSalaryLevel(@salary DECIMAL(18,4)) that receives salary of an employee and returns the level of the salary.
    • If salary is < 30000 return "Low"
    • If salary is between 30000 and 50000 (inclusive) return "Average"
    • If salary is > 50000 return "High"
*/

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(7);
	
	IF(@salary < 30000)
		BEGIN
			SET @SalaryLevel = 'Low';
		END
	ELSE IF(@salary BETWEEN 30000 AND 50000)
		BEGIN
			SET @SalaryLevel = 'Average';
		END
	ELSE
		BEGIN
			SET @SalaryLevel = 'High';
		END

	RETURN @SalaryLevel;
END

GO

SELECT dbo.ufn_GetSalaryLevel(Salary)
FROM Employees

GO

/*
Write a stored procedure usp_EmployeesBySalaryLevel that receive as parameter level of salary (low, average or high) and
print the names of all employees that have given level of salary.
You should use the function - "dbo.ufn_GetSalaryLevel(@Salary) "
*/

CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(7))
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE @SalaryLevel = dbo.ufn_GetSalaryLevel(Salary)

--EXEC usp_EmployeesBySalaryLevel 'Low'

GO

/*
Define a function ufn_IsWordComprised(@setOfLetters, @word)
that returns true or false depending on that if the word is a comprised of the given set of letters.
*/

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(10), @word VARCHAR(10))
RETURNS BIT
AS
BEGIN
	DECLARE @Result BIT;
	SET @Result = 0;

	DECLARE @Index TINYINT;
	SET @Index = 1;

	WHILE (LEN(@word) >= @Index)
		BEGIN
			IF(CHARINDEX(SUBSTRING(@word, @Index, 1),@setOfLetters)) != 0
				BEGIN
					SET @Result = 1;
				END;
			ELSE
				BEGIN
					SET @Result = 0;
					BREAK;
				END
			SET @Index += 1;
		END
RETURN @Result;
END

GO

/*
Write a procedure with the name usp_DeleteEmployeesFromDepartment (@departmentId INT) which deletes all Employees from a given department.
Delete these departments from the Departments table too.
Finally SELECT the number of employees from the given department.
If the delete statements are correct the select query should return 0.
*/

ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL

GO

CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
	
	ALTER TABLE Departments
	ALTER COLUMN ManagerID int NULL

	DECLARE @empIDsToBeDeleted TABLE
	(
	Id int
	)

	INSERT INTO @empIDsToBeDeleted
	SELECT e.EmployeeID
	FROM Employees AS e
	WHERE e.DepartmentID = @departmentId

	ALTER TABLE Departments
	ALTER COLUMN ManagerID int NULL

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

	DELETE FROM Employees
	WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId 

	SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
	JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID
	WHERE e.DepartmentID = @departmentId

GO

--EXEC usp_DeleteEmployeesFromDepartment 7
