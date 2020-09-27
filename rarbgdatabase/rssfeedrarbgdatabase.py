##
#        File: rssfeedrarbgdatabase.py
#     Created: 08/28/2020
#     Updated: 09/27/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: Retrieve RSS feed from RarBg site
#     Version: 0.0.1 Python3
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
    import feedparser, re, logging, json, datetime, pytz, tzlocal, sqlalchemy, sqlite3, urllib, pathlib#, pythonjsonlogger

    # Declare dictionary list
    feedInfo = []
    feedStorage = []

    # Retrieve movie data from web site
    feedInfo = rfrbdbclass.extractrssfeed('RarBGMovie')
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
          feedStorage.append({'TitleLong': rssFeedTitle, 'TitleShort': rssFeedTitleShort, 'PublishDate': rssFeedPublishDateLocalTimeStamp})

      # Check if there are any values to process
      if feedStorage:
        # MSSQL BEGIN
        # Delete temp movie media only if there are records
        deleteFreeTDSMovie = rfrbdbclass._deleteTempMovieMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSMovie = re.split(r'~', deleteFreeTDSMovie)

          # # Check if SError is returned
          # if splitDeleteFreeTDSMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete FreeTDSRarBG ' + splitDeleteFreeTDSMovie[1])
            # # print(str(feedInfo))

        # Insert movie media into temp table
        insertFreeTDSMovie = rfrbdbclass._insertTempMovieMedia('FreeTDSRarBG', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSMovie = re.split(r'~', insertFreeTDSMovie)

          # # Check if SError is returned
          # if splitInsertFreeTDSMovie[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert FreeTDSRarBG ' + splitInsertFreeTDSMovie[1])
            # # print(str(feedInfo))

        # Bulk update movie media
        updateBulkFreeTDSMovie = rfrbdbclass._updateBulkMovieMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSMovie = re.split(r'~', updateBulkFreeTDSMovie)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk FreeTDSRarBG ' + splitUpdateBulkFreeTDSMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie media
        insertBulkFreeTDSMovie = rfrbdbclass._insertBulkMovieMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSMovie = re.split(r'~', insertBulkFreeTDSMovie)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSMovie[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk FreeTDSRarBG ' + splitInsertBulkFreeTDSMovie[1])
          # # print(str(feedInfo))
        # MSSQL END
        # MySQL BEGIN
        # Delete temp movie only if there are records
        deleteMySQLMovie = rfrbdbclass._deleteTempMovieMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitDeleteMySQLMovie = re.split(r'~', deleteMySQLMovie)

        # # Check if SError is returned
        # if splitDeleteMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete MySQLRarBG ' + splitDeleteMySQLMovie[1])
          # # print(str(feedInfo))

        # Insert movie into temp table
        insertMySQLMovie = rfrbdbclass._insertTempMovieMedia('MySQLRarBG', feedStorage)

        # # Split at the tilde (~)
        # splitInsertMySQLMovie = re.split(r'~', insertMySQLMovie)

        # # Check if SError is returned
        # if splitInsertMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert MySQLRarBG ' + splitInsertMySQLMovie[1])
          # # print(str(feedInfo))

        # Bulk update movie
        updateBulkMySQLMovie = rfrbdbclass._updateBulkMovieMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkMySQLMovie = re.split(r'~', updateBulkMySQLMovie)

        # # Check if SError is returned
        # if splitUpdateBulkMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk MySQLRarBG ' + splitUpdateBulkMySQLMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie
        insertBulkMySQLMovie = rfrbdbclass._insertBulkMovieMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitInsertBulkMySQLMovie = re.split(r'~', insertBulkMySQLMovie)

        # # Check if SError is returned
        # if splitInsertBulkMySQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk MySQLRarBG ' + splitInsertBulkMySQLMovie[1])
          # # print(str(feedInfo))
        # MySQL END
        # PostgreSQL BEGIN
        # Delete temp movie only if there are records
        deletePostgreSQLMovie = rfrbdbclass._deleteTempMovieMedia('PGSQLRarBG')

        # # Split at the tilde (~)
        # splitDeletePostgreSQLMovie = re.split(r'~', deletePostgreSQLMovie)

        # # Check if SError is returned
        # if splitDeletePostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete PGSQLRarBG ' + splitDeletePostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Insert movie into temp table
        insertPostgreSQLMovie = rfrbdbclass._insertTempMovieMedia('PGSQLRarBG', feedStorage)

        # # Split at the tilde (~)
        # splitInsertPostgreSQLMovie = re.split(r'~', insertPostgreSQLMovie)

        # # Check if SError is returned
        # if splitInsertPostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert PGSQLRarBG ' + splitInsertPostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Bulk update movie
        updateBulkPostgreSQLMovie = rfrbdbclass._updateBulkMovieMedia('PGSQLRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkPostgreSQLMovie = re.split(r'~', updateBulkPostgreSQLMovie)

        # # Check if SError is returned
        # if splitUpdateBulkPostgreSQLMovie[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk PGSQLRarBG ' + splitUpdateBulkPostgreSQLMovie[1])
          # # print(str(feedInfo))

        # Bulk insert movie
        insertBulkPostgreSQLMovie = rfrbdbclass._insertBulkMovieMedia('PGSQLRarBG')

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

    # Retrieve tv data from web site
    feedInfo = rfrbdbclass.extractrssfeed('RarBGTV')

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
          feedStorage.append({'TitleLong': rssFeedTitle, 'TitleShort': rssFeedTitleShort, 'PublishDate': rssFeedPublishDateLocalTimeStamp})

      # Check if there are any values to process
      if feedStorage:
        # MSSQL BEGIN
        # Delete temp tv media only if there are records
        deleteFreeTDSTV = rfrbdbclass._deleteTempTVMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
          # splitDeleteFreeTDSTV = re.split(r'~', deleteFreeTDSTV)

          # # Check if SError is returned
          # if splitDeleteFreeTDSTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error delete FreeTDSRarBG ' + splitDeleteFreeTDSTV[1])
            # # print(str(feedInfo))

        # Insert tv media into temp table
        insertFreeTDSTV = rfrbdbclass._insertTempTVMedia('FreeTDSRarBG', feedStorage)

        # # Split at the tilde (~)
          # splitInsertFreeTDSTV = re.split(r'~', insertFreeTDSTV)

          # # Check if SError is returned
          # if splitInsertFreeTDSTV[0] == 'SError':
            # # Log string
            # rnfdbclass._setLogger('Error insert FreeTDSRarBG ' + splitInsertFreeTDSTV[1])
            # # print(str(feedInfo))

        # Bulk update tv media
        updateBulkFreeTDSTV = rfrbdbclass._updateBulkTVMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkFreeTDSTV = re.split(r'~', updateBulkFreeTDSTV)

        # # Check if SError is returned
        # if splitUpdateBulkFreeTDSTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error update bulk FreeTDSRarBG ' + splitUpdateBulkFreeTDSTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv media
        insertBulkFreeTDSTV = rfrbdbclass._insertBulkTVMedia('FreeTDSRarBG')

        # # Split at the tilde (~)
        # splitInsertBulkFreeTDSTV = re.split(r'~', insertBulkFreeTDSTV)

        # # Check if SError is returned
        # if splitInsertBulkFreeTDSTV[0] == 'SError':
          # # Log string
          # rnfdbclass._setLogger('Error insert bulk FreeTDSRarBG ' + splitInsertBulkFreeTDSTV[1])
          # # print(str(feedInfo))
        # MSSQL END
        # MySQL BEGIN
        # Delete temp tv only if there are records
        deleteMySQLTV = rfrbdbclass._deleteTempTVMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitDeleteMySQLTV = re.split(r'~', deleteMySQLTV)

        # # Check if SError is returned
        # if splitDeleteMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete MySQLRarBG ' + splitDeleteMySQLTV[1])
          # # print(str(feedInfo))

        # Insert tv into temp table
        insertMySQLTV = rfrbdbclass._insertTempTVMedia('MySQLRarBG', feedStorage)

        # # Split at the tilde (~)
        # splitInsertMySQLTV = re.split(r'~', insertMySQLTV)

        # # Check if SError is returned
        # if splitInsertMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert MySQLRarBG ' + splitInsertMySQLTV[1])
          # # print(str(feedInfo))

        # Bulk update tv
        updateBulkMySQLTV = rfrbdbclass._updateBulkTVMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkMySQLTV = re.split(r'~', updateBulkMySQLTV)

        # # Check if SError is returned
        # if splitUpdateBulkMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk MySQLRarBG ' + splitUpdateBulkMySQLTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv
        insertBulkMySQLTV = rfrbdbclass._insertBulkTVMedia('MySQLRarBG')

        # # Split at the tilde (~)
        # splitInsertBulkMySQLTV = re.split(r'~', insertBulkMySQLTV)

        # # Check if SError is returned
        # if splitInsertBulkMySQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert bulk MySQLRarBG ' + splitInsertBulkMySQLTV[1])
          # # print(str(feedInfo))
        # MySQL END
        # PostgreSQL BEGIN
        # Delete temp tv only if there are records
        deletePostgreSQLTV = rfrbdbclass._deleteTempTVMedia('PGSQLRarBG')

        # # Split at the tilde (~)
        # splitDeletePostgreSQLTV = re.split(r'~', deletePostgreSQLTV)

        # # Check if SError is returned
        # if splitDeletePostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error delete PGSQLRarBG ' + splitDeletePostgreSQLTV[1])
          # # print(str(feedInfo))

        # Insert tv into temp table
        insertPostgreSQLTV = rfrbdbclass._insertTempTVMedia('PGSQLRarBG', feedStorage)

        # # Split at the tilde (~)
        # splitInsertPostgreSQLTV = re.split(r'~', insertPostgreSQLTV)

        # # Check if SError is returned
        # if splitInsertPostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error insert PGSQLRarBG ' + splitInsertPostgreSQLTV[1])
          # # print(str(feedInfo))

        # Bulk update tv
        updateBulkPostgreSQLTV = rfrbdbclass._updateBulkTVMedia('PGSQLRarBG')

        # # Split at the tilde (~)
        # splitUpdateBulkPostgreSQLTV = re.split(r'~', updateBulkPostgreSQLTV)

        # # Check if SError is returned
        # if splitUpdateBulkPostgreSQLTV[0] == 'SError':
          # # Log string
          # rfrbdbclass._setLogger('Error update bulk PGSQLRarBG ' + splitUpdateBulkPostgreSQLTV[1])
          # # print(str(feedInfo))

        # Bulk insert tv
        insertBulkPostgreSQLTV = rfrbdbclass._insertBulkTVMedia('PGSQLRarBG')

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