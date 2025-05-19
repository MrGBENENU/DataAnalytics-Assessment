-- TASK 2: CATEGORIZING CUSTOMERS BASED ON THE FREQUENCY OF TRANSACTIONS PER MONTH

-- Creating a temporary table that counts the number of transactions per user per month
WITH monthly_transactions AS (
    SELECT 
        owner_id,  -- ID of users who made the transaction
        YEAR(transaction_date) AS transaction_year,  -- Extracting the year component of the transaction
        MONTH(transaction_date) AS transaction_month,  -- Extracting the month month component of the transaction
        COUNT(*) AS transaction_count  -- To get Count of transactions in that month
    FROM savings_savingsaccount
    GROUP BY owner_id, YEAR(transaction_date), MONTH(transaction_date)
),

-- Calculating each user's average count monthly transactions
user_avg AS (
    SELECT 
        owner_id,  
        AVG(transaction_count) AS avg_transactions_per_month  -- Average monthly transaction count
    FROM monthly_transactions
    GROUP BY owner_id
)

-- Categorizing users based on their average transaction frequency according to the given criteria
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'  
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'  
        ELSE 'Low Frequency'  
    END AS frequency_category,

    COUNT(owner_id) AS customer_count,  -- Number of users in each frequency category

    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month  -- Average per category, rounded to 1 decimal
FROM user_avg
GROUP BY frequency_category

-- Sorting the result in a logical order
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
