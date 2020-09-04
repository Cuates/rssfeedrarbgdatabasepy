##
#        File: rssfeedrarbgdatabaseclass.py
#     Created: 08/28/2020
#     Updated: 09/04/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: RSS feed Rarbg database Class
##

# Import modules
import rssfeedrarbgdatabaseconfig # rss feed rarbg database config
#import tkinter # tkinter
import feedparser # feed parser
#import webbrowser # web browser
#import pathlib # path
import re as regEx # regular expression
#import requests # requests
#import bs4 # beautiful soup
import logging # logging
import logging.config # logging configuration
import json # json
#import sys # system
import datetime # datetime
import pytz # pytz
import tzlocal # tz local
import sqlalchemy # sqlalchemy
from sqlalchemy import event # sqlalchemy event
#import pythonjsonlogger # python json logger
#import sqlite3 # sqlite3
import urllib # urllib

# Class
class RssFeedRarBgDatabaseClass:
    # Constructor
    def __init__(self):
        pass

    # extract url
    def extractrssfeed(self, mediatype):
        # initialize variable
        feedlist = []

        # try to execute the command(s)
        try:
            # create object of rss feed parser rarbg config
            rfrbgdbconfig = rssfeedrarbgdatabaseconfig.RssFeedRarBgDatabaseConfig()

            # set variables based on type
            rfrbgdbconfig._setConfigVars(mediatype)

            # get dictionary of values
            dictmediatype = rfrbgdbconfig._getConfigVars()

            # set file name
            urlstring = dictmediatype['MainURL'] + dictmediatype['RssURL'] + dictmediatype['CategoryURL']

            # Pull rss feed from given url
            feedlist = feedparser.parse(urlstring)
        except Exception as e:
            ## log string
            ##self._setlogger('issue extract rss feed ' + mediatype + ' ' + str(e))
            print(str(e))

        # return built url string
        return feedlist

    # Delete temp movie media
    def _deleteTempMovieMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue deleting temp movie media : ' + str(e))
            print('Delete Temp Movie Media: ' + str(e))

    # Insert temp movie media
    def _insertTempMovieMedia(self, feedStorage):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = :parameterValue")

            # Bind parameters with dictionary key
            query = query.bindparams(
                sqlalchemy.bindparam("parameterValue")
            )

            # Execute many queries
            messageResponse = self.connection.execute(query, feedStorage)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue inserting temp movie media : ' + str(e))
            print(str(e))

    # Update bulk movie media
    def _updateBulkMovieMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue bulk updating movie media : ' + str(e))
            print(str(e))

    # Insert bulk movie media
    def _insertBulkMovieMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue bulk inserting movie media : ' + str(e))
            print(str(e))

    # Delete temp tv media
    def _deleteTempTVMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue deleting temp tv media : ' + str(e))
            print(str(e))

    # Insert temp tv media
    def _insertTempTVMedia(self, feedStorage):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = :parameterValue")

            # Bind parameters with dictionary key
            query = query.bindparams(
                sqlalchemy.bindparam("parameterValue")
            )

            # Execute many queries
            messageResponse = self.connection.execute(query, feedStorage)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue inserting temp tv media : ' + str(e))
            print(str(e))

    # Update bulk tv media
    def _updateBulkTVMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue bulk updating tv media : ' + str(e))
            print(str(e))

    # Insert bulk tv media
    def _insertBulkTVMedia(self):
        try:
            # Open connection
            self.__openConnection('<MSSQL_Type>')

            # Convert statement to text
            query = sqlalchemy.text("<Stored_Procedure> @parameter = parameterValue")

            ## Bind parameters with dictionary key
            #query = query.bindparams(
            #)

            # Execute many queries
            messageResponse = self.connection.execute(query)

            # Fetch a record
            fetchRecord = messageResponse.fetchone()

            ## Print message from database
            #print('Fetch record response: ' + str(fetchRecord))

            # Close database connection
            self.connection.close()
        except Exception as e:
            ## Log string
            #self._setLogger('Issue bulk inserting tv media : ' + str(e))
            print(str(e))

    # Open connection based on type
    def __openConnection(self, type = 'notype'):
        # Create empty dictionary
        returnDict = {}

        # Try to execute the command(s)
        try:
            # Create object of configuration script
            hrfrbgdbconfig = rssfeedrarbgdatabaseconfig.RssFeedRarBgDatabaseConfig()

            # Set variables based on type
            hrfrbgdbconfig._setConfigVars(type)

            # Create empty dictionary
            conVars = {}

            # Get dictionary of values
            conVars = hrfrbgdbconfig._getConfigVars()

            # Set credentials from dictionary
            self.Driver = conVars['Driver']
            self.Server = conVars['Servername']
            self.Port = conVars['Port']
            self.PathParent = conVars['PathParent']
            self.PathLevelOne = conVars['PathLevelOne']
            self.PathLevelTwo = conVars['PathLevelTwo']
            self.PathDB = conVars['PathDB']
            self.Database = conVars['Database']
            self.User = conVars['Username']
            self.Pass = conVars['Password']
            self.MainURL = conVars['MainURL']
            self.RssURL = conVars['RssURL']
            self.CategoryURL = conVars['CategoryURL']
            self.TorrentSearchURL = conVars['TorrentSearchURL']
            self.SearchEntryURL = conVars['SearchEntryURL']

            # Check if string is SQLite
            if regEx.match(r'<SQLite_Type>[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                ## Set variable with string
                #print('sqlite:dbname=' + self.Database)

                ## Set engine
                self.engine = sqlalchemy.create_engine(self.Database)
                #self.engine = sqlalchemy.create_engine(self.Database, echo=True) # for debugging purposes only

                # Connect to engine
                self.connection = self.engine.connect

            # Else check if database type is MySQL or the alternative MariaDB
            elif regEx.match(r'<MySQL_Type>[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                ## Set variable with string
                #print('mysql:host=' + self.Server + ';port=' + self.Port + ';dbname=' + self.Database, self.User, self.Pass)

                # Set engine
                # dialect+driver://username:password@host:port/database
                self.engine = sqlalchemy.create_engine('mysql://' + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database + '?autocommit=true')

                # Connect to engine
                self.connection = self.engine.connect()

                # Set meta data based on engine
                metadata = sqlalchemy.MetaData(self.engine)

                ## Debugging purposes only
                #print ('Driver: ' + self.Driver + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')

                ####
                ## Close database connection
                #self.connection.close()
                ####

            # Else check if database type is PGSQL
            elif regEx.match(r'<PGSQL_Type>[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                ## Check else if database type is PostgreSQL
                #print('pgsql:host=' + self.Server + '; port=' + self.Port + '; dbname=' + self.Database + '; user=' + self.User + '; password=' + self.Pass + ';')

                # Set engine
                # dialect+driver://username:password@host:port/database
                self.engine = sqlalchemy.create_engine('postgresql://' + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database + '?autocommit=true')

                # Connect to engine
                self.connection = self.engine.connect()

                # Set meta data based on engine
                metadata = sqlalchemy.MetaData(self.engine)

                ## Debugging purposes only
                #print ('Driver: ' + self.Driver + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')

                ####
                ## Close database connection
                #self.connection.close()
                ####

            # Else check if databaswe type is FreeTDS
            elif regEx.match(r'<MSSQL_Type>[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                ## Check if database type is Microsoft
                #print('odbc:Driver=' + self.Driver + '; Servername=' + self.Server + '; Port=' + self.Port + '; Database=' + self.Database + '; UID=' + self.User + '; PWD=' + self.Pass + ';')

                # Set engine
                # dialect+driver://username:password@host:port/database
                params = urllib.parse.quote_plus('DRIVER={' + self.Driver + '};SERVER=' + self.Server + ';DATABASE=' + self.Database + ';UID=' + self.User + ';PWD=' + self.Pass + ';TDS_Version=8.0;Port=' + self.Port + ';')

                self.engine = sqlalchemy.create_engine('mssql+pyodbc:///?odbc_connect={}&autocommit=true'.format(params))
                #self.engine = sqlalchemy.create_engine('mssql+pyodbc:///?odbc_connect={}&autocommit=true'.format(params), echo=True) # for debugging purposes only

                # Connect to engine
                self.connection = self.engine.connect()

                # Set meta data based on engine
                metadata = sqlalchemy.MetaData(self.engine)

                ## Debugging purposes only
                #print ('Driver: ' + self.Driver + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')
            else:
                # Set server error
                returnDict['SError'] = 'Cannot connect to the database'

        # Set error message
        except Exception as e:
            # Set execption error
            returnDict['SError'] = 'Caught - cannot connect to the database - ' + str(e)

            ## Log string
            #self._setLogger('SError~Caught - cannot connect to the database - ' + str(e))
            print(str(e))

        return returnDict