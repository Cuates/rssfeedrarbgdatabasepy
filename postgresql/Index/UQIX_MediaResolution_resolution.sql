-- Database Connect
\c <databasename>;

-- =====================================================
--        File: uqix_mediaresolution_resolution
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media resolution resolution
-- =====================================================

-- Index Drop
drop index if exists uqix_mediaresolution_resolution;

-- Index Create
create unique index if not exists uqix_mediaresolution_resolution on mediaresolution (resolution);
