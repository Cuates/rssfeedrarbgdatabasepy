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
drop table if exists dbo.MovieFeedTemp
go

-- Table Create
create table [dbo].[MovieFeedTemp](
  [titlelong] [nvarchar](max) null,
  [titleshort] [nvarchar](max) null,
  [publish_date] [nvarchar](max) null,
  [created_date] [datetime2](6) null
) on [primary]
go

-- Contraint Default
alter table [dbo].[MovieFeedTemp] add  default (getdate()) for [created_date]
go
