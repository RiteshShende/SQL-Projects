create table automotive (car_name varchar, year numeric,selling_price numeric,km_driven NUMERIC,fuel varchar,seller_type varchar,
transmission varchar,owner varchar,mileage text,engine text,max_power text,torque text,seats numeric)

select * from automotive
--- 1. Calculate the average selling price for cars with a manual transmission and owned by the first owner, for each fuel type?

Select fuel as fuel_type_of_cars , ROUND(AVG(selling_price),2) as avg_selling_price from dbo.Worksheet$
where transmission = 'Manual' and owner = 'First Owner' group by fuel;

--- 2. Find the top 3 car models with the highest average mileage, considering only cars with more than 5 seats.---
Select car_name as Car_model, avg(cast(regexp_replace(mileage,'[^0-9.]', '','g')as float))
as avg_mileage_in_kmpl from automotive where seats = 5 group by Car_model order by 2 desc limit 3

--- 3. Identify the car models where the difference between the maximum and minimum selling prices is greater than $10,000. ---

select name as selling_price from dbo.Worksheet$ group by name 
having (max(selling_price)-min(selling_price))>10000;


--- 4. Retrieve the names of cars with a selling price above the overall average selling price and a mileage 
--below the overall average mileage. ---

Select car_name,selling_price, mileage from automotive 
where selling_price > (select AVG(selling_price) from automotive) and
cast(regexp_replace(mileage, '[^0-9.]', '', 'g') as float) < (select AVG(cast(regexp_replace(mileage, '[^0-9.]', '', 'g') as float))
from automotive)

--- 5. Calculate the cumulative sum of the selling prices over the years for each car model. ---
select  car_name, year, selling_price,sum(selling_price) over(partition by car_name order by year) as cummulative_selling_price from automotive 
 order by 1,2

--- 6. Identify the car models that have a selling price within 10% of the average selling price. ---
Select car_name, selling_price from automotive where selling_price between (select avg(selling_price)*0.90 from automotive) and
(select avg(selling_price)*1.10 from automotive)


--- 7). Identify the car models that have had a decrease in selling price from the previous year. ---

with price_comparision as (select car_name, year, selling_price, lag(selling_price) over(partition by car_name order by year)
as previous_year_price from automotive) select car_name, year,selling_price, previous_year_price
from price_comparision  where selling_price < previous_year_price


--- 8. Retrieve the names of cars with the highest total mileage for each transmission type. ---
with mileage_Trans as( 
select  car_name, transmission, sum(km_driven)as total_mileage from automotive group by 1,2),
max_mileage as (select transmission, max(total_mileage) as Max_Mileage from mileage_Trans group by 1)
select mt.car_name, mt.transmission, mt.total_mileage from mileage_Trans mt join max_mileage mm on mt.transmission = mm.transmission
And mt.total_mileage = mm.Max_Mileage order by 3 desc





 --- 9. Find the average selling price per year for the top 3 car models with the highest overall selling prices. ---
with total_selling_price as (select car_name, sum(selling_price) as total_price from automotive
group by car_name),
top_models as (select car_name  from total_selling_price order by total_price desc limit 3) 
select a.year,a.car_name, round(AVG(a.selling_price) AS avg_selling_price_per_year from automotive a join 
top_models tm on a.car_name = tm.car_name group by 1,2 order by 1 asc, 3 desc

