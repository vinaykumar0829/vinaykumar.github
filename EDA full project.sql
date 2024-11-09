-- EDA 

select*
from layoff_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoff_staging2;

select*
from layoff_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;



select industry ,sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select min(`date`),MAX(`date`)
from layoff_staging2;

select*
from layoff_staging2;

select country ,sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

select `date` ,sum(total_laid_off)
from layoff_staging2
group by `date`
order by 2 desc;


select YEAR(`date`) ,sum(total_laid_off)
from layoff_staging2
group by YEAR(`date`) 
order by 1 desc;

select stage ,sum(total_laid_off)
from layoff_staging2
group by stage 
order by 2 desc;



select company , AVG (percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select substring(`date`,6,2) AS `MONTH`, sum(total_laid_off)
from layoff_staging2
group by `MONTH`;


select substring(`date`,6,2) AS `MONTH`, sum(total_laid_off)
from layoff_staging2
Where substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS 
(
select substring(`date`,6,2) AS `MONTH`, sum(total_laid_off) AS total_off
from layoff_staging2
Where substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
)
select `MONTH`,total_off,SUM(total_off) over ( ORDER BY `MONTH`) AS rolling_total
from Rolling_total;

select company , SUM(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select company ,YEAR(`date`) , sum(total_laid_off)
from layoff_staging2
group by company,YEAR(`date`)
order by company asc;

select company ,YEAR(`date`) , sum(total_laid_off)
from layoff_staging2
group by company,YEAR(`date`)
order by 3 desc;


WITH company_year as 
(
select company ,YEAR(`date`) , sum(total_laid_off)
from layoff_staging2
group by company,YEAR(`date`)
)
select*
from company_year;


WITH company_year (company,years,total_laid_off) AS
(
select company ,YEAR(`date`) , sum(total_laid_off)
from layoff_staging2
group by company,YEAR(`date`)
)
select*, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
from company_year
where  years IS NOT NULL 
ORDER BY Ranking ASC;



WITH company_year (company,years,total_laid_off) AS
(
select company ,YEAR(`date`) , sum(total_laid_off)
from layoff_staging2
group by company,YEAR(`date`)
), company_year_rank AS
(select*, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
from company_year
where  years IS NOT NULL 
)
select*
from company_year_rank
where Ranking <=5;



