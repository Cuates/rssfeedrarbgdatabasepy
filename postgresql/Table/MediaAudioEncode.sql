-- Database Connect
\c <databasename>;

-- ===============================
--        File: mediaaudioencode
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media audio encode
-- ===============================

-- Sequence Drop
drop sequence if exists mediaaudioencode_maeID_seq cascade;

-- Sequence Create
create sequence if not exists mediaaudioencode_maeID_seq;

-- Table Drop
drop table if exists mediaaudioencode;

-- Table Create
create table if not exists mediaaudioencode(
  maeID bigint not null default nextval('mediaaudioencode_maeID_seq'),
  audioencode citext not null,
  movieInclude smallint not null default 0,
  tvInclude smallint not null default 0,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint pk_mediaaudioencode_audioencode primary key (audioencode)
);

-- Sequence Alter ownership
alter sequence mediaaudioencode_maeID_seq owned by mediaaudioencode.maeID;

-- Grant permission to a sequence
grant usage, select on sequence mediaaudioencode_maeID_seq to <username>;
