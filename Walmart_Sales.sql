create database Walmart_Sales;

use Walmart_Sales;

create table sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null, 
city varchar(50) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10, 2) not null,
quantity int not null,
VAT float(6, 4) not null,
total decimal(12, 4) not null,
date datetime not null,
time time not null,
payment_method varchar(20) not null,
cogs decimal(10, 2) not null,
gross_margin_pct float(11, 9),
gross_income decimal(12, 4) not null,
rating float(2, 1)
); 

show tables;

select * from sales;

-- ---------------------------------------------------------------------------------------------------------------
-- --------------------------------Feature Engineering------------------------------------------------------------

-- Create Column time_of_day

SELECT
    time,
    (CASE	
        WHEN time between '00:00:00' and '12:00:00' THEN 'Morning'
        WHEN time between '12:01:00' and '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
    ) AS time_of_day
FROM sales;

alter table sales add column time_of_day varchar(30);

update sales
set time_of_day = (
	CASE	
			WHEN time between '00:00:00' and '12:00:00' THEN 'Morning'
			WHEN time between '12:01:00' and '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
		END
);

/* Total Count in Each time_of_day */

select distinct time_of_day, count(*) as count_per_time
from sales
group by time_of_day;

-- Create a Column Day_Name

select
 date, 
    dayname(date) as day_name
 from sales;
 
 alter table sales add column day_name varchar(20);
 
 update sales 
 set day_name = dayname(date);
 
 
 -- Create a Month_Name
 
 select 
   date, 
   monthname(date) as Month_name
from sales;

alter table sales add column month_name varchar(30);

update sales 
set month_name = monthname(date);

-- ------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------

-- How many unique cities does the data have?

select
		distinct city 
from sales; 

-- How many unique Branch does the data have?

select distinct branch
from sales;


-- List of the city and branches in the given data?

select 
	city, branch 
from sales;

select
	distinct city, 
		branch
from sales;

-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
-- Which Branch sold more product than avrage product sold ?

select round(avg(quantity), 2) as avg_product_sold
from  sales;                                              -- 5.50 avg_product_sold

select
	branch,
    sum(quantity) as qty
from sales
where quantity > (select round(avg(quantity), 2) as avg_product_sold from  sales)
group by branch;


-- ------------------------------------------------------------------------------------------------------------
-- --------------------------------------Product---------------------------------------------------------------

-- find total_count of each product lines does the data have and most of the selling product?

select
	product_line,
	count(product_line) as product_count
from sales
group by product_line
order by product_count desc;


-- total_count of each payment method

select
	payment_method, count(payment_method) as pay_mode
from sales
group by payment_method;


-- find city, gender and payment_method where cutomer_type is normal nad product_line is healthcare

select city, gender, payment_method
from sales
where customer_type= 'Normal' and product_line = 'Health and beauty'
order by city asc;

-- What product line had the largest VAT?

select 
	product_line, 
    avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- total revenue by month

select 
	month_name as month,
    sum(total) as revenue
from sales
group by month_name
order by revenue desc;

-- what is the most common product line by gender?

select 
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- what is the average rating of each product?

select 
	product_line,
	round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- --------------------------------------------------------------------------------------------------
-- ----------------------------------------------Sales ----------------------------------------------

-- Number of sales made in each time of the per weekday and weekend?

SELECT
   day_name, time_of_day,count(*) as total_sales,
    (CASE
        WHEN day_name between'Saturday' and 'Sunday' THEN 'Weekend'
        ELSE 'Weekday'
    END) AS day_type
FROM sales
group by day_name, time_of_day
order by time_of_day, total_sales asc;

-- Which of the customer bring the most Revenue?

select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which City has the largest tax percent / VAT (Value Add Tax)?

select city, avg(vat) as percent
from sales
group by city
order by percent desc;

-- find the avrage income of customer type where city is yangon and cutomer_type is female? 

select customer_type, round(avg(gross_income), 2) as Income
from sales
where city = 'Yangon' and gender = 'Female';

-- -----------------------------------------------------------------------------------------------
-- ------------------------------Customer---------------------------------------------------------

-- How many unique customer types does the data have?

select distinct customer_type
from sales;

-- How many unique payment methods does the data have?

select distinct payment_method
from sales;

-- which time of the day cumtomers give most rating?

select time_of_day,
round(avg(rating), 2) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
































