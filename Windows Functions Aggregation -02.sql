Use SalesDB;

-- 1] Find the total no of Orders
Select
Count(*) TotalOrders
From Sales.Orders;

-- 2] Find the total no of Orders
-- Additionally provide details such as order id and order date

Select
OrderID,
OrderDate,
Count(*) OVER()TotalOrders
From Sales.Orders;


--3] Find the total no of Orders
-- Find total no of orders for each customers 
-- Additionally provide details such as order id and order date
-- Use case Group wise analysis , to understand patterns within different categories
Select 
   OrderID,
   OrderDate,
   CustomerID,
   Count(*) Over() TotalOrders,
   Count(*) Over(Partition By CustomerID) OrdersByCustomers
From Sales.Orders;

-- 4] Find total no of Customers , additionally provide all customers details
-- Use case detecting number of nulls by comparing to total numbers of rows 

Select 
*,
Count(*) Over() TotalCustomers,
Count(1) Over() TotalCustomersOne,
Count(Score) over() TotalScores,
Count(Country) over() TotalCountries
From Sales.Customers;

-- 5] Check weather table 'Orders'contains duplicate rows 
Select 
*
from(
Select 
  OrderID,
  Count(*) OVER(Partition by OrderID) CheckPK 
From Sales.OrdersArchive)t
where CheckPK>1;

-- 6] Find the total Sales accross all orders 
-- And the total sales for each product
-- Additionally provie details such orderId, Order Date

Select
OrderId,
OrderDate,
Sales,
Sum(Sales) Over() TotalSale,
Sum(Sales) Over(Partition By ProductID) SalesByProducts
from Sales.Orders;

 -- 7] Find the Percentage Contribution of each Product Sales to the total Sales 
 -- Percentage Calculation=(Products Sales/Total Sales)*100
 Select 
 OrderID,
 ProductID,
 Sales,
 Sum(Sales) Over() TotalSales,
 Round(Cast(Sales as float)/Sum(Sales) Over()*100 ,2)PercentageOfTotal
 from Sales.Orders;

 -- Cast--> Use to typecast ---> Change the data type of columns 
 -- Part to whole analysis --> Shows contribution of each data point to the overall dataset

 -- 8] Find the average sales accross all orders
 -- And find the average sales for each product
 -- Additionally provide details such as order_id,order date

 Select 
 OrderID,
 OrderDate,
 Sales,
 ProductID,
 Avg(Sales) Over() AvgSales,
 Avg(Sales) Over(Partition by ProductID) AvgSalesByProducts
 From Sales.Orders;

 -- 9] Find the average scores of customers
 -- Additionally provide details such as CustomerID and LastName

 Select 
 CustomerID,
 LastName,
 Score,
 Coalesce(Score,0) CustomerScore,
 Avg(Score) Over() AvgScore,
 Avg(Coalesce(Score,0)) Over() AvgScoreWithoutNull
 from Sales.Customers;

 -- 10] Find all orders where Sales are higher than the average sales accross all orders

 Select
 *
 from(
 Select 
 OrderID,
 ProductID,
 Sales,
 Avg(Sales) Over() AvgSales
 from Sales.Orders
 )t where Sales> AvgSales;

 -- Use case helps to evaluate wheather a value is above or below the average

 -- 11] Find the highest and lowest sales accross all orders and the highest and lowest sales for each product.
 -- Additionally provide details such as order Id, order date

 Select
 OrderID,
 OrderDate,
 ProductID,
 Sales,
 Max(Sales) Over() MaxSales,
 Min(Sales) Over() MinSales,
 Max(Sales) Over(Partition by ProductID) as MaxProductSales,
 Min(Sales) Over(Partition by ProductID) as MinProductSales
 from Sales.Orders;

 -- 12] Show the employee who have higher salaries
 Select 
 * 
 from (
 Select 
 *,
 Max(Salary) over() HighestSalary
 from Sales.Employees
 )t where Salary=HighestSalary;


-- 13] Calculate deviation of each sale from both the minimum and maximmum sales amounts 

Select
 OrderID,
 OrderDate,
 ProductID,
 Sales,
 Max(Sales) Over() MaxSales,
 Min(Sales) Over() MinSales,
 Sales-MIN(Sales) Over() DeviationFromMin,
 Max(Sales) Over()-Sales  DeviationFromMax
 from Sales.Orders;

 -- 14] Calculate moving averageof sales for each product over time
 Select 
 OrderID,
 ProductID,
 OrderDate,
 Sales,
 Avg(Sales) Over(Partition by ProductID) AvgByProduct,
 Avg(Sales) Over(Partition by ProductID Order by OrderDate) MovingAvg
 from Sales.Orders;

 -- 15] Calculating moving average of sales for each product overtime
 -- Calculate moving average of sales for each product over time ,including only the next order

 Select 
 OrderID,
 ProductID,
 OrderDate,
 Sales,
 Avg(Sales) Over(Partition by ProductID) AvgByProduct,
 Avg(Sales) Over(Partition by ProductID Order by OrderDate) MovingAvg,
 Avg(Sales) Over(Partition by ProductID Order by OrderDate rows between current row and 1 following) RollingAvg
 from Sales.Orders;

 -- 16] Calculate Overall Total, Total Per groups ,Running Total and Rolling Total of sales 
 
 Select 
 OrderID,
 ProductID,
 OrderDate,
 Sales,
 Sum(Sales) Over() OverallSales,
 Sum(Sales) Over(Partition by ProductID ) TotalSalesPerGroup, 
 Sum(Sales) Over(Partition by ProductID Order by OrderDate) RunningTotal,
 Sum(Sales) Over(Partition by ProductID Order by OrderDate rows between current row and 1 following) RollingTotal
 from Sales.Orders;
