##
#        File: rssfeedrarbgdatabaseconfig.py
#     Created: 08/28/2020
#     Updated: 10/13/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: RSS feed Rarbg database Configuration
##

# Import modules
import re as regEx # regular expression

# Class
class RssFeedRarBgDatabaseConfig:
  # Declare protected variables
  _mainURL = None
  _categoryURL = None
  _rssLimit = None
  _rssURL = None
  _torrentSearchURL = None
  _searchEntryURL = None
  _filenameIgnore = None
  _filenameDelete = None
  _pathParent = None
  _pathLevelOne = None
  _pathLevelTwo = None
  _filenameMedia = None
  _driver = None
  _databasedialect = None
  _serverName = None
  _port = None
  _database = None
  _username = None
  _password = None
  _pathDB = None

  # Constructor
  def __init__(self):
    pass

  # Set database variable
  def _setConfigVars(self, type):
    # Define server information
    ServerInfo = 'DEV-SERVER'

    # Define list of dev words
    ServerType = ['dev']

    # Set production database information where server info does not consist of server type
    if not regEx.search(r'\b' + "|".join(ServerType) + r'\b', ServerInfo, flags=regEx.IGNORECASE):
      # Check if type is MariaDB
      if type == 'OptionInConfig':
        # Set variables
        self._driver = 'MariaDB'
        self._databasedialect = 'mysql://'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is PGSQL
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'PostgreSQL'
        self._databasedialect = 'postgresql://'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is RarBG Movie MSSQL Linux
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is MSSQL Windows
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is RarBG Movie
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = 'URL_News'
        self._rssURL = 'rssURLNews.json?'
        self._rssLimit = ''
        self._categoryURL = 'category=#'
        self._torrentSearchURL = 'searchURL?'
        self._searchEntryURL = '&search='
      # Else check if type is RarBG Television
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = 'URL_News'
        self._rssURL = 'rssURLNews.json?'
        self._rssLimit = ''
        self._categoryURL = 'category=41;49'
        self._torrentSearchURL = 'searchURL?'
        self._searchEntryURL = '&search='
      # Else check if type is log media
      elif type == 'LogMedia':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = '/path/to/log/file'
        self._pathLevelOne = '/log'
        self._pathLevelTwo = ''
        self._filenameMedia = '/logfile.log'
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else
      else:
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
    else:
      # Else set development database information
      # Check if type is MariaDB
      if type == 'OptionInConfig':
        # Set variables
        self._driver = 'MariaDB'
        self._databasedialect = 'mysql://'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is PGSQL
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'PostgreSQL'
        self._databasedialect = 'postgresql://'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is RarBG Movie MSSQL Linux
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is MSSQL Windows
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = '<IP_Address_ServerName>'
        self._port = '<Port>'
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = '<Database>'
        self._username = '<Username>'
        self._password = '<Password>'
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else check if type is RarBG Movie
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = 'URL_News'
        self._rssURL = 'rssURLNews.json?'
        self._rssLimit = ''
        self._categoryURL = 'category=#'
        self._torrentSearchURL = 'searchURL?'
        self._searchEntryURL = '&search='
      # Else check if type is RarBG Television
      elif type == 'OptionInConfig':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = 'URL_News'
        self._rssURL = 'rssURLNews.json?'
        self._rssLimit = ''
        self._categoryURL = 'category=41;49'
        self._torrentSearchURL = 'searchURL?'
        self._searchEntryURL = '&search='
      # Else check if type is log media
      elif type == 'LogMedia':
        # Set variables
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = '/path/to/log/file'
        self._pathLevelOne = '/log'
        self._pathLevelTwo = ''
        self._filenameMedia = '/logfile.log'
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''
      # Else
      else:
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._pathParent = ''
        self._pathLevelOne = ''
        self._pathLevelTwo = ''
        self._filenameMedia = ''
        self._pathDB = ''
        self._database = ''
        self._username = ''
        self._password = ''
        self._mainURL = ''
        self._rssURL = ''
        self._rssLimit = ''
        self._categoryURL = ''
        self._torrentSearchURL = ''
        self._searchEntryURL = ''

  # Get database variable
  def _getConfigVars(self):
    return {'Driver': self._driver, 'DatabaseDialect': self._databasedialect, 'Servername': self._servername, 'Port': self._port, 'PathParent': self._pathParent, 'PathLevelOne': self._pathLevelOne, 'PathLevelTwo': self._pathLevelTwo, 'PathDB': self._pathDB, 'Database': self._database, 'Username': self._username, 'Password': self._password, 'MainURL': self._mainURL, 'RssURL': self._rssURL, 'RssLimit': self._rssLimit, 'CategoryURL': self._categoryURL, 'TorrentSearchURL': self._torrentSearchURL, 'SearchEntryURL': self._searchEntryURL, 'FilenameMedia': self._filenameMedia}

  # Set filename variable
  def _setFilenameVars(self, feedAction):
    # Check if media action type is log
    if regEx.search(r'\bLog\b', feedAction, flags=regEx.IGNORECASE):
      self._pathParent = '/path/to/log/file'
      self._pathLevelOne = '/log'
      self._pathLevelTwo = ''
      self._filenameMedia = '/path/to/default/log_file.log'
    else:
      self._pathParent = ''
      self._pathLevelOne = ''
      self._pathLevelTwo = ''
      self._filenameMedia = ''

  # Get filename variable
  def _getFilenameVars(self):
    return {'pathParent': self._pathParent, 'pathLevelOne': self._pathLevelOne, 'pathLevelTwo': self._pathLevelTwo, 'filenameMedia': self._filenameMedia}