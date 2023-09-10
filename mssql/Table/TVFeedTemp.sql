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
drop table if exists dbo.TVFeedTemp
go

-- Table Create
create table [dbo].[TVFeedTemp](
  [titlelong] [nvarchar](max) null,
  [titleshort] [nvarchar](max) null,
  [info_url] [nvarchar](max) null,
  [publish_date] [nvarchar](max) null,
  [created_date] [datetime2](6) null
) on [primary]
go

-- Contraint Default
alter table [dbo].[TVFeedTemp] add  default (getdate()) for [created_date]
go
