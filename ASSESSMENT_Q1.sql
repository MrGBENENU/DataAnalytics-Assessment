-- TASK 1: IDENTIFYING HIGH VALUE CUSTOMERS WITH BOTH A SAVINGS AND AN INVESTMENT PLAN

SELECT 
-- Extracting the unique identifiers for the customers
    users_customuser.id AS owner_id, 
    -- Getting the full name of the user by combining the first name and last name columns    
    CONCAT(users_customuser.first_name,
            ' ',
            users_customuser.last_name) AS name,
			-- Determining the count of savings and investment plans as well as Total Deposits
    savings_data.savings_count,
    investment_data.investment_count,
    savings_data.total_deposits
    
-- Joining with a subquery that calculates savings-related data for each user
FROM
    users_customuser
        INNER JOIN
    (SELECT 
        savings_savingsaccount.owner_id,
            COUNT(DISTINCT savings_savingsaccount.id) AS savings_count,
            SUM(savings_savingsaccount.confirmed_amount) AS total_deposits
            
	-- Joining with the plans table to filter only savings plans
    FROM
        savings_savingsaccount
    INNER JOIN plans_plan ON savings_savingsaccount.plan_id = plans_plan.id
    WHERE
        plans_plan.is_regular_savings = 1
    GROUP BY savings_savingsaccount.owner_id) AS savings_data ON users_customuser.id = savings_data.owner_id
    
    -- Joining with another subquery that calculates investment data for each user
        INNER JOIN
    (SELECT 
        plans_plan.owner_id,
            COUNT(DISTINCT plans_plan.id) AS investment_count
    FROM
        plans_plan
    WHERE
        plans_plan.is_a_fund = 1
        
	-- Grouping the results and sorting by total savings deposit in descending order
    GROUP BY plans_plan.owner_id) AS investment_data ON users_customuser.id = investment_data.owner_id
ORDER BY savings_data.total_deposits DESC;
