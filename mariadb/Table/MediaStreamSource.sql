-- Database Connect
use <databasename>;

-- ================================
--        File: MediaStreamSource
--     Created: 09/07/2020
--     Updated: 09/28/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media stream source
-- ================================

-- Table Drop
drop table if exists MediaStreamSource;

-- Table Create
create table if not exists `MediaStreamSource`(
  `mssID` bigint(20) unsigned not null auto_increment,
  `streamsource` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `movieInclude` bit(1) not null default b'0',
  `tvInclude` bit(1) not null default b'0',
  `created_date` datetime not null default current_timestamp(),
  `modified_date` datetime default current_timestamp(),
  primary key (`mssID`),
  unique key `UQIX_MediaStreamSource_streamsource` (`streamsource`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
