-- Database Connect
\c <databasename>;

-- ====================================================
--        File: UQIX_MediaAudioEncode_audioencode
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status audio encode
-- ====================================================

-- Index Drop
drop index if exists UQIX_MediaAudioEncode_audioencode;

-- Index Create
create unique index if not exists UQIX_MediaAudioEncode_audioencode on MediaAudioEncode ((audioencode));
