-- Database Connect
\c <databasename>;

-- =========================================
--        File: ix_tvfeed_titleshort
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title short
-- =========================================

-- Index Drop
drop index if exists ix_tvfeed_titleshort;

-- Index Create
create index if not exists ix_tvfeed_titleshort on tvfeed (titleshort);
