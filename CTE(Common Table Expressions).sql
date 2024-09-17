-- 1] Find the total sales per customer 

WITH CTE_TOTAL_SALES as (
Select 
CustomerID,
Sum(Sales) as TotalSales
from Sales.Orders
group by CustomerID
)
-- 2] Find the last order date per customer 
, Cte_Last_order as (
Select 
CustomerId,
max(OrderDate) as Last_Order
from Sales.Orders
group by CustomerID
), 
-- 3]Rank the customer based on Total Sales Per Customer 
   CTE_CUSTOMER_Rank as (
   Select CustomerID,
   TotalSales,
   Rank() over(Order by TotalSales desc) as CustomerRank
   from CTE_TOTAL_SALES
   )
,
-- 4]Segment customers based on their total sales 
CTE_Customer_Segments as (
Select 
  CustomerID,
  Case when TotalSales>100 then 'High'
       when TotalSales>60 then 'Medium'
	   else 'Low'
   End CustomerSegments
   from CTE_TOTAL_SALES
)
-- Main Query 
Select 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.CustomerRank,
ccs.CustomerSegments
from Sales.Customers c
left join CTE_TOTAL_SALES cts
on cts.CustomerID=c.CustomerID
left join Cte_Last_order clo
on clo.CustomerID=c.CustomerID
left join CTE_CUSTOMER_Rank ccr
on ccr.CustomerID=c.CustomerID
left join CTE_Customer_Segments  ccs
on ccs.CustomerID=c.CustomerID
order by CustomerID;

