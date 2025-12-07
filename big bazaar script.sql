-- Total sales and average sales per item for each Item_Type

SELECT
  Item_Type,
  SUM(total_Sales) AS total_sales,
  AVG(total_Sales) AS avg_sales_per_item
FROM Big_bazaar
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- Total number of items sold per Outlet_Location_Type
SELECT
    Outlet_Location_Type,
    SUM(Item_Weight) AS total_weight
FROM big_bazaar
GROUP BY Outlet_Location_Type
ORDER BY total_weight DESC;

-- Max, min, avg Item_Outlet_Sales for each Outlet_Type
SELECT 
    outlet_type,
    MIN(total_sales) AS min_sale,
    MAX(total_sales) AS max_sale,
    AVG(total_sales) AS avg_sale
FROM big_bazaar
GROUP BY outlet_type
ORDER BY AVG(total_sales) DESC;

-- Top 5 outlets with highest total revenue

SELECT
  Outlet_Identifier,      
  SUM(total_Sales) AS total_revenue
FROM big_bazaar
GROUP BY Outlet_Identifier
ORDER BY total_revenue DESC
LIMIT 5;

-- Percentage contribution of each Item_Type to total sales

SELECT Item_Type,
  SUM(total_Sales) AS total_sales,
  ROUND(100.0 * SUM(total_Sales) / SUM(SUM(total_Sales)) OVER (), 2) AS per_of_sale
FROM big_bazaar
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- Records where Item_Visibility > average visibility
SELECT *
FROM big_bazaar
WHERE Item_Visibility > (SELECT AVG(Item_Visibility) FROM big_bazaar);

-- Items sold in multiple item types
select item_identifier , item_type , count(item_type) as outlet_type
from big_bazaar 
group by item_identifier , item_type
HAVING COUNT(DISTINCT Outlet_Type) > 1;

-- For each Outlet_Type, rank items by total sales (highest first)
SELECT
  Outlet_Type,Item_identifier,Item_type,total_sales,
  RANK() OVER (PARTITION BY Outlet_Type ORDER BY total_sales DESC) AS sales_rank
FROM (
  SELECT Outlet_Type, Item_identifier, Item_type, SUM(total_Sales) AS total_sales
  FROM big_bazaar
  GROUP BY Outlet_Type, Item_identifier, Item_type) s
ORDER BY Outlet_Type, sales_rank;

-- For each Item_fat_contain, find avg sales and compare each item’s sale to the average   8
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

-- Items whose sales are higher than the average sales across all items

WITH total_sales AS (
SELECT item_type, SUM(total_sales) AS item_outlet_sales
    FROM big_bazaar
    GROUP BY item_type
)
SELECT *
FROM total_sales
WHERE item_outlet_sales > (
    SELECT AVG(item_outlet_sales) FROM total_sales)
ORDER BY item_outlet_sales DESC;

-- Item_Types that contribute > 10% of total sales
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

-- Top 2 performing items in each outlet using
SELECT 
    outlet_identifier,outlet_size,outlet_type,item_type,Item_Fat_Content,item_weight
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
