use sales_project
-- Checking for distinct data 
select distinct status from sales_project..sales_data_sample -- can be used 
select distinct country from sales_project..sales_data_sample -- can be used 
select distinct year_id from sales_project..sales_data_sample -- can be used 
select distinct state from sales_project..sales_data_sample --- The states are of only USA can be used 
select distinct productline from sales_project..sales_data_sample --- Can be used 
select distinct dealsize from dbo.sales_data_sample -- can be used  
select distinct month_id from dbo.sales_data_sample where year_id  = 2003 -- We have all months data in the year 2003
select distinct month_id from dbo.sales_data_sample where year_id  = 2004 --We have all months data in the year 2004
select distinct month_id from dbo.sales_data_sample where year_id  = 2005 -- We have only 5 months of data 

--- Doing the Analysis 

select country, year_id, sum(sales) as Revenue from 
dbo.sales_data_sample
where status <> 'Cancelled'
group by country, YEAR_ID
order by 2 desc -- useful 

--- Revenue of different productline in 2003,2004,2005
select  year_id, productline, sum(sales) as Revenue from 
dbo.sales_data_sample
where status <> 'Cancelled'
group by YEAR_ID,productline
order by 1  -- useful 
select year_id, sum(sales) as Revenue from 
dbo.sales_data_sample
group by YEAR_ID
order by 1  --   very useful  

select productline, year_id, sum(sales) as Revenue from 
dbo.sales_data_sample
group by YEAR_ID,PRODUCTLINE
order by 2 -- Useful data 

select productline,  sum(sales) as Revenue from 
dbo.sales_data_sample
group by PRODUCTLINE
order by 2 -- Useful data


-- checking best month in 2003 
select month_id,year_id,  sum(sales) as Revenue, count(ordernumber) as Frequency from 
dbo.sales_data_sample 
group by month_id,YEAR_ID 
order by 2  -- Usefull data 


-- checking best month in 2004
select month_id, sum(sales) as Revenue, count(ordernumber) as Frequency from 
dbo.sales_data_sample
where year_id = 2004 
group by month_id 
order by 2 desc -- Usefull data 
----- (Month 11 and 10 Seems to have very high revenue compaed to he others )  -----

--checking the product line
select month_id, productline, sum(sales) as Revenue, count(ordernumber) as Frequency from 
dbo.sales_data_sample
where year_id = 2003 and MONTH_ID = 11
group by month_id,PRODUCTLINE 
order by 3 desc


--Revenue From Different countries 
Select country, sum(sales) as Revenue from dbo.sales_data_sample
where status <> '%cancelled%' 
group by country 
order by 2 desc

--Revenue from Different type of deal size 
select dealsize, Sum(sales) as revenue 
from dbo.sales_data_sample
where status <> 'Cancelled' 
Group by dealsize 
order by 2 desc 


select sum(sales) as revenue 
from dbo.sales_data_sample

-- from which product we are getting good revenue in the year 2003
select productline, sum(sales) as Revenue  
from dbo.sales_data_sample 
where status <>  'Cancelled' and  year_id = 2003 
group by productline 
order by 2 desc 


-- from which product we are getting good revenue in the year 2004
select productline, sum(sales) as Revenue  
from dbo.sales_data_sample 
where status <>  'Cancelled' and  year_id = 2004 
group by productline 
order by 2 desc 


-- from which product we are getting good revenue in the year 2005
select productline, sum(sales) as Revenue  
from dbo.sales_data_sample 
where status <>  'Cancelled' and  year_id = 2005
group by productline 
order by 2 desc 


--- from which product and country we are getting the revenue 
select country, productline, sum(sales) as Revenue 
from dbo.sales_data_sample
where status <> 'Cancelled' 
Group by country,productline
order by 3 desc


select productline, year_id, count(productline) as Frequency
from dbo.sales_data_sample
group by PRODUCTLINE, YEAR_ID 
order by 2

---- Revenue Lost due to Cancellation 
select year_id, sum(sales) as Revenue 
from dbo.sales_data_sample 
where status like '%cancelled%'
group by year_id 