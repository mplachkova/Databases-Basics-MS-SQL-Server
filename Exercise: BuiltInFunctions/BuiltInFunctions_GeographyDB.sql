USE Geography

/*Find all countries that holds the letter 'A' in their name at least 3 times (case insensitively),
sorted by ISO code. Display the country name and ISO code.*/

SELECT CountryName, IsoCode
FROM Countries
WHERE (LEN(CountryName) - LEN(REPLACE(CountryName,'a',''))) >= 3
ORDER BY IsoCode;

/*Combine all peak names with all river names, so that the last letter of each peak name is the same as the first letter of its corresponding river name.
Display the peak names, river names, and the obtained mix (mix should be in lowercase).
Sort the results by the obtained mix.*/

SELECT P.PeakName, R.RiverName,
LOWER (CONCAT(SUBSTRING(P.PeakName,1, LEN(P.PeakName) - 1),R.RiverName)) AS Mix
FROM Rivers AS R, Peaks AS P
WHERE RIGHT(PeakName,1) = LEFT(RiverName, 1)
ORDER BY Mix;