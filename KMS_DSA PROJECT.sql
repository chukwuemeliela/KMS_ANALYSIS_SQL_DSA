CREATE DATABASE KMS_PROJECT

---Import the data to be analyzed into the database

SELECT * FROM kms
SELECT * FROM Order_Status

--QUESTION 1--
--Product Category With the Highest Sales
SELECT Top 1 Product_Category, sum(sales) as Highest_Sales
FROM kms
GROUP BY Product_Category
ORDER BY Highest_Sales Desc
--The result shows that Technology has the highest sales of 5984248.50


--QUESTION 2a--
--Top 3 Region by Sales
SELECT Top 3 Region, sum(sales) as Total_Sales
FROM kms
GROUP BY Region
ORDER BY Total_Sales Desc
--West, Ontario and Prarie has the top 3 sales with total sales of 3597549.41, 3063212.60, and 2837304.60 respectively

--QUESTION 2b--
--Bottom 3 Region by Sales
SELECT Top 3 Region, sum(sales) as Total_Sales
FROM kms
GROUP BY Region
Order by Total_Sales
--Nunavut, Northwest Territories, and Yukon has the bottom 3 sales with total sales of 116376.47, 800847.35, and 975867.39 respectively


--QUESTION 3--
--Total Sales of Appliances in Ontario
SELECT Region, sum(sales) as App_Total_Sales
FROM kms
WHERE Product_Sub_Category = 'Appliances'
	AND Region = 'Ontario'
GROUP BY Region

--Alternative Method--
SELECT sum(sales) as Ontario_Appliance_Total_Sales
FROM kms
WHERE product_sub_category ='appliances'
and region = 'ontario'
--Total Sales of Appliances in Ontario is 202346.84


---QUESTION 4
--Bottom 10 Customers by Revenue
SELECT Top 10 
	Customer_Name, 
	Customer_Segment,
	Product_Category,
	Sales
FROM kms
ORDER BY Sales


--QUESTION 5--
--Shipping Method With the Most Shipping Cost
SELECT Top 1 Ship_Mode, sum(shipping_cost) as Shipping_Cost
FROM kms
GROUP BY Ship_Mode
ORDER BY Shipping_Cost Desc
--KMS incurred the most shipping cost using Delivery Truck, with the sum of 51971.94


---CASE SCENARIO II---
--QUESTION 6
--Most Valuable Customers and the Products They Purchase
SELECT TOP 10
	customer_name,
	product_category,
	count(product_category) as number_purchased,
	sum(sales) as Total_Sales
FROM kms
GROUP BY 
	customer_name,
	product_category
ORDER BY Total_Sales Desc
--Emily Phan is the most valuable customer with total revenue of 110481.96

--Most Valuable Customers by Segment and the Products They Purchase
SELECT
	customer_segment,
	product_category,
	count(product_category) as number_purchased,
	sum(sales) as Total_Sales
FROM kms
GROUP BY 
	customer_segment,
	product_category
ORDER BY Total_Sales Desc
--The Corporate segment is the most valuable customer segment with purchases made most from the Technology category

--QUESTION 7
--Small Business Owner With the Highest Sales
SELECT Top 1 Customer_Name, sum(sales) as SB_Highest_Sales
FROM kms
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY SB_Highest_Sales Desc
--Dennis Kane with total sales of 75967.59 is the small business customer with the highest sales


--QUESTION 8
--Corporate Customer with the most number of orders placed in 2009 - 2012
SELECT Top 1 Customer_Name, count(Order_Quantity) as Order_Quantity
FROM kms
WHERE Customer_Segment = 'Corporate'
GROUP BY Customer_Name
ORDER BY Order_Quantity Desc
--Adam Hart with 27 orders placed the highest number of orders from the corporate customer segment from 2009 to 2012


--QUESTION 9
--Consumer Customer That Was Most Profitable
SELECT Top 1 Customer_Name, sum(Profit) as Profit
FROM kms
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY Profit Desc
--Emily Phan is the most profitable consumer customer with a total profit of 34005.44


--QUESTION 10
--Customers That Returned Items And Their Segment
CREATE VIEW vw_kms_joined as
	SELECT distinct
		kms.Order_ID,
		kms.Customer_Name,
		kms.Customer_Segment
	FROM (select distinct order_id, customer_name, customer_segment from kms) as kms
inner join Order_Status
on kms.Order_ID = Order_Status.Order_ID
SELECT * FROM vw_kms_joined
--573 distinct customers returned items

--QUESTION 11
--Appropriation of Shipping Costs Based on Order Priority
SELECT order_priority, count(order_priority) as Total_Order
FROM kms
GROUP BY order_priority

SELECT ship_mode, count(ship_mode) as Total_Order
FROM kms
GROUP BY ship_mode

SELECT
	ship_mode,
	CASE
		WHEN order_priority in ('not specified', 'low') THEN 'Low'
		WHEN order_priority = 'medium' THEN 'medium'
		WHEN order_priority in ('high', 'critical') THEN 'high'
		ELSE 'Empty'
	END as Urgency_Group,
	count(order_priority) as Order_Count,
	sum(shipping_cost) as Total_Shipping_Cost,
	avg(shipping_cost) as Avg_Shipping_Cost
FROM kms
GROUP BY 
	ship_mode,	
	CASE
		WHEN order_priority in ('not specified', 'low') THEN 'Low'
		WHEN order_priority = 'medium' THEN 'medium'
		WHEN order_priority in ('high', 'critical') THEN 'high'
		ELSE 'Empty'
	END
ORDER BY ship_mode, Urgency_Group
