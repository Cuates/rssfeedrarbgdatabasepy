-- Database Connect
\c <databasename>;

-- ================================
--        File: MediaStreamSource
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media stream source
-- ================================

-- Sequence Drop
drop sequence if exists MediaStreamSource_mssID_seq;

-- Sequence Create
create sequence if not exists MediaStreamSource_mssID_seq;

-- Table Drop
drop table if exists MediaStreamSource;

-- Table Create
create table if not exists MediaStreamSource(
  mssID bigint not null default nextval('MediaStreamSource_mssID_seq'),
  streamsource varchar(100) not null,
  movieInclude bit(1) not null default b'0',
  tvInclude bit(1) not null default b'0',
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MediaStreamSource_streamsource primary key (streamsource)
);

-- Sequence Alter ownership
alter sequence MediaStreamSource_mssID_seq owned by MediaStreamSource.mssID;

-- Grant permission to a sequence
grant usage, select on sequence MediaStreamSource_mssID_seq to <username>;
