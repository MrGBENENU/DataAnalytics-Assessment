# MySQL Assessment for Cowrywise
This is to guide you through my thought process in solving the series of SQL tasks uploaded in this repository designed to assess data querying, joining, filtering, aggregation, and logical thinking using MySQL.

## Q1. Identifying High Value Customers with Both a Savings and an Investment Plan: 
-	First, I familiarized myself with the dataset to get a good understanding of the records it contains
-	And for this task, I identified the user’s unqiue identifiers as well as their first name and last name, in the User’s table
-	I then went on to identify the savings and investment plans
-	Given that savings plans are marked by: is_regular_savings = 1, in the Plans table. And also noting that the Savings table references the ‘plan_id’ column on the Plans table. So, I joined the Savings Table with the Plans table on the ‘plan_id’ column to filter for savings plans
-	The investment plans are marked by: is_a_fund = 1, in the Plans table. So I filtered them out.
-	I then aggregated the savings and investment counts for each individual user, and linked it to the Users Table using the ‘owner_id’ column to get the user’s names (which was achieved by concatenating the ‘first_name’ and ‘last_name’ columns)
-	I used subqueries to pre-aggregate savings and investment records before joining with the User information in order to improve the query efficiency

## Q2. Categorizing Customers Based on the Frequency of Transactions Per Month
-	I first extracted the year and month components from the ‘transaction_date’ column in the Savings table
-	I then went on to count the amount of transactions each user made per month and calculate the average to get the average to get the average transactions per month
-	After that, I created categories based on the criteria given for high, medium and low frequency users and counted how many users fell into each category and the average transactions they made per month

## Q3. Checking for Accounts with no Transactions in the Last 365 Days
-	The condition for inactivity here is defined by accounts having no transactions in the past 365 days. I also considered accounts created over a year ago with no recorded transactions
-	I joined the Plans table to the Savings table on the ‘plan_id” column using the left join to ensure the plans with no recorded transactions were also included
-	I then determined the different account types based on the given information for identifying the savings and investment plans
-	After that, I proceeded to determine the last transaction dates and count of days of inactivity
-	I then filtered to only include the records that are currently active (‘status_id’ =1, in the Plans table)
-	I then grouped the records and filtered using the ‘having clause’ to filter results based on two conditions: Accounts with activity for over 365 days, OR, accounts created over the period of 365 days with no recorded transactions

## Q4. Estimating the CLV of users based on their transaction Volume and tenure.
-	I joined the Savings Table to the User table
-	I then went on to calculate the difference between the current date and the month joined, and then summed the transactions carried out within that period
-	After that, I applied the given formula to calculate the CLV and filtered out the users whose tenures are less than a month and sorted the records by decreasing order of the CLV

## CHALLENGES
1.	The dataset provided is very large with many columns, so it took some time to understand and decipher the relationships in the tables. However, it helped that some hints were provided in the instructions documents which directed me towards the areas to investigate.
2.	Some queries, like joining of large tables slowed down performance. Considering the emphasis on query efficiency and performance in the task instructions, I had to optimize queries by using subqueries to pre-aggregate data.
