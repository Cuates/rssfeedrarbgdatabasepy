-- Database Connect
\c <databasename>;

-- ==========================================================
--        File: uqix_mediastreamsource_streamsource
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media stream source streamsource
-- ==========================================================

-- Index Drop
drop index if exists uqix_mediastreamsource_streamsource;

-- Index Create
create unique index if not exists uqix_mediastreamsource_streamsource on mediastreamsource (streamsource);
