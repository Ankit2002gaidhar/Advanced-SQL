/* Create report showing total Sales for each of folling categories :
High(Sales over 50) ,Medium (Sales over 21-50) , and low (Sales 20 or less)
Sort the categories from highest sales to lowest .*/

use SalesDB;

Select
Category,
SUM(Sales) as TotalSales
from(
Select 
OrderID,
Sales,
CASE 
    WHEN Sales >50 then 'High'
	WHEN Sales>20 then 'Medium'
	ELSE 'Low'
END Category 
From Sales.Orders
)t
Group BY Category
Order By TotalSales Desc;

-- Retrive employee details with gender displayed as full text

Select 
    EmployeeID,
	FirstName,
	LastName,
	Gender,
	Case 
	    When Gender ='F' then 'Female'
		When Gender ='M' then 'Male'
		Else 'Not Available'
	End GenderFullText
from Sales.Employees;

-- Retrieve employee details with abbreviated country code

Select Distinct Country
from Sales.Customers;

Select 
   CustomerID,
   FirstName,
   LastName,
   Country,
   Case 
       When Country='Germany' Then 'DE'
	   When Country='USA' then 'US'
	   Else 'n/a'
	End CountryAbbr,

	Case Country
       When 'Germany' Then 'DE'
	   When 'USA' then 'US'
	   Else 'n/a'
	End CountryAbbr2
from Sales.Customers;


-- Find the average scores of customers and treat Nulls as 0
-- Additionally provide details such as CustomerID and LastName

Select 
CustomerID,
LastName,
Score,
Case 
When Score is Null then 0
else Score
End ScoreClean,
AVG(
Case 
When Score is Null then 0
else Score
End) Over() AvgCustomerClean,
Avg(Score) Over() AvgCustomer
from Sales.Customers;


-- Count how many times each customer has made an order with sales greater than 30

-- Flag: Binary Indicator(1,0) to be summarised to show how many times the condition is true.

Select 
     CustomerID,
	 Sum(Case
	        When Sales>30 then 1
			Else 0
	 End) TotalOrdersHighSales,
	 Count(*) TotalOrders
from Sales.Orders
Group By CustomerID;

