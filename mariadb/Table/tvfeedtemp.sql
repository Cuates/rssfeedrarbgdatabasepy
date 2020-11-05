-- Database Connect
use <databasename>;

-- ============================
--        File: tvfeedtemp
--     Created: 09/07/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists tvfeedtemp;

-- Table Create
create table if not exists `tvfeedtemp`(
  `titlelong` text collate utf8mb4_unicode_520_ci default null,
  `titleshort` text collate utf8mb4_unicode_520_ci default null,
  `publish_date` text collate utf8mb4_unicode_520_ci default null,
  `created_date` datetime default current_timestamp(6)
) engine=InnoDB default charset=utf8mb4 collate utf8mb4_unicode_520_ci;
