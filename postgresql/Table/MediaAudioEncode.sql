-- Database Connect
\c <databasename>;

-- ===============================
--        File: MediaAudioEncode
--     Created: 09/07/2020
--     Updated: 10/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media audio encode
-- ===============================

-- Sequence Drop
drop sequence if exists MediaAudioEncode_maeID_seq;

-- Sequence Create
create sequence if not exists MediaAudioEncode_maeID_seq;

-- Table Drop
drop table if exists MediaAudioEncode;

-- Table Create
create table if not exists MediaAudioEncode(
  maeID bigint not null default nextval('MediaAudioEncode_maeID_seq'),
  audioencode citext not null,
  movieInclude bit(1) not null default b'0',
  tvInclude bit(1) not null default b'0',
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_MediaAudioEncode_audioencode primary key (audioencode)
);

-- Sequence Alter ownership
alter sequence MediaAudioEncode_maeID_seq owned by MediaAudioEncode.maeID;

-- Grant permission to a sequence
grant usage, select on sequence MediaAudioEncode_maeID_seq to <username>;
