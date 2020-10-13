##
#        File: rssfeedrarbgdatabase.py
#     Created: 08/28/2020
#     Updated: 10/13/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: Retrieve RSS feed from RarBg site
#     Version: 0.0.8 Python3
##

# Import modules
import rssfeedrarbgdatabaseclass # rss feed rarbg class

# Set object
rfrbdbclass = rssfeedrarbgdatabaseclass.RssFeedRarBgDatabaseClass()

# Program entry point
def main():
  # Try to execute the command(s)
  try:
    # Check if modules are installed
    import feedparser, re, logging, json, datetime, pytz, tzlocal, sqlalchemy, urllib, pathlib, csv, os, traceback

    # Declare dictionary list
    feedInfo = []
    feedStorage = []
    feedStorageNested = {}

    # Retrieve movie data from web site
    feedInfo = rfrbdbclass.extractrssfeed('OptionInConfig')
    # print(feedInfo)

    # Check if list is not empty
    if feedInfo:
      # Loop through data feed information
      for feedEntry in feedInfo.entries:
        # Initialize variable
        rssFeedTitle = ''
        rssFeedTitleShort = ''
        rssFeedPublishDateUTCTimeStamp = ''
        rssFeedPublishDateLocalTimeStamp = ''
        local_tz = ''

        # Store title
        rssFeedTitle = feedEntry.title

        # Check if pattern is found to input into the database
        # r is to escape any back slashes within the regular expression string
        if re.search(r'\.[0-9]{4}\.', rssFeedTitle, re.IGNORECASE):
          # Initialize variable
          titleArray = []

          # Split string based on regular express
          titleArray = re.split(r'(\.[0-9]{4}\.)', rssFeedTitle, flags=re.IGNORECASE)

          # Retrieve last element from list
          lastElement = titleArray[-1]

          # Remove last element from list
          titleArray = titleArray[:-1]

          # Retrieve left most five characters
          firstFiveChars = lastElement[:5]

          # Check if string matches the regular expression
          if re.search(r'^[0-9]{4}\.', firstFiveChars, flags=re.IGNORECASE):
            # Append string to the list
            titleArray.append(firstFiveChars)

          # Convert elements in the list to a string
          rssFeedTitleShort = ''.join(titleArray)

          # Set title short
          rssFeedTitleShort = rssFeedTitleShort[:-1]

          # Set publish date
          rssFeedPublishDateUTCTimeStamp = feedEntry.published

          # Set local time zone
          local_tz = tzlocal.get_localzone()

          # Set UTC date time to local date time
          rssFeedPublishDateLocalTimeStamp = str(datetime.datetime.strptime(rssFeedPublishDateUTCTimeStamp, '%a, %d %b %Y %H:%M:%S %z').astimezone(pytz.timezone(str(local_tz))).strftime('%Y-%m-%d %H:%M:%S'))

          # Set dictionary list with values
          feedStorage.append({'Param01': rssFeedTitle, 'Param02': rssFeedTitleShort, 'Param03': rssFeedPublishDateLocalTimeStamp})

      # Check if there are any values to process
      if feedStorage:
        # MSSQL BEGIN
        # Set header row for CSV file
        movieHeaderColumn = ['Param01', 'Param02', 'Param03']

        # Write data to a CSV file
        writeCSVFileResp = rfrbdbclass._writeToCSVFile('/path/to/share/drive/Outbound.csv', movieHeaderColumn, feedStorage)
        # print (writeCSVFileResp)

        # Get current time stamp
        dateTimeObj = datetime.datetime.now()

        # Convert date time to string
        timestampStr = dateTimeObj.strftime('%Y-%m-%d %H:%M:%S.%f')

        # Restructure JSON output
        feedStorageNested = {'movie': {'created_date': timestampStr, 'count': len(feedStorage), 'children': feedStorage}}

        # Write data to a JSON file
        writeJSONFileResp = rfrbdbclass._writeToJSONFile('/path/to/share/drive/Outbound.json', feedStorageNested)
        # print (writeJSONFileResp)

        # Delete temp movie media only if there are records
        deleteFreeTDSWMovie = rfrbdbclass._deleteTempMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSWMovie = re.split(r'~', deleteFreeTDSWMovie)

          # # Check if SError is returned
          # if splitDeleteFreeTDSWMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete MSSQLWRarBG ' + splitDeleteFreeTDSWMovie[1])
            # # print(str(feedInfo))

        # Delete temp movie media only if there are records
        deleteFreeTDSLMovie = rfrbdbclass._deleteTempMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSLMovie = re.split(r'~', deleteFreeTDSLMovie)

          # # Check if SError is returned
          # if splitDeleteFreeTDSLMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete MSSQLLRarBG ' + splitDeleteFreeTDSLMovie[1])
            # # print(str(feedInfo))

        # Insert movie media into temp table
        insertFreeTDSWMovie = rfrbdbclass._insertTempMovieMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSWMovie = re.split(r'~', insertFreeTDSWMovie)

          # # Check if SError is returned
          # if splitInsertFreeTDSWMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert MSSQLWRarBG ' + splitInsertFreeTDSWMovie[1])
            # # print(str(feedInfo))

        # Insert movie media into temp table
        insertFreeTDSLMovie = rfrbdbclass._insertTempMovieMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSLMovie = re.split(r'~', insertFreeTDSLMovie)

          # # Check if SError is returned
          # if splitInsertFreeTDSLMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert MSSQLLRarBG ' + splitInsertFreeTDSLMovie[1])
            # # print(str(feedInfo))

        # Bulk update movie media
        updateBulkFreeTDSWMovie = rfrbdbclass._updateBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSWMovie = re.split(r'~', updateBulkFreeTDSWMovie)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSWMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk MSSQLWRarBG ' + splitUpdateBulkFreeTDSWMovie[1])
          # # print(str(feedInfo))

        # Bulk update movie media
        updateBulkFreeTDSLMovie = rfrbdbclass._updateBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSLMovie = re.split(r'~', updateBulkFreeTDSLMovie)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSLMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk MSSQLLRarBG ' + splitUpdateBulkFreeTDSLMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie media
        insertBulkFreeTDSWMovie = rfrbdbclass._insertBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSWMovie = re.split(r'~', insertBulkFreeTDSWMovie)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSWMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk MSSQLWRarBG ' + splitInsertBulkFreeTDSWMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie media
        insertBulkFreeTDSLMovie = rfrbdbclass._insertBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSLMovie = re.split(r'~', insertBulkFreeTDSLMovie)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSLMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk MSSQLLRarBG ' + splitInsertBulkFreeTDSLMovie[1])
          # # print(str(feedInfo))
        # MSSQL END
        # MySQL BEGIN
        # Delete temp movie only if there are records
        deleteMySQLMovie = rfrbdbclass._deleteTempMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitDeleteMySQLMovie = re.split(r'~', deleteMySQLMovie)

        # # Check if SError is returned
        # if splitDeleteMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete MariaDBSQLRarBG ' + splitDeleteMySQLMovie[1])
          # # print(str(feedInfo))

        # Insert movie into temp table
        insertMySQLMovie = rfrbdbclass._insertTempMovieMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
        # splitInsertMySQLMovie = re.split(r'~', insertMySQLMovie)

        # # Check if SError is returned
        # if splitInsertMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert MariaDBSQLRarBG ' + splitInsertMySQLMovie[1])
          # # print(str(feedInfo))

        # Bulk update movie
        updateBulkMySQLMovie = rfrbdbclass._updateBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkMySQLMovie = re.split(r'~', updateBulkMySQLMovie)

        # # Check if SError is returned
        # if splitUpdateBulkMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk MariaDBSQLRarBG ' + splitUpdateBulkMySQLMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie
        insertBulkMySQLMovie = rfrbdbclass._insertBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkMySQLMovie = re.split(r'~', insertBulkMySQLMovie)

        # # Check if SError is returned
        # if splitInsertBulkMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk MariaDBSQLRarBG ' + splitInsertBulkMySQLMovie[1])
          # # print(str(feedInfo))
        # MySQL END
        # PostgreSQL BEGIN
        # Delete temp movie only if there are records
        deletePostgreSQLMovie = rfrbdbclass._deleteTempMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitDeletePostgreSQLMovie = re.split(r'~', deletePostgreSQLMovie)

        # # Check if SError is returned
        # if splitDeletePostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete PGSQLRarBG ' + splitDeletePostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Insert movie into temp table
        insertPostgreSQLMovie = rfrbdbclass._insertTempMovieMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
        # splitInsertPostgreSQLMovie = re.split(r'~', insertPostgreSQLMovie)

        # # Check if SError is returned
        # if splitInsertPostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert PGSQLRarBG ' + splitInsertPostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Bulk update movie
        updateBulkPostgreSQLMovie = rfrbdbclass._updateBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkPostgreSQLMovie = re.split(r'~', updateBulkPostgreSQLMovie)

        # # Check if SError is returned
        # if splitUpdateBulkPostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk PGSQLRarBG ' + splitUpdateBulkPostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie
        insertBulkPostgreSQLMovie = rfrbdbclass._insertBulkMovieMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkPostgreSQLMovie = re.split(r'~', insertBulkPostgreSQLMovie)

        # # Check if SError is returned
        # if splitInsertBulkPostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk PGSQLRarBG ' + splitInsertBulkPostgreSQLMovie[1])
          # # print(str(feedInfo))
        # PostgreSQL END
    else:
      # Log string
      rfrbdbclass._setLogger('Error retrieveing movie feed data ' + str(feedInfo))
      # print(str(feedInfo))

    # Set dictionary list
    feedInfo = []
    feedStorage = []
    feedStorageNested = {}

    # Retrieve tv data from web site
    feedInfo = rfrbdbclass.extractrssfeed('OptionInConfig')

    # Check if list is not empty
    if feedInfo:
      # Loop through data feed information
      for feedEntry in feedInfo.entries:
        # Initialize variable
        rssFeedTitle = ''
        rssFeedTitleShort = ''
        rssFeedPublishDateUTCTimeStamp = ''
        rssFeedPublishDateLocalTimeStamp = ''
        local_tz = ''

        # Store title
        rssFeedTitle = feedEntry.title

        # Check if pattern is found to input into the database
        # r is to escape any back slashes within the regular expression string
        if re.search(r'\.s[0-9]{2,3}|\.[0-9]{4}\.[0-9]{2}\.[0-9]{2}\.', rssFeedTitle, re.IGNORECASE):
          # Initialize variable
          titleArray = []

          # Split string based on regular express
          titleArray = re.split(r'\.s[0-9]{2,3}|\.[0-9]{4}\.[0-9]{2}\.[0-9]{2}\.', rssFeedTitle, flags=re.IGNORECASE)

          # Set title
          rssFeedTitleShort = titleArray[0]

          # Set publish date
          rssFeedPublishDateUTCTimeStamp = feedEntry.published

          # Set local time zone
          local_tz = tzlocal.get_localzone()

          # Set UTC date time to local date time
          rssFeedPublishDateLocalTimeStamp = str(datetime.datetime.strptime(rssFeedPublishDateUTCTimeStamp, '%a, %d %b %Y %H:%M:%S %z').astimezone(pytz.timezone(str(local_tz))).strftime('%Y-%m-%d %H:%M:%S'))

          # Set dictionary list with values
          feedStorage.append({'Param01': rssFeedTitle, 'Param02': rssFeedTitleShort, 'Param03': rssFeedPublishDateLocalTimeStamp})

      # Check if there are any values to process
      if feedStorage:
        # MSSQL BEGIN
        # Set header row for CSV file
        tvHeaderColumn = ['Param01', 'Param02', 'Param03']

        # Write data to a CSV file
        writeCSVFileResp = rfrbdbclass._writeToCSVFile('/path/to/share/drive/Outbound.csv', tvHeaderColumn, feedStorage)
        # print (writeCSVFileResp)

        # Get current time stamp
        dateTimeObj = datetime.datetime.now()

        # Convert date time to string
        timestampStr = dateTimeObj.strftime('%Y-%m-%d %H:%M:%S.%f')

        # Restructure JSON output
        feedStorageNested = {'tv': {'created_date': timestampStr, 'count': len(feedStorage), 'children': feedStorage}}

        # Write data to a JSON file
        writeJSONFileResp = rfrbdbclass._writeToJSONFile('/path/to/share/drive/Outbound.json', feedStorageNested)
        # print (writeJSONFileResp)

        # Delete temp tv media only if there are records
        deleteFreeTDSWTV = rfrbdbclass._deleteTempTVMedia('OptionInConfig')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSWTV = re.split(r'~', deleteFreeTDSWTV)

          # # Check if SError is returned
          # if splitDeleteFreeTDSWTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete MSSQLWRarBG ' + splitDeleteFreeTDSWTV[1])
            # # print(str(feedInfo))

        # Delete temp tv media only if there are records
        deleteFreeTDSLTV = rfrbdbclass._deleteTempTVMedia('OptionInConfig')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSLTV = re.split(r'~', deleteFreeTDSLTV)

          # # Check if SError is returned
          # if splitDeleteFreeTDSLTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete MSSQLLRarBG ' + splitDeleteFreeTDSLTV[1])
            # # print(str(feedInfo))

        # Insert tv media into temp table
        insertFreeTDSWTV = rfrbdbclass._insertTempTVMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSWTV = re.split(r'~', insertFreeTDSWTV)

          # # Check if SError is returned
          # if splitInsertFreeTDSWTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert MSSQLWRarBG ' + splitInsertFreeTDSWTV[1])
            # # print(str(feedInfo))

        # Insert tv media into temp table
        insertFreeTDSLTV = rfrbdbclass._insertTempTVMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSLTV = re.split(r'~', insertFreeTDSLTV)

          # # Check if SError is returned
          # if splitInsertFreeTDSLTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert MSSQLLRarBG ' + splitInsertFreeTDSLTV[1])
            # # print(str(feedInfo))

        # Bulk update tv media
        updateBulkFreeTDSWTV = rfrbdbclass._updateBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSWTV = re.split(r'~', updateBulkFreeTDSWTV)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSWTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk MSSQLWRarBG ' + splitUpdateBulkFreeTDSWTV[1])
          # # print(str(feedInfo))

        # Bulk update tv media
        updateBulkFreeTDSLTV = rfrbdbclass._updateBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSLTV = re.split(r'~', updateBulkFreeTDSLTV)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSLTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk MSSQLLRarBG ' + splitUpdateBulkFreeTDSLTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv media
        insertBulkFreeTDSWTV = rfrbdbclass._insertBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSWTV = re.split(r'~', insertBulkFreeTDSWTV)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSWTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk MSSQLWRarBG ' + splitInsertBulkFreeTDSWTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv media
        insertBulkFreeTDSLTV = rfrbdbclass._insertBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSLTV = re.split(r'~', insertBulkFreeTDSLTV)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSLTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk MSSQLLRarBG ' + splitInsertBulkFreeTDSLTV[1])
          # # print(str(feedInfo))
        # MSSQL END
        # MySQL BEGIN
        # Delete temp tv only if there are records
        deleteMySQLTV = rfrbdbclass._deleteTempTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitDeleteMySQLTV = re.split(r'~', deleteMySQLTV)

        # # Check if SError is returned
        # if splitDeleteMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete MariaDBSQLRarBG ' + splitDeleteMySQLTV[1])
          # # print(str(feedInfo))

        # Insert tv into temp table
        insertMySQLTV = rfrbdbclass._insertTempTVMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
        # splitInsertMySQLTV = re.split(r'~', insertMySQLTV)

        # # Check if SError is returned
        # if splitInsertMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert MariaDBSQLRarBG ' + splitInsertMySQLTV[1])
          # # print(str(feedInfo))

        # Bulk update tv
        updateBulkMySQLTV = rfrbdbclass._updateBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkMySQLTV = re.split(r'~', updateBulkMySQLTV)

        # # Check if SError is returned
        # if splitUpdateBulkMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk MariaDBSQLRarBG ' + splitUpdateBulkMySQLTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv
        insertBulkMySQLTV = rfrbdbclass._insertBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkMySQLTV = re.split(r'~', insertBulkMySQLTV)

        # # Check if SError is returned
        # if splitInsertBulkMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk MariaDBSQLRarBG ' + splitInsertBulkMySQLTV[1])
          # # print(str(feedInfo))
        # MySQL END
        # PostgreSQL BEGIN
        # Delete temp tv only if there are records
        deletePostgreSQLTV = rfrbdbclass._deleteTempTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitDeletePostgreSQLTV = re.split(r'~', deletePostgreSQLTV)

        # # Check if SError is returned
        # if splitDeletePostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete PGSQLRarBG ' + splitDeletePostgreSQLTV[1])
          # # print(str(feedInfo))

        # Insert tv into temp table
        insertPostgreSQLTV = rfrbdbclass._insertTempTVMedia('OptionInConfig', feedStorage)

        # # Split at the tilde (~)
        # splitInsertPostgreSQLTV = re.split(r'~', insertPostgreSQLTV)

        # # Check if SError is returned
        # if splitInsertPostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert PGSQLRarBG ' + splitInsertPostgreSQLTV[1])
          # # print(str(feedInfo))

        # Bulk update tv
        updateBulkPostgreSQLTV = rfrbdbclass._updateBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitUpdateBulkPostgreSQLTV = re.split(r'~', updateBulkPostgreSQLTV)

        # # Check if SError is returned
        # if splitUpdateBulkPostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk PGSQLRarBG ' + splitUpdateBulkPostgreSQLTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv
        insertBulkPostgreSQLTV = rfrbdbclass._insertBulkTVMedia('OptionInConfig')

        # # Split at the tilde (~)
        # splitInsertBulkPostgreSQLTV = re.split(r'~', insertBulkPostgreSQLTV)

        # # Check if SError is returned
        # if splitInsertBulkPostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk PGSQLRarBG ' + splitInsertBulkPostgreSQLTV[1])
          # # print(str(feedInfo))
        # PostgreSQL END
    else:
      # Log string
      rfrbdbclass._setLogger('Error retrieveing tv feed data ' + str(feedInfo))
      # print(str(feedInfo))
  except Exception as e:
    # # Log string
    # logException = 'Issue with loop'

    # Log string
    rfrbdbclass._setLogger('Issue executing main PY file ' + str(e))
    # print(str(e))

# Run program
if __name__ == '__main__':
  main()