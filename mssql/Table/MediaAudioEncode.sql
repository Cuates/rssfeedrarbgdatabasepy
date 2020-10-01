-- Database Connect
use [Media]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- Table Drop
drop table if exists dbo.MediaAudioEncode
go

-- Table Create
create table [dbo].[MediaAudioEncode](
	[maeID] [bigint] identity(1,1) not null,
	[audioencode] [nvarchar](100) not null,
	[movieInclude] [bit] not null,
	[tvInclude] [bit] not null,
	[created_date] [datetime2](6) not null,
	[modified_date] [datetime2](6) null,
 CONSTRAINT [PK_MediaAudioEncode_audioencode] primary key clustered
(
	[audioencode] asc
)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on, fillfactor = 90, optimize_for_sequential_key = off) on [primary]
) on [primary]
go

-- Contraint Default
alter table [dbo].[MediaAudioEncode] add  default ((0)) for [movieInclude]
go

-- Contraint Default
alter table [dbo].[MediaAudioEncode] add  default ((0)) for [tvInclude]
go

-- Contraint Default
alter table [dbo].[MediaAudioEncode] add  default (getdate()) for [created_date]
go

-- Contraint Default
alter table [dbo].[MediaAudioEncode] add  default (getdate()) for [modified_date]
go
