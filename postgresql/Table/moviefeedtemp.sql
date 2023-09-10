-- Database Connect
\c <databasename>;

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
create table if not exists moviefeedtemp(
  titlelong citext default null,
  titleshort citext default null,
  info_url citext default null,
  publish_date varchar(255) default null,
  created_date timestamp default current_timestamp
);
