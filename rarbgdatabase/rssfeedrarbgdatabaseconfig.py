##
#        File: rssfeedrarbgdatabaseconfig.py
#     Created: 08/28/2020
#     Updated: 09/04/2020
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
            # Check if type is SQLite
            if type == '<SQLite_Type>':
                # Set variables
                self._driver = 'sqlite:///'
                self._servername = ''
                self._port = ''
                self._pathParent = './resource'
                self._pathLevelOne = '/database'
                self._pathLevelTwo = ''
                #self._pathDB = '/mediaRSSFeed.sqlite3'
                self._pathDB = '/medialisttest.sqlite3'
                self._database = self._pathParent  + self._pathLevelOne + self._pathLevelTwo + self._pathDB
                self._username = ''
                self._password = ''
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is MySQL
            elif type == '<MySQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is PGSQL
            elif type == '<PGSQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is MSSQL
            elif type == '<MSSQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is RarBG Movie
            elif type == '<Rarb_Movie_Type>':
                # Set variables
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = '<rarbg_main_url>'
                self._rssURL = '<rss_url>?'
                self._categoryURL = 'category=<##;##>'
                self._torrentSearchURL = '<torrent_search_url>?'
                self._searchEntryURL = '&search='
            # Else check if type is RarBG Television
            elif type == '<Rarb_TV_Type>':
                # Set variables
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = '<rarbg_main_url>'
                self._rssURL = '<rss_url>?'
                self._categoryURL = 'category=<##;##>'
                self._torrentSearchURL = '<torrent_search_url>?'
                self._searchEntryURL = '&search='
            # Else
            else:
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
        else:
            # Else set development database information
            # Check if type is SQLite
            if type == '<SQLite_Type>':
                # Set variables
                self._driver = 'sqlite:///'
                self._servername = ''
                self._port = ''
                self._pathParent = './resource'
                self._pathLevelOne = '/database'
                self._pathLevelTwo = ''
                #self._pathDB = '/mediaRSSFeed.sqlite3'
                self._pathDB = '/medialisttest.sqlite3'
                self._database = self._driver + self._pathParent  + self._pathLevelOne + self._pathLevelTwo + self._pathDB
                self._username = ''
                self._password = ''
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is MySQL
            elif type == '<MySQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is PGSQL
            elif type == '<PGSQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is MSSQL
            elif type == '<MSSQL_Type>':
                # Set variables
                self._driver = '<driver_name>'
                self._servername = '<server_name_or_ip_address>'
                self._port = '<port>'
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = '<database_name>'
                self._username = '<user_name>'
                self._password = '<password>'
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''
            # Else check if type is RarBG Movie
            elif type == '<Rarb_Movie_Type>':
                # Set variables
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = '<rarbg_main_url>'
                self._rssURL = '<rss_url>?'
                self._categoryURL = 'category=<##;##>'
                self._torrentSearchURL = '<torrent_search_url>?'
                self._searchEntryURL = '&search='
            # Else check if type is RarBG Television
            elif type == '<Rarb_TV_Type>':
                # Set variables
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = '<rarbg_main_url>'
                self._rssURL = '<rss_url>?'
                self._categoryURL = 'category=<##;##>'
                self._torrentSearchURL = '<torrent_search_url>?'
                self._searchEntryURL = '&search='
            # Else
            else:
                self._driver = ''
                self._servername = ''
                self._port = ''
                self._pathParent = ''
                self._pathLevelOne = ''
                self._pathLevelTwo = ''
                self._pathDB = ''
                self._database = ''
                self._username = ''
                self._password = ''
                self._mainURL = ''
                self._rssURL = ''
                self._categoryURL = ''
                self._torrentSearchURL = ''
                self._searchEntryURL = ''

    # Get database variable
    def _getConfigVars(self):
        return {'Driver': self._driver, 'Servername': self._servername, 'Port': self._port, 'PathParent': self._pathParent, 'PathLevelOne': self._pathLevelOne, 'PathLevelTwo': self._pathLevelTwo, 'PathDB': self._pathDB, 'Database': self._database, 'Username': self._username, 'Password': self._password, 'MainURL': self._mainURL, 'RssURL': self._rssURL, 'CategoryURL': self._categoryURL, 'TorrentSearchURL': self._torrentSearchURL, 'SearchEntryURL': self._searchEntryURL}