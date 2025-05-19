-- TASK 3: CHECKING FOR ACCOUNTS WITH NO TRANSACTIONS IN THE LAST 365 DAYS


SELECT 
    plans_plan.id AS plan_id,
    plans_plan.owner_id,
    
    -- Categorizing the types of plans
    CASE
        WHEN plans_plan.is_regular_savings = 1 THEN 'Savings'
        WHEN plans_plan.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    
    -- Getting the most recent transaction date for the plans
    MAX(savings_savingsaccount.transaction_date) AS last_transaction_date,
    -- -- Calculating the number of days since the last transaction
    DATEDIFF(CURDATE(),
            MAX(savings_savingsaccount.transaction_date)) AS inactivity_days
            
-- -- Joining the savings_savingsaccount table to access transaction data
FROM
    plans_plan
        LEFT JOIN
    savings_savingsaccount ON plans_plan.id = savings_savingsaccount.plan_id
-- Filtering to include only plans that are currently active
WHERE
    plans_plan.status_id = 1
    
-- Grouping by plan details to aggregate transaction data per plan    
GROUP BY plans_plan.id , plans_plan.owner_id , plans_plan.is_regular_savings , plans_plan.is_a_fund , plans_plan.created_on
-- Plans with at least one transaction, but none in the past 365 days
HAVING inactivity_days > 365 
	-- Plans with no transactions at all and created over 365 days ago
    OR (MAX(savings_savingsaccount.transaction_date) IS NULL
    AND DATEDIFF(CURDATE(), plans_plan.created_on) > 365)
ORDER BY inactivity_days DESC;
