-- Database Connect
use <databasename>;

-- ==========================
--        File: actionstatus
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Action status
-- ==========================

-- Table Drop
drop table if exists actionstatus;

-- Table Create
create table if not exists `actionstatus`(
  `asID` bigint(20) unsigned not null auto_increment,
  `actionnumber` int(11) not null,
  `actiondescription` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`asID`),
  unique key `UQIX_actionstatus_actionnumber` (`actionnumber`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
