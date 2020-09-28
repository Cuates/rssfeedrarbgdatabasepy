-- Database Connect
\c <databasename>;

-- =====================================================
--        File: UQIX_ActionStatus_actionnumber
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status action number
-- =====================================================

-- Index Drop
drop index if exists UQIX_ActionStatus_actionnumber;

-- Index Create
create unique index if not exists UQIX_ActionStatus_actionnumber on ActionStatus ((actionnumber));
