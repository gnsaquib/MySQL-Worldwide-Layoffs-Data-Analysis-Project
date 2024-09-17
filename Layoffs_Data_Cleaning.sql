#DATA CLEANING

USE world_layoffs;
SELECT * FROM layoffs;

RENAME TABLE layoffs to layoffs_raw;

CREATE TABLE layoffs_staging LIKE layoffs_raw;

SELECT * FROM layoffs_staging;
INSERT layoffs_staging SELECT * FROM layoffs_raw;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, "date") AS row_num  FROM layoffs_staging;

WITH duplicate_check AS 
( SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_check 
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
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

SELECT * FROM layoffs_staging2
WHERE row_num > 1;
INSERT INTO layoffs_staging2 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

#STANDARDIZING DATA
UPDATE layoffs_staging2 SET company = TRIM(company);
SELECT company FROM layoffs_staging2;

UPDATE layoffs_staging2 SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

UPDATE layoffs_staging2 SET country = "United States"
WHERE country LIKE "United States%";

SELECT DISTINCT country FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry FROM layoffs_staging2
ORDER BY 1;

#WORKING WITH NULL AND MISSING VALUES

UPDATE layoffs_staging2 SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t21
JOIN layoffs_staging2 t22
ON t21.company = t22.company
SET t21.industry = t22.industry
WHERE t21.industry IS NULL
AND t22.industry IS NOT NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;