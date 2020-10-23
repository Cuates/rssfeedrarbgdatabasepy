-- Database Connect
\c <databasename>;

-- =======================
--        File: MovieFeed
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie Feed
-- =======================

-- Sequence Drop
drop sequence if exists moviefeed_mfID_seq cascade;

-- Sequence Create
create sequence if not exists moviefeed_mfID_seq;

-- Table Drop
drop table if exists moviefeed;

-- Table Create
create table if not exists moviefeed(
  mfID bigint not null default nextval('moviefeed_mfID_seq'),
  titlelong citext not null,
  titleshort citext not null,
  publish_date timestamp not null,
  actionstatus int not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint pk_moviefeed_titlelong primary key (titlelong)
);

-- Sequence Alter ownership
alter sequence moviefeed_mfID_seq owned by moviefeed.mfID;

-- Grant permission to a sequence
grant usage, select on sequence moviefeed_mfID_seq to <userrolename>;
