create database Seminar_DDS
go

use Seminar_DDS
go

create table DimEmployee (
	[key] int identity(1,1) primary key,
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
	[is_active] tinyint,
	[effective_date] datetime,
	[expiry_date] datetime,
)
go

create table DimEmployee_indexed (
	[key] int identity(1,1) primary key,
	[id] int not null,
	[attr_1] varchar(50),
	[attr_2] varchar(50),
	[attr_3] varchar(50),
	[attr_4] varchar(50),
	[attr_5] varchar(50),
	[attr_6] varchar(50),
	[is_active] tinyint,
	[effective_date] datetime,
	[expiry_date] datetime,
)
go

create index emp_id_index
on DimEmployee_indexed (id);
go

-- truncate table DimEmployee
-- truncate table DimEmployee_indexed