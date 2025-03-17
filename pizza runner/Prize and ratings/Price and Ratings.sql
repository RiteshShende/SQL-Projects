---Case Study Questions - Price & Ratings

--1)-If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
--how much money has Pizza Runner made so far if there are no delivery fees?

select sum(case when pizza_id= 1 then 12 else 10 end) as total_cost from temp_customers_orders join temp_runner_orders using (order_id)
where cancellation is null


--2)-What if there was an additional $1 charge for any pizza extras?
with pizza_revenue as(select sum(case when pizza_name = 'Meatlovers' then 12 else 10 end) as total_pizza_revenue from 
pizza_names join temp_customers_orders using(pizza_id) join temp_runner_orders using (order_id) where cancellation is null),
extras_revenue as(
select sum(case when extras is null or extras = '' then 0 else array_length(string_to_array(extras,','),1)end) as extra_revenue
from temp_customers_orders join temp_runner_orders using(order_id) where cancellation is null)
select (Select total_pizza_revenue from pizza_revenue) + (select extra_revenue from extras_revenue) as total_cost

--3)-The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,
--how would you design an additional table for this new dataset generate a schema for this new table and insert 
--your own data for ratings for each successful customer order between 1 to 5.
Create table runner_ratings(order_id int, rating int, comments text)
insert into runner_ratings (order_id,rating,comments) VALUES(1, 1, 'Really bad service'),(2, 1, NULL), (3, 2, 'Took too long...'),
       (4, 1,'Runner was lost delivered it AFTER an hour Pizza arrived cold'),(5, 4, 'Good service'),(6, 5, 'It was great, good service and fast'),
       (8, 1, 'He tossed it on the doorstep, poor service'),(10, 5, 'Delicious!, he delivered it sooner than expected too!');
Select * from runner_ratings

--4)-Using your newly generated table - can you join all of the information together to form a table which has the following information
--for successful deliveries? 1) customer_id 2) order_id 3) runner_id 4) rating 5) order_time  6) pickup_time 7)Time between order and pickup
--8) Delivery duration 9) Average speed 10) Total number of pizzas

Select  customer_id, order_id, runner_id, rating, order_time, pickup_time , duration as Delivery_duration, 
extract(epoch from (pickup_time::timestamp - order_time) )/60 as preparation_time, round(distance::numeric*60/duration::numeric,2)as avg_speed,
count(pizza_id) as total_pizza_count from temp_customers_orders join temp_runner_orders using (order_id) join runner_ratings using(order_id)
where cancellation is null group by 1,2,3,4,5,6,7, distance order by 1 



--5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?

with sales_revenue as (select sum(case when pizza_id = 1 then 12 else 10 end) as pizza_revenue from temp_customers_orders join 
temp_runner_orders using(order_id) where cancellation is null), 
runner_expense as (select sum(distance::numeric *0.30) as total_expenses from temp_runner_orders
where cancellation is null and distance IS NOT NULL) 
select(select pizza_revenue from sales_revenue) - (select total_expenses from runner_expense) total_leftover

