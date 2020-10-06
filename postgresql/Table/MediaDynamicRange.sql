-- Database Connect
\c <databasename>;

-- ================================
--        File: MediaDynamicRange
--     Created: 09/07/2020
--     Updated: 10/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media dynamic range
-- ================================

-- Sequence Drop
drop sequence if exists MediaDynamicRange_mdrID_seq;

-- Sequence Create
create sequence if not exists MediaDynamicRange_mdrID_seq;

-- Drop Table
drop table if exists MediaAudioEncode;

-- Table Create
create table if not exists MediaDynamicRange(
  mdrID bigint not null default nextval('MediaDynamicRange_mdrID_seq'),
  dynamicrange citext not null,
  movieInclude bit(1) not null default b'0',
  tvInclude bit(1) not null default b'0',
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MediaDynamicRange_dynamicrange primary key (dynamicrange)
);

-- Sequence Alter ownership
alter sequence MediaDynamicRange_mdrID_seq owned by MediaDynamicRange.mdrID;

-- Grant permission to a sequence
grant usage, select on sequence MediaDynamicRange_mdrID_seq to <username>;
