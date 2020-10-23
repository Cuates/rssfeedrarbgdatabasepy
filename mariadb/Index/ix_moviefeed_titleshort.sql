-- Database Connect
use <databasename>;

-- =========================================
--        File: ix_moviefeed_titleshort
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Index movie feed title short
-- =========================================

-- Index Drop
drop index if exists `ix_moviefeed_titleshort` on moviefeed;

-- Index Create
create index `ix_moviefeed_titleshort` on moviefeed (`titleshort`);
