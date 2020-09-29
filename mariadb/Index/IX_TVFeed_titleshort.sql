-- Database Connect
use <databasename>;

-- =========================================
--        File: IX_TVFeed_titleshort
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title short
-- =========================================

-- Index Drop
drop index if exists `IX_TVFeed_titleshort` on TVFeed;

-- Index Create
create index `IX_TVFeed_titleshort` on TVFeed (`titleshort`);
