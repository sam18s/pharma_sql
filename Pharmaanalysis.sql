CREATE DATABASE pharma1;
use pharma1;
select * from pharma_data;

-- 1. Retrieve all columns for all records in the dataset.
 select * from pharma_data;
 
--  2. How many unique countries are represented in the dataset?
select country,count(country)
from pharma_data
group by country;

-- 3. Select the names of all the customers on the 'Retail' channel.
select customer_Name, Sub_Channel
from pharma_data
where Sub_Channel = 'Retail';


-- 4. Find the total quantity sold for the ' Antibiotics' product class.
select Product_Class, count(Quantity) as Total_Quantity
from pharma_data
where Product_Class = 'Antibiotics';


-- 5. List all the distinct months present in the dataset. 
select distinct(Month),count(Month) as Count
from pharma_data
group by Month;


-- 6. Calculate the total sales for each year.
select Year,count(Sales) as Total_sales
from pharma_data
group by Year;


-- 7. Find the customer with the highest sales value.
SELECT Customer_Name, Sales
FROM pharma_data
ORDER BY Sales DESC
LIMIT 1;


-- 8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.
select Name_of_Sales_Rep as employees , Manager
from pharma_data
where Manager = 'James Goodwill'
group by Name_of_Sales_Rep;

-- 10. Calculate the average price of products in each sub-channel.
select Sub_channel , AVG(Price)
from pharma_data
group by Sub_channel;


-- 11.Retrieve all sales and customer name list
select Customer_Name, sales
from pharma_Data;


-- 12. Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.
SELECT *
FROM pharma_Data
WHERE  Name_of_Sales_Rep = 'Rendsburg'
    AND YEAR(Sales) = 2018;

-- 13. Calculate the total sales for each product class, for each month, and order the results by year, month, and product class.
SELECT YEAR AS Sale_Year,
       MONTH AS Sale_Month,
       Product_Class,
       SUM(Sales) AS Total_Sales
FROM pharma_Data
GROUP BY YEAR, MONTH, Product_Class
ORDER BY Sale_Year, Sale_Month, Product_Class;


-- 14. Find the top 3 sales reps with the highest sales in 2019.
SELECT Sales
FROM pharma_data
WHERE Year = '2019'
ORDER BY Sales DESC
LIMIT 3;


-- 15. Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years. 
select Month, Sub_Channel,  count(Sales) as Total_sales , avg(Sales) as Average_sales 
from pharma_Data
group by Month , Sub_Channel;


-- 16. Create a summary report that includes the total sales, average price, and total quantity sold for each product class.
SELECT 
    Product_Class,
    SUM(Sales) AS Total_Sales,
    AVG(Price) AS Average_Price,
    SUM(Quantity) AS Total_Quantity_Sold
FROM 
    pharma_Data
GROUP BY 
    Product_Class;
    
-- 17. Find the top 5 customers with the highest sales for each year.
SELECT Customer_Name, Sales, Year
FROM (
    SELECT Customer_Name, Sales, Year,
           ROW_NUMBER() OVER(PARTITION BY Year ORDER BY Sales DESC) AS SalesRank
    FROM pharma_Data
) ranked_sales
WHERE SalesRank <= 5;

-- 18. Calculate the year-over-year growth in sales for each country.
SELECT Country, Year, Sales,
    LAG(Sales) OVER(PARTITION BY Country ORDER BY Year) AS Previous_Year_Sales,
    (Sales - LAG(Sales) OVER(PARTITION BY Country ORDER BY Year)) / LAG(Sales)
    OVER(PARTITION BY Country ORDER BY Year) * 100 AS YoY_Growth
FROM pharma_Data
ORDER BY Country, Year;


-- 19. List the months with the lowest sales for each year
WITH RankedSales AS (
    SELECT Year,
           Month,
           Sales,
           ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Sales) AS SalesRank
    FROM pharma_data
)
SELECT Year, Month, Sales
FROM RankedSales
WHERE SalesRank = 1;


-- 20. Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel.
SELECT Country, Sub_Channel, SUM(Sales) AS TotalSales
FROM pharma_data
GROUP BY Country, Sub_Channel;

-- then find the country with the highest total sales for each sub-channel. 
WITH SubChannelSales AS (
    SELECT Country, Sub_Channel, SUM(Sales) AS TotalSales,
           ROW_NUMBER() OVER(PARTITION BY Sub_Channel ORDER BY SUM(Sales) DESC) AS RN
    FROM pharma_Data
    GROUP BY Country, Sub_Channel
)
SELECT Country, Sub_Channel, TotalSales
FROM SubChannelSales
WHERE RN = 1;


