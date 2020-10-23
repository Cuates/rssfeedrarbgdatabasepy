-- Database Connect
\c <databasename>;

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
create table if not exists tvfeedtemp(
  titlelong citext default null,
  titleshort citext default null,
  publish_date varchar(255) default null,
  created_date timestamp default current_timestamp
);
