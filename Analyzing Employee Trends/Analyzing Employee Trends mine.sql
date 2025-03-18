Select * from dbo.Worksheet$
--1)-Count the number of employees in each department?
select distinct department, COUNT(emp_no) over (partition by department) as employess from dbo.Worksheet$;
select department, COUNT(emp_no) as employess from dbo.Worksheet$ group by  department;

--2)---- 2.Calculate the average age for each department?
select department, round(AVG(age),2) as average_age_of_employee from dbo.Worksheet$ group by  department;

--3) Identify the most common job roles in each department

with job_role_count as (SELECT department, job_role, COUNT(*) AS role_count, RANK() 
over (partition by department order by count(job_role) desc) as rnk
FROM dbo.Worksheet$ GROUP BY department, job_role)
select department, job_role, role_count from job_role_count where rnk=1

--- 4. Calculate the average job satisfaction for each education level --
select education, round(avg(job_satisfaction),2) avg_jobsatisfaction from dbo.Worksheet$ group by education

--- 5.Determine the average age for employees with different levels of job satisfaction ---
select job_satisfaction, ROUND(avg(age),2) avg_age_of_employee from dbo.Worksheet$ group by job_satisfaction order by 1

--- 6. Calculate the attrition rate for each age band --

Select age_band, count(case when attrition = 'Yes' then 1 end)*100/COUNT(*)  as attrition_rate 
from dbo.Worksheet$ group by age_band


--- 7) Identify the departments with the highest and lowest average job satisfaction ---
with department_satisfaction as(select department, round(AVG(job_satisfaction),2) as avg_satisfaction from dbo.Worksheet$ 
group by department)
select  department, avg_satisfaction from department_satisfaction 
where avg_satisfaction = (select MAX(avg_satisfaction) from department_satisfaction )
or avg_satisfaction = (select min(avg_satisfaction) from department_satisfaction)

--- 8) Find the age band with the highest attrition rate among employees with a specific education level---
Select age_band, education, COUNT(case when attrition ='Yes' then 1 end)*100/COUNT(attrition) as attrition_rate 
from dbo.Worksheet$ group by age_band, education order by 1,3 desc

with higher_attrition as (Select age_band, education, ROUND((COUNT(case when attrition ='Yes' then 1 end)*100/COUNT(*)),2) as 
attrition_rate, RANK() over (partition by age_band order by 
COUNT(case when attrition ='Yes' then 1 end)*100/COUNT(*) desc) as rnk
from dbo.Worksheet$ group by age_band, education)
select age_band, education, round(attrition_rate,2) as higher_attrition_by_education from higher_attrition where rnk =1

--- 9.Find the education level with the highest average job satisfaction among employees who travel frequently

Select education, round(AVG(job_satisfaction),2) as avg_satisfaction from dbo.Worksheet$ 
where business_travel = 'Travel_Frequently' group by education order by 2 desc


--- 10. Identify the age band with the highest average job satisfaction among married employees

select age_band, round(avg(job_satisfaction),2) avg_jobsatisfaction from dbo.Worksheet$
where marital_status = 'Married' group by age_band order by 2 desc