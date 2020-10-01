-- Database Connect
use <databasename>;

-- =======================
--        File: MovieFeed
--     Created: 09/07/2020
--     Updated: 09/30/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie Feed
-- =======================

-- Table Drop
drop table if exists MovieFeed;

-- Table Create
create table if not exists `MovieFeed`(
  `mfID` bigint(20) unsigned not null auto_increment,
  `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
  `publish_date` datetime not null,
  `actionstatus` int(11) not null default 0,
  `created_date` datetime(6) not null default current_timestamp(6),
  `modified_date` datetime(6) default current_timestamp(6),
  primary key (`mfID`),
  unique key `UQIX_MovieFeed_titlelong` (`titlelong`),
  index `IX_MovieFeed_titleshort` (`titleshort`)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
