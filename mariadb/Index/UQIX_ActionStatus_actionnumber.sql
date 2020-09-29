-- Database Connect
use <databasename>;

-- =====================================================
--        File: UQIX_ActionStatus_actionnumber
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status action number
-- =====================================================

-- Index Drop
drop index if exists `UQIX_ActionStatus_actionnumber` on ActionStatus;

-- Index Create
create unique index `UQIX_ActionStatus_actionnumber` on ActionStatus (`actionnumber`);
