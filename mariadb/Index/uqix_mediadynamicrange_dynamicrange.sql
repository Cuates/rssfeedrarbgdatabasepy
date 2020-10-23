-- Database Connect
use <databasename>;

-- ===========================================================
--        File: uqix_mediadynamicrange_dynamicrange
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index media dynamic range dynamic range
-- ===========================================================

-- Index Drop
drop index if exists `uqix_mediadynamicrange_dynamicrange` on mediadynamicrange;

-- Index Create
create unique index `uqix_mediadynamicrange_dynamicrange` on mediadynamicrange (`dynamicrange`);
