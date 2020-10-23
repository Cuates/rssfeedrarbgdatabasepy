-- Database Connect
use <databasename>;

-- =========================================
--        File: ix_tvfeed_titleshort
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index tv feed title short
-- =========================================

-- Index Drop
drop index if exists `ix_tvfeed_titleshort` on tvfeed;

-- Index Create
create index `ix_tvfeed_titleshort` on tvfeed (`titleshort`);
