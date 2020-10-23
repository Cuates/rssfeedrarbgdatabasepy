-- Database Connect
\c <databasename>;

-- ====================================================
--        File: uqix_mediaaudioencode_audioencode
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status audio encode
-- ====================================================

-- Index Drop
drop index if exists uqix_mediaaudioencode_audioencode;

-- Index Create
create unique index if not exists uqix_mediaaudioencode_audioencode on mediaaudioencode (audioencode);
