----- Exploratory Data Analysis---

select*
from layoff_staging3;

-- finding maximum laid off and max percentage laid off
select max(total_laid_off),max(percentage_laid_off)
from layoff_staging3;

-- finding all laid off where percentage laid off is 1 in descending order 
select*
from layoff_staging3
where percentage_laid_off=1
order by total_laid_off desc;


-- finding all laid off where fund raise is maximum in descending order 
select*
from layoff_staging3
where percentage_laid_off=1
order by funds_raised_millions desc;


-- finding company with max no of laid off by descending order
select company, sum(total_laid_off)
from layoff_staging3
group by company
order by 2 desc;

-- finding the period of laid off
select min(`date`),max(`date`)
from layoff_staging3;

-- industry wise laid off
select industry, sum(total_laid_off)
from layoff_staging3
group by industry
order by 2 desc;

-- countrywise laid off
select country,sum(total_laid_off)
from layoff_staging3
group by country
order by 2 desc;

-- by date total laid off
select `date`, sum(total_laid_off)
from layoff_staging3
group by `date`
order by 1 desc;

-- by date in year total laid off
select year(`date`),sum(total_laid_off)
from layoff_staging3
group by year(`date`)
order by 1 desc;

-- by stage of company laid off
select stage,sum(total_laid_off)
from layoff_staging3
group by stage
order by 2 desc;

-- pulling out month from date for counting rolling total
select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoff_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- rolling total by month

with rolling_total as
(select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_laid 
from layoff_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_laid, sum(total_laid) over(order by `month`) as rolling_total 
from rolling_total;

-- finding company with max no of laid off by descending order
select company,year(`date`),sum(total_laid_off)
from layoff_staging3
group by company,year(`date`)
order by 3 desc;

-- company ranking laid off by year
with company_year (company,years,total_laid_offs) as
(select company,year(`date`),sum(total_laid_off)
from layoff_staging3
group by company,year(`date`)
), company_year_rank as
(select *,
dense_rank() over(partition by years order by total_laid_offs desc) as ranking
from company_year
where years is not null
)
select*
from company_year_rank
where ranking <=5;