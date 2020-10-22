-- Database Connect
use <databasename>;

-- =============================
--        File: MediaResolution
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media resolution
-- =============================

-- Drop Table
drop table if exists MediaResolution;

-- Table Create
create table if not exists `MediaResolution`(
  `mrID` bigint(20) unsigned not null auto_increment,
  `resolution` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`mrID`),
  unique key `UQIX_MediaResolution_resolution` (`resolution`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
