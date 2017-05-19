-- Load
rawData = LOAD '/user/cloudera/exercicio/input/' AS (line:chararray);

-- Parse
tempWithYear = FOREACH rawData GENERATE SUBSTRING (line, 15, 19) AS (year:chararray), (SUBSTRING(line, 87, 88)=='+'? SUBSTRING(line, 88, 92) : SUBSTRING(line, 87, 92)) AS (temp:chararray), SUBSTRING(line, 92, 93) AS (quality:chararray);

-- Check if is valid
tempWithYear_filtered = FILTER tempWithYear BY (quality MATCHES '[01459]');

-- CAST to int (important)
tempWithYear_cast = FOREACH tempWithYear GENERATE year, (int) temp;


-- GROUP BY YEAR
tempByYear = GROUP tempWithYear_cast BY year;

-- Finally generate the average temperature
avgByYear = FOREACH tempByYear GENERATE group AS year, AVG(tempWithYear_cast.temp) AS temp;

-- Show to user
DUMP avgByYear;
