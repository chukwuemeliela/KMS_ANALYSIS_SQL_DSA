# KMS_ANALYSIS_SQL_DSA
SQL-based analysis of sales and customer data from Kultra Mega Stores  (KMS) to uncover insights into product performance, customer value, shipping efficiency, and revenue strategy between 2009–2012.

## Project Objectives

- Create a database. 
- Clean and transform raw transactional data using SQL.
- Write analytical queries to uncover business insights.
- Present results clearly using query outputs

## Dataset Info

- **Source**: Kultra Mega Stores, Abuja Branch
- **Tables**:
  - KMS (Contains Customers, Orders, Products, Shipping and Sales Details)
  - Orders_Status

 ## Analysis Tools
 
 - SQL Server
 - SSMS

## Data Preparation and Cleaning

- Created a database specific for the project.
  <pre>CREATE DATABASE KMS_PROJECT</pre>
- Imported the CSV into the database.
- While importing, ensured that the datatypes matched the columns.
- Data Cleaning for nulls

## Business Questions Answered

1.  Which product category had the highest sales? 
2. What are the Top 3 and Bottom 3 regions in terms of sales? 
3. What were the total sales of appliances in Ontario?
4. The bottom 10 customers and how to improve revenue from them.
5. KMS incurred the most shipping cost using which shipping method?
6. Who are the most valuable customers, and what products or services do they typically 
purchase? 
7. Which small business customer had the highest sales? 
8. Which Corporate Customer placed the most number of orders in 2009 – 2012? 
9. Which consumer customer was the most profitable one? 
10. Which customer returned items, and what segment do they belong to?
11. Did the company appropriately spend shipping costs based on the order priority?

## SQL SCRIPTS AND INSIGHTS
<a href=https://github.com/chukwuemeliela/KMS_ANALYSIS_SQL_DSA/blob/main/KMS_DSA%20PROJECT.sql>View SQL Files<a/>

### Product Category With the Highest Sales
<pre>SELECT Top 1 Product_Category, sum(sales) as Highest_Sales
FROM kms
GROUP BY Product_Category
ORDER BY Highest_Sales Desc</pre>
The result shows that **Technology** has the highest sales of **5984248.50**.

### Top 3 Region by Sales
<pre>SELECT Top 3 Region, sum(sales) as Total_Sales
FROM kms
GROUP BY Region
ORDER BY Total_Sales Desc</pre>
**West**, **Ontario** and **Prarie** has the top 3 sales with total sales of **3597549.41**, **3063212.60**, and **2837304.60** respectively.

**Bottom 3 Region by Sales**
<pre>SELECT Top 3 Region, sum(sales) as Total_Sales
FROM kms
GROUP BY Region
Order by Total_Sales</pre>
**Nunavut**, **Northwest Territories**, and **Yukon** has the bottom 3 sales with total sales of **116376.47**, **800847.35**, and **975867.39** respectively.

### Total Sales of Appliances in Ontario
<pre>SELECT Region, sum(sales) as App_Total_Sales
FROM kms
WHERE Product_Sub_Category = 'Appliances'
	AND Region = 'Ontario'
GROUP BY Region</pre>

**Alternative Method**
<pre>SELECT sum(sales) as Ontario_Appliance_Total_Sales
FROM kms
WHERE product_sub_category ='appliances'
and region = 'ontario'</pre>
Total Sales of Appliances in Ontario is **202346.84**.

### Bottom 10 Customers by Revenue
<PRE>SELECT Top 10 
	Customer_Name, 
	Customer_Segment,
	Product_Category,
	Sales
FROM kms
ORDER BY Sales</PRE>
All bottom 10 customers are from the **Office Supplies** Product Category and 7 of them from the **Corporate** Customer Segment, with a customer **Adam Hart** making 2 very low purchases.
#### ADVICE:
  - Offer multiple-item combos at a slight discount if bought together.
  - Run segment-specific ad campaigns for Office Suplies, such that Home Offices might have free shipping attached to it, Small Businesses bulk discounts or subscription options while Corporate customers may need procurement-level deals or invoice based purchases.
  - Check for friction in the purchase experience of Office Supplies, such as delivery delay, limited stock, etc.
  - Reach out to the customers for feedbacks.

### Shipping Method With the Most Shipping Cost
<pre>SELECT Top 1 Ship_Mode, sum(shipping_cost) as Shipping_Cost
FROM kms
GROUP BY Ship_Mode
ORDER BY Shipping_Cost Desc</pre>
KMS incurred the most shipping cost using **Delivery Truck**, with the sum of **51971.94**.

### Most Valuable Customers and the Products They Purchase
<pre>SELECT TOP 10
	customer_name,
	product_category,
	count(product_category) as number_purchased,
	sum(sales) as Total_Sales
FROM kms
GROUP BY 
	customer_name,
	product_category
ORDER BY Total_Sales Desc</pre>
**Emily Phan** is the most valuable customer with purchases from the **Techonolgy** category and a total revenue of **110481.96**.

**Most Valuable Customers by Segment and the Products They Purchase**
<pre>SELECT
	customer_segment,
	product_category,
	count(product_category) as number_purchased,
	sum(sales) as Total_Sales
FROM kms
GROUP BY 
	customer_segment,
	product_category
ORDER BY Total_Sales Desc</pre>
The **Corporate** segment is the most valuable customer segment with purchases made most from the **Technology** category

### Small Business Owner With the Highest Sales
<pre>SELECT Top 1 Customer_Name, sum(sales) as SB_Highest_Sales
FROM kms
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY SB_Highest_Sales Desc</pre>
**Dennis Kane** with total sales of **75967.59** is the small business customer with the highest sales

### Corporate Customer with the most number of orders placed in 2009 - 2012
<pre>SELECT Top 1 Customer_Name, count(Order_Quantity) as Order_Quantity
FROM kms
WHERE Customer_Segment = 'Corporate'
GROUP BY Customer_Name
ORDER BY Order_Quantity Desc</pre>
**Adam Hart** with **27** orders placed the highest number of orders from the corporate customer segment from 2009 to 2012
**ADVICE**: Adam Hart is a repeat customer with low-value purchases. His loyalty presents an opportunity to upsell via tailored offers. The customer manager should reach out to him to build relationship and understand his needs better. Loyalties and bonuses for larger purchases can be offered to him to encourage more purchases.

### Consumer Customer That Was Most Profitable
<pre>SELECT Top 1 Customer_Name, sum(Profit) as Profit
FROM kms
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY Profit Desc</pre>
**Emily Phan** is the most profitable consumer customer with a total profit of **34005.44**.

### Customers That Returned Items And Their Segment
<pre>CREATE VIEW vw_kms_joined as
	SELECT distinct
		kms.Order_ID,
		kms.Customer_Name,
		kms.Customer_Segment
	FROM (select distinct order_id, customer_name, customer_segment from kms) as kms
inner join Order_Status
on kms.Order_ID = Order_Status.Order_ID</pre>
<pre>SELECT * FROM vw_kms_joined</pre>
*573* distinct customers returned item.

### Appropriation of Shipping Costs Based on Order Priority
<pre>SELECT order_priority, count(order_priority) as Total_Order
FROM kms
GROUP BY order_priority</pre>
<pre>SELECT ship_mode, count(ship_mode) as Total_Order
FROM kms
GROUP BY ship_mode</pre>
<pre>SELECT
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
ORDER BY ship_mode, Urgency_Group</pre>
**Delivery Truck** has the highest average shipping cost despite being supposedly economical. Meanwhile, both **Express Air** and **Regular Air** both have average shipping costs under 9, even for high-priority orders.
The company did not appropriately spend spend shipping costs based on urgency.
- High priority orders were often shipped via Delivery Truck (476 orders) which is the slowest shipping method.
- Meanwhile, Express Air and Regular Air, which are faster, handled more low and medium urgency orders than high-priority ones.
- The supposed "most economical" method is actually the most expensive per order. This could be because it used to ship heavier products which would normally cost more.

**Recommendation**
- Reassess logistics strategy. Urgent orders should be assigned to Express or Regular Air, which are both faster and cheaper based on actual cost data.
- Limit Delivery Truck usage for low-priority or bulk shipments, not high-urgency ones.
- Consider integrating cost-based priority rules into order fulfillment workflows to avoid wasteful shipping expenses. 
