-- 3 month moving average of internet sales.
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
GROUP BY Year, Month, AVG_Monthly_Sales
ORDER BY Year, Month; 

-- Yearly Running Total
SELECT Year
,Month
,SUM(Sales) OVER (PARTITION BY Year ORDER BY Month ROWS UNBOUNDED PRECEDING) as YTDSales
,Sales AS Monthly_sales
FROM
(SELECT	SUM(s.SalesAmount) AS 'Sales' 
		,	MONTH(s.OrderDate) AS 'Month'
		,	year(s.OrderDate) AS 'Year'
	FROM	FactInternetSales s
	GROUP BY
			MONTH(s.OrderDate)
		,	year(s.OrderDate)) AS S
GROUP BY Year, Month, Sales
ORDER BY Year, Month;
                                  
