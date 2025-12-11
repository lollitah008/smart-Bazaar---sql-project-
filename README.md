# <p align="center">Big-Bazaar grocery sales Project</p>


**Tools Used:** Excel, MySQL, Tableau

[Datasets Used](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/Big%20Bazaar.csv)

[SQL Analysis (Code)](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/big%20bazaar%20script.sql)

[Big Bazaar Dashboard - Power Bi](https://github.com/hardikjhalani263/Big-Bazaar---sql-project-/blob/main/Big%20Bazaar%20Dashbord.png)

- **Business Problem:**

- - **How I Plan On Solving the Problem:**

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
## 5. Percentage contribution of each Item_Type to total sales
```mysql
SELECT Item_Type,
  SUM(total_Sales) AS total_sales,
  ROUND(100.0 * SUM(total_Sales) / SUM(SUM(total_Sales)) OVER (), 2) AS per_of_sale
FROM big_bazaar
GROUP BY Item_Type
ORDER BY total_sales DESC;
```
## 6 . Records where Item_Visibility > average visibility
```mysql 
SELECT *
FROM big_bazaar
WHERE Item_Visibility > (SELECT AVG(Item_Visibility) FROM big_bazaar);
```
## 7. Items sold in multiple item types
```mysql
select item_identifier , item_type , count(item_type) as outlet_type
from blinkit_grocery 
group by item_identifier , item_type
HAVING COUNT(DISTINCT Outlet_Type) > 1
order by outlet_type desc
limit 10 ;
