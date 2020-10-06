-- Database Connect
\c <databasename>;

-- =======================
--        File: MovieFeed
--     Created: 09/07/2020
--     Updated: 10/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Movie Feed
-- =======================

-- Sequence Drop
drop sequence if exists MovieFeed_mfID_seq;

-- Sequence Create
create sequence if not exists MovieFeed_mfID_seq;

-- Table Drop
drop table if exists MovieFeed;

-- Table Create
create table if not exists MovieFeed(
  mfID bigint not null default nextval('MovieFeed_mfID_seq'),
  titlelong citext not null,
  titleshort citext not null,
  publish_date timestamp not null,
  actionstatus int not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MovieFeed_titlelong primary key (titlelong)
);

-- Sequence Alter ownership
alter sequence MovieFeed_mfID_seq owned by MovieFeed.mfID;

-- Grant permission to a sequence
grant usage, select on sequence MovieFeed_mfID_seq to <username>;
