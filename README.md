# rssfeedrarbgdatabasepy
> Python [rarbg](https://rarbg.to/torrents.php) RSS Feed Parser for Movies and TVs

## Table of Contents
* [Version](#version)
* [Important Note](#important-note)
* [Prerequisite Python Modules](#prerequisite-python-modules)

### Version
* 0.0.8

### **Important Note**
* This script was written with Python 3 methods

### Prerequisite Python Modules
* List installed modules
  * `pip3.9 list`
* Module version
  * `pip3.9 show <modulename>`
* Module Outdated
  * `pip3.9 list --outdated`
* Module Upgrade
  * `pip3.9 install --upgrade <modulename>`
  * `pip3.9 install --upgrade <modulename> <modulename> <modulename>`
* MSSQL
  * `pip3.9 install pyodbc`
    * [PyODBC](https://pypi.org/project/pyodbc/)
* MySQL/MariaDB
  * `pip3.9 install mysqlclient`
    * [MySQL Client](https://pypi.org/project/mysqlclient/)
    * If "NameError: name '\_mysql' is not defined", then proceed with the following instead
      * `pip3.9 uninstall mysqlclient`
      * `pip3.9 install --no-binary mysqlclient mysqlclient`
        * Note: The first occurrence is the name of the package to apply the no-binary option to, the second specifies the package to install
* PostgreSQL
  * `pip3.9 install psycopg2-binary`
    * [Psycopg2 Binary](https://pypi.org/project/psycopg2/)
* feedparser
  * `pip3.9 install feedparser`
    * [Feed Parser](https://pypi.org/project/feedparser/)
* pytz
  * `pip3.9 install pytz`
    * [PYTZ](https://pypi.org/project/pytz/)
* tzlocal
  * `pip3.9 install tzlocal`
    * [TZLocal](https://pypi.org/project/tzlocal/)
* SQLAlchemy
  * `pip3.9 install sqlalchemy`
    * [SQLAlchemy](https://pypi.org/project/SQLAlchemy/)
* Install module in batch instead of Individual Installation
  * `pip3.9 install -r /path/to/requirements.txt`

* Upgrade module in batch instead of Individual Upgrades
  * `pip3.9 install --upgrade -r /path/to/requirements.txt`
