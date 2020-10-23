-- Database Connect
use <databasename>;

-- ============================
--        File: moviefeedtemp
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists moviefeedtemp;

-- Table Create
create table if not exists `moviefeedtemp`(
  `titlelong` text collate utf8mb4_unicode_520_ci default null,
  `titleshort` text collate utf8mb4_unicode_520_ci default null,
  `publish_date` text collate utf8mb4_unicode_520_ci default null,
  `created_date` datetime(6) default current_timestamp(6)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
