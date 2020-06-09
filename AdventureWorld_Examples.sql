-- 3 month moving average of internet sales.

SELECT Year
, Month
, AVG(AVG_Monthly_Sales) OVER(ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS '3_Month_Moving_AVG'
, AVG_Monthly_Sales
FROM 
(SELECT YEAR(s.OrderDate) AS 'Year', MONTH(s.OrderDate) AS 'Month', SUM(s.SalesAmount) AS 'AVG_Monthly_Sales'
FROM FactInternetSales s 
GROUP BY YEAR(s.OrderDate), MONTH(s.OrderDate)) AS s
GROUP BY Year, Month, AVG_Monthly_Sales
ORDER BY Year, Month; 
