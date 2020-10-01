-- Database Connect
use [databasename]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- Table Drop
drop table if exists dbo.ActionStatus
go

-- Table Create
create table [dbo].[ActionStatus](
  [asID] [bigint] identity(1,1) not null,
  [actionnumber] [int] not null,
  [actiondescription] [nvarchar](255) not null,
  [created_date] [datetime2](6) not null,
  [modified_date] [datetime2](6) null,
 constraint [PK_ActionStatus_actionnumber] primary key clustered
(
  [actionnumber] asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on, fillfactor = 90, optimize_for_sequential_key = off) on [primary]
) on [primary]
go

-- Contraint Default
alter table [dbo].[ActionStatus] add  default (getdate()) for [created_date]
go

-- Contraint Default
alter table [dbo].[ActionStatus] add  default (getdate()) for [modified_date]
go
