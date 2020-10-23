-- Database Connect
\c <databasename>;

-- ========================================================
--        File: uqix_mediavideoencode_videoencode
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media video encode videoencode
-- ========================================================

-- Index Drop
drop index if exists uqix_mediavideoencode_videoencode;

-- Index Create
create unique index if not exists uqix_mediavideoencode_videoencode on mediavideoencode (videoencode);
