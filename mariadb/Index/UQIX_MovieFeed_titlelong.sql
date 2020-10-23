-- Database Connect
use <databasename>;

-- ========================================
--        File: uqix_moviefeed_titlelong
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title long
-- ========================================

-- Index Drop
drop index if exists `uqix_moviefeed_titlelong` on moviefeed;

-- Index Create
create unique index `uqix_moviefeed_titlelong` on moviefeed (`titlelong`);
