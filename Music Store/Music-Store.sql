Select * from employee;
--1)-Who is the senior most employee based on job title?
select * from employee order by levels desc limit 1;

--2)-Which countries have the most Invoices?
Select * from invoice;
select invoice.billing_country, count(*) as NoofInvoices from invoice group by billing_country order by NoofInvoices desc;

--3)-What are top 3 values of total invoice?
select invoice_id, total from invoice order by total desc limit 3;


--4)-Which city has the best customers? We would like to throw a promotional Music
--Festival in the city we made the most money. Write a query that returns one city that
--has the highest sum of invoice totals. Return both the city name & sum of all invoice
--totals
Select  * from invoice;
Select * from customer;

select billing_city, round(sum(total)::numeric,2) as Invoicetotal_as_per_city from invoice 
group by billing_city order by Invoicetotal_as_per_city desc limit 1;


--5)-Who is the best customer? The customer who has spent the most money will be
--declared the best customer. Write a query that returns the person who has spent the
--most money?

select c.customer_id, concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name, round(sum(i.total)::numeric,2) as total_spent 
from customer c join invoice i using(customer_id) group by c.customer_id order by total_spent desc limit 1;

--6)-1. Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with A?

select distinct c.email,trim(c.first_name) first_name,trim(c.last_name) as last_name, g.name genre 
from customer c join invoice i using(customer_id) join invoice_line il 
using(invoice_id) join track using(track_id) join genre g using(genre_id) where  g.name = 'Rock';


--7)-Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands?

select a.artist_id, a.name artist_name,g.name Genre, count(a.artist_id) as track_count from artist a 
join album using(artist_id) join track using(album_id) join genre g using(genre_id) where g.name ='Rock'
group by a.artist_id, g.name order by track_count desc limit 10;

select * from track;

--8)-. Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the
--longest songs listed first
select name track_name, milliseconds track_lenght from track where milliseconds > (select avg(milliseconds) from track) 
order by track_lenght desc;

--9)-Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

Select c.customer_id, concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name, a.name as Artist_name,
round(SUM(il.unit_price*il.quantity)::numeric,2) AS amount_spent from customer c 
join invoice using(customer_id) join invoice_line il using(invoice_id) join track using(track_id) join album using (album_id)
join artist a using (artist_id) group by 1,2,3 order by 4 desc;



--10)-We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum
--number of purchases is shared return all Genres
with popular_genre as 
(Select c.country as Country, g.name, round(SUM(il.unit_price*il.quantity)::numeric,2) AS Purchase_Amount,
rank() over(partition by c.country order by SUM(il.unit_price*il.quantity) desc) as rank
from genre g join track USING(genre_id) join invoice_line il using(track_id) join invoice i using(invoice_id) join customer c using(customer_id)
group by 1,2)
select * from popular_genre where rank = 1 


--11)-Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country 
--along with the top customer and how--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amount

with customer_with_country as (Select c.customer_id, c.country,concat(trim(c.first_name),' ',trim(c.last_name)) as customer_name, round(sum(i.total)::numeric,2) Total_Spent,
row_number() Over(partition by c.country order by sum(total) desc) as rank from customer c
join invoice i using(customer_id) group by 1,2,3 order by 2)
Select * from customer_with_country where rank=1;





SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC






