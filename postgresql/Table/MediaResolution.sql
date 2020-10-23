-- Database Connect
\c <databasename>;

-- =============================
--        File: mediaresolution
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media resolution
-- =============================

-- Sequence Drop
drop sequence if exists mediaresolution_mrID_seq cascade;

-- Sequence Create
create sequence if not exists mediaresolution_mrID_seq;

-- Drop Table
drop table if exists mediaresolution;

-- Table Create
create table if not exists mediaresolution(
  mrID bigint not null default nextval('mediaresolution_mrID_seq'),
  resolution citext not null,
  movieInclude smallint not null default 0,
  tvInclude smallint not null default 0,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_mediaresolution_resolution primary key (resolution)
);

-- Sequence Alter ownership
alter sequence mediaresolution_mrID_seq owned by mediaresolution.mrID;

-- Grant permission to a sequence
grant usage, select on sequence mediaresolution_mrID_seq to <username>;
