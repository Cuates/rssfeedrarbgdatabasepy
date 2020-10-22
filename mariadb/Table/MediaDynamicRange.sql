-- Database Connect
use <databasename>;

-- ================================
--        File: MediaDynamicRange
--     Created: 09/07/2020
--     Updated: 09/30/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media dynamic range
-- ================================

-- Drop Table
drop table if exists MediaDynamicRange;

-- Table Create
create table if not exists `MediaDynamicRange`(
  `mdrID` bigint(20) unsigned not null auto_increment,
  `dynamicrange` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`mdrID`),
  unique key `UQIX_MediaDynamicRange_dynamicrange` (`dynamicrange`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
