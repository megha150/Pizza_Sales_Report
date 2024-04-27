CREATE TABLE PizzaSales(
	pizza_id serial Primary Key,
	order_id int,
	pizza_name_id varchar(50),
	quantity int,
	order_date timestamp,
	order_time timestamp,
	unit_price numeric(4,2),
	total_price numeric(4,2),
	pizza_size varchar(5),
	pizza_category varchar(50),
	pizza_ingredients varchar(200),
	pizza_name varchar(100)
);


COPY PizzaSales FROM 'D:/pizza_sales.csv' WITH CSV HEADER;


select * from pizzasales;


--Finding out the important KPI's required to determine sales result
SELECT SUM(total_price) AS Total_Revenue
FROM pizzasales;

SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value 
FROM pizzasales;

SELECT SUM(quantity) AS Total_pizza_sold 
FROM pizzasales;

SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizzasales;

SELECT CAST(CAST(SUM(quantity) AS numeric(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS numeric(10,2)) AS numeric(10,2))
AS Avg_Pizzas_per_order
FROM pizzasales;


--hourly trend for total pizzas sold
SELECT extract(HOUR from order_time) as order_hours, SUM(quantity) as total_pizzas_sold
from pizzasales
group by extract(HOUR from order_time)
order by extract(HOUR from order_time);


--weekly trend for total orders
SELECT 
    extract(week from order_date) AS WeekNumber,
    extract(year from order_date) AS Year,
    COUNT(DISTINCT order_id) AS Total_orders
FROM 
    pizzasales
GROUP BY 
    extract(week from order_date),
    extract(year from order_date)
ORDER BY 
    Year, WeekNumber;
	
	
--% of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS numeric(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizzasales) AS numeric(10,2)) AS PCT
FROM pizzasales
GROUP BY pizza_category;


--% of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS NUMERIC(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizzasales) AS NUMERIC(10,2)) AS PCT
FROM pizzasales
GROUP BY pizza_size
ORDER BY pizza_size;


--Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizzasales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;


--Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;


--Bottom 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;


--Top 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;


--Bottom 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;


--Top 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;


--Bottom 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;
