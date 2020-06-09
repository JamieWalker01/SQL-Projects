-- 3 Month Moving Average of Internet Sales.
SELECT Year
, Month
, AVG(AVG_Monthly_Sales) OVER(ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS '3_Month_Moving_AVG'
, AVG_Monthly_Sales
FROM 
(SELECT YEAR(s.OrderDate) AS 'Year'
 ,MONTH(s.OrderDate) AS 'Month'
 ,SUM(s.SalesAmount) AS 'AVG_Monthly_Sales'
FROM FactInternetSales s 
GROUP BY YEAR(s.OrderDate), MONTH(s.OrderDate)) AS s
-- Using an inner query to make an aggregate of an aggregate.
GROUP BY Year, Month, AVG_Monthly_Sales
ORDER BY Year, Month; 

-- Yearly Running Total
SELECT Year
,Month
,SUM(Sales) OVER (PARTITION BY Year ORDER BY Month ROWS UNBOUNDED PRECEDING) as YTD_Sales
,Sales AS Monthly_sales
FROM
(SELECT	
 SUM(s.SalesAmount) AS 'Sales' 
,MONTH(s.OrderDate) AS 'Month'
,year(s.OrderDate) AS 'Year'
FROM FactInternetSales s
GROUP BY MONTH(s.OrderDate), year(s.OrderDate)) AS S
-- Again using an inner query to make an aggregate of an aggregate. 
GROUP BY Year, Month, Sales
ORDER BY Year, Month;
			  
-- Year on Year Monthly Sales Percent Change 
WITH MonthlySales_CTE (Year, Month, Sales) AS
(SELECT 
  d.CalendarYear
, d.MonthNumberOfYear
, SUM(s.SalesAmount) 
FROM DimDate d	
JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear) 
-- Using a common table expression to hold previous years sales.

SELECT 
  d.CalendarYear AS Year
, d.MonthNumberOfYear AS Month
, CTE.Sales AS Last_years_Sales
, SUM(s.SalesAmount) AS Current_Sales
, (SUM(s.SalesAmount) - CTE.Sales)/ SUM(s.SalesAmount) AS Percent_Change
FROM DimDate d
JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
JOIN MonthlySales_CTE CTE ON d.CalendarYear-1 = CTE.Year -- The CTE is joined on calenderyear-1 to assign it to the previous years sales.
AND d.MonthNumberOfYear = CTE.Month
GROUP BY d.CalendarYear, d.MonthNumberOfYear, CTE.Sales
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
                                  
