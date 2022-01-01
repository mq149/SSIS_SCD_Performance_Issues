use Seminar_Stage
go

-- Table for second ETL
create table employee_table_1 (
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
	[hash_type_1] varbinary(8000),
	[hash_type_2] varbinary(8000)
)
go

CREATE TRIGGER row_value_trigger_1 on employee_table_1
FOR UPDATE, INSERT AS
UPDATE employee_table_1
SET [hash_type_1] = (select hashbytes('md5', (select [attr_1], [attr_2] for xml raw))),
[hash_type_2] = (select hashbytes('md5', (select [attr_4], [attr_5], [attr_6] for xml raw)))
GO

-- Table for second ETL
create table employee_sync_table_1 (
	[employee_sync_table_id] int identity(1,1),
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
	[hash_type_1] varbinary(8000),
	[hash_type_2] varbinary(8000),
	[updated_date] datetime
)
go

/* Populate data
-- Step 1: Populate data for 'employee_table_1' 
-- (1M rows)

	truncate table employee_table_1;

	insert into employee_table_1 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6)
	select * from employee_data_table;

-- Step 2: Sync 'employee_table_1' with 'employee_sync_table_1' 
-- (1M rows - simulate first time ETL is completed)

	truncate table employee_sync_table_1;

	insert into employee_sync_table_1 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6, hash_type_1, hash_type_2)
	select * from employee_table_1;

-- Step 3: Update new data and changed data to 'employee_table_1' 
-- (1M + 40k rows - simulate new data and changes in 'employee_table_1)

	truncate table employee_table_1;

	insert into employee_table_1 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6)
	select * from employee_data_update_table;

*/

/* Filter new data and changes

	SELECT e.*, 1 AS type, 0 AS new
	FROM employee_sync_table_1 es
	JOIN employee_table_1 e
	ON es.id = e.id
	WHERE es.hash_type_1 != e.hash_type_1 
		and es.hash_type_2 = e.hash_type_2
	UNION ALL
	(
		SELECT e.*, 2 AS type, 0 AS new
		FROM employee_sync_table_1 es
		JOIN employee_table_1 e
		ON es.id = e.id
		WHERE es.hash_type_2 != e.hash_type_2
	)
	UNION ALL
	(
		SELECT *, NULL AS type, 1 AS new
		FROM employee_table_1
		WHERE id NOT IN
		(
			SELECT id FROM employee_sync_table_1
		)
	);

*/

