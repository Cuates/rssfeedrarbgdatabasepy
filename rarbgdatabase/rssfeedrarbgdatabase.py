##
#        File: rssfeedrarbgdatabase.py
#     Created: 08/28/2020
#     Updated: 09/04/2020
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
        import feedparser, re, urllib, tzlocal, pytz, logging, json, datetime # tkinter, webbrowser, pathlib, requests, bs4, sqlite3, sqlalchemy, sys, pythonjsonlogger

        # Declare dictionary list
        feedInfo = []
        feedStorage = []

        # Retrieve movie data from web site
        feedInfo = rfrbdbclass.extractrssfeed('<Rarb_Movie_Type>')
        #print(feedInfo)

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
                titleArray = re.split(r'\.[0-9]{4}\.', rssFeedTitle, flags=re.IGNORECASE)

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
            # Delete temp movie media only if there are records
            rfrbdbclass._deleteTempMovieMedia()

            # Insert movie media into temp table
            rfrbdbclass._insertTempMovieMedia(feedStorage)

            # Bulk update movie media
            rfrbdbclass._updateBulkMovieMedia()

            # Bulk insert movie media
            rfrbdbclass._insertBulkMovieMedia()

        # Set dictionary list
        feedInfo = []
        feedStorage = []

        # Retrieve tv data from web site
        feedInfo = rfrbdbclass.extractrssfeed('<Rarb_TV_Type>')

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
            if re.search(r'\.s[0-9]{2,3}|\.[0-9]{4}\.[0-9]{2}\.[0-9]{2}\.|\.[0-9]{4}\.', rssFeedTitle, re.IGNORECASE):
                # Initialize variable
                titleArray = []

                # Split string based on regular express
                titleArray = re.split(r'\.s[0-9]{2,3}|\.[0-9]{4}\.[0-9]{2}\.[0-9]{2}\.|\.[0-9]{4}\.', rssFeedTitle, flags=re.IGNORECASE)

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
            # Delete temp tv media only if there are records
            rfrbdbclass._deleteTempTVMedia()

            # Insert tv media into temp table
            rfrbdbclass._insertTempTVMedia(feedStorage)

            # Bulk update tv media
            rfrbdbclass._updateBulkTVMedia()

            # Bulk insert tv media
            rfrbdbclass._insertBulkTVMedia()

    except Exception as e:
        ## Log string
        logException = 'Issue with loop'

        #rfrbdbclass._setLogger('Issue executing main PY file ' + str(e))
        print(str(e))

# Run program
if __name__ == '__main__':
    main()