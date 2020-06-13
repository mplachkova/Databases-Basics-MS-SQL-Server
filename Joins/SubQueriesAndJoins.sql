USE SoftUni

/*Write a query that selects:
    • EmployeeId
    • JobTitle
    • AddressId
    • AddressText
Return the first 5 rows sorted by AddressId in ascending order.
*/

SELECT TOP(5) EmployeeID, JobTitle, Addresses.AddressID, AddressText
FROM Employees
JOIN Addresses ON Employees.AddressID = Addresses.AddressID
ORDER BY AddressID;

/*
Write a query that selects:
    • FirstName
    • LastName
    • Town
    • AddressText
Sorted by FirstName in ascending order then by LastName. Select first 50 employees.
*/

SELECT TOP(50) FirstName, LastName, Towns.[Name], AddressText
FROM Employees
JOIN Addresses ON Employees.AddressID = Addresses.AddressID
JOIN Towns ON Addresses.TownID = Towns.TownID
ORDER BY FirstName, LastName;

/*
Write a query that selects:
    • EmployeeID
    • FirstName
    • LastName
    • DepartmentName
Sorted by EmployeeID in ascending order.
Select only employees from "Sales" department.
*/

SELECT EmployeeID, FirstName, LastName,Departments.[Name]
FROM Employees
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.[Name] = 'Sales'
ORDER BY EmployeeID;

/*
Write a query that selects:
    • EmployeeID
    • FirstName
    • Salary
    • DepartmentName
Filter only employees with salary higher than 15000.
Return the first 5 rows sorted by DepartmentID in ascending order.
*/

SELECT TOP(5) EmployeeID, FirstName, Salary, Departments.[Name]
FROM Employees
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Salary > 15000
ORDER BY Employees.DepartmentID;

/*Write a query that selects:
    • EmployeeID
    • FirstName
Filter only employees without a project.
Return the first 3 rows sorted by EmployeeID in ascending order.
*/

SELECT TOP (3) Employees.EmployeeID, FirstName
FROM Employees
LEFT JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
WHERE EmployeesProjects.ProjectID IS NULL
ORDER BY Employees.EmployeeID;

/*
Write a query that selects:
    • FirstName
    • LastName
    • HireDate
    • DeptName
Filter only employees hired after 1.1.1999 and are from either "Sales" or "Finance" departments,
sorted by HireDate (ascending).
*/

SELECT FirstName, LastName, HireDate, Departments.[Name]
FROM Employees
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE HireDate > '1.1.1999' AND Departments.[Name] IN ('Sales','Finance')
ORDER BY HireDate;

/*
Write a query that selects:
    • EmployeeID
    • FirstName
    • ProjectName
Filter only employees with a project which has started after 13.08.2002 and it is still ongoing (no end date).
Return the first 5 rows sorted by EmployeeID in ascending order.
*/

SELECT TOP(5) Employees.EmployeeID, FirstName, Projects.[Name] AS ProjectName
FROM Employees
JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
JOIN Projects ON Projects.ProjectID = EmployeesProjects.ProjectID
WHERE Projects.StartDate > '2002-08-13' AND Projects.EndDate IS NULL
ORDER BY Employees.EmployeeID;

/*
Write a query that selects:
    • EmployeeID
    • FirstName
    • ProjectName
Filter all the projects of employee with Id 24.
If the project has started during or after 2005 the returned value should be NULL.
*/

SELECT Employees.EmployeeID, Employees.FirstName,
CASE
	WHEN DATEPART(YEAR,StartDate) >= 2005 THEN NULL
	ELSE Projects.[Name]
END AS ProjectName
FROM Employees
JOIN EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID
JOIN Projects ON Projects.ProjectID = EmployeesProjects.ProjectID
WHERE Employees.EmployeeID = 24;

/*Write a query that selects:
    • EmployeeID
    • FirstName
    • ManagerID
    • ManagerName
Filter all employees with a manager who has ID equals to 3 or 7.
Return all the rows, sorted by EmployeeID in ascending order.
*/

SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	m.FirstName AS ManagerName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3 , 7)
ORDER BY EmployeeID;

/*Write a query that selects:
    • EmployeeID
    • EmployeeName
    • ManagerName
    • DepartmentName
Show first 50 employees with their managers and the departments they are in (show the departments of the employees).
Order by EmployeeID.
*/

SELECT TOP (50)
	e.EmployeeID,
	CONCAT(e.FirstName,' ', e.LastName) AS EmployeeName,
	CONCAT(m.FirstName,' ', m.LastName) AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY EmployeeID;

--Write a query that returns the value of the lowest average salary of all departments.

SELECT TOP (1) AVG(Salary) AS MinAvrageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY MinAvrageSalary;

/*Write a query that selects:
    • CountryCode
    • MountainRange
    • PeakName
    • Elevation
Filter all peaks in Bulgaria with elevation over 2835. Return all the rows sorted by elevation in descending order.
*/

USE Geography

SELECT CountryCode, MountainRange, PeakName, Elevation
FROM Peaks AS p
JOIN Mountains AS m ON p.MountainId = m.Id
JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC;

/*Write a query that selects:
    • CountryCode
    • MountainRanges
Filter the count of the mountain ranges in the United States, Russia and Bulgaria.
*/

SELECT mc.CountryCode, COUNT(m.MountainRange) AS MountainRanges
FROM Mountains AS m
JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
JOIN Countries AS c ON c.CountryCode = mc.CountryCode
WHERE c.CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY mc.CountryCode;

/*Write a query that selects:
    • CountryName
    • RiverName
Find the first 5 countries with or without rivers in Africa. Sort them by CountryName in ascending order.
*/

SELECT TOP (5) CountryName, RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
JOIN Continents ON c.ContinentCode = Continents.ContinentCode
WHERE Continents.ContinentName = 'Africa'
ORDER BY c.CountryName;
