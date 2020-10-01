-- Database Connect
\c <databasename>;

-- ===========================================================
--        File: UQIX_MediaDynamicRange_dynamicrange
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media dynamic range dynamic range
-- ===========================================================

-- Index Drop
drop index if exists UQIX_MediaDynamicRange_dynamicrange;

-- Index Create
create unique index if not exists UQIX_MediaDynamicRange_dynamicrange on MediaDynamicRange ((dynamicrange));