Use SalesDB;

Select 
OrderID,
CreationTime,
'2025-08-20' HardCoded,
GETDATE() Today     --->Returns current date and time at the moment when query is executed
from Sales.Orders

 
 -- > Part Extraction
 -- Day/Month/Year

 Select
 OrderId,
 CreationTime,
 Day(CreationTime) Day,
 Month(CreationTime) Month,
 Year(CreationTime) Year
 from Sales.Orders; 

-- DatePart -- Returns specific part of data as a number


 Select
 OrderId,
 CreationTime,
 DatePart(year,CreationTime) Year_DP,
 DatePart(month,CreationTime) Month_DP,
 DatePart(day,CreationTime) Day_DP,
 DatePart(week,CreationTime) WEEK_DP,
 DatePart(quarter,CreationTime) Quarter_DP,
 DatePart(hour,CreationTime) Hour_DP,
 DatePart(minute,CreationTime) Minute_DP,
 DatePart(SECOND,CreationTime) Seconds_DP
 from Sales.Orders; 

-- DateName()-- Returns specific part of date as string 


 Select
 OrderId,
 CreationTime,
 DateName(year,CreationTime) Year_DN,  -- Datatype is String
 DateName(month,CreationTime) Month_DN, 
 DateName(weekday,CreationTime) WEEK_DN
 from Sales.Orders; 

-- DateTrunc() -- Truncates the date to specific part

 Select
 OrderId,
 CreationTime,
 DateTrunc(year,CreationTime) Year_DT,
 DateTrunc(month,CreationTime) Month_DT, 
 DateTrunc(day,CreationTime) WEEK_DT,
  DateTrunc(hour,CreationTime) Hour_DT, 
 DateTrunc(minute,CreationTime) Minute_DT
 from Sales.Orders; 

-- Count no of orderss according to time
-- According to year
Select
DateTrunc(year,CreationTime) Creation,
Count(*) Orders
from Sales.Orders
group by DateTrunc(year,CreationTime);

-- According to Month
Select
DateTrunc(Month,CreationTime) Creation,
Count(*) Orders
from Sales.Orders
group by DateTrunc(month,CreationTime);

-- EOMONTH() --Returns the last day of a month

Select
OrderID,
CreationTime,
EOMONTH(CreationTime) EndOfMonth,
Cast(DateTrunc(month,CreationTime) as Date) StartOfMonth
from Sales.Orders; 

-- How many orders were placed each year?

Select 
Year(OrderDate),
Count(*) NrOfOrders
from Sales.Orders
group by Year(OrderDate);

-- How many orders were placed each month?
-- Aggregation
Select 
DateName(month,OrderDate) as OrderDate,
Count(*) NrOfOrders
from Sales.Orders
group by DateName(month,OrderDate);


-- Show all orders that were placed during month of february

Select 
*
from Sales.Orders
where Month(OrderDate)=2;

-- Avoid using DateName for filtering data ,use datepart


-- Format() function

Select 
OrderID,
CreationTime,
Format(CreationTime,'MM-dd-yyy') USA_Format,
Format(CreationTime,'dd-MM-yyy') USA_Format,
Format(CreationTime,'dd') dd,
Format(CreationTime,'ddd') ddd,
Format(CreationTime,'dddd') dddd,
Format(CreationTime,'MM') MM,
Format(CreationTime,'MMM') MMM,
Format(CreationTime,'MMMM') MMMM
from Sales.Orders;


-- Show creation time using the following format:
-- Day wed Jan Q1 2025 12:34:56 PM

Select 
OrderID,
CreationTime,
'Day '+ Format(CreationTime,'ddd MMM')  +
' Q' + DateName(quarter,CreationTime) +' '+
Format(CreationTime, 'yyyy hh:mm:ss tt') as CustomFormat
from Sales.Orders;


-- Use case format() Data Aggregation

Select 
FORMAT(OrderDate,'MMM yy' ) OrderDate,
count(*)
from Sales.Orders
group by Format(OrderDate,'MMM yy')

--Use case2 : Data Standarddization


-- Convert() Function

Select 
Convert(Int,'123') as [String to Int Convert],
Convert(Date,'2025-08-20') as [String to Date Convert],
CreationTime,
Convert(Date,CreationTime) as [Datetime to Date Convert]
from Sales.Orders;


Select 
CreationTime,
Convert(Date,CreationTime) as [Datetime to Date Convert],
Convert(Varchar,CreationTime,32) as [USA Std. Style:32],
Convert(Varchar,CreationTime,34) as [EURO Std. Style:34]
from Sales.Orders;


-- Cast() 
Select 
Cast('123' as INT) as [String to Int],
Cast(123 as varchar) as [Int to String],
Cast('2025-08-20' as Date) as [String to Date],
Cast('2025-08-20' as DateTime2) as [String to Datetime],
CreationTime,
Cast(CreationTime as Date) as [DateTime to Date]
from Sales.Orders;



-- DateAdd() 

Select 
OrderID,
OrderDate,
DateAdd(day,-10,OrderDate) as TenDaysBefore,
DateAdd(year,2,OrderDate) as TwoYearsLater,
DateAdd(month,3,OrderDate) as ThreeMonthsLater
from Sales.Orders;

-- Calculate age of employees 
Select 
EmployeeID,
BirthDate,
Datediff(year,BirthDate,GetDate()) Age
from Sales.Employees;

-- Find the average shipping duration in days for each month

Select 
DateName(month,OrderDate) as OrderDate,
Avg(DateDiff(day,OrderDate,ShipDate)) AvgShip
from Sales.Orders
Group By DateName(month,OrderDate);

-- Time Gap Analysis
-- Find the number of days between each order and the previous order

Select 
OrderID,
OrderDate CurrentOrderDate,
Lag(OrderDate) Over(Order By OrderDate) PreviousOrderDate,
DateDiff(day,Lag(OrderDate) over(Order By OrderDate) ,OrderDate) NrOfDays
from Sales.Orders;


-- IsDATE() 
Select
IsDate('123') DateCheck1,
IsDate('2025-08-20') DateCheck2,
ISDATE('20-08-2025') DteCheck3,
ISDATE('2025') DateCheck4,
ISDATE('08') DateCheck5

Select
   OrderDate,
   ISDATE(OrderDate),
   Case When ISDATE(OrderDate) =1 then Cast(OrderDate as Date)
        else '9999-01-01'
   End NewOrderDate
from 
(
Select '2025-08-20' as OrderDate Union 
Select '2025-08-21' Union
Select '2025-08-23' Union
Select '2025-08'
)t
