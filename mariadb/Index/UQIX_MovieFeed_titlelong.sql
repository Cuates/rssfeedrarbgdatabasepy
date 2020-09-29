-- Database Connect
use <databasename>;

-- ========================================
--        File: UQIX_MovieFeed_titlelong
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title long
-- ========================================

-- Index Drop
drop index if exists `UQIX_MovieFeed_titlelong` on MovieFeed;

-- Index Create
create unique index `UQIX_MovieFeed_titlelong` on MovieFeed (`titlelong`);
