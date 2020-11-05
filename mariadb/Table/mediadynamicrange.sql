-- Database Connect
use <databasename>;

-- ================================
--        File: mediadynamicrange
--     Created: 09/07/2020
--     Updated: 11/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media dynamic range
-- ================================

-- Drop Table
drop table if exists mediadynamicrange;

-- Table Create
create table if not exists `mediadynamicrange`(
  `mdrID` bigint(20) unsigned not null auto_increment,
  `dynamicrange` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` tinyint unsigned not null default 0,
  `tvInclude` tinyint unsigned not null default 0,
  `created_date` datetime not null default current_timestamp(6),
  `modified_date` datetime default current_timestamp(6),
  primary key (`mdrID`),
  unique key `uqix_mediadynamicrange_dynamicrange` (`dynamicrange`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
