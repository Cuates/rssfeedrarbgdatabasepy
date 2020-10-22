-- Database Connect
use <databasename>;

-- ===============================
--        File: mediaaudioencode
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media audio encode
-- ===============================

-- Table Drop
drop table if exists mediaaudioencode;

-- Table Create
create table if not exists `mediaaudioencode`(
  `maeID` bigint(20) unsigned not null auto_increment,
  `audioencode` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`maeID`),
  unique key `UQIX_mediaaudioencode_audioencode` (`audioencode`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
