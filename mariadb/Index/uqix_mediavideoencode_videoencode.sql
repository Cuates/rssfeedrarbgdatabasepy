-- Database Connect
use <databasename>;

-- ========================================================
--        File: uqix_mediavideoencode_videoencode
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media video encode videoencode
-- ========================================================

-- Index Drop
drop index if exists `uqix_mediavideoencode_videoencode` on mediavideoencode;

-- Index Create
create unique index `uqix_mediavideoencode_videoencode` on mediavideoencode (`videoencode`);
