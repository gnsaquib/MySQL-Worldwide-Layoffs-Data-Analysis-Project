#EXPLORATORY DATA ANALYSIS

USE world_layoffs;

SELECT * FROM layoffs_staging2;

#LAID OFF EXPLORATORY
SELECT MAX(total_laid_off) FROM layoffs_staging2;

SELECT MAX(percentage_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY industry
ORDER BY 1 DESC;

SELECT country, SUM(total_laid_off) FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

 SELECT company, SUM(percentage_laid_off) FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;