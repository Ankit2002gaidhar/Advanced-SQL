use SalesDB;
-- Set Operators 
-- 1] Union : Returns all distinct rows from both queries 
-- 2] UnionAll: Return all rows from both the queries including duplicates
-- 3] Except: Return all distinct rows from first query that are not founded in second query
-- 4] Intersect : Return only the rows that are common in both queries .

-- #### Rules
-- Rule 1]: No of Columns in each query must be same hence it will throw error.
Select 
CustomerID,
FirstName,
LastName
from Sales.Customers
Union
Select 
FirstName,
LastName
from Sales.Employees

-- Rule 2] : Data Type of columns must be same  hence it will throw error.
Select 
CustomerID,-- Int
LastName
from Sales.Customers
Union
Select 
FirstName,-- Varchar()
LastName
from Sales.Employees

-- Rule 3]:Order of columns in each query must be same
Select 
CustomerID,
LastName
from Sales.Customers
Union
Select 
LastName,
EmployeeID
from Sales.Employees

-- Rule 4] : Column Names in the result set are determined by column names specified in first query .

Select 
CustomerID as ID,
LastName as Last_Name
from Sales.Customers
Union
Select 
EmployeeID,
LastName 
from Sales.Employees


-- Rule 5] Even  if all rules are met and sql shows no errors , the result may be incorrect .
-- Incorrect columns selection leads to inaccurate leads.
Select 
FirstName,
LastName 
from Sales.Customers
Union
Select 
LastName,
FirstName
from Sales.Employees


-- Rules of Set operators 
-- 1] Order By can be used only once and that too in last 
-- 2] Same number of columns should be there in each query 
-- 3] Query data types should be matching
-- 4] Same order of columns should be there inorder to get  correct result
-- 5] First query control alliases 
-- 6] Mapping correct columns to get correct results.

-- Task 1:Combine the data from employees and customers into one table

Select 
FirstName,
LastName
From Sales.Customers
Union 
Select 
FirstName,
LastName
From Sales.Employees


-- Task 2:Combine the data from employees and customers into one table including duplicates

Select 
FirstName,
LastName
From Sales.Customers
Union all
Select 
FirstName,
LastName
From Sales.Employees


-- Task 3: Find the employees who are not customers at the same time

Select 
FirstName,
LastName
from Sales.Employees
Except
Select
FirstName,
LastName
from Sales.Customers


-- Task 4: Find the customers who are not employees at the same time

Select 
FirstName,
LastName
from Sales.Customers
Except
Select
FirstName,
LastName
from Sales.Employees

-- Order of Queries : The order of queries in a except does affect the result !!

-- Task 5] Find the  Employees who are also customers 
Select 
FirstName,
LastName
from Sales.Customers
Intersect
Select 
FirstName,
LastName
from Sales.Employees

-- Task 6] Orders are stored in seperate tables (Orders and Orders Archives )
-- Combine all orders into one report without duplicates.
-- Union use case
Select 
'Orders' as SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
from Sales.Orders
UNION
Select 
'OrdersArchive' as SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
 from Sales.OrdersArchive
 Order by OrderID;
