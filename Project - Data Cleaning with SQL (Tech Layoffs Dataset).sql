-- PROJECT: DATA CLEANING
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022?resource=download


-- -----------------------------------------------------------------------------
-- REMOVE DUPLICATES --

SELECT *
FROM layoffs;

CREATE TABLE layoffS_staging -- COPYING THE TABLE
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_Staging -- INSERTING DATA TO COPIED TABLE
SELECT *
FROM layoffs;

SELECT COUNT(*) -- 2689 ROWS
FROM layoffs_Staging; 

SELECT *, -- CREATING A COLUMN TO SEE DUPLICATES
ROW_NUMBER() OVER(PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, stage, funds_raised, country, date_added) AS row_num 
FROM layoffs_staging;

SELECT * -- CHECKING IF THERE'S ANY DUPLICATE
FROM 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, stage, funds_raised, country, date_added) AS row_num 
FROM layoffs_staging
) AS SUB
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Beyond Meat';

CREATE TABLE `layoffs_staging2` ( -- CREATING ANOTHER TABLE FOR DELETING DUPLICATES
  `company` text,
  `location` text,
  `total_laid_off` bigint DEFAULT NULL,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2 -- INSERTING DATA
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, stage, funds_raised, country, date_added) AS row_num 
FROM layoffs_staging;

DELETE -- DELETING DUPLICATES
FROM layoffs_staging2
WHERE row_num > 1;


-- -----------------------------------------------------------------------------
-- STANDARDIZING DATA -- 

SELECT company -- FINDING ISSUES ON THE COMPANY COLUMN
FROM layoffs_staging2;

SELECT company, TRIM(company) -- REMOVING WHITE SPACES
FROM layoffs_Staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT DISTINCT industry -- FINDING ISSUES ON THE INDUSTRY COLUMN
FROM layoffs_staging2
ORDER BY 1;

SELECT location -- FINDING ISSUES ON THE LOCATION COLUMN
FROM layoffs_staging2;

SELECT location -- NOTICED THAT THERE'S AN ISSUE IN SPACES
FROM layoffs_Staging2
WHERE location LIKE '%,Non-U.S.';

SELECT location, REPLACE(location, ',Non-U.S.', ', Non-U.S.') AS upd_location -- TESTING
FROM layoffs_staging2
WHERE location LIKE '%,Non-U.S.';

UPDATE layoffs_staging2 -- ADDING SPACES
SET location = REPLACE(location, ',Non-U.S.', ', Non-U.S.') 
WHERE location LIKE '%,Non-U.S.';

SELECT distinct country
FROM layoffs_Staging2
ORDER BY 1;

SELECT country, REPLACE(country, 'UAE', 'United Arab Emirates') AS upd_country
FROM layoffs_staging2
WHERE country = 'UAE';

UPDATE layoffs_staging2 -- CHANGING UAE TO United Arab Emirates
SET country = REPLACE(country, 'UAE', 'United Arab Emirates') 
WHERE country = 'UAE';

SELECT `date`, -- FIX THE DATE FORMAT
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT date_added,
STR_TO_DATE(date_added, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET date_added = STR_TO_DATE(date_added, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN date_added DATE;


-- -----------------------------------------------------------------------------
-- NULL VALUES / BLANK VALUES --

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; -- FEW

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith';

UPDATE layoffs_staging2 -- INSERTING DATA USING CASE STATEMENT
SET industry = 
CASE
	WHEN company = 'Appsmith' THEN 'Software Development'
END
WHERE industry = '';

UPDATE layoffs_staging2 -- CAN'T BE POPULATED: NOT ENOUGH DATA
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

UPDATE layoffs_staging2 -- CAN'T BE POPULATED: NOT ENOUGH DATA
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_staging2 -- CAN BE POPULATED. HOWEVER, IT'S NOT PART OF THIS PROJECT
SET funds_raised = NULL 
WHERE funds_raised = '';

SELECT *
FROM layoffs_staging2;


-- -----------------------------------------------------------------------------
-- REMOVING UNNECESSARY DATA/COLUMNS --

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
