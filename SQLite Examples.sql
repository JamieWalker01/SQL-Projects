-- Top 10 Customers By Revenue 
SELECT (c.FirstName ||' '|| c.LastName) AS Customer_name, 
c.Country, 
ROUND(SUM(i.Total),2) AS Total_Purchased
FROM customers c
JOIN invoices i
ON c.CustomerId = i.CustomerId
GROUP BY c.FirstName, c.LastName
ORDER BY 3 DESC
LIMIT 10;

-- Top 10 Countries By Revenue and Their Percentage of Total Income 
SELECT  BillingCountry, 
ROUND(SUM(Total),2) AS Total_Purchased, 
ROUND(100.0 * ROUND(SUM(Total),2)/(SELECT SUM(Total) FROM invoices),2) AS Percent_of_Total
FROM invoices 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Revenue By Month
SELECT strftime("%Y-%m", InvoiceDate) AS Month, 
SUM(Total) 
FROM invoices
GROUP BY 1
ORDER BY 1;
