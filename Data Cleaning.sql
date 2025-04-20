/* 
Data Cleaning
1. Understand the data. Identify what each column means.
	- Date Column: Date of transaction
	- Client: Name of client's company
	- Contact: Name of contact person in the company
	- Department: Department of the contact person 
	- Payment: Type of payment method
	- Revenue: Total sales
	- Profit: Total sales after deduction of expenses 
	- Profit Margin: percentage of profit over revenue

2. Back-up original table.

3. Using Excel, remove unnecessary or blank columns, fill in empty cells where possible, and standardize the formatting.
	- Remove the blank column A and row 1.
	- Stripped the “$” from the Revenue and Profit columns and the “%” from the Profit Margin column.
	- Transform date into Mysql format.
	- Capitalize each word and trim Client and Contact column.
	- Seperate the state into Depertment column.
	- Data Quality Check: Detected blank cells in the Payment, Revenue, Profit, and Profit Margin fields.
		• Queried all other transactions for the same Contact to source replacement values; none were available.
		• Applied the imputation rule.
  		• Payment → NULL (no reliable categorical substitute)
  		• Revenue, Profit, Profit Margin → 0.00 (DOUBLE) to preserve numeric integrity and prevent type‑mismatch on import.

4. Import table data
	- While importing data from a csv file using MySQL Workbench’s Table Data Import Wizard,
	  the records were not being imported successfully even though the format looked correct.
	- Created the table first manually, specifying the appropriate data types (e.g., INT, DOUBLE, VARCHAR, etc.). 
    */
    use projects;
    
    create table sales (
    `Date` date,
    `Client` varchar(255),
    Contact varchar(255),
    Department varchar(100),
    State varchar(100),
    Payment varchar(50),
    Revenue double,
    Profit double,
    `Profit Margin` double
);
/*
	- Used Table Data Import Wizard to import records into that newly created table. This method worked — the data was successfully imported.
	- Check if imported data table was correct.
 */
select * from sales;
/*
5. Identify duplicate record and delete them.
	- Create copy of sales.csv, add row_num column.
*/
create table sales_copy (
    `Date` date,
    `Client` varchar(255),
    Contact varchar(255),
    Department varchar(100),
    State varchar(100),
    Payment varchar(50),
    Revenue double,
    Profit double,
    `Profit Margin` double,
    row_num int);
-- Insert data records from sales to sales_copy with row_num to identify which rows has duplicate records
insert into sales_copy select *, row_number() over(
partition by `Date`, `Client`, Contact, Department, State, Payment, Revenue order by `date`) as row_num from sales;
 -- Check if the data records was inserted properly.
 select * from sales_copy;
 -- Check the row_num that is greater than 1.
 select * from sales_copy where row_num > 1;
/*
Three duplicate rows were identified: 
(1) 30 May 2023 – The Goldman Sachs Group, Inc. (David Rasmussen, Operations, Florida), payment Check, revenue 5,000, profit 684, margin 0.14; 
(2) 31 May 2023 – Costco Wholesale Corporation (Conor Wise, Operations, Florida), payment Transfer, revenue 6,000, profit 998, margin 0.17; and 
(3) 31 May 2023 – McDonald’s Corporation (Steven Michael, Big Data, California), payment Check, revenue 4,500, profit 780, margin 0.17.
*/
-- Delete the 3 duplicate records
		set sql_safe_updates = 0;
		delete from sales_copy where row_num > 1;
-- Checked data records if duplicate still exist using query above.
-- Result: No row_num > 1, so duplicate records already deleted.

-- 6. Create summary report of the dataset.
-- 		• Determine total revenue on each Department and State.
		select Department, State, sum(Revenue) from sales_copy group by Department, State;
-- 		• Determine highest revenue based on Department and State.
		select Department, State, max(Revenue) from sales_copy group by Department, State; 
-- 		• Determine lowest revenue based on Department and State.
		select Department, State, min(Revenue) from sales_copy group by Department, State; 
-- 		• Determine total revenue on each Client.
		select `Client`, sum(Revenue) from sales_copy group by `Client`;
        
        
        