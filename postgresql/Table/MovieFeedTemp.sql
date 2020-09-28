-- Database Connect
\c <databasename>;

-- ============================
--        File: MovieFeedTemp
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists MovieFeedTemp;

-- Table Create
create table if not exists MovieFeedTemp(
  titlelong varchar(255) default null,
  titleshort varchar(255) default null,
  publish_date varchar(255) default null,
  created_date timestamp default current_timestamp
);
