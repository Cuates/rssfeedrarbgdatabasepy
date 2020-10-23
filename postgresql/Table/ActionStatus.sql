-- Database Connect
\c <databasename>;

-- ==========================
--        File: actionstatus
--     Created: 09/07/2020
--     Updated: 10/23/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Action status
-- ==========================

-- Sequence Drop
drop sequence if exists actionstatus_asID_seq cascade;

-- Sequence Create
create sequence if not exists actionstatus_asID_seq;

-- Table Drop
drop table if exists actionstatus;

-- Table Create
create table if not exists actionstatus(
  asID bigint not null default nextval('actionstatus_asID_seq'),
  actionnumber int not null,
  actiondescription varchar(255) not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_actionstatus_actionnumber primary key (actionnumber)
);

-- Sequence Alter ownership
alter sequence actionstatus_asID_seq owned by actionstatus.asID;

-- Grant permission to a sequence
grant usage, select on sequence actionstatus_asID_seq to <username>;
