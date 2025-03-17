--Case Study Questions - Ingredient Optimisation

--1)-What are the standard ingredients for each pizza?
Select * from pizza_recipes
Select * from pizza_names
Select * from pizza_toppings

Select pn.pizza_id, pn.pizza_name, pt.topping_id,pt.topping_name from pizza_names pn join
pizza_recipes pr using (pizza_id) join lateral unnest(string_to_array(pr.toppings, ',')::Integer[]) as t(topping_id) on true
join pizza_toppings pt using (topping_id) order by 1

--2)-What was the most commonly added extra?

with extras_expanded as (select unnest(string_to_array(extras,',')::integer[]) as extra_id from
temp_customers_orders where extras is not null and extras <> ''),
count_extras as (select extra_id, count(*) as frequency from extras_expanded group by 1 order by 2 desc)
select pt.topping_name, ce.frequency from pizza_toppings pt join count_extras ce on ce.extra_id = pt.topping_id

--3)-What was the most common exclusion?

with exclusions_expanded as (select unnest(string_to_array(exclusions,',')::integer[]) as exclusion_id from
temp_customers_orders where exclusions is not null and exclusions <> ''),
count_exclusion as (select exclusion_id, count(*) as frequency from exclusions_expanded group by 1 order by 2 desc)
select pt.topping_name, ce.frequency from pizza_toppings pt join count_exclusion ce on ce.exclusion_id = pt.topping_id order by 2 desc


