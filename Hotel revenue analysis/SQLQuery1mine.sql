--1) "Is our hotel revenue growing by year?"
with hotels as
(Select * from dbo.['2018$'] union 
select * from dbo.['2019$'] union 
select * from dbo.['2020$'])
Select h.arrival_date_year, 
round(SUM(((h.stays_in_weekend_nights+h.stays_in_week_nights)*h.adr)*(1-ms.Discount)*
(case when h.reservation_status = 'Canceled' AND h.deposit_type in('No Deposit', 'Refundable') then 0 
when  h.reservation_status = 'No-Show' AND h.deposit_type in('No Deposit', 'Refundable') then 0
else 1 End)),2) as Revenue,h.hotel
from hotels h left join market_segment$ ms on h.market_segment=ms.market_segment group by h.arrival_date_year,h.hotel

--2) Number of total peoples visiting each hotel(adults +children + babies) by month and year
  with hotels as (Select * from dbo.['2018$'] union 
select * from dbo.['2019$'] union 
select * from dbo.['2020$'])
Select sum(case when h.reservation_status = 'Check-Out' 
then (h.adults+h.children+h.babies) else 0 End) as Total_guest_arrived, 
h.arrival_date_year, arrival_date_month, h.hotel from hotels h 
group by h.arrival_date_year, arrival_date_month,h.hotel
order by h.arrival_date_year asc,h.arrival_date_month desc

--3) What is the hotel type’s average daily rate (ADR)?
with hotels as (Select * from dbo.['2018$'] union 
select * from dbo.['2019$'] union 
select * from dbo.['2020$'])
select h.hotel, round(AVG(h.adr),2) as 'Average_Daily_Rate(ADR)' from hotels h group by h.hotel
use [Hotel projects]
--4) Calculate the average discount from the hotel chain?
with hotels as (Select * from dbo.['2018$'] union 
select * from dbo.['2019$'] union 
select * from dbo.['2020$'])
select h.hotel, round(AVG(ms.Discount*100),2) as 'Average_Discount' from hotels h
left join dbo.market_segment$ ms on ms.market_segment=h.market_segment group by h.hotel



--5. Average daily guest by month?
WITH hotels AS 
(SELECT * FROM dbo.['2018$'] UNION SELECT * FROM dbo.['2019$']	 UNION SELECT * FROM dbo.['2020$'])

SELECT 
    SUM(CASE 
        WHEN h.reservation_status = 'Check-Out' 
        THEN (h.adults + h.children + h.babies) 
        ELSE 0 
    END) / NULLIF(COUNT(DISTINCT 
        CASE 
            WHEN h.reservation_status = 'Check-Out' 
            THEN DATEFROMPARTS(
                h.arrival_date_year, 
                CASE 
                    WHEN h.arrival_date_month = 'January' THEN 1
                    WHEN h.arrival_date_month = 'February' THEN 2
                    WHEN h.arrival_date_month = 'March' THEN 3
                    WHEN h.arrival_date_month = 'April' THEN 4
                    WHEN h.arrival_date_month = 'May' THEN 5
                    WHEN h.arrival_date_month = 'June' THEN 6
                    WHEN h.arrival_date_month = 'July' THEN 7
                    WHEN h.arrival_date_month = 'August' THEN 8
                    WHEN h.arrival_date_month = 'September' THEN 9
                    WHEN h.arrival_date_month = 'October' THEN 10
                    WHEN h.arrival_date_month = 'November' THEN 11
                    WHEN h.arrival_date_month = 'December' THEN 12
                    ELSE 1
                END, 
                h.arrival_date_day_of_month
            )
        END
    ), 0) AS average_daily_guest,
    h.arrival_date_month
FROM 
    hotels h 
GROUP BY 
    h.arrival_date_month

--6. Revenue by  market segment?
WITH hotels AS 
(SELECT * FROM dbo.['2018$'] 
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select Round(SUM(((h.stays_in_weekend_nights+h.stays_in_week_nights)*(h.adr))*(1-ms.Discount)*
(case when h.reservation_status= 'No-Show' and  h.deposit_type IN ('Refundable','No Deposit') then 0
when h.reservation_status= 'Canceled' and  h.deposit_type IN ('Refundable','No Deposit') then 0
else 1 end)),2) as Revenue, h.market_segment from hotels h left join dbo.market_segment$ ms
on h.market_segment = ms.market_segment group by h.market_segment


--7.discount given to market segment

WITH hotels AS 
(SELECT * FROM dbo.['2018$'] 
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select SUM(ms.Discount),h.market_segment from hotels h left join
dbo.market_segment$ ms on ms.market_segment =h.market_segment 
group by h.market_segment


--8.calculates the total number of nights stayed by guest.
Use [Hotel projects]
WITH hotels AS 
(SELECT * FROM dbo.['2018$']
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select sum(case when reservation_status='Check-Out' then
(stays_in_weekend_nights+stays_in_week_nights)else 0 End)   
total_nights_stays_by_guest from hotels 

--9.Count the number of required car parking spaces.
WITH hotels AS 
(SELECT * FROM dbo.['2018$']
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select sum(required_car_parking_spaces) as required_car_spaces from hotels

--10 What is the total revenue generated from the hotels?
With hotels AS
(SELECT * FROM dbo.['2018$']
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select round(SUM(((h.stays_in_weekend_nights+h.stays_in_week_nights)*h.adr)*(1-ms.Discount)*
(case when h.reservation_status = 'Canceled' AND h.deposit_type in('No Deposit', 'Refundable') then 0 
when  h.reservation_status = 'No-Show' AND h.deposit_type in('No Deposit', 'Refundable') then 0
else 1 End)),2) as Revenue from hotels h left join market_segment$ ms on ms.market_segment=h.market_segment

--11. Calculate the revenue by customer type.
With hotels AS
(SELECT * FROM dbo.['2018$']
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select h.customer_type, round(SUM(((h.stays_in_weekend_nights+h.stays_in_week_nights)*h.adr)*(1-ms.Discount)*
(case when h.reservation_status = 'Canceled' AND h.deposit_type in('No Deposit', 'Refundable') then 0 
when  h.reservation_status = 'No-Show' AND h.deposit_type in('No Deposit', 'Refundable') then 0
else 1 End)),2) as Revenue from hotels h left join dbo.market_segment$ ms on ms.market_segment=h.market_segment
Group by h.customer_type order by Revenue

--12..Calculate the revenue, count of required car parking spaces, and parking percentage for each arrival year and hotel.
--Methodology
With hotels AS
(SELECT * FROM dbo.['2018$']
UNION SELECT * FROM dbo.['2019$'] 
UNION SELECT * FROM dbo.['2020$'])
Select  round(SUM(((stays_in_weekend_nights+stays_in_week_nights)*adr)*(1-ms.Discount)*
(case when reservation_status = 'Canceled' AND deposit_type in('No Deposit', 'Refundable') then 0 
when  reservation_status = 'No-Show' AND deposit_type in('No Deposit', 'Refundable') then 0
else 1 End)),2) as Revenue , COUNT(required_car_parking_spaces) as count_req_car_parking,
round(SUM(required_car_parking_spaces)*100/nullif(SUM(case when reservation_status = 'Check-Out' then 
(stays_in_weekend_nights+stays_in_week_nights) else 0 end),0),2) as car_parking_percentage, arrival_date_year, hotel
From hotels left join dbo.market_segment$ ms on ms.market_segment=hotels.market_segment 
Group by arrival_date_year, hotel order by Revenue

use [Hotel projects]

--13 What is the cancellation rate, and does it vary based on the year?

with hotels as
(Select * from dbo.['2018$']
union select * from dbo.['2019$']
union select * from dbo.['2020$'])
Select arrival_date_year, SUM(case when is_canceled = 1 then 1 else 0 end) as total_cancelation, 
Count(*) as total_bookings,
COncat(Round(SUM(case when is_canceled = 1 then 1 else 0 end)*100/COUNT(*),2),'%') as Cancelation_rate from hotels
group by arrival_date_year