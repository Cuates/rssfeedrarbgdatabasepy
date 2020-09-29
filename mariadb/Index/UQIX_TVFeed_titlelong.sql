-- Database Connect
use <databasename>;

-- ========================================
--        File: UQIX_TVFeed_titlelong
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index tv feed title long
-- ========================================

-- Index Drop
drop index if exists `UQIX_TVFeed_titlelong` on TVFeed;

-- Index Create
create unique index `UQIX_TVFeed_titlelong` on TVFeed (`titlelong`);
