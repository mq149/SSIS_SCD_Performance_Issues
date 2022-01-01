use Seminar_Stage
go

-- Table for third ETL
create table employee_table_2 (
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

CREATE TRIGGER row_value_trigger_2 on employee_table_2
FOR UPDATE, INSERT AS
UPDATE employee_table_2
SET [hash_type_1] = (select hashbytes('md5', (select [attr_1], [attr_2] for xml raw))),
[hash_type_2] = (select hashbytes('md5', (select [attr_4], [attr_5], [attr_6] for xml raw)))
GO

-- Table for third ETL
create table employee_sync_table_2 (
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
-- Step 1: Populate data for 'employee_table_2' 
-- (1M rows)

	truncate table employee_table_2;

	insert into employee_table_2 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6)
	select * from employee_data_update_table;

-- Step 2: Sync 'employee_table_2' with 'employee_sync_table_2' 
-- (1M40k rows - simulate second time ETL is completed)

	truncate table employee_sync_table_2;

	insert into employee_sync_table_2 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6, hash_type_1, hash_type_2)
	select * from employee_table_2;

-- Step 3: Update new data and changed data to 'employee_table_2' 
-- (1M + 80k rows - simulate new data and changes in 'employee_table_2)

	truncate table employee_table_2;

	insert into employee_table_2 (id, attr_1, attr_2, attr_3, attr_4, attr_5, attr_6)
	select * from employee_data_update_2_table;

*/

/* Filter new data and changes

	SELECT e.*, 1 AS type, 0 AS new
	FROM employee_sync_table_2 es
	JOIN employee_table_2 e
	ON es.id = e.id
	WHERE es.hash_type_1 != e.hash_type_1 
		and es.hash_type_2 = e.hash_type_2
	UNION ALL
	(
		SELECT e.*, 2 AS type, 0 AS new
		FROM employee_sync_table_2 es
		JOIN employee_table_2 e
		ON es.id = e.id
		WHERE es.hash_type_2 != e.hash_type_2
	)
	UNION ALL
	(
		SELECT *, NULL AS type, 1 AS new
		FROM employee_table_2
		WHERE id NOT IN
		(
			SELECT id FROM employee_sync_table_2
		)
	);

*/