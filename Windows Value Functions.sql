use SalesDB;


-- Analyze the month-over-month performance by finding the percentage change
-- In Sales between the current and previous months
Select
*,
CurrentMonthSales-PreviousMonthSales as MOM_Change,
Round(Cast((CurrentMonthSales-PreviousMonthSales) as Float)/PreviousMonthSales*100,1) as MOM_Percentage
from(
Select
Month(OrderDate) OrderMonth,
Sum(Sales) CurrentMonthSales,
LAG(Sum(Sales)) Over(Order BY Month(OrderDate)) PreviousMonthSales
from Sales.Orders
group by
Month(OrderDate)
)t ;

-- Analyze customerLoyalty by ranking customers 
-- based on the average number of days beween orders.

Select
CustomerID,
Avg(DaysUntilNextOrder) AvgDays,
Rank() Over (Order By Coalesce(Avg(DaysUntilNextOrder),999999)) RankingAvg
from(
Select 
OrderID,
CustomerID,
OrderDate CurrentOrder,
Lead(OrderDate) Over(Partition By CustomerID Order By OrderDate) NextOrder,
DateDiff(Day,OrderDate,Lead(OrderDate) Over(Partition By CustomerID Order BY OrderDate)) DaysUntilNextOrder
from Sales.Orders)
t Group BY CustomerID;

-- DateDiff() Calculate fate difference between 2 date values

-- Find the lowest sales and highest sales for each product

Select 
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) Over (Partition By ProductID Order BY Sales) LowestSales,
Last_Value(Sales) Over(Partition by ProductID Order by Sales
Rows Between Current Row and Unbounded Following) HighestSales,
First_Value(Sales) Over(Partition by ProductID Order BY Sales DESC) HighestSales2,
MIN(Sales) Over(Partition by ProductID) LowestSales2,
Max(Sales)  Over (Partition By ProductID) HighestSales3
From Sales.Orders
-- Use Case
-- Compare to extremes : How well a value is performing relative to extremes

-- Find the difference between current and lowest sales 

Select 
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) Over (Partition By ProductID Order BY Sales) LowestSales,
Last_Value(Sales) Over(Partition by ProductID Order by Sales
Rows Between Current Row and Unbounded Following) HighestSales,
Sales-First_Value(Sales) Over(Partition by ProductID Order BY Sales) as SalesDifference
From Sales.Orders
