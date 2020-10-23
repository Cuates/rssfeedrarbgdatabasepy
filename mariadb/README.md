# MariaDB SQL Function, Index, Stored Procedure, Table, and or View
> MariaDB SQL database schema for this project

## Table of Contents
* [Important Note](#important-note)
* [Prerequisite Data Types](#prerequisite-data-types)
* [Prerequisite Functions](#prerequisite-functions)
* [Prerequisite Conditions](#prerequisite-conditions)
* [Stored Procedure Usage](#stored-procedure-usage)

### **Important Note**
* This project was written with MariaDB 10.5.6 methods
* Configure utf8mb4 charset

### Prerequisite Data Types
* bigint
* int
* nvarchar
* datetime2
* bit
* text

### Prerequisite Functions
* trim
* regexp_replace
* substring
* nullif
* str_to_date
* lower
* current_timestamp
* date_format
* date_add
* concat
* cast
* max
* if

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
