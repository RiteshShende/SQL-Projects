--1)-Which actors have the first name ‘Scarlett’

select * from actor where first_name='Scarlett';

--2)-Which actors have the last name ‘Johansson’?

Select * from actor where last_name = 'Johansson'; 

--3)-How many distinct actors' last names are there? 
Select count(distinct last_name) from actor;

--4)-Which last names are not repeated?
select distinct last_name from actor

--5)-Which last names appear more than once?
select last_name, count(*) as count from actor group by last_name having count(*)>1

--6)-Which actor has appeared in the most films? 
 select a.actor_id , concat(a.first_name,' ',a.last_name) as actor_name, Count(f.film_id) as countofmovies from actor a
 join film_actor fa using(actor_id) join film f using(film_id) group by a.actor_id having count(*)>1 order by countofmovies desc

--7)-Is ‘Academy Dinosaur’ available for rent from Store 1? 

select count(f.film_id) as noofcopies from film f join inventory i 
using(film_id) join store s using(store_id) where s.store_id = 1 and title = 'Academy Dinosaur'

--8)-Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today?
select * from customer where first_name = 'Mary' and last_name = 'Smith'; --from here we will get customer_id
select * from film where title like '%Academy Dinosaur%';--from here we will get film_id
select * from inventory where film_id = 1--from here we will get inventory_id
select * from staff--from here we will get staff_id

insert into rental(rental_date,inventory_id,customer_id,staff_id) VALUES(now(), 1,1,1)--insertd the record

select * from rental where inventory_id = 1 and staff_id = 1 and customer_id = 1 ---showing the inserted record 

--9)-When is ‘Academy Dinosaur’ due? 
select title, concat(rental_duration,' ','days from rental date') as due_date from film
where title = 'Academy Dinosaur'

--10)-What is the average running time of all the films in the sakila DB? 
select round(avg(length),2) avg_length from film 

--11)-What is the average running time of films by category? 

select c.name, avg(length) avg_time from category c join
film_category using(category_id) join film f using (film_id) 
group by c.name

--12)-Write a query to find the id, first name, and last name of an actor whose first name is like 'JOE'.

select actor_id, first_name, last_name from actor where first_name like '%joe%' or first_name like 'Joe' 


--13)-find all the actors, whose last name contains the letters 'GEN'. Make this case insensitive.

select * from actor where last_name like '%GEN%' or last_name like '%gen%'

--14)-Add a middle_name column to the table actor. Specify the appropriate column type 

alter table actor add column middle_name varchar

--15)-Now write a query that would remove the middle_name column
alter table actor drop column middle_name

--16)-List the last names of actors, as well as how many actors have that last name
select last_name, count(*) from actor group by last_name

--17)-List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(*) from actor group by last_name having count(*) >1


--18)-Use a JOIN to display the total amount rung up by each staff member in february of 2007. Use tables, staff and payment.

select * from staff
select * from payment
select staff_id, first_name, last_name, round(sum(amount),2) Total_amount_rung from payment join staff using(staff_id) 
where extract(month from payment_date) = 2 and extract(year from payment_date)=2007 group by staff_id

--19)- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select title as Film_name,count(actor_id) as Total_actors_listed from film inner join film_actor using(film_id)
group by title order by Total_actors_listed desc

--20)-How many copies of the film Hunchback Impossible exist in the inventory system? 
select * from film where title = 'Hunchback Impossible' ---- thhis will give us the film _if for title Hunchback Impossible

Select title, count(film_id) as copies_available from inventory join film using(film_id) where title = 'Hunchback Impossible'
group by title


--21)-Using the tables payment and customer and the JOIN command, list the total paid by each customer 
Select * from customer
select * from payment
select customer_id, first_name,last_name, sum(amount) as total_paid from customer 
join payment using(customer_id) group by customer_id order by customer_id 


--22)-The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
--films starting with the letters K and Q have also soared in popularity.
--display the titles of movies starting with the letters K and Q whose language is English 


Select f.title, l.name from film f join language l on l.language_id = f.language_id 
where title like 'K%' or title like 'Q%' and l.name = 'English'

--23)-Use subqueries to display all actors who appear in the film Alone Trip
select * from actor where actor_id in 
(select actor_id from film_actor where film_id in 
(select film_id from film where title = 'Alone Trip'))







