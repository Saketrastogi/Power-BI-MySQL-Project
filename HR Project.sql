CREATE DATABASE project;
USE project;
SHOW TABLES;
DESCRIBE HR;
SELECT * FROM HR;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SELECT birthdate from hr;

SET SQL_SAFE_UPDATES = 0;

UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN date_format(STR_TO_DATE(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN date_format(STR_TO_DATE(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
  ELSE NULL
  END;
  
  ALTER TABLE HR
  MODIFY COLUMN birthdate DATE;
  
  SELECT birthdate from hr;
  
UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN date_format(STR_TO_DATE(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN date_format(STR_TO_DATE(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
  ELSE NULL
  END;
  
  SELECT hire_date from hr;
  
  ALTER TABLE HR
  MODIFY COLUMN hire_date DATE;
  
  
select termdate from hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SET sql_mode = 'ALLOW_INVALID_DATES';

SELECT termdate FROM hr;

ALTER TABLE HR ADD COLUMN age INT;


ALTER TABLE hr
MODIFY COLUMN termdate DATE;

SELECT * FROM  HR;

update hr
SET age = timestampdiff(YEAR,birthdate, CURDATE());

select birthdate ,age from hr;

SELECT 
min(AGE) AS YOUNGEST,
max(AGE) AS OLDEST
FROM HR;


SELECT count(*) FROM HR WHERE AGE< 18;

# 1. What is the gender breakdown of employess in the company?

 SELECT gender, count(*)AS COUNT
     FROM HR
     WHERE AGE >= 18 AND termdate = 0000-00-00
     GROUP BY gender;
     
     
     SELECT * FROM  HR;
     
     # What is the race/ethinicity breakdown of employees in the company?
     
     select race,count(*) AS COUNT FROM HR
     WHERE AGE>= 18 AND TERMDATE = 0000-00-00
     GROUP BY RACE
     ORDER BY COUNT(*) DESC;
     
     
 #What is the age distribution of employees int the company?
 
 SELECT min(AGE) AS youngest, max(age) as oldest from hr
 where age > 18 and termdate = 0000-00-00;
 
 select 
 case 
  when age >= 18 and age <=24 then '18-24'
  when age >= 25 and age <=34 then '25-34'
  when age >= 35 and age <=44 then '35-44'
  when age >= 45 and age <=54 then '45-54'
  when age >= 55 and age <=64 then '55-64'
  ELSE '65+'
  end as age_group,
  count(*) as count
  from hr
  where age > 18 and termdate = 0000-00-00
  group by age_group
  order by age_group;
 
 
 select 
 case 
  when age >= 18 and age <=24 then '18-24'
  when age >= 25 and age <=34 then '25-34'
  when age >= 35 and age <=44 then '35-44'
  when age >= 45 and age <=54 then '45-54'
  when age >= 55 and age <=64 then '55-64'
  ELSE '65+'
  end as age_group,gender,
  count(*) as count
  from hr
  where age > 18 and termdate = 0000-00-00
  group by age_group,gender
  order by age_group,gender;
 
 
 # How many employees work at headquarter versue remote locations?
 
 SELECT LOCATION,COUNT(*) AS COUNT FROM HR
 where age > 18 and termdate = 0000-00-00
 GROUP BY LOCATION;
 
 # What is the avg length of employment for employees who have been terminated?
 
 SELECT 
 ROUND(AVG(datediff(TERMDATE,HIRE_DATE))/365,0) AS avg_length_employment
 FROM hr 
 where termdate <= curdate() AND TERMDATE <> 0000-00-00 AND AGE >=18;
 
 
 #How does the gender dsitribution vary across departments and job titles?
 SELECT DEPARTMENT,GENDER,COUNT(*) AS COUNT
 from hr
  where age > 18 and termdate = 0000-00-00
  group by department,gender
  order by department;
 
 # what is distribution of job titles across the company?
 
 SELECT JOBTITLE, count(*) AS COUNT
 FROM HR
 WHERE AGE >= 18 AND TERMDATE = 0000-00-00
 GROUP BY JOBTITLE
 ORDER BY JOBTITLE DESC;
 
 # which department has the highest turnover rate?
 
 select department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM(
SELECT DEPARTMENT ,
count(*) AS TOTAL_COUNT,
SUM(CASE WHEN TERMDATE <> 0000-00-00 AND TERMDATE <= curdate() THEN 1 ELSE 0 END) AS TERMINATED_COUNT
FROM HR
WHERE AGE >= 18
GROUP BY DEPARTMENT
) AS subquery
order by termination_rate DESC;
 
 # What is the distribution of employees across locations by city and state?
 
select location_state, count(*) AS count from hr
WHERE AGE >= 18 AND TERMDATE = 0000-00-00
group by location_state 
order by count DESC;

  # how has the company's employees count changed over time based on hire and term date?

select
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires * 100,2) as net_change_percent
from (
select year(hire_date) as year,
count(*) as hires,
sum(case when termdate<> 0000-00-00 and termdate<= curdate() then 1 else 0 end) as terminations
from hr
where age >=18
group by year(hire_date)
) as subquery
order by year asc;

  # what is the tenure distribution for each department?

SELECT department, round(avg(datediff(termdate,hire_Date)/365),0) as ang_tenure
from hr
where termdate <= curdate() and termdate <> 0000-00-00 and age >= 18
group by department;


