# MSSQL Function, Index, Stored Procedure, Table, and or View
> MSSQL database schema for this project

## Table of Contents
* [Important Note](#important-note)
* [Dependent MSSQL Function](#dependent-mssql-function)
* [Prerequisite Data Types](#prerequisite-data-types)
* [Prerequisite Functions](#prerequisite-functions)
* [Prerequisite Conditions](#prerequisite-conditions)
* [Stored Procedure Usage](#stored-procedure-usage)

### **Important Note**
* This project was written with SQL Server 2019 methods

### Dependent MSSQL Function
* [Omit Characters](https://github.com/Cuates/omitcharactersmssql)

### Prerequisite Data Types
* bigint
* int
* nvarchar
* datetime2
* bit

### Prerequisite Functions
* substring
* nullif
* try_cast
* error_number
* error_line
* error_message
* lower
* iif
* datepart
* cast
* dateadd
* trim
* max
* concat

### Prerequisite Conditions
* not in

### Stored Procedure Usage
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'deleteTempMovie'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'deleteTempTV'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'insertTempMovie', @titleLong = 'titleLongValue', @titleShort = 'titleShortValue', @publishDate = '2020-10-13 00:00:00'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'insertTempTV', @titleLong = 'titleLongValue', @titleShort = 'titleShortValue', @publishDate = '2020-10-13 00:00:00'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'updateBulkMovie'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'updateBulkTV'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'insertBulkMovie'`
* `exec dbo.insertupdatedeleteBulkMediaFeed @optionMode = 'insertBulkTV'`
