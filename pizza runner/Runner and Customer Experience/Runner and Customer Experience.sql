--Case Study Questions - Runner and Customer Experience--



-- Week Numbering: The ISO week date system is commonly used in many parts of the world. 
--According to this system, the first week of the year is the week that contains the first Thursday of the year, and it is numbered as week 1. 
--Weeks start on a Monday.
-- This system can lead to having either 52 or 53 weeks in a year. The 53rd week is possible in years where
--January 1st falls on a Friday in a common year or on a Thursday or Friday in a leap year. Hence, a week numbered 53 is entirely valid.

--1)-How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select * from runners
Select extract(week from registration_date) week, count(runner_id)_number_of_runners from runners group by 1
select * from temp_customers_orders
select * from temp_runner_orders

--2)-What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

Select runner_id, round(avg(extract(epoch from (pickup_time::"timestamp" - order_time))/60),2) as avg_time_to_pickup from temp_customers_orders 
join temp_runner_orders using(order_id) where pickup_time is not null and cancellation is null group by 1

--3)-Is there any relationship between the number of pizzas and how long the order takes to prepare?
with order_count as
(select order_id, count(order_id) pizza_order_count, extract(epoch from (pickup_time::timestamp - order_time))/60 as preparation_time
from temp_customers_orders join temp_runner_orders using(order_id) where pickup_time is not null and (cancellation is null or cancellation = '')
group by 1,pickup_time, order_time)
select pizza_order_count, round(avg(preparation_time),2) as time_for_prepare  from order_count group by 1 order by 1

--4)-What was the average distance travelled for each customer?
select customer_id, round(avg(distance)::numeric,2) as avg_distance from temp_customers_orders join temp_runner_orders using(order_id)
where cancellation is null group by 1 

--5)-What was the difference between the longest and shortest delivery times for all orders?

select (max(duration) - min(duration)) as deliverytime from temp_runner_orders

--6)-What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id,order_id, round(distance::numeric,2) as distance_km,round(duration::numeric/60,2) as duration_in_hrs,
round(distance::numeric*60/duration::numeric,2) as avg_speed from temp_runner_orders where cancellation is null 


--7)-What is the successful delivery percentage for each runner?

select runner_id, round(100.00 * count(pickup_time) /count(*),2) as deliverypercentage 
from temp_runner_orders group by 1 order by 1

