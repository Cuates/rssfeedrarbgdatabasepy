-- Database Connect
use <databasename>;

-- ====================================================
--        File: UQIX_MediaAudioEncode_audioencode
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status audio encode
-- ====================================================

-- Index Drop
drop index if exists `UQIX_MediaAudioEncode_audioencode` on MediaAudioEncode;

-- Index Create
create unique index `UQIX_MediaAudioEncode_audioencode` on MediaAudioEncode (`audioencode`);