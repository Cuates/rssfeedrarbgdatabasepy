-- Database Connect
use <databasename>;

-- =====================================================
--        File: uqix_actionstatus_actionnumber
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Unique index action status action number
-- =====================================================

-- Index Drop
drop index if exists `uqix_actionstatus_actionnumber` on actionstatus;

-- Index Create
create unique index `uqix_actionstatus_actionnumber` on actionstatus (`actionnumber`);
