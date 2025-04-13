-- The first step after connecting to the PostgreSQL Database is connecting to the schema in the warehouse database that houses the table that we need by setting a path to that schema specifically.
set search_path to dataanalytics;
-- We then select all from the table needed(international_debt)
select * from international_debt;

-- Write SQL queries to find answers to the following key questions:
 
-- 1. What is the total amount of debt owed by all countries in the dataset?
select sum(debt)
from international_debt;
-- In the above question we are required to use the aggregate SUM function so as to add up the values of the debt column. 
-- The total amount of debt owed by all countries is 3,082,151,260,000
-- How many distinct countries are recorded in the dataset?
select count(DISTINCT(country_name)) as Total_Distinct_Countries
from international_debt id;
-- The DISTINCT function in this case is used to find Unique values in the country_name column
-- In the above code the count(DISTINCT(country_name)) part counts the number of distinct country names in the table.
-- The as Total_Distinct_Countries part gives a specific alias for the desired output column.
-- There are 124 distinct countries in the dataset
-- What are the distinct types of debt indicators, and what do they represent

select distinct(indicator_name)
from international_debt;
-- Principal repayments on external debt, private nonguaranteed (PNG) (AMT, current US$): Repayments of principal by private debtors, not backed by public guarantee.

-- PPG, bonds (INT, current US$): Interest payments on public and publicly guaranteed bonds.

-- Interest payments on external debt, long-term (INT, current US$): Interest paid on long-term external debt.

-- PPG, multilateral (INT, current US$): Interest on public and publicly guaranteed multilateral loans.

-- PPG, commercial banks (AMT, current US$): Principal repayments on public loans from commercial banks.

-- PPG, official creditors (AMT, current US$): Principal repayments to official creditors.

-- PPG, bonds (AMT, current US$): Principal repayments on public and publicly guaranteed bonds.

-- Interest payments on external debt, private nonguaranteed (PNG) (INT, current US$): Interest on private debt without public guarantee.

-- PPG, bilateral (AMT, current US$): Principal repayments to bilateral creditors.

-- PPG, private creditors (INT, current US$): Interest on public debt from private creditors (suppliers, exporters, etc.).

-- PPG, other private creditors (INT, current US$): Interest on public debt from other private creditors.

-- PPG, official creditors (INT, current US$): Interest payments to official creditors.

-- Disbursements on external debt, long-term (DIS, current US$): New loan disbursements on long-term external debt.

-- PPG, multilateral (DIS, current US$): New public loans from multilateral sources.

-- PPG, bilateral (INT, current US$): Interest payments on public bilateral debt.

-- PPG, official creditors (DIS, current US$): Disbursements of loans from official creditors.

-- Principal repayments on external debt, long-term (AMT, current US$): Repayments of principal on long-term external debt.

-- PPG, bilateral (DIS, current US$): Disbursements of public bilateral loans.

-- PPG, private creditors (AMT, current US$): Principal repayments to private creditors (suppliers, exporters, etc.).

-- PPG, commercial banks (DIS, current US$): New public loans from commercial banks.

-- PPG, other private creditors (INT, current US$): Interest on public debt from other private creditors.

-- PPG, multilateral (AMT, current US$): Principal repayments to multilateral lenders.

-- PPG, commercial banks (INT, current US$): Interest on public loans from commercial banks.

-- PPG, private creditors (DIS, current US$): Disbursements of public loans from private creditors.

-- PPG, other private creditors (AMT, current US$): Principal repayments to other private creditors.


-- Which country has the highest total debt, and how much does it owe?
select country_name, SUM(debt) as Total_debt from international_debt
group by country_name
order by Total_debt desc;

-- China has the highest total debt and it owes 285,793,518
-- In the above code we need to select the column country name then calculate the total debt using the SUM aggregate function of all its debt entries.
-- Then use group by to group the data based on the country name.
-- Eventually sort the results from the largest total debt using DESC

-- What is the average debt across different debt indicators?
select indicator_name, avg(debt) as Average_Debt_Indicators
from international_debt
group by indicator_name
order by Average_Debt_Indicators Desc;
-- I have first selected the indicator name column, then used the AVG aggregate on the debt column.
-- I have grouped by the indicator name then ordered by the alias name in descending order


-- Which country has made the highest amount of principal repayments?
-- In this case principal repayments indicators are missing as a data gap has been identified.


-- What is the most common debt indicator across all countries?
select indicator_name, count(*) as Most_Common_Debt_Indicator
from international_debt 
group by indicator_name
order by Most_Common_Debt_Indicator  DESC;

-- The most common debt indicator is both Principal repayments on external debt, long-term (AMT, current US$) and Interest payments on external debt, long-term (INT, current US$) eah having 127.
-- I first select the indicator name column then use the COUNT aggregate and aliased the output.
-- I then grouped by the indicator name column and ordered by the alias in descending order.

-- Identify any other key debt trends and summarize your findings.
-- Indicate the top five debtors
SELECT country_name, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 5;
-- Indicate the last five debtors 
SELECT country_name, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt ASC
LIMIT 5;

-- Findings
 -- The country with the least debt is Sao Tome and Principle 
-- The country with the highest debt is China
-- The most common debt indicator is both Principal repayments on external debt, long-term (AMT, current US$) and Interest payments on external debt, long-term (INT, current US$) each having 127.
-- There are 124 distinct countries in the dataset



