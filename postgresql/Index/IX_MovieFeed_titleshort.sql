-- Database Connect
\c <databasename>;

-- =========================================
--        File: IX_MovieFeed_titleshort
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title short
-- =========================================

-- Index Drop
drop index if exists IX_MovieFeed_titleshort;

-- Index Create
create index if not exists IX_MovieFeed_titleshort on MovieFeed ((titleshort));
