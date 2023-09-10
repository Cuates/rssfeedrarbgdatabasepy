-- Database Connect
use <databasename>;

-- =======================
--        File: moviefeed
--     Created: 09/07/2020
--     Updated: 11/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie Feed
-- =======================

-- Table Drop
drop table if exists moviefeed;

-- Table Create
create table if not exists `moviefeed`(
  `mfID` bigint(20) unsigned not null auto_increment,
  `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `info_url` text collate utf8mb4_unicode_520_ci default null,
  `publish_date` datetime(6) not null,
  `actionstatus` int(11) not null default 0,
  `created_date` datetime not null default current_timestamp(6),
  `modified_date` datetime default current_timestamp(6),
  primary key (`mfID`),
  unique key `uqix_moviefeed_titlelong` (`titlelong`),
  index `ix_moviefeed_titleshort` (`titleshort`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
