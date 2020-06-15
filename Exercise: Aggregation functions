USE Gringotts

SELECT COUNT (*)
FROM WizzardDeposits;

SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits;

/*
For wizards in each deposit group show the longest magic wand.
Rename the new column appropriately.
*/

SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup;

/*
Select the two deposit groups with the lowest average wand size.
*/

SELECT DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
HAVING AVG(MagicWandSize) =
  (SELECT TOP 1
  AVG(MagicWandSize) AS AverageWandSize
  FROM WizzardDeposits
  GROUP BY DepositGroup
  ORDER BY AverageWandSize)

/*
Select all deposit groups and their total deposit sums.
*/

SELECT DepositGroup, SUM(DepositAmount)
FROM WizzardDeposits
GROUP BY DepositGroup;

/*
Select all deposit groups and their total deposit sums but only for the wizards who have their magic wands crafted by Ollivander family.
*/

SELECT DepositGroup, Sum(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup;

/*
Select all deposit groups and their total deposit sums but only for the wizards who have their magic wands crafted by Ollivander family.
Filter total deposit amounts lower than 150000. Order by total deposit amount in descending order.
*/

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits AS wd
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC;

/*
Create a query that selects:
    • Deposit group 
    • Magic wand creator
    • Minimum deposit charge for each group 
Select the data in ascending ordered by MagicWandCreator and DepositGroup.
*/

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup;

/*
Write down a query that creates 7 different groups based on their age.
Age groups should be as follows:
    • [0-10]
    • [11-20]
    • [21-30]
    • [31-40]
    • [41-50]
    • [51-60]
    • [61+]
The query should return
    • Age groups
    • Count of wizards in it
*/

SELECT
	CASE 
		WHEN wd.Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN wd.Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN wd.Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN wd.Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN wd.Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN wd.Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN wd.Age >= 61 THEN '[61+]'
	END AS AgeGroup,
COUNT(*) AS WizardCount
FROM WizzardDeposits AS wd
GROUP BY 
	CASE 
		WHEN wd.Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN wd.Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN wd.Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN wd.Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN wd.Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN wd.Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN wd.Age >= 61 THEN '[61+]'
	END;

/*Write a query that returns all unique wizard first letters of their first names only if they have deposit of type Troll Chest.
Order them alphabetically.
Use GROUP BY for uniqueness.
*/
 
SELECT DISTINCT(SUBSTRING(FirstName, 1 , 1)) AS FirstLetter
FROM WizzardDeposits AS wd
WHERE DepositGroup = 'Troll Chest';
