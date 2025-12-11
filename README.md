# <p align="center">Big-Bazaar grocery sales Project</p>


**Tools Used:** Excel, MySQL, Tableau

[Datasets Used](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/Big%20Bazaar.csv)

[SQL Analysis (Code)](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/big%20bazaar%20script.sql)

[Big Bazaar Dashboard - Power Bi](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/Big%20Bazaar%20Dashbord.png)

- **Business Problem:** These queries together help solve the major business problem of improving sales, optimizing inventory, identifying top-performing products/outlets, understanding customer demand, and making better strategic decisions across stores and product categories.

- - **How I Plan On Solving the Problem:**  In helping BigBazaar gather valuable insights from their extensive datashet, I will be utilizing SQL and a data visualization tool like Power bi to extract relevant information, and conduct insightful analyses. By leveraging SQL's functions, I can uncover key metrics such as viewer ratings, popularity trends, genre preferences, and viewership patterns. Once the data has been extracted and prepared, I will leverage Power bi to present the findings. I plan on creating a dynamic dashboard in power bi that enables users to delve into specific viewer demographics, or geographical regions

## Questions I Wanted To Answer From the Dataset:

## 1. Total sales and average sales per item for each Item_Type
```mysql
SELECT
  Item_Type,
  SUM(total_Sales) AS total_sales,
  AVG(total_Sales) AS avg_sales_per_item
FROM Big_bazaar
GROUP BY Item_Type
ORDER BY total_sales DESC;
```
result 

This query helps the business understand which item categories generate the most revenue and how much, on average, each item sells.
It identifies top-performing item types, highlights low-selling categories, and supports decisions on inventory planning, promotions, and pricing strategy.

## 2. Total number of items sold per Outlet_Location_Type
```mysql
SELECT
    Outlet_Location_Type,
    SUM(Item_Weight) AS total_weight
FROM big_bazaar
GROUP BY Outlet_Location_Type
ORDER BY total_weight DESC;
```
result

This query shows which outlet locations handle the highest volume of products by total item weight.
It helps the business understand demand patterns across different locations, so they can make better decisions about stock distribution, logistics planning, and resource allocation.

## 3.Max, min, avg Item_Outlet_Sales for each Outlet_Type
```mysql
SELECT 
    outlet_type,
    MIN(total_sales) AS min_sale,
    MAX(total_sales) AS max_sale,
    AVG(total_sales) AS avg_sale
FROM big_bazaar
GROUP BY outlet_type
ORDER BY AVG(total_sales) DESC;
```
result

This query helps compare sales performance across different outlet types by showing their minimum, maximum, and average sales.
It allows the business to identify high-performing outlet formats, detect underperforming ones, and make decisions on investment, improvements, or expansion based on outlet performance trends.

## 4.Top 5 outlets with highest total revenue
```mysql
SELECT
  Outlet_Identifier,      
  SUM(total_Sales) AS total_revenue
FROM big_bazaar
GROUP BY Outlet_Identifier
ORDER BY total_revenue DESC
LIMIT 5;
```

result 

This query identifies the top 5 outlets generating the highest revenue.
It helps the business focus on best-performing stores, understand what drives their success, and use those insights for strategy, resource allocation, and expansion planning.

## 5. Percentage contribution of each Item_Type to total sales
```mysql
SELECT Item_Type,
  SUM(total_Sales) AS total_sales,
  ROUND(100.0 * SUM(total_Sales) / SUM(SUM(total_Sales)) OVER (), 2) AS per_of_sale
FROM big_bazaar
GROUP BY Item_Type
ORDER BY total_sales DESC;
```

result 

This query shows how much each item category contributes to the company’s total sales.
It helps the business identify which product types drive revenue, prioritize high-impact categories, and decide where to focus marketing, inventory, and shelf space for maximum profit.

## 6 . Records where Item_Visibility > average visibility
```mysql 
SELECT *
FROM big_bazaar
WHERE Item_Visibility > (SELECT AVG(Item_Visibility) FROM big_bazaar);
```
## 7. Items sold in multiple item types
top 10 
```mysql
select item_identifier , item_type , count(item_type) as outlet_type
from blinkit_grocery 
group by item_identifier , item_type
HAVING COUNT(DISTINCT Outlet_Type) > 1
order by outlet_type desc
limit 10 ;
```

below 10 

```
select item_identifier , item_type , count(item_type) as outlet_type
from blinkit_grocery 
group by item_identifier , item_type
HAVING COUNT(DISTINCT Outlet_Type) > 1
order by outlet_type desc
limit 10 ;
```

result

This query identifies items that are sold across multiple outlet types.
It helps the business understand which products are widely distributed, have broad market demand, and may require priority stocking, consistent pricing, and wider availability across outlets.

## 8. For each Outlet_Type, rank items by total sales (highest first)
```mysql
SELECT
  Outlet_Type,Item_identifier,Item_type,total_sales,
  RANK() OVER (PARTITION BY Outlet_Type ORDER BY total_sales DESC) AS sales_rank
FROM (
  SELECT Outlet_Type, Item_identifier, Item_type, SUM(total_Sales) AS total_sales
  FROM big_bazaar
  GROUP BY Outlet_Type, Item_identifier, Item_type) s
ORDER BY Outlet_Type, sales_rank;
```
result 

This query ranks items by total sales within each outlet type, showing which products perform best in each store format.
It helps the business identify top-selling items per outlet category, optimize store-specific inventory, and tailor promotions or product placement based on what sells the most in each outlet type.

## 9. For each Item_fat_contain, find avg sales and compare each item’s sale to the average   
```mysql
SELECT 
    item_fat_content,item_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,1)) AS avg_total_sales,
    COUNT(*) AS no_of_item,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM big_bazaar
WHERE outlet_establishment_year = 2000
GROUP BY item_fat_content,item_type
ORDER BY total_sales DESC;
```

result
This query analyzes how different fat-content categories perform by comparing their total and average sales, number of items, and customer ratings.
It helps the business understand which fat-content and item types sell better, how customers rate them, and whether health-focused or regular items perform differently—especially for when outlets is established in which year. 

## 10. Item_Types that contribute > 10% of total sales
```mysql
WITH type_sales AS (
    SELECT Item_Type,
	SUM(total_Sales) AS sales,SUM(total_Sales) * 100.0 
	/ SUM(SUM(total_Sales)) OVER () AS pct_of_total
    FROM big_bazaar
    GROUP BY Item_Type
)
SELECT * FROM type_sales
WHERE pct_of_total > 10
ORDER BY pct_of_total DESC;
```

result 

This query identifies which item categories contribute more than 10% to the company’s total sales.
It helps the business focus on high-impact product types, prioritize them for inventory, marketing, and promotions, and understand which categories drive the majority of revenue.

## 11. Top 2 performing items in each outlet using
```mysql
SELECT outlet_identifier,outlet_size,outlet_type,item_type,Item_Fat_Content,item_weight
FROM (
    SELECT
        outlet_identifier,outlet_size,outlet_type,item_type,Item_Fat_Content,item_weight,
        SUM(total_sales) AS sales,
        DENSE_RANK() OVER (PARTITION BY outlet_identifier ORDER BY SUM(total_sales) DESC) AS sale_rank
    FROM big_bazaar
    GROUP BY
        outlet_identifier,outlet_size,outlet_type,item_type,Item_Fat_Content,item_weight
) t
WHERE sale_rank <= 2
ORDER BY outlet_identifier, sale_rank;
```
result 

This query finds the top 2 best-selling items in every outlet.
It helps the business understand which products drive the most sales at each store, allowing better decisions for store-level stocking, targeted promotions, and product placement based on what customers buy the most in each outlet.

