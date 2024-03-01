create database integrated_case_study

Select * from table1 
Select * from table2
Select * from table3


--Q1 Import all three tables & Join them (You can create separate csv files for each table
  -- in the data set "Data for SQL PowerBI Assessment Sheet")
Select * from table1 as t1 
join table2 as t2 on t1.[Primary Producer]=t2.[Primary Producer]
join table3 as t3 on t2.office = t3.[Primary Office]

--Q2 What are the percentage of deals closed (Hint: Closing deal means that Stage name should be 3-Closed Won)  
    SELECT 
        (COUNT(CASE WHEN [Stage name] = '3-Closed Won' THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) AS per_of_closed
     FROM Table1 

--Q3- Replace missing values in  "Niche Affiliations" variable with "Others"
  update table1
     set [Niche Affiliations] = 'others'
  where [Niche Affiliations] = ' '

--Q4 Select the deals with criteria (Revenue should >5000 and Opportunity Name = Cyber Consultancy and office = "Office2")

  Select * from table1 as t1
     join table2 as t2 on t1.[Primary Producer]=t2.[Primary Producer]
  where [Annual Revenue]>'5000' 
     and [Opportunity Name] = 'Cyber Consultancy' 
     and office = 'office 2'

--Q5  Select top 5 opportunities by revenue for each stage (Hint: Required to aggregate the data by "Stage Name" and rank)
   with abc as(
     select *, DENSE_RANK() over (partition by [Stage Name] order by [Annual Revenue] desc) as rnk  from table1)
   Select * from abc 
      where rnk<=5

--Q6 Find the number of opportunities and total opportunity amount (revenue) by each month? (Use Date field)
   Select month(convert(Datetime,Date,105))mnth,count([Opportunity Name]) cnt_opportunity ,sum([Annual Revenue]) Total_revenue from table1
     group by month(convert(Datetime,Date,105))

--Q7  Create a separate file with accounts and Group the accounts based on revenue as Tier1 (having revenue > 10000),
--Tier 2(5000 to 10000), Teir 3 (<5000) 
    Select [Account Name],[Annual Revenue], case when [Annual Revenue]>10000 then 'tier1' 
      when  [Annual Revenue]>=5000 then 'tier2' 
    when [Annual Revenue]<5000 then 'tier3' end as grouping_  from table1
		 
--Q8. Calculate revenue contribution of each producer
   select [Primary Producer],SUM([annual revenue]) ttl_revenue from Table1
     group by [Primary Producer]

--Q9 Create a calculated column to derive stage numbers from Stage Name (ex: 3-Closed Won stage number is 3)
    select LEFT([Stage Name],1) Stage_number,[Stage Name] from Table1

--Q10 Compare quarterly sales for different years (Use Date field)
SELECT 
    CEILING(MONTH(convert(datetime,date,105)) / 3.0) AS Qrtr,year(convert(datetime,date,105))YRS,
	  SUM ([Annual revenue]) ttl_revenue
    FROM Table1
      group by CEILING(MONTH(convert(datetime,date,105)) / 3.0),year(convert(datetime,date,105))