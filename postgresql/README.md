# PostgreSQL Function, Index, Stored Procedure, Table, and or View
> PostgreSQL database schema for this project

## Table of Contents
* [Important Note](#important-note)
* [Prerequisite Data Types](#prerequisite-data-types)
* [Prerequisite Functions](#prerequisite-functions)
* [Prerequisite Conditions](#prerequisite-conditions)
* [Stored Procedure Usage](#stored-procedure-usage)

### **Important Note**
* This project was written with PostgreSQL 13.0 methods
* Install citext

### Prerequisite Data Types
* bigint
* int
* varchar
* timestamp
* bit
* citext

### Prerequisite Functions
* trim
* regexp_replace
* substring
* nullif
* to_timestamp
* lower
* current_timestamp
* to _char
* concat
* cast
* max

### Prerequisite Conditions
* N/A

### Stored Procedure Usage
* `call insertupdatedeletebulkmediafeed ('deleteTempMovie', '', '', '', '', '');`
* `call insertupdatedeletebulkmediafeed ('deleteTempTV', '', '', '', '', '');`
* `call insertupdatedeletebulkmediafeed ('insertTempMovie', 'titleLongValue', 'titleShortValue', '2020-10-13 00:00:00');`
* `call insertupdatedeletebulkmediafeed ('insertTempTV', 'titleLongValue', 'titleShortValue', '2020-10-13 00:00:00');`
* `call insertupdatedeletebulkmediafeed ('updateBulkMovie', '', '', '', '', '');`
* `call insertupdatedeletebulkmediafeed ('updateBulkTV', '', '', '', '', '');`
* `call insertupdatedeletebulkmediafeed ('insertBulkMovie', '', '', '', '', '');`
* `call insertupdatedeletebulkmediafeed ('insertBulkTV', '', '', '', '', '');`
