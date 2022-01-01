use Seminar_Stage
go

-- Data table (no hash columns) (for first ETL)
create table employee_data_table (
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
)
go

-- Data update table (no hash columns) (for second ETL)
create table employee_data_update_table (
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
)
go

-- Data update table 2 (no hash columns) (for third ETL)
create table employee_data_update_2_table (
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
)
go

/* Prepare data 3 tables above: (EXECUTE STEP BY STEP)
--Step 1: 
	Generate 1.000.000 rows to employee_data_table
	Tool used: SQL Data Generator 4: https://www.red-gate.com/products/sql-development/sql-data-generator/ 

--Step 2: 
	Run the following command to copy all the data 
	from 'employee_data_table' to 'employee_data_update_table'

	truncate table employee_data_update_table;
	insert into employee_data_update_table
	select * from employee_data_table;

--Step 3: 
	Update the data in 'employee_data_update_table'
	for 5 columns to simulate changes

	Type 1 columns: update ~10000 rows:

	update employee_data_update_table set attr_1 = 'new attr 1 value'
	where id in (select top 6000 id from employee_data_update_table order by newid())
	update employee_data_update_table set attr_2 = 'new attr 2 value'
	where id in (select top 4000 id from employee_data_update_table order by newid())

	Type 2 columns: update ~20000 rows:

	update employee_data_update_table set attr_3 = 'new attr 3 value'
	where id in (select top 7000 id from employee_data_update_table order by newid())
	update employee_data_update_table set attr_4 = 'new attr 4 value'
	where id in (select top 5000 id from employee_data_update_table order by newid())
	update employee_data_update_table set attr_5 = 'new attr 5 value'
	where id in (select top 8000 id from employee_data_update_table order by newid())

-- Step 4: 
	Generate 40.000 more rows to 'employee_data_update_table'

	select count(*) from employee_data_update_table
	select * from employee_data_update_table

-- Step 5:
	Copy all the data from 'employee_data_update_table' to 'employee_data_update_2_table'

	truncate table employee_data_update_2_table
	insert into employee_data_update_2_table
	select * from employee_data_update_table;

-- Step 6: 
	Simulate changes for the second time:

	Type 1 columns: update ~20000 rows:

	update employee_data_update_2_table set attr_1 = 'new attr 1 value second'
	where id in (select top 12000 id from employee_data_update_table order by newid())
	update employee_data_update_2_table set attr_2 = 'new attr 2 value second'
	where id in (select top 8000 id from employee_data_update_table order by newid())

	Type 2 columns: update ~40000 rows:

	update employee_data_update_2_table set attr_3 = 'new attr 3 value second'
	where id in (select top 20000 id from employee_data_update_table order by newid())
	update employee_data_update_2_table set attr_4 = 'new attr 4 value second'
	where id in (select top 8000 id from employee_data_update_table order by newid())
	update employee_data_update_2_table set attr_5 = 'new attr 5 value second'
	where id in (select top 12000 id from employee_data_update_table order by newid())
	 
-- Step 7:
	Generate 80.000 more rows to 'employee_data_update_2_table'

	select count(*) from employee_data_update_2_table
	select * from employee_data_update_2_table where id > 1000000 order by id asc

----------
	Now the 'employee_data_table' has 1.000.000 rows of data,
	the 'employee_data_update_table' has 1.040.000 rows of data (40k new, ~30k changes)
	the 'employee_data_update_table' has 1.120.000 rows of data (80k new, ~60k changes)

*/

/* 

select count(*) from employee_data_table

select count(*) from employee_update_table

select count(*) from employee_update_2_table

*/