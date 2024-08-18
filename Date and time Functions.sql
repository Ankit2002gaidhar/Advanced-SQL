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