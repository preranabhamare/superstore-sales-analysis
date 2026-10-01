-- Table name: superstore (loaded from the cleaned pandas DataFrame into SQLite)

-- 1. Sales and profit by category
SELECT Category, ROUND(SUM(Sales),0) AS sales, ROUND(SUM(Profit),0) AS profit
FROM superstore GROUP BY Category;

-- 2. Five least profitable sub-categories
SELECT `Sub-Category`, ROUND(SUM(Profit),0) AS profit
FROM superstore GROUP BY 1 ORDER BY profit LIMIT 5;

-- 3. Average profit by discount level
SELECT CASE WHEN Discount=0 THEN '0%'
            WHEN Discount<=0.2 THEN '1-20%'
            WHEN Discount<=0.4 THEN '21-40%'
            ELSE '40%+' END AS discount_level,
       ROUND(AVG(Profit),1) AS avg_profit, COUNT(*) AS orders
FROM superstore GROUP BY 1;

-- 4. Sub-categories with the highest average discount
SELECT `Sub-Category`, ROUND(AVG(Discount)*100,1) AS avg_discount_pct, ROUND(SUM(Profit),0) AS profit
FROM superstore GROUP BY 1 ORDER BY avg_discount_pct DESC LIMIT 5;

-- 5. Profit by region
SELECT Region, ROUND(SUM(Profit),0) AS profit
FROM superstore GROUP BY Region ORDER BY profit;

-- 6. Margin and average discount by region
SELECT Region, ROUND(SUM(Sales),0) AS sales,
       ROUND(SUM(Profit)*100.0/SUM(Sales),1) AS margin_pct,
       ROUND(AVG(Discount)*100,1) AS avg_discount_pct
FROM superstore GROUP BY Region ORDER BY margin_pct;

-- 7. Rank sub-categories by profit within each category (window function)
SELECT Category, `Sub-Category`, ROUND(SUM(Profit),0) AS profit,
       RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS rnk
FROM superstore GROUP BY Category, `Sub-Category`;
