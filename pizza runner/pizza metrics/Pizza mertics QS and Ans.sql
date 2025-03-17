

--Case Study Questions - Pizza Metrics--

--1)-How many pizzas were ordered?
select count(order_id) as total_pizza_orders from customer_orders

--2)-How many unique customer orders were made?
Select count(distinct order_id) as unique_orders from temp_customers_orders

--3)-How many successful orders were delivered by each runner?
select runner_id, count(order_id) successfully_delivered_orders from temp_runner_orders where cancellation is null group by runner_id;


--4)-How many of each type of pizza was delivered?

select pizza_id , pizza_name, count(order_id) as delivery_count_by_type from pizza_names join  temp_customers_orders 
using(pizza_id) join temp_runner_orders tro using(order_id) where cancellation is null group by 1,2;

--5)-How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, pizza_name, count(order_id) as order_count from pizza_names join  temp_customers_orders 
using(pizza_id) group by 1,2 order by customer_id;

--6)-What was the maximum number of pizzas delivered in a single order?

select order_id , count(pizza_id) as pizza_counts from temp_runner_orders join temp_customers_orders using(order_id)
group by 1 order by 2 desc limit 1

--7)-For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

Select customer_id, sum(case when exclusions is null and extras is null then 1 else 0 end) as no_change,
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as atleast_one_change,
(case when cancellation is null then 'yes' else 'no'end) delivered from temp_customers_orders join temp_runner_orders using (order_id)
where cancellation is null group by 1,4

--8)-How many pizzas were delivered that had both exclusions and extras?
select tco.order_id,tco.customer_id, count(tco.order_id) pizza_delivered_count_ from temp_customers_orders tco 
join temp_runner_orders tro using(order_id) where cancellation is null and exclusions is not null and extras is not null group by 1,2;

--9)-What was the total volume of pizzas ordered for each hour of the day?

select extract(hour from order_time) as hour_of_the_day, count(order_id) as orders_per_hour
from temp_customers_orders group by 1 order by 1;

--10)-What was the volume of orders for each day of the week?

select to_char(order_time,'day') as day_of_the_week, count(order_id) volume_of_order
from temp_customers_orders group by 1 order by 1;






