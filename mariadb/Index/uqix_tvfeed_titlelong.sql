-- Database Connect
use <databasename>;

-- ========================================
--        File: uqix_tvfeed_titlelong
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index tv feed title long
-- ========================================

-- Index Drop
drop index if exists `uqix_tvfeed_titlelong` on tvfeed;

-- Index Create
create unique index `uqix_tvfeed_titlelong` on tvfeed (`titlelong`);
