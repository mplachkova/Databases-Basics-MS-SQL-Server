USE Diablo

/*
Find the top 50 games ordered by start date, then by name of the game.
Display only games from 2011 and 2012 year.
Display start date in the format "yyyy-MM-dd".
*/

SELECT TOP(50) [Name],
	FORMAT([Start],'yyyy-MM-dd') AS [Start]
FROM Games
WHERE YEAR([Start]) IN (2011,2012)
ORDER BY [Start], [Name];

/*
Find all users along with information about their email providers.
Display the username and email provider.
Sort the results by email provider alphabetically, then by username.
*/

SELECT Username,
     RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS [Email provider]
FROM Users
ORDER BY [Email provider], Username;

/*
Find all users along with their IP addresses sorted by username alphabetically.
Display only rows that IP address matches the pattern: "***.1^.^.***". 
Legend: * - one symbol, ^ - one or more symbols
*/

SELECT Username, IpAddress
FROM Users
WHERE IpAddress LIKE ('___.1%.%.___')
ORDER BY Username;

/*
Find all games with part of the day and duration sorted by game name alphabetically then by duration (alphabetically, not by the timespan)
and part of the day (all ascending).
Parts of the day should be Morning (time is >= 0 and < 12),
Afternoon (time is >= 12 and < 18),
Evening (time is >= 18 and < 24).
Duration should be Extra Short (smaller or equal to 3),
Short (between 4 and 6 including),
Long (greater than 6) and 
Extra Long (without duration).
*/

SELECT [Name],
CASE
	WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
END AS [Part of the day],
CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'
END AS Duration
FROM Games
ORDER BY [Name], Duration;