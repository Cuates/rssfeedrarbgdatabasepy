-- Database Connect
\c <databasename>;

-- ============================
--        File: MovieFeedTemp
--     Created: 09/07/2020
--     Updated: 10/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie feed temp
-- ============================

-- Table Drop
drop table if exists MovieFeedTemp;

-- Table Create
create table if not exists MovieFeedTemp(
  titlelong citext default null,
  titleshort citext default null,
  publish_date varchar(255) default null,
  created_date timestamp default current_timestamp
);
