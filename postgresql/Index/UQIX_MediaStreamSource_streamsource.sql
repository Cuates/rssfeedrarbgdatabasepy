-- Database Connect
\c <databasename>;

-- ==========================================================
--        File: UQIX_MediaStreamSource_streamsource
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media stream source streamsource
-- ==========================================================

-- Index Drop
drop index if exists UQIX_MediaStreamSource_streamsource;

-- Index Create
create unique index if not exists UQIX_MediaStreamSource_streamsource on MediaStreamSource ((streamsource));
