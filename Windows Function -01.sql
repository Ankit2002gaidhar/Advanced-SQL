-- 1] Find the total sales across all orders

Use SalesDB;

Select 
sum(Sales) totalSales
from Sales.Orders;

-- 2] Find the total sales for each product

Select 
ProductID,
sum(Sales) TotalSales
from Sales.Orders 
group by ProductID;

-- 3] Find the total sales for each product additionally provide details suc as order id,order date

Select
  OrderID,
  OrderDate,
  ProductID,
  SUM(Sales) TotalSales
From Sales.Orders
  Group By
  OrderID,
  OrderDate,
  ProductID;

-- Group by Cant do aggregations and provide details at same time 

-- Window functions
-- Returns a result for each row
SELECT 
  OrderID,
  OrderDate,
  ProductID,
SUM(Sales) Over(Partition by ProductID) TotalSalesByProducts
from Sales.Orders;

-- 4] Find the total sales across all orders 
-- Additionally provide details such as order ID,Order Date

Select 
OrderID,
OrderDate,
sum(Sales) OVER() TotalSales
From Sales.Orders;

-- 5] Find Total sales for each product 
-- additionally provide details such as order id,order date

Select 
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER(Partition by ProductID) TotalSales
from Sales.Orders;


-- Alows aggregation of data at different granularities within the same query
Select 
OrderID,
OrderDate,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,-- It gives aggregation of all the data 
SUM(Sales) OVER(Partition by ProductID) TotalSales -- It gives aggregation of particular product id
from Sales.Orders;

-- 6] Find the total sales for each combination of product and order status 

Select 
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER() TotalSales, -- It gives aggregation of all the data 
SUM(Sales) OVER(Partition by ProductID) TotalSales, -- It gives aggregation of particular product id
SUM(Sales) OVER(Partition by ProductID,OrderStatus) SalesByProductAndStatus -- It gives aggregation of of particular Product id and OrderStatus as well 
from Sales.Orders;

-- 7] Rank each order based on their sales from highest to lowest , additionally provide details such as order_id & order date

Select 
OrderID,
OrderDate,
Sales,
Rank() Over(Order By Sales desc)RankSales
from Sales.Orders;

-- Ascending 

Select 
OrderID,
OrderDate,
Sales,
Rank() Over(Order By Sales asc)RankSales
from Sales.Orders;

-- Partition by product id order by Sales 
Select 
OrderID,
OrderDate,
ProductID,
Sales,
Rank() Over(Partition by ProductID Order By Sales desc)RankSales
from Sales.Orders;

-- Frames  demonstration 
-- 1] ROWS Between current row and 2 following
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS Between current row and 2 following) TotalSales
from Sales.Orders;

-- 2] ROWS Between 2 preceding and current row
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS Between 2 preceding and current row) TotalSales
from Sales.Orders;

-- 3] ROWS 2 preceding
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS 2 preceding) TotalSales
from Sales.Orders;

-- 4] ROWS between Unbounded preceding and current row

Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS between Unbounded preceding and current row) TotalSales
from Sales.Orders;


-- 5] ROWS between 1 preceding and 1 following

Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS between 1 preceding and 1 following ) TotalSales
from Sales.Orders;


-- 6] ROWS between Unbounded preceding and Unbounded following

Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS between Unbounded preceding and Unbounded following) TotalSales
from Sales.Orders;

-- 7] ROWS between current row and unbounded following

Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus Order By OrderDate 
ROWS between current row and unbounded following) TotalSales
from Sales.Orders;


-- we are allowed to use window functions only in select and order by clause .....
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus) TotalSales
from Sales.Orders
order by SUM(Sales) Over(Partition by OrderStatus) desc

-- This query will not executed as window function is used by where clause.
-- Window functions works only with select and order by clause...
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus) TotalSales
from Sales.Orders
where SUM(Sales) Over(Partition by OrderStatus);

-- We cannot use nested window functions .
-- This query will never executed
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
Sum(SUM(Sales) Over(Partition by OrderStatus)) Over (Partition by OrderStatus) TotalSales
from Sales.Orders;


-- 8] Find total sales for each order status , only for two products 101 and 102
-- SQL executes window function after where clause...
Select 
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) Over(Partition by OrderStatus) TotalSales
from Sales.Orders
where ProductID in (101,102);


-- 9] Rank customers based on their total sales 
-- SUM(Sales) is part of group by so query will execute 
Select 
  CustomerID,
  SUM(Sales) TotalSales,
  RANK() Over(ORDER BY SUM(Sales)DESC) RankCustomers
from Sales.orders
Group By CustomerID;

-- CustomerID is part of group by so query  will execute 
Select 
  CustomerID,
  SUM(Sales) TotalSales,
  RANK() Over(ORDER BY CustomerID DESC) RankCustomers
from Sales.orders
Group By CustomerID;

-- Since sales is not a part of group by this query will not execute 
Select 
  CustomerID,
  SUM(Sales) TotalSales,
  RANK() Over(ORDER BY Sales DESC) RankCustomers
from Sales.orders
Group By CustomerID;


