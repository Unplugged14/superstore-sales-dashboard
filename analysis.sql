--Q1: Revenue and profit by region

SELECT Region,
         ROUND(SUM(Sales),2) AS Total_Sales,
         ROUND(SUM(Profit),2) AS Total_Profit,
         ROUND(AVG(Profit/Sales)*100,1) AS Avg_Margin_Pct
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC


--Q2: Top 5 sub-categories by profit

SELECT [Sub-Category],
         ROUND(SUM(Sales),2) AS Sales,
         ROUND(SUM(Profit),2) AS Profit
FROM superstore
GROUP BY [Sub-Category]
ORDER BY Profit DESC
LIMIT 5


--Q2: Bottom 5 sub-categories by profit

SELECT [Sub-Category],
         ROUND(SUM(Sales),2) AS Sales,
         ROUND(SUM(Profit),2) AS Profit
FROM superstore
GROUP BY [Sub-Category]
ORDER BY Profit ASC
LIMIT 5


--Q3: Month-over-month sales trend (window function)

SELECT YearMonth,
        ROUND(SUM(Sales),2) AS Monthly_Sales,
        ROUND(SUM(SUM(Sales)) OVER (ORDER BY YearMonth),2) AS Running_Total
FROM superstore
GROUP BY YearMonth
ORDER BY YearMonth

--Q4: Profit by segment and category

SELECT Segment,Category,
           ROUND(SUM(Profit),2) AS Total_Profit,
           COUNT(DISTINCT [Order ID]) AS Order_Count
FROM superstore
GROUP BY Segment,Category
ORDER BY Total_Profit DESC

--Q5: Discount vs profit relationship

SELECT
    CASE
      WHEN Discount=0 THEN 'No Discount'
      WHEN Discount<=0.2 THEN 'Low(1-20%)'
      WHEN Discount<=0.4 THEN 'Medium(21-40%)'
      ELSE 'High(40%+)'
    END AS Discount_Band,
    COUNT(*) AS Orders,
    ROUND(AVG(Profit),2) AS Avg_Profit
FROM superstore
GROUP BY Discount_Band
ORDER BY Avg_Profit DESC

--Q6: Top 10 customers by revenue (with ranking)

SELECT [Customer Name],
         ROUND(SUM(Sales),2) AS Total_Sales,
         ROUND(SUM(Profit),2) AS Total_Profit,
         RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore
GROUP BY [Customer Name]
ORDER BY Total_Sales DESC
LIMIT 10

--Q7: YoY growth by category

SELECT Category,Year,
        ROUND(SUM(Sales),2) AS Sales,
        ROUND(SUM(Sales)-LAG(Sales) OVER(PARTITION BY Category ORDER BY Year),2) AS YoY_Change
FROM superstore
GROUP BY Category,Year
ORDER BY Category,Year

--Q8: States with negative profit (loss-making)

SELECT State,
        ROUND(SUM(Sales),2) AS Sales,
        ROUND(SUM(Profit),2) AS Profit
FROM superstore
GROUP BY State
HAVING Profit<0
ORDER BY Profit ASC

