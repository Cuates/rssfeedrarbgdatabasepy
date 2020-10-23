-- Database Connect
\c <databasename>;

-- ================================
--        File: mediastreamsource
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media stream source
-- ================================

-- Sequence Drop
drop sequence if exists mediastreamsource_mssID_seq;

-- Sequence Create
create sequence if not exists mediastreamsource_mssID_seq;

-- Table Drop
drop table if exists MediaStreamSource;

-- Table Create
create table if not exists mediastreamsource(
  mssID bigint not null default nextval('mediastreamsource_mssID_seq'),
  streamsource citext not null,
  streamdescription citext not null,
  movieInclude smallint not null default 0,
  tvInclude smallint not null default 0,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_mediastreamsource_streamsource primary key (streamsource)
);

-- Sequence Alter ownership
alter sequence mediastreamsource_mssID_seq owned by mediastreamsource.mssID;

-- Grant permission to a sequence
grant usage, select on sequence mediastreamsource_mssID_seq to <username>;
