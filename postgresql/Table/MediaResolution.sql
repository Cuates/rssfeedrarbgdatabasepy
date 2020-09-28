-- Database Connect
\c <databasename>;

-- =============================
--        File: MediaResolution
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media resolution
-- =============================

-- Sequence Drop
drop sequence if exists MediaResolution_mrID_seq;

-- Sequence Create
create sequence if not exists MediaResolution_mrID_seq;

-- Drop Table
drop table if exists MediaDynamicRange;

-- Table Create
create table if not exists MediaResolution(
  mrID bigint not null default nextval('MediaResolution_mrID_seq'),
  resolution varchar(100) not null,
  movieInclude bit(1) not null default b'0',
  tvInclude bit(1) not null default b'0',
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MediaResolution_resolution primary key (resolution)
);

-- Sequence Alter ownership
alter sequence MediaResolution_mrID_seq owned by MediaResolution.mrID;

-- Grant permission to a sequence
grant usage, select on sequence MediaResolution_mrID_seq to <username>;
