use SalesDB;

-- Rank the orders based on their sales from highest to lowest .

Select
OrderID,
ProductID,
Sales,
ROW_NUMBER() Over(Order By Sales Desc) SalesRank_ROW,
RANK() Over(Order By Sales Desc) SalesRank_Rank,
Dense_Rank() Over(Order By Sales Desc) SalesRank_Dense
from Sales.Orders;

--  Find the top highest sales for each product
-- Top N Case : Analysis the top performers to do targeted marketing

Select*
from(
Select
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(Partition By ProductID Order by Sales Desc) RankByProduct
From Sales.Orders
)t where RankByProduct=1;


-- Find the lowest 2 Customers based on their total Sales
-- Bottom N Analysis : Help analysis the underperformance to manage risks and to do optimizations 
Select *
from(
Select 
CustomerID,
Sum(Sales) TotalSales,
ROW_NUMBER() Over(Order by Sum(Sales)) RankCustomers
From Sales.Orders
Group By 
CustomerID
)t where RankCustomers<=2;

-- Assign Unique IDS to the rows of the Orders Archive Table
-- Help to assign unique identifier for each row to help paginating
-- Paginating: The process of breaking down a large data into smaller , more manageable chunks 

Select 
Row_Number() over(Order By OrderID,OrderDate) UniqueID,
* 
from Sales.OrdersArchive;

-- Identifying Duplicates 
-- Identify and remove duplicate rows to improve data quality

-- Identify duplicate rows in the table 'Orders Archive' 
-- and return a clean result without any duplicates

Select * from(
Select
Row_Number() Over(Partition by OrderID Order by CreationTime desc) row_no,
* 
From Sales.ordersArchive
)t where row_no=1;

 
-- Ntile()
Select 
OrderID,
Sales,
Ntile(1) Over(Order By Sales Desc) OneBucket,
Ntile(2) Over(Order By Sales Desc) TwoBucket,
Ntile(3) Over(Order By Sales Desc) ThreeBucket,
Ntile(4) Over(Order By Sales Desc) FourBucket
from Sales.Orders;

-- Segment all orders into 3 categories : high, medium and low sales.
Select
*,
Case When Buckets=1 then 'High'
When Buckets=2 then 'Medium'
When Buckets=3 then 'Low'
End SalesSegmentations
from(
Select 
   OrderID,
   Sales,
   NTILE(3) Over(Order By Sales Desc) Buckets
from Sales.Orders
)t ;

--In Order to export the data , divide the orders into 2 groups .
-- Load Balancing 
Select 
Ntile(2) over(Order By OrderID ) Buckets,
*
from Sales.Orders;

-- Percentage Based Ranking Functions 
 -- Cume_Dist=(Position_NR)/(No of Rows)
 -- Percent_Rank=(Position_NR -1)/(No of Rows - 1)

-- Find the products that fall within the highest 40 % of the prices
-- Using Cume_Dist
Select 
*,
Concat(DistRank*100,'%') DistRankPercentage
from(
Select 
Product,
Price,
Cume_Dist() Over(Order by Price Desc) DistRank
from Sales.Products
)t where DistRank<=0.4;


-- Using Percent Rank

Select 
*,
Concat(DistRank*100,'%') DistRankPercentage
from(
Select 
Product,
Price,
Percent_Rank() Over(Order by Price Desc) DistRank
from Sales.Products
)t where DistRank<=0.4;

