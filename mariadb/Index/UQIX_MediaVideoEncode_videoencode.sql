-- Database Connect
use <databasename>;

-- ========================================================
--        File: UQIX_MediaVideoEncode_videoencode
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media video encode videoencode
-- ========================================================

-- Index Drop
drop index if exists `UQIX_MediaVideoEncode_videoencode` on MediaVideoEncode;

-- Index Create
create unique index `UQIX_MediaVideoEncode_videoencode` on MediaVideoEncode (`videoencode`);
