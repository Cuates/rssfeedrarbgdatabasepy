-- Database Connect
\c <databasename>;

-- ==========================
--        File: ActionStatus
--     Created: 09/07/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Action status
-- ==========================

-- Sequence Drop
drop sequence if exists ActionStatus_asID_seq;

-- Sequence Create
create sequence if not exists ActionStatus_asID_seq;

-- Table Drop
drop table if exists ActionStatus;

-- Table Create
create table if not exists ActionStatus(
  asID bigint not null default nextval('ActionStatus_asID_seq'),
  actionnumber int not null,
  actiondescription varchar(255) not null,
  created_date timestamp not null default current_timestamp,
  modified_date timestamp default current_timestamp,
  constraint PK_ActionStatus_actionnumber primary key (actionnumber)
);

-- Sequence Alter ownership
alter sequence ActionStatus_asID_seq owned by ActionStatus.asID;

-- Grant permission to a sequence
grant usage, select on sequence ActionStatus_asID_seq to <username>;
