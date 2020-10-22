-- Database Connect
use <databasename>;

-- ================================
--        File: mediastreamsource
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media stream source
-- ================================

-- Table Drop
drop table if exists mediastreamsource;

-- Table Create
create table if not exists `mediastreamsource`(
  `mssID` bigint(20) unsigned not null auto_increment,
  `streamsource` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `streamdescription` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`mssID`),
  unique key `UQIX_mediastreamsource_streamsource` (`streamsource`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
