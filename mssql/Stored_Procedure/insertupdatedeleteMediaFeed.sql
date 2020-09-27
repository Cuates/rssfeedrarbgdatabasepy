use [Media]
go

set ansi_nulls on
go

set quoted_identifier on
go

-- ============================================
--        File: insertupdatedeleteMediaFeed
--     Created: 08/26/2020
--     Updated: 09/27/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert Update Delete Media Feed
-- ============================================
create procedure [dbo].[insertupdatedeleteMediaFeed]
  -- Add the parameters for the stored procedure here
  @optionMode nvarchar(max),
  @titleLong nvarchar(max) = null,
  @titleShort nvarchar(max) = null,
  @publishDate nvarchar(max) = null
as
begin
  -- Set nocount on added to prevent extra result sets from interfering with select statements
  set nocount on

  -- Declare variables
  declare @yearString as nvarchar(255)

  -- Set variables
  set @yearString = ''

  -- Omit characters
  set @optionMode = dbo.OmitCharacters(@optionMode, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @optionMode = ''
    begin
      -- Set parameter to null if empty string
      set @optionMode = nullif(@optionMode, '')
    end

  -- Set character limit
  set @optionMode = substring(@optionMode, 1, 255)

  -- Omit characters
  set @titleLong = dbo.OmitCharacters(@titleLong, '45,46,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,93,95,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @titleLong = ''
    begin
      -- Set parameter to null if empty string
      set @titleLong = nullif(@titleLong, '')
    end

  -- Set character limit
  set @titleLong = substring(@titleLong, 1, 255)

  -- Omit characters
  set @titleShort = dbo.OmitCharacters(@titleShort, '45,46,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,93,95,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @titleShort = ''
    begin
      -- Set parameter to null if empty string
      set @titleShort = nullif(@titleShort, '')
    end

  -- Set character limit
  set @titleShort = substring(@titleShort, 1, 255)

  -- Omit characters
  set @publishDate = dbo.OmitCharacters(@publishDate, '32,45,47,48,49,50,51,52,53,54,55,56,57,58')

  -- Check if the parameter cannot be casted into a date time
  if try_cast(@publishDate as datetime2(7)) is null
    begin
      -- Set the string as empty to be nulled below
      set @publishDate = ''
    end

  -- Check if empty string
  if @publishDate = ''
    begin
      -- Set parameter to null if empty string
      set @publishDate = nullif(@publishDate, '')
    end

  -- Set character limit
  set @publishDate = substring(@publishDate, 1, 255)

  -- Check if option mode is delete temp movie
  if @optionMode = 'deleteTempMovie'
    begin
      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Delete records
          delete from dbo.MovieFeedTemp

          -- Select message
          select
          'Success~Record(s) deleted' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~deleteTempMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
        -- End catch block
    end

  -- Else check if option mode is delete temp tv
  else if @optionMode = 'deleteTempTV'
    begin
      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Delete records
          delete from dbo.TVFeedTemp

          -- Select message
          select
          'Success~Record(s) deleted' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~deleteTempTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
        -- End catch block
    end

  -- Else check if option mode is insert temp movie
  else if @optionMode = 'insertTempMovie'
    begin
      -- Check if parameters are null
      if @titleLong is not null and @titleShort is not null and @publishDate is not null
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Insert record
              insert into dbo.MovieFeedTemp (titlelong, titleshort, publish_date, created_date) values (@titleLong, lower(@titleShort), @publishDate, getdate())

              -- Select message
              select
              'Success~Record(s) inserted' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Select error number, line, and message
              select
              'Error~insertTempMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end
            end catch
            -- End catch block
        end
      else
        begin
          -- Select message
          select
          'Error~Process halted, title long, title short, and or publish date were not provided' as [Status]
        end
    end

  -- Else check if option mode is insert temp tv
  else if @optionMode = 'insertTempTV'
    begin
      -- Check if parameters are null
      if @titleLong is not null and @titleShort is not null and @publishDate is not null
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Insert record
              insert into dbo.TVFeedTemp (titlelong, titleshort, publish_date, created_date) values (@titleLong, lower(@titleShort), @publishDate, getdate())

              -- Select message
              select
              'Success~Record(s) inserted' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Select error number, line, and message
              select
              'Error~insertTempTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end
            end catch
            -- End catch block
        end
      else
        begin
          -- Select message
          select
          'Error~Process halted, title long, title short, and or publish date were not provided' as [Status]
        end
    end

  -- Else check if option mode is update bulk movie
  else if @optionMode = 'updateBulkMovie'
    begin
      -- Set variables
      select
      @yearString = iif(datepart(month, getdate()) <= 3, cast(datepart(year, dateadd(year, -1, getdate())) as nvarchar) + '|' + cast(datepart(year, getdate()) as nvarchar), cast(datepart(year, getdate()) as nvarchar))

      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Remove duplicate records based on group by
          ;with subMovieDetails as
          (
            -- Select unique records
            select
            trim(mft.titlelong) as mfttitlelong,
            lower(trim(mft.titlelong)) as mfttitlelonglower,
            trim(mft.titleshort) as mfttitleshort,
            mft.publish_date as mftpublishdate,
            mf.mfID as mfmfID,
            trim(mf.titlelong) as mftitlelong,
            lower(trim(mf.titlelong)) as mftitlelonglower,
            trim(mf.titleshort) as mftitleshort,
            mf.actionstatus as mfactionstatus
            from dbo.MovieFeedTemp mft
            left join dbo.MovieFeed mf on mf.titleshort = mft.titleshort
            where
            (
              mf.actionstatus not in (1) and
              mf.actionstatus is not null
            ) and
            (
              mft.titlelong is not null and
              mft.titleshort is not null and
              mft.publish_date is not null
            ) and
            (
              cast(mft.publish_date as datetime2(7)) >= dateadd(hour, -1, getdate()) and
              cast(mft.publish_date as datetime2(7)) <= dateadd(hour, 0, getdate())
            )
            group by mft.titlelong, mft.titleshort, mft.publish_date, mf.titlelong, mf.titleshort, mf.actionstatus, mf.mfID
          ),
          movieDetails as
          (
            -- Select unique records
            select
            smd.mfttitlelong as mfttitlelong,
            smd.mfttitlelonglower as mfttitlelonglower,
            smd.mfttitleshort as mfttitleshort,
            max(smd.mftpublishdate) as mftpublishdate,
            smd.mfactionstatus as mftactionstatus,
            smd.mfmfID as mfmfID
            from subMovieDetails smd
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
            where
            (
              smd.mfttitlelonglower = smd.mftitlelonglower
            ) and
            (
              (
                @yearString like '%|%' and
                (
                  smd.mfttitlelonglower like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.mfttitlelonglower like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.mfttitlelonglower like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.mfttitlelong, smd.mfttitlelonglower, smd.mfttitleshort, smd.mfactionstatus, smd.mfmfID
          )

          -- Update records
          update mf
          set
          mf.publish_date = cast(md.mftpublishdate as datetime2(7)),
          mf.modified_date = cast(getdate() as datetime2(7))
          from movieDetails md
          join dbo.MovieFeed mf on mf.mfID = md.mfmfID

          -- Select message
          select
          'Success~Record(s) updated' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~updateBulkMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
    end

  -- Else check if option mode is update bulk tv
  else if @optionMode = 'updateBulkTV'
    begin
      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Remove duplicate records based on group by
          ;with subTVDetails as
          (
            -- Select unique records
            select
            trim(tft.titlelong) as tfttitlelong,
            lower(trim(tft.titlelong)) as tfttitlelonglower,
            trim(tft.titleshort) as tfttitleshort,
            tft.publish_date as tftpublishdate,
            tf.tfID as tftfID,
            trim(tf.titlelong) as tftitlelong,
            lower(trim(tf.titlelong)) as tftitlelonglower,
            trim(tf.titleshort) as tftitleshort,
            tf.actionstatus as tfactionstatus
            from dbo.TVFeedTemp tft
            left join dbo.TVFeed tf on tf.titleshort = tft.titleshort
            where
            (
              tf.actionstatus not in (1) and
              tf.actionstatus is not null
            ) and
            (
              tft.titlelong is not null and
              tft.titleshort is not null and
              tft.publish_date is not null
            ) and
            (
              cast(tft.publish_date as datetime2(7)) >= dateadd(hour, -1, getdate()) and
              cast(tft.publish_date as datetime2(7)) <= dateadd(hour, 0, getdate())
            )
            group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
          ),
          tvDetails as
          (
            -- Select unique records
            select
            std.tfttitlelong as tfttitlelong,
            std.tfttitleshort as tfttitleshort,
            cast(max(std.tftpublishdate) as datetime2(7)) as tftpublishdate,
            iif(std.tfactionstatus is null, cast(0 as int), cast(std.tfactionstatus as int)) as tfactionstatus,
            std.tftfID as tftfID
            from subTVDetails std
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
            where
            (
              std.tfttitlelonglower = std.tftitlelonglower
            )
            group by std.tfttitlelong, std.tfttitleshort, std.tfactionstatus, std.tftfID
          )

          -- Update records
          update tf
          set
          tf.publish_date = cast(td.tftpublishdate as datetime2(7)),
          tf.modified_date = cast(getdate() as datetime2(7))
          from tvDetails td
          join dbo.TVFeed tf on tf.tfID = td.tftfID

          -- Select message
          select
          'Success~Record(s) updated' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~updateBulkTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
    end

  -- Else check if option mode is insert bulk movie
  else if @optionMode = 'insertBulkMovie'
    begin
      -- Set variables
      select
      @yearString = iif(datepart(month, getdate()) <= 3, cast(datepart(year, dateadd(year, -1, getdate())) as nvarchar) + '|' + cast(datepart(year, getdate()) as nvarchar), cast(datepart(year, getdate()) as nvarchar))

      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Remove duplicate records based on group by
          ;with subMovieDetails as
          (
            -- Select unique records
            select
            trim(mft.titlelong) as mfttitlelong,
            lower(trim(mft.titlelong)) as mfttitlelonglower,
            trim(mft.titleshort) as mfttitleshort,
            mft.publish_date as mftpublishdate,
            mf.mfID as mfmfID,
            trim(mf.titlelong) as mftitlelong,
            lower(trim(mf.titlelong)) as mftitlelonglower,
            trim(mf.titleshort) as mftitleshort,
            mf.actionstatus as mfactionstatus
            from dbo.MovieFeedTemp mft
            left join dbo.MovieFeed mf on mf.titleshort = mft.titleshort
            where
            (
              mf.actionstatus not in (1) or
              mf.actionstatus is null
            ) and
            (
              mft.titlelong is not null and
              mft.titleshort is not null and
              mft.publish_date is not null
            ) -- and
            -- (
            --   cast(mft.publish_date as datetime2(7)) >= dateadd(hour, -1, getdate()) and
            --   cast(mft.publish_date as datetime2(7)) <= dateadd(hour, 0, getdate())
            -- )
            group by mft.titlelong, mft.titleshort, mft.publish_date, mf.titlelong, mf.titleshort, mf.actionstatus, mf.actionstatus, mf.mfID
          ),
          movieDetails as
          (
            -- Select unique records
            select
            smd.mfttitlelong as mfttitlelong,
            smd.mfttitleshort as mfttitleshort,
            cast(max(smd.mftpublishdate) as datetime2(7)) as mftpublishdate,
            iif(smd.mfactionstatus is null, cast(0 as int), cast(smd.mfactionstatus as int)) as mfactionstatus,
            smd.mfmfID as mfmfID
            from subMovieDetails smd
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
            where
            (
              smd.mfttitlelonglower <> smd.mftitlelonglower or
              smd.mftitlelong is null
            ) and
            (
              (
                @yearString like '%|%' and
                (
                  smd.mfttitlelonglower like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.mfttitlelonglower like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.mfttitlelonglower like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.mfttitlelong, smd.mfttitlelonglower, smd.mfttitleshort, smd.mfactionstatus, smd.mfmfID
          )

          -- Insert records
          insert into dbo.MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          md.mfttitlelong,
          md.mfttitleshort,
          md.mftpublishdate,
          md.mfactionstatus,
          cast(getdate() as datetime2(7)),
          cast(getdate() as datetime2(7))
          from movieDetails md
          left join dbo.MovieFeed mf on mf.titlelong = md.mfttitlelong
          where
          mf.titlelong is null
          group by md.mfttitlelong, md.mfttitleshort, md.mftpublishdate, md.mfactionstatus

          -- Select message
          select
          'Success~Record(s) inserted' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~insertBulkMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
    end

  -- Else check if option mode is insert bulk tv
  else if @optionMode = 'insertBulkTV'
    begin
      -- Begin the tranaction
      begin tran
        -- Begin the try block
        begin try
          -- Remove duplicate records based on group by
          ;with subTVDetails as
          (
            -- Select unique records
            select
            trim(tft.titlelong) as tfttitlelong,
            lower(trim(tft.titlelong)) as tfttitlelonglower,
            trim(tft.titleshort) as tfttitleshort,
            tft.publish_date as tftpublishdate,
            tf.tfID as tftfID,
            trim(tf.titlelong) as tftitlelong,
            lower(trim(tf.titlelong)) as tftitlelonglower,
            trim(tf.titleshort) as tftitleshort,
            tf.actionstatus as tfactionstatus
            from dbo.TVFeedTemp tft
            left join dbo.TVFeed tf on tf.titleshort = tft.titleshort
            where
            (
              tf.actionstatus not in (1) or
              tf.actionstatus is null
            ) and
            (
              tft.titlelong is not null and
              tft.titleshort is not null and
              tft.publish_date is not null
            ) -- and
            -- (
            --   cast(tft.publish_date as datetime2(7)) >= dateadd(hour, -1, getdate()) and
            --   cast(tft.publish_date as datetime2(7)) <= dateadd(hour, 0, getdate())
            -- ) and
            group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
          ),
          tvDetails as
          (
            -- Select unique records
            select
            std.tfttitlelong as tfttitlelong,
            std.tfttitleshort as tfttitleshort,
            cast(max(std.tftpublishdate) as datetime2(7)) as tftpublishdate,
            iif(std.tfactionstatus is null, cast(0 as int), cast(std.tfactionstatus as int)) as tfactionstatus,
            std.tftfID as tftfID
            from subTVDetails std
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
            where
            (
              std.tfttitlelonglower <> std.tftitlelonglower or
              std.tftitlelong is null
            )
            group by std.tfttitlelong, std.tfttitleshort, std.tfactionstatus, std.tftfID
          )

          -- Insert records
          insert into dbo.TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          td.tfttitlelong,
          td.tfttitleshort,
          td.tftpublishdate,
          td.tfactionstatus,
          cast(getdate() as datetime2(7)),
          cast(getdate() as datetime2(7))
          from tvDetails td
          left join dbo.TVFeed tf on tf.titlelong = td.tfttitlelong
          where
          tf.titlelong is null
          group by td.tfttitlelong, td.tfttitleshort, td.tftpublishdate, td.tfactionstatus

          -- Select message
          select
          'Success~Record(s) inserted' as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Commit transactional statement
              commit tran
            end
        end try
        -- End try block
        -- Begin catch block
        begin catch
          -- Select error number, line, and message
          select
          'Error~insertBulkTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]

          -- Check if there is trans count
          if @@trancount > 0
            begin
              -- Rollback to the previous state before the transaction was called
              rollback
            end
        end catch
    end
end
go