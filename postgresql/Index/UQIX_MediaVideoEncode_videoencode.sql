-- Database Connect
\c <databasename>;

-- ========================================================
--        File: UQIX_MediaVideoEncode_videoencode
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media video encode videoencode
-- ========================================================

-- Index Drop
drop index if exists UQIX_MediaVideoEncode_videoencode;

-- Index Create
create unique index if not exists UQIX_MediaVideoEncode_videoencode on MediaVideoEncode ((videoencode));
