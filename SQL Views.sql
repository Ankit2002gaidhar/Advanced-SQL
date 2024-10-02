use SalesDB;

-- find running total of sales for each month
-- In sql server if we have o update the view then first we have to drop it ....
-- and after that only we can make changes in it .
Create View V_Monthly_Summary as(
Select 
DateTrunc(month,OrderDate) OrderMonth,
sum(Sales) TotalSales,
Count(OrderID) TotalOrders,
Sum(Quantity) TotalQuantities
from Sales.Orders
group by DateTrunc(month,OrderDate)
)

Select *
from V_Monthly_Summary;


-- Drop the view 
Drop View V_Monthly_Summary;

-- Use Case Hide complexity
-- Provide view that combines details from orders ,products ,customers and employees
Create View Sales.V_Order_Detail as (
Select 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
coalesce(c.FirstName,'')+' '+coalesce(c.LastName,'')  CustomerName,
c.Country CustomerCountry,
coalesce(e.FirstName,'')+' '+coalesce(e.LastName,'')  SalesPersonName,
o.Sales,
o.Quantity
from Sales.Orders o
left join Sales.Products p
on p.ProductID=o.ProductID
left join Sales.Customers c
on c.CustomerID=o.CustomerID
left join Sales.Employees e
on e.EmployeeID=o.SalesPersonID
);

Select *
from Sales.V_Order_Detail

-- Use Case Data Security 
-- Provide a view for EU Sales Team that combines details from all tables 
-- and excludes data related to the use

Create VIEW Sales.V_Order_Details_EU as (
Select 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
coalesce(c.FirstName,'')+' '+coalesce(c.LastName,'')  CustomerName,
c.Country CustomerCountry,
coalesce(e.FirstName,'')+' '+coalesce(e.LastName,'')  SalesPersonName,
o.Sales,
o.Quantity
from Sales.Orders o
left join Sales.Products p
on p.ProductID=o.ProductID
left join Sales.Customers c
on c.CustomerID=o.CustomerID
left join Sales.Employees e
on e.EmployeeID=o.SalesPersonID
where c.Country!='USA'
);


Select *
from Sales.V_Order_Details_EU;

