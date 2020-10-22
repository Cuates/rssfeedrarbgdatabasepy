-- Database Connect
use <databasename>;

-- ===============================
--        File: mediavideoencode
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media video encode
-- ===============================

-- Table Drop
drop table if exists mediavideoencode;

-- Table Create
create table if not exists `mediavideoencode`(
  `mveID` bigint(20) unsigned not null auto_increment,
  `videoencode` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`mveID`),
  unique key `UQIX_mediavideoencode_videoencode` (`videoencode`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
