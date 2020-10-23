-- Database Connect
\c <databasename>;

-- ===============================
--        File: mediavideoencode
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media video encode
-- ===============================

-- Sequence Drop
drop sequence if exists mediavideoencode_mveID_seq;

-- Sequence Create
create sequence if not exists mediavideoencode_mveID_seq;

-- Table Drop
drop table if exists mediavideoencode;

-- Table Create
create table if not exists mediavideoencode(
  mveID bigint not null default nextval('mediavideoencode_mveID_seq'),
  videoencode citext not null,
  movieInclude smallint not null default 0,
  tvInclude smallint not null default 0,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_mediavideoencode_videoencode primary key (videoencode)
);

-- Sequence Alter ownership
alter sequence mediavideoencode_mveID_seq owned by mediavideoencode.mveID;

-- Grant permission to a sequence
grant usage, select on sequence mediavideoencode_mveID_seq to <username>;
