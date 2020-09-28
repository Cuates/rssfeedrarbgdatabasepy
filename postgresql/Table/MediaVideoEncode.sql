-- Database Connect
\c <databasename>;

-- ===============================
--        File: MediaVideoEncode
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media video encode
-- ===============================

-- Sequence Drop
drop sequence if exists MediaVideoEncode_mveID_seq;

-- Sequence Create
create sequence if not exists MediaVideoEncode_mveID_seq;

-- Table Drop
drop table if exists MediaVideoEncode;

-- Table Create
create table if not exists MediaVideoEncode(
  mveID bigint not null default nextval('MediaVideoEncode_mveID_seq'),
  videoencode varchar(100) not null,
  movieInclude bit(1) not null default b'0',
  tvInclude bit(1) not null default b'0',
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MediaVideoEncode_videoencode primary key (videoencode)
);

-- Sequence Alter ownership
alter sequence MediaVideoEncode_mveID_seq owned by MediaVideoEncode.mveID;

-- Grant permission to a sequence
grant usage, select on sequence MediaVideoEncode_mveID_seq to <username>;
