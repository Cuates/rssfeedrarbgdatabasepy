-- Database Connect
\c <databasename>;

-- ============================
--        File: TVFeedTemp
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists TVFeedTemp;

-- Table Create
create table if not exists TVFeedTemp(
  titlelong varchar(255) default null,
  titleshort varchar(255) default null,
  publish_date varchar(255) default null,
  created_date timestamp default current_timestamp
);
