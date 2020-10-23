-- Database Connect
use <databasename>;

-- =====================================================
--        File: uqix_mediaresolution_resolution
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media resolution resolution
-- =====================================================

-- Index Drop
drop index if exists `uqix_mediaresolution_resolution` on mediaresolution;

-- Index Create
create unique index `uqix_mediaresolution_resolution` on mediaresolution (`resolution`);
