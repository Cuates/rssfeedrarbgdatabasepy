-- Database Connect
use <databasename>;

-- ============================
--        File: MovieFeedTemp
--     Created: 09/07/2020
--     Updated: 09/30/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists MovieFeedTemp;

-- Table Create
create table if not exists `MovieFeedTemp`(
  `titlelong` varchar(255) collate utf8mb4_unicode_520_ci default null,
  `titleshort` varchar(255) collate utf8mb4_unicode_520_ci default null,
  `publish_date` varchar(255) collate utf8mb4_unicode_520_ci default null,
  `created_date` datetime(6) default current_timestamp(6)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
