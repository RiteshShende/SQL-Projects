CREATE TABLE walmart_sales (
    Invoice_ID VARCHAR(20) not null PRIMARY KEY,
    Branch CHAR(1) not null,
    City VARCHAR(50) not null,
    Customer_type VARCHAR(20) not null,
    Gender VARCHAR(10) not null,
    Product_line VARCHAR(100) not null,
    Unit_price NUMERIC(10,2) not null,
    Quantity INT not null,
    "Tax_5%" NUMERIC(10,4) not null,
    Total NUMERIC(10,4) not null,
    Date DATE not null,
    Time TIME not null,
    Payment VARCHAR(20) not null,
    cogs NUMERIC(10,2) not null,
    gross_margin_percentage NUMERIC(10,6) not null,
    gross_income NUMERIC(10,4) not null,
    Rating NUMERIC(3,1) not null
);

Select * from walmart_sales

--==========================================================
--Feature Engineering
--Time of the day
--Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. 
--This will help answer the question on which part of the day most sales are made.
Select (case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:00:01' and '16:00:00' then 'Afternoon'
else 'Evening' end) as time_of_day from walmart_sales
alter table walmart_sales add column time_of_the_day varchar
update walmart_sales set time_of_the_day= case when time between '00:00:00' and '12:00:00' then 'Morning'
when time between '12:00:01' and '16:00:00' then 'Afternoon'
else 'Evening' end

select round(sum(walmart_sales.total),2) as total_sales, time_of_the_day from walmart_sales	 group by time_of_the_day

--2)-Add a new column named day_name that contains the extracted days of the week on which the 
--given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

ALTER TABLE walmart_sales add column day_name varchar
UPDATE walmart_sales set day_name = to_char(date,'dy');

Select distinct on (branch) branch, day_name, round(sum(total),2) as total_sales from walmart_sales
GROUP by branch, day_name order by branch, total_sales desc 

--3)Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
--Help determine which month of the year has the most sales and profit.

ALTER TABLE walmart_sales add column Month_name varchar;
UPDATE walmart_sales set month_name = to_char(date,'Mon');

ALTER TABLE walmart_sales add column year int;
UPDATE walmart_sales set year = extract(year from date);

select year,month_name, round(sum(total),2) as total_sales from walmart_sales 
group by year, month_name  

select * from walmart_sales

--Generic Questions

---4)-How many distinct cities are present in the dataset?
Select distinct city, from walmart_sales 

--5)-In which city is each branch situated?
Select branch,city from walmart_sales group by branch, city order by branch
In which city is each branch situated?

select * from walmart_sales
--#Product Analysis
--6)-How many distinct product lines are there in the dataset?
Select distinct walmart_sales.product_line from walmart_sales;

--7)-What is the most common payment method?
select payment, count(payment) as PaymentUsing from  walmart_sales group by payment order by paymentusing	DESC;

--8)-What is the most selling product line?
Select product_line, count(*) as most_selling_product from walmart_sales group by product_line order by most_selling_product desc;

--9)-What is the total revenue by month?
select round(sum(total),2) as revenue, month_name from walmart_Sales group by month_name order by revenue desc;

--10)-Which month recorded the highest Cost of Goods Sold (COGS)?
Select round(sum(cogs),2) as highest_cogs, month_name from walmart_sales group by month_name order by highest_cogs desc;


--11)-Which product line generated the highest revenue?
select round(sum(total),2) as revenue, product_line from walmart_Sales group by product_line order by revenue desc;

--12)-Which city has the highest revenue?

select round(sum(total),2) as revenue, city from walmart_Sales group by city order by revenue desc;


--13)- Which product line incurred the highest VAT?

select round(sum("Tax_5%"),2) as Vat, product_line from walmart_Sales  group by product_line order by Vat desc;

--14)-Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,' 
--based on whether its sales are above the average.

Alter table walmart_sales add column product_category VARCHAR

UPDATE walmart_sales SET product_category = case when total > (select avg(total) from walmart_sales) then 'Good' else 'Bad' end

--15-Which branch sold more products than average product sold?

select branch, sum(quantity) as quantity_sold from walmart_sales group by branch
having sum(quantity) >avg(quantity) order by quantity_sold desc


--16)-What is the most common product line by gender?

select gender,product_line,  count(product_line) as Totalcount from walmart_sales 
GROUP by gender, product_line order by Totalcount desc






--17-What is the average rating of each product line?

Select DISTINCT product_line,round(avg(rating) over (partition by product_line),2) as avg_rating from walmart_sales  order by avg_rating desc

Select  product_line,round(avg(rating),2) as avg_rating from walmart_sales group by product_line order by avg_rating desc

--### Sales Analysis
--18)-Number of sales made in each time of the day per weekday

Select count(walmart_sales.invoice_id) as total_sales, time_of_the_day,day_name from walmart_sales 
group by day_name,time_of_the_day having day_name not in ('sun', 'sat') order by total_sales desc

--19)-Identify the customer type that generates the highest revenue?

Select customer_type, sum(total) as revenue from walmart_sales group by customer_type order by revenue desc 

--20)-Which city has the largest tax percent/ VAT (Value Added Tax)?

Select city, sum("Tax_5%") as Vat from walmart_sales group by city order by vat desc


--21)-Which customer type pays the most VAT?

Select customer_type, sum("Tax_5%") as Vat from walmart_sales group by customer_type order by vat desc


--### Customer Analysis
--22)- How many unique customer types does the data have?

Select count(distinct customer_type) from walmart_sales

--23)-How many unique payment methods does the data have?

select count(distinct payment) from walmart_sales

--24)-Which is the most common customer type?

select customer_type, count(customer_type) as common_customer from walmart_sales group by customer_type order by common_customer desc limit 1

--25)-Which customer type buys the most?
select customer_type, round(sum(total),2) as most_buyes from walmart_sales group by customer_type order by most_buyes desc limit 1

--26)-What is the gender of most of the customers?

select gender, count(*) as customer_Count from walmart_sales group by gender

--27)-What is the gender distribution per branch?

select branch, gender, count(*) as gender_Count from walmart_sales group by branch, gender order by branch 

--28)-Which time of the day do customers give most ratings?

select time_of_the_day, count(rating) as ratings_count from walmart_Sales group by time_of_the_day 
order by ratings_count desc

select time_of_the_day, avg(rating) as average_rating from walmart_Sales group by time_of_the_day 
order by average_rating desc

--29)-Which time of the day do customers give most ratings per branch?

Select branch, time_of_the_day, count(rating) as rating_count from walmart_Sales group by
branch, time_of_the_day order by branch asc,rating_count desc

--30)-Which day of the week has the best avg ratings?

select day_name, round(avg(rating),2) as avg_rating from walmart_sales group by day_name order by avg_rating desc






--31)-Which day of the week has the best average ratings per branch?
select distinct on (branch) branch, day_name, round(avg(rating),2) avg_rating from walmart_sales group by branch, day_name 
order by branch, avg_rating desc




