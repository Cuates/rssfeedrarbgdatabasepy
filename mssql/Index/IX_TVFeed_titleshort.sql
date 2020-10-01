-- Database Connect
use [databasename]
go

-- Set ansi padding
set ansi_padding on
go

-- Index Drop
drop index if exists IX_TVFeed_titleshort on dbo.TVFeed

-- Index Create
create nonclustered index [IX_TVFeed_titleshort] on [dbo].[TVFeed]
(
  [titleshort] asc
)with (pad_index = off, statistics_norecompute = off, sort_in_tempdb = off, drop_existing = off, online = off, allow_row_locks = on, allow_page_locks = on, optimize_for_sequential_key = off) on [primary]
go
