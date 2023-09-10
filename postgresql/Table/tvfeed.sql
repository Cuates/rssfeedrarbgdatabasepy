-- Database Connect
\c <databasename>;

-- =======================
--        File: tvfeed
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: TV feed
-- =======================

-- Sequence Drop
drop sequence if exists tvfeed_tfID_seq cascade;

-- Sequence Create
create sequence if not exists tvfeed_tfID_seq;

-- Table Drop
drop table if exists tvfeed;

-- Table Create
create table if not exists tvfeed(
  tfID bigint not null default nextval('tvfeed_tfID_seq'),
  titlelong citext not null,
  titleshort citext not null,
  info_url citext default null,
  publish_date timestamp not null,
  actionstatus int not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint pk_tvfeed_titlelong primary key (titlelong)
);

-- Sequence Alter ownership
alter sequence tvfeed_tfID_seq owned by tvfeed.tfID;

-- Grant permission to a sequence
grant usage, select on sequence tvfeed_tfID_seq to <userrolename>;
