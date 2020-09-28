-- Database Connect
use <databasename>;

-- ==========================
--        File: ActionStatus
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Action status
-- ==========================

-- Table Drop
drop table if exists ActionStatus;

-- Table Create
create table if not exists `ActionStatus`(
  `asID` bigint(20) unsigned not null auto_increment,
  `actionnumber` int(11) not null,
  `actiondescription` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `created_date` datetime not null default current_timestamp(),
  `modified_date` datetime default current_timestamp(),
  primary key (`asID`),
  unique key `UQIX_ActionStatus_actionnumber` (`actionnumber`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
