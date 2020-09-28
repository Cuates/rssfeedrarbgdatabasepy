-- Database Connect
\c <databasename>;

-- =======================
--        File: TVFeed
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: TV Feed
-- =======================

-- Sequence Drop
drop sequence if exists TVFeed_tfID_seq;

-- Sequence Create
create sequence if not exists TVFeed_tfID_seq;

-- Table Drop
drop table if exists TVFeed;

-- Table Create
create table if not exists TVFeed(
  tfID bigint not null default nextval('TVFeed_tfID_seq'),
  titlelong varchar(255) not null,
  titleshort varchar(255) not null,
  publish_date timestamp not null,
  actionstatus int not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_TVFeed_titlelong primary key (titlelong)
);

-- Sequence Alter ownership
alter sequence TVFeed_tfID_seq owned by TVFeed.tfID;

-- Grant permission to a sequence
grant usage, select on sequence TVFeed_tfID_seq to <username>;
