-- Find the average scores of the customers handling null values
 use SalesDB;

 Select 
 CustomerID,
 Score,
 Coalesce(Score,0) Score2,
 Avg(Score) Over() AvgScores,
 Avg(Coalesce(Score,0)) Over() AvgScores2
 from Sales.Customers;

 -- Display the full name of customers in a single field 
 -- by merging their first name and last names
 -- and add 10 bonus points to each customers score
 --Coalesce(val1,val2) --> Returns the first non null values from a list

 Select 
 CustomerID,
 FirstName,
 LastName,
 FirstName+' '+Coalesce(LastName,'') as FullName,
 Score,
 Coalesce(Score,0) +10 as ScoreWithBonus
 From Sales.Customers;

 -- Sort the customers from lowest to highest scores ,
 -- with nulls appearing last

 Select 
 CustomerID,
 Score
 from Sales.Customers
 Order By case when Score IS NUll then 1 else 0 end, Score;

 -- Find the Sales Price for each Order by dividing sales by quantity
 Select 
 OrderID,
 Sales,
 Quantity ,
 Sales/Nullif(Quantity,0) as Price
 from Sales.Orders;

 -- Identify the customers who have no scores
 Select 
 * 
 from Sales.Customers
 where Score IS NULL;

 --List all customers who have scores

 Select 
 *
 from Sales.Customers
 where Score is not null

 -- List all details for customers who have not placed any orders

 Select 
 c.*,
 o.OrderID
 from Sales.Customers c
 Left Join Sales.Orders o
 on c.CustomerID=o.CustomerID
 where o.CustomerID is NULL 


-- NULL VS Empty Space vs Blank Space 

with Orders as (
Select 1 Id, 'A' Category Union
Select 2,Null Union
Select 3, '' Union
Select 4, '  '
)
Select
*,
DATALENGTH(Category) CategoryLen,
DATALENGTH(TRIM(Category)) Policy1 ,  -- Trim used to remove whitespaces
NullIF(TRIM(Category),'') Policy2,
Coalesce(NullIF(Trim(Category),''),'unknown') Policy3
from Orders;
