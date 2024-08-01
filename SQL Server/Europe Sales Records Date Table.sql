-- Date Table for Europe Sales Data Database



CREATE TABLE [Europe Sales Data].dbo.[dim_Dates] (
	DATE DATE NOT NULL PRIMARY KEY,
	[YEAR] SMALLINT NOT NULL,
	[QUARTER] TINYINT NOT NULL,
	[MONTH] TINYINT NOT NULL,
	[MONTHNAME] VARCHAR(9) NOT NULL,
	[DAYOFYEAR] SMALLINT NOT NULL,
	[DAYOFMONTH] TINYINT NOT NULL,
	[DAYOFWEEK] TINYINT NOT NULL, 
	[WEEKDAYNAME] VARCHAR(9) NOT NULL
	)



DECLARE @Earliest_Date AS DATE;
DECLARE @Latest_Date AS DATE;

SELECT @Earliest_Date = MIN(Order_Date) FROM [Europe Sales Records];
SELECT @Latest_Date = MAX(Ship_Date) FROM [Europe Sales Records];

WITH ExpandedDate(DateRange)
AS(
SELECT DateRange = DATEADD(DAY, value, @Earliest_Date)
FROM GENERATE_SERIES(0, DATEDIFF(DAY, @Earliest_Date, @Latest_Date))
)
INSERT INTO [dim_Dates]
SELECT DateRange AS DATE, 
		DATEPART(YYYY, DateRange) AS [YEAR], 
		DATEPART(Q, DateRange) AS [QUARTER], 
		DATEPART(MM, DateRange) AS [MONTH],
		dbo.func_MONTHNAME(DateRange) AS [MONTHNAME],
		DATEPART(DY, DateRange) AS [DAYOFYEAR],
		DATEPART(DD, DateRange) AS [DAYOFMONTH],
		DATEPART(DW, DateRange) AS [DAYOFWEEK],
		dbo.func_WEEKDAYNAME(DateRange) AS [WEEKDAYNAME]
FROM ExpandedDate