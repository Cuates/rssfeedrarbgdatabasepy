-- Database Connect
use <databasename>;

-- =========================================
--        File: IX_MovieFeed_titleshort
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title short
-- =========================================

-- Index Drop
drop index if exists `IX_MovieFeed_titleshort` on MovieFeed;

-- Index Create
create index `IX_MovieFeed_titleshort` on MovieFeed (`titleshort`);
