-- DATA CLEANING


SELECT*
FROM layoffs;



CREATE TABLE layoff_staging
like layoffs;

SELECT*
FROM layoff_staging;

INSERT layoff_staging 
SELECT*
FROM layoffs;
-- to see duplicates; 

select*,
ROW_NUMBER() OVER (PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
from layoff_staging;

-- create a cte 

WITH duplicate_cte AS
(
select*,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoff_staging
)
select *
from duplicate_cte
where row_num >1;

select*
from layoff_staging
where company='casper';

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
from layoff_staging2;


INSERT INTO layoff_staging2
select*,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoff_staging;

DELETE
from layoff_staging2
where row_num >1;
SELECT*
from layoff_staging2;

-- standardize the data 
 
 select company, trim(company)
 from layoff_staging2;
 
 UPDATE layoff_staging2
 SET company=trim(company);
 
 SELECT distinct industry
 from layoff_staging2
 order by 1;
 
 SELECT *
 FROM layoff_staging2
 where industry LIKE 'crypto%';

UPDATE layoff_staging2
SET industry='crypto'
WHERE industry LIKE 'crypto%';


SELECT DISTINCT location
from layoff_staging2
order by 1;


select distinct country
from layoff_staging2
order by 1;

select distinct country, trim(TRAILING '.'FROM country)
from layoff_staging2
order by 1;

UPDATE layoff_staging2
SET country= trim(TRAILING '.'FROM country)
where country LIKE 'united states%';


select *
from layoff_staging2;

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date`=str_to_date(`date`,'%m/%d/%Y');

select *
from layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN 	`date` DATE;

SELECT *
FROM layoff_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoff_staging2
SET industry = NULL
WHERE industry= '';




SELECT *
FROM layoff_staging2
WHERE industry IS NULL
or industry=' ' ;

select *
from layoff_staging2
where company='Airbnb';

SELECT *
from layoff_staging2 t1
join layoff_staging2 t2 
	on t1.company=t2.company
where (t1.industry IS null OR  t1.industry='')
AND t2.industry IS NOT null; 

SELECT t1.industry,t2.industry
from layoff_staging2 t1
join layoff_staging2 t2 
	on t1.company=t2.company
where (t1.industry IS null OR  t1.industry='')
AND t2.industry IS NOT null; 






UPDATE layoff_staging2 t1
join layoff_staging2 t2 
	on t1.company=t2.company
 set t1.industry=t2.industry   
where t1.industry IS null
AND t2.industry IS NOT null ;

select*
from layoff_staging2;

DELETE
FROM layoff_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;



   