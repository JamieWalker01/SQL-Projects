-- Top 10 customers
SELECT (c.FirstName ||' '|| c.LastName) AS Customer_name, 
c.Country, 
ROUND(SUM(i.Total),2) AS Total_Purchased
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName
ORDER BY 3 DESC
LIMIT 10;
