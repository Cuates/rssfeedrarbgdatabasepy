##
#        File: rssfeedrarbgdatabase.py
#     Created: 08/28/2020
#     Updated: 11/25/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: Retrieve RSS feed from RarBg site
#     Version: 0.1.0 Python3
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

    # Initialize list
    mandatoryParams = ['title', 'published']
    possibleParams = ['titlelong', 'titleshort', 'publishdate']
    removeParams = []

    # Retrieve movie data from web site
    feedInfo = rfrbdbclass.extractrssfeed('RarBGMovie', mandatoryParams)
    # print(feedInfo)

    # Check if status exists
    if feedInfo.get('Status') != None:
      # Check if status is equal to success
      if feedInfo.get('Status') == 'Success':
        # Check if list is not empty
        if feedInfo.get('Result'):
          # Loop through data feed information
          for feedEntry in feedInfo.get('Result'):
            # Initialize variable
            rssFeedTitle = ''
            rssFeedTitleShort = ''
            rssFeedPublishDateUTCTimeStamp = ''
            rssFeedPublishDateLocalTimeStamp = ''
            local_tz = ''

            # Store title
            rssFeedTitle = feedEntry.get('title')

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
              rssFeedPublishDateUTCTimeStamp = feedEntry.get('published')

              # Set local time zone
              local_tz = tzlocal.get_localzone()

              # Set UTC date time to local date time
              rssFeedPublishDateLocalTimeStamp = str(datetime.datetime.strptime(rssFeedPublishDateUTCTimeStamp, '%a, %d %b %Y %H:%M:%S %z').astimezone(pytz.timezone(str(local_tz))).strftime('%Y-%m-%d %H:%M:%S'))

              # Set dictionary list with values
              feedStorage.append({'titlelong': rssFeedTitle, 'titleshort': rssFeedTitleShort, 'publishdate': rssFeedPublishDateLocalTimeStamp})

          # Check if there are any values to process
          if feedStorage:
            # MSSQL BEGIN
            # Set header row for CSV file
            movieHeaderColumn = ['titlelong', 'titleshort', 'publishdate']

            # Write data to a CSV file
            writeCSVFileResp = rfrbdbclass._writeToCSVFile('/mnt/share/linuxprivate/Rarbg/DEV/Movie/Movie_Outbound.csv', movieHeaderColumn, feedStorage)
            # print (writeCSVFileResp)

            # Get current time stamp
            dateTimeObj = datetime.datetime.now()

            # Convert date time to string
            timestampStr = dateTimeObj.strftime('%Y-%m-%d %H:%M:%S.%f')

            # Restructure JSON output
            feedStorageNested = {'movie': {'created_date': timestampStr, 'count': len(feedStorage), 'children': feedStorage}}

            # Write data to a JSON file
            writeJSONFileResp = rfrbdbclass._writeToJSONFile('/mnt/share/linuxprivate/Rarbg/DEV/Movie/Movie_Outbound.json', feedStorageNested)
            # print (writeJSONFileResp)
            # MSSQL END

            # Initialize empty list/dictionary
            feedStorageEmtpy = [{'titlelong': '', 'titleshort': '', 'publishedate': ''}]

            # Delete temp movie only if there are records
            deleteTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'deleting', 'insertupdatedeletebulkmediafeed', 'deleteTempMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Delete temp movie only if there are records
            deleteTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'deleting', 'insertupdatedeletebulkmediafeed', 'deleteTempMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Delete temp movie media only if there are records
            deleteTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'deleting', 'dbo.insertupdatedeleteBulkMediaFeed', 'deleteTempMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Delete temp movie media only if there are records
            deleteTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'deleting', 'dbo.insertupdatedeleteBulkMediaFeed', 'deleteTempMovie', possibleParams, feedStorageEmtpy, removeParams)

            # print(f'deleteTempMovieFeed: {deleteTempMovieFeed}')

            # Insert movie into temp table
            insertTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertTempMovie', possibleParams, feedStorage, removeParams)

            # Insert movie into temp table
            insertTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertTempMovie', possibleParams, feedStorage, removeParams)

            # Insert movie media into temp table
            insertTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertTempMovie', possibleParams, feedStorage, removeParams)

            # Insert movie media into temp table
            insertTempMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertTempMovie', possibleParams, feedStorage, removeParams)

            # print(f'insertTempMovieFeed: {insertTempMovieFeed}')

            # Bulk update movie
            updateBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'updating', 'insertupdatedeletebulkmediafeed', 'updateBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk update movie
            updateBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'updating', 'insertupdatedeletebulkmediafeed', 'updateBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk update movie media
            updateBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'updating', 'dbo.insertupdatedeleteBulkMediaFeed', 'updateBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk update movie media
            updateBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'updating', 'dbo.insertupdatedeleteBulkMediaFeed', 'updateBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # print(f'updateBulkMovieFeed: {updateBulkMovieFeed}')

            # Bulk insert movie
            insertBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk insert movie
            insertBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk insert movie media
            insertBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

            # Bulk insert movie media
            insertBulkMovieFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertBulkMovie', possibleParams, feedStorageEmtpy, removeParams)

      #       print(f'insertBulkMovieFeed: {insertBulkMovieFeed}')
      # else:
      #   print(f'''Status: {feedInfo.get('Status')}, Message: {feedInfo.get('Message')}, Result: []''')
    else:
      # print(f'Status: Error, Message: {feedInfo}, Result: []')

      # Log string
      rfrbdbclass._setLogger('Error retrieveing movie feed data ' + str(feedInfo))

    # Set dictionary list
    feedInfo = []
    feedStorage = []
    feedStorageNested = {}

    # Retrieve movie data from web site
    feedInfo = rfrbdbclass.extractrssfeed('RarBGTV', mandatoryParams)
    # print(feedInfo)

    # Check if status exists
    if feedInfo.get('Status') != None:
      # Check if status is equal to success
      if feedInfo.get('Status') == 'Success':
        # Check if list is not empty
        if feedInfo.get('Result'):
          # Loop through data feed information
          for feedEntry in feedInfo.get('Result'):
            # Initialize variable
            rssFeedTitle = ''
            rssFeedTitleShort = ''
            rssFeedPublishDateUTCTimeStamp = ''
            rssFeedPublishDateLocalTimeStamp = ''
            local_tz = ''

            # Store title
            rssFeedTitle = feedEntry.get('title')

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
              rssFeedPublishDateUTCTimeStamp = feedEntry.get('published')

              # Set local time zone
              local_tz = tzlocal.get_localzone()

              # Set UTC date time to local date time
              rssFeedPublishDateLocalTimeStamp = str(datetime.datetime.strptime(rssFeedPublishDateUTCTimeStamp, '%a, %d %b %Y %H:%M:%S %z').astimezone(pytz.timezone(str(local_tz))).strftime('%Y-%m-%d %H:%M:%S'))

              # Set dictionary list with values
              feedStorage.append({'titlelong': rssFeedTitle, 'titleshort': rssFeedTitleShort, 'publishdate': rssFeedPublishDateLocalTimeStamp})

          # Check if there are any values to process
          if feedStorage:
            # MSSQL BEGIN
            # Set header row for CSV file
            tvHeaderColumn = ['titlelong', 'titleshort', 'publishdate']

            # Write data to a CSV file
            writeCSVFileResp = rfrbdbclass._writeToCSVFile('/mnt/share/linuxprivate/Rarbg/DEV/TV/TV_Outbound.csv', tvHeaderColumn, feedStorage)
            # print (writeCSVFileResp)

            # Get current time stamp
            dateTimeObj = datetime.datetime.now()

            # Convert date time to string
            timestampStr = dateTimeObj.strftime('%Y-%m-%d %H:%M:%S.%f')

            # Restructure JSON output
            feedStorageNested = {'tv': {'created_date': timestampStr, 'count': len(feedStorage), 'children': feedStorage}}

            # Write data to a JSON file
            writeJSONFileResp = rfrbdbclass._writeToJSONFile('/mnt/share/linuxprivate/Rarbg/DEV/TV/TV_Outbound.json', feedStorageNested)
            # print (writeJSONFileResp)
            # MSSQL END

            # Delete temp tv only if there are records
            deleteTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'deleting', 'insertupdatedeletebulkmediafeed', 'deleteTempTV', possibleParams, feedStorage, removeParams)

            # Delete temp tv only if there are records
            deleteTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'deleting', 'insertupdatedeletebulkmediafeed', 'deleteTempTV', possibleParams, feedStorage, removeParams)

            # Delete temp tv media only if there are records
            deleteTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'deleting', 'dbo.insertupdatedeleteBulkMediaFeed', 'deleteTempTV', possibleParams, feedStorage, removeParams)

            # Delete temp tv media only if there are records
            deleteTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'deleting', 'dbo.insertupdatedeleteBulkMediaFeed', 'deleteTempTV', possibleParams, feedStorage, removeParams)

            # print(f'deleteTempTVFeed: {deleteTempTVFeed}')

            # Insert tv into temp table
            insertTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertTempTV', possibleParams, feedStorage, removeParams)

            # Insert tv into temp table
            insertTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertTempTV', possibleParams, feedStorage, removeParams)

            # Insert tv media into temp table
            insertTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertTempTV', possibleParams, feedStorage, removeParams)

            # Insert tv media into temp table
            insertTempTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertTempTV', possibleParams, feedStorage, removeParams)

            # print(f'insertTempTVFeed: {insertTempTVFeed}')

            # Bulk update tv
            updateBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'updating', 'insertupdatedeletebulkmediafeed', 'updateBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk update tv
            updateBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'updating', 'insertupdatedeletebulkmediafeed', 'updateBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk update tv media
            updateBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'updating', 'dbo.insertupdatedeleteBulkMediaFeed', 'updateBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk update tv media
            updateBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'updating', 'dbo.insertupdatedeleteBulkMediaFeed', 'updateBulkTV', possibleParams, feedStorage, removeParams)

            # print(f'updateBulkTVFeed: {updateBulkTVFeed}')

            # Bulk insert tv
            insertBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MariaDBSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk insert tv
            insertBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('PGSQLRarBG', 'inserting', 'insertupdatedeletebulkmediafeed', 'insertBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk insert tv media
            insertBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLWRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertBulkTV', possibleParams, feedStorage, removeParams)

            # Bulk insert tv media
            insertBulkTVFeed = rfrbdbclass._insertupdatedeleteMediaFeed('MSSQLLRarBG', 'inserting', 'dbo.insertupdatedeleteBulkMediaFeed', 'insertBulkTV', possibleParams, feedStorage, removeParams)

      #       print(f'insertBulkTVFeed: {insertBulkTVFeed}')
      # else:
      #   print(f'''Status: {feedInfo.get('Status')}, Message: {feedInfo.get('Message')}, Result: []''')
    else:
      # print(f'Status: Error, Message: {feedInfo}, Result: []')

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