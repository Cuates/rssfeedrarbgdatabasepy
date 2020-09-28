-- Database Connect
use <databasename>;

-- =====================================================
--        File: UQIX_MediaResolution_resolution
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media resolution resolution
-- =====================================================

-- Index Drop
drop index if exists UQIX_MediaResolution_resolution;

-- Index Create
create unique index UQIX_MediaResolution_resolution on MediaResolution ((resolution));
