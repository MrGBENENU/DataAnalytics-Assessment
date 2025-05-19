-- TASK 4: Estimating the CLV of users based on their transaction Volume and tenure.

SELECT 
    users_customuser.id AS customer_id,
    CONCAT(users_customuser.first_name,
            ' ',
            users_customuser.last_name) AS name,
            
	-- Calculating how long the user has been with the platform (in months)
    TIMESTAMPDIFF(MONTH,
        users_customuser.date_joined,
        CURDATE()) AS tenure_months,
        
	-- Total confirmed transaction amount across all their savings accounts
    COALESCE(SUM(savings_savingsaccount.confirmed_amount),
            0) AS total_transactions,
            
	-- Calculating annualized profit (0.1% per transaction, multiplied by 12 months) divided by months of tenure
    ROUND((COALESCE(SUM(savings_savingsaccount.confirmed_amount),
                    0) * 0.001 * 12) / GREATEST(TIMESTAMPDIFF(MONTH,
                        users_customuser.date_joined,
                        CURDATE()),
                    1),
            2) AS estimated_clv
            
-- Joining savings account data to link transactions to each user
FROM
    users_customuser
        LEFT JOIN
    savings_savingsaccount ON users_customuser.id = savings_savingsaccount.owner_id
    
-- Grouping results per user to calculate aggregated metrics
GROUP BY users_customuser.id , users_customuser.first_name , users_customuser.last_name , users_customuser.date_joined

-- Filtering out new users with less than one month of activity
HAVING tenure_months > 0

-- Sorting to show customers with the highest estimated CLV first
ORDER BY estimated_clv DESC;
