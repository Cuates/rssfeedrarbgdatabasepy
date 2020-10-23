-- Database Connect
\c <databasename>;

-- ================================
--        File: mediadynamicrange
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media dynamic range
-- ================================

-- Sequence Drop
drop sequence if exists mediadynamicrange_mdrID_seq;

-- Sequence Create
create sequence if not exists mediadynamicrange_mdrID_seq;

-- Drop Table
drop table if exists mediaaudioencode;

-- Table Create
create table if not exists mediadynamicrange(
  mdrID bigint not null default nextval('mediadynamicrange_mdrID_seq'),
  dynamicrange citext not null,
  movieInclude smallint not null default 0,
  tvInclude smallint not null default 0,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_mediadynamicrange_dynamicrange primary key (dynamicrange)
);

-- Sequence Alter ownership
alter sequence mediadynamicrange_mdrID_seq owned by mediadynamicrange.mdrID;

-- Grant permission to a sequence
grant usage, select on sequence mediadynamicrange_mdrID_seq to <username>;
