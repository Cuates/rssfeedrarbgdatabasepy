-- Database Connect
use [Databasename]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- Procedure Drop
drop procedure if exists dbo.insertupdatedeleteMediaFeed
go

-- ============================================
--        File: insertupdatedeleteMediaFeed
--     Created: 08/26/2020
--     Updated: 10/10/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert Update Delete Media Feed
-- ============================================

-- Procedure Create
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
  declare @omitOptionMode as nvarchar(255)
  declare @omitTitleLong as nvarchar(255)
  declare @omitTitleShort as nvarchar(255)
  declare @omitPublishDate as nvarchar(255)

  -- Set variables
  set @yearString = ''
  set @omitOptionMode = N'0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitleLong = N'-,.,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,[,],_,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitleShort = N'-,.,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,[,],_,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitPublishDate = N' ,-,/,0,1,2,3,4,5,6,7,8,9,:'

  -- Check if parameter is not null
  if @optionMode is not null
    begin
      -- Omit characters
      set @optionMode = dbo.OmitCharacters(@optionMode, @omitOptionMode)

      -- Set character limit
      set @optionMode = substring(@optionMode, 1, 255)

      -- Check if empty string
      if @optionMode = ''
        begin
          -- Set parameter to null if empty string
          set @optionMode = nullif(@optionMode, '')
        end
    end

  -- Check if parameter is not null
  if @titleLong is not null
    begin
      -- Omit characters
      set @titleLong = dbo.OmitCharacters(@titleLong, @omitTitleLong)

      -- Set character limit
      set @titleLong = substring(@titleLong, 1, 255)

      -- Check if empty string
      if @titleLong = ''
        begin
          -- Set parameter to null if empty string
          set @titleLong = nullif(@titleLong, '')
        end
    end

  -- Check if parameter is not null
  if @titleShort is not null
    begin
      -- Omit characters
      set @titleShort = dbo.OmitCharacters(@titleShort, @omitTitleShort)

      -- Set character limit
      set @titleShort = substring(@titleShort, 1, 255)

      -- Check if empty string
      if @titleShort = ''
        begin
          -- Set parameter to null if empty string
          set @titleShort = nullif(@titleShort, '')
        end
    end

  -- Check if parameter is not null
  if @publishDate is not null
    begin
      -- Omit characters
      set @publishDate = dbo.OmitCharacters(@publishDate, @omitPublishDate)

      -- Set character limit
      set @publishDate = substring(@publishDate, 1, 255)

      -- Check if the parameter cannot be casted into a date time
      if try_cast(@publishDate as datetime2(6)) is null
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
    end

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
            trim(mft.titleshort) as mfttitleshort,
            mft.publish_date as mftpublishdate,
            mfas.actionstatus as mfasactionstatus,
            mf.mfID as mfmfID
            from dbo.MovieFeedTemp mft
            left join dbo.MovieFeed mf on mf.titlelong = mft.titlelong
            left join dbo.MovieFeed mfas on mfas.titleshort = mft.titleshort
            where
            mfas.actionstatus not in (1) and
            mf.mfID is not null and
            (
              (
                trim(mft.titlelong) <> '' and
                trim(mft.titleshort) <> '' and
                trim(mft.publish_date) <> ''
              ) or
              (
                mft.titlelong is not null and
                mft.titleshort is not null and
                mft.publish_date is not null
              )
            ) and
            (
              cast(mft.publish_date as datetime2(6)) >= dateadd(hour, -1, getdate()) and
              cast(mft.publish_date as datetime2(6)) <= dateadd(hour, 0, getdate())
            )
            group by mft.titlelong, mft.titleshort, mft.publish_date, mfas.actionstatus, mf.mfID
          ),
          filteredMovieDetails as
          (
            -- Select unique records
            select
            smd.mfttitlelong as titlelong,
            max(smd.mftpublishdate) as publishdate
            from subMovieDetails smd
            group by smd.mfttitlelong
          ),
          movieDetails as
          (
            -- Select unique records
            select
            substring(dbo.OmitCharacters(smd.mfttitlelong, @omitTitleLong), 1, 255) as titlelong,
            substring(dbo.OmitCharacters(smd.mfttitleshort, @omitTitleShort), 1, 255) as titleshort,
            substring(dbo.OmitCharacters(smd.mftpublishdate, @omitPublishDate), 1, 255) as publishdate,
            smd.mfasactionstatus as actionstatus,
            smd.mfmfID as mfID
            from subMovieDetails smd
            join filteredMovieDetails fmd on fmd.titlelong = smd.mfttitlelong and fmd.publishdate = smd.mftpublishdate
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelong like concat('%', mve.videoencode, '%')
            where
            (
              (
                @yearString like '%|%' and
                (
                  smd.mfttitlelong like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.mfttitlelong like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.mfttitlelong like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.mfttitlelong, smd.mfttitleshort, smd.mftpublishdate, smd.mfasactionstatus, smd.mfmfID
          )

          -- Update records
          update mf
          set
          mf.publish_date = cast(md.publishdate as datetime2(6)),
          mf.modified_date = cast(getdate() as datetime2(6))
          from dbo.MovieFeed mf
          join movieDetails md on md.mfID = mf.mfID

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
            trim(tft.titleshort) as tfttitleshort,
            tft.publish_date as tftpublishdate,
            tfas.actionstatus as tfasactionstatus,
            tf.tfID as tftfID
            from dbo.TVFeedTemp tft
            left join dbo.TVFeed tf on tf.titlelong = tft.titlelong
            left join dbo.TVFeed tfas on tfas.titleshort = tft.titleshort
            where
            tfas.actionstatus not in (1) and
            tf.tfID is not null and
            (
              (
                trim(tft.titlelong) <> '' and
                trim(tft.titleshort) <> '' and
                trim(tft.publish_date) <> ''
              ) or
              (
                tft.titlelong is not null and
                tft.titleshort is not null and
                tft.publish_date is not null
              )
            ) and
            (
              cast(tft.publish_date as datetime2(6)) >= dateadd(hour, -1, getdate()) and
              cast(tft.publish_date as datetime2(6)) <= dateadd(hour, 0, getdate())
            )
            group by tft.titlelong, tft.titleshort, tft.publish_date, tfas.actionstatus, tf.tfID
          ),
          filteredTVDetails as
          (
            -- Select unique records
            select
            std.tfttitlelong as titlelong,
            max(std.tftpublishdate) as publishdate
            from subTVDetails std
            group by std.tfttitlelong
          ),
          tvDetails as
          (
            -- Select unique records
            select
            substring(dbo.OmitCharacters(std.tfttitlelong, @omitTitleLong), 1, 255) as titlelong,
            substring(dbo.OmitCharacters(std.tfttitleshort, @omitTitleShort), 1, 255) as titleshort,
            substring(dbo.OmitCharacters(std.tftpublishdate, @omitPublishDate), 1, 255) as publishdate,
            std.tfasactionstatus as actionstatus,
            std.tftfID as tfID
            from subTVDetails std
            join filteredTVDetails ftd on ftd.titlelong = std.tfttitlelong and ftd.publishdate = std.tftpublishdate
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelong like concat('%', mve.videoencode, '%')
            group by std.tfttitlelong, std.tfttitleshort, std.tftpublishdate, std.tfasactionstatus, std.tftfID
          )

          -- Update records
          update tf
          set
          tf.publish_date = cast(td.publishdate as datetime2(6)),
          tf.modified_date = cast(getdate() as datetime2(6))
          from dbo.TVFeed tf
          join tvDetails td on td.tfID = tf.tfID

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
            trim(mft.titleshort) as mfttitleshort,
            mft.publish_date as mftpublishdate,
            mfas.actionstatus as mfasactionstatus,
            mf.mfID as mfmfID
            from dbo.MovieFeedTemp mft
            left join dbo.MovieFeed mf on mf.titlelong = mft.titlelong
            left join dbo.MovieFeed mfas on mfas.titleshort = mft.titleshort
            where
            (
              mfas.actionstatus not in (1) or
              mfas.actionstatus is null
            ) and
            mf.mfID is null and
            (
              (
                trim(mft.titlelong) <> '' and
                trim(mft.titleshort) <> '' and
                trim(mft.publish_date) <> ''
              ) or
              (
                mft.titlelong is not null and
                mft.titleshort is not null and
                mft.publish_date is not null
              )
            ) -- and
            -- (
            --   cast(mft.publish_date as datetime2(6)) >= dateadd(hour, -1, getdate()) and
            --   cast(mft.publish_date as datetime2(6)) <= dateadd(hour, 0, getdate())
            -- )
            group by mft.titlelong, mft.titleshort, mft.publish_date, mfas.actionstatus, mf.mfID
          ),
          filteredMovieDetails as
          (
            -- Select unique records
            select
            smd.mfttitlelong as titlelong,
            max(smd.mftpublishdate) as publishdate
            from subMovieDetails smd
            group by smd.mfttitlelong
          ),
          movieDetails as
          (
            -- Select unique records
            select
            substring(dbo.OmitCharacters(smd.mfttitlelong, @omitTitleLong), 1, 255) as titlelong,
            substring(dbo.OmitCharacters(smd.mfttitleshort, @omitTitleShort), 1, 255) as titleshort,
            substring(dbo.OmitCharacters(smd.mftpublishdate, @omitPublishDate), 1, 255) as publishdate,
            smd.mfasactionstatus as actionstatus,
            smd.mfmfID as mfID
            from subMovieDetails smd
            join filteredMovieDetails fmd on fmd.titlelong = smd.mfttitlelong and fmd.publishdate = smd.mftpublishdate
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelong like concat('%', mve.videoencode, '%')
            where
            (
              (
                @yearString like '%|%' and
                (
                  smd.mfttitlelong like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.mfttitlelong like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.mfttitlelong like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.mfttitlelong, smd.mfttitleshort, smd.mftpublishdate, smd.mfasactionstatus, smd.mfmfID
          )

          -- Insert records
          insert into dbo.MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          md.titlelong,
          md.titleshort,
          cast(md.publishdate as datetime2(6)),
          iif(md.actionstatus is null, 0, md.actionstatus),
          cast(getdate() as datetime2(6)),
          cast(getdate() as datetime2(6))
          from movieDetails md
          left join dbo.MovieFeed mf on mf.mfID = md.mfID
          group by md.titlelong, md.titleshort, md.publishdate, md.actionstatus

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
            trim(tft.titleshort) as tfttitleshort,
            tft.publish_date as tftpublishdate,
            tfas.actionstatus as tfasactionstatus,
            tf.tfID as tftfID
            from dbo.TVFeedTemp tft
            left join dbo.TVFeed tf on tf.titlelong = tft.titlelong
            left join dbo.TVFeed tfas on tfas.titleshort = tft.titleshort
            where
            (
              tfas.actionstatus not in (1) or
              tfas.actionstatus is null
            ) and
            tf.tfID is null and
            (
              (
                trim(tft.titlelong) <> '' and
                trim(tft.titleshort) <> '' and
                trim(tft.publish_date) <> ''
              ) or
              (
                tft.titlelong is not null and
                tft.titleshort is not null and
                tft.publish_date is not null
              )
            ) -- and
            -- (
            --   cast(tft.publish_date as datetime2(6)) >= dateadd(hour, -1, getdate()) and
            --   cast(tft.publish_date as datetime2(6)) <= dateadd(hour, 0, getdate())
            -- ) and
            group by tft.titlelong, tft.titleshort, tft.publish_date, tfas.actionstatus, tf.tfID
          ),
          filteredTVDetails as
          (
            -- Select unique records
            select
            std.tfttitlelong as titlelong,
            max(std.tftpublishdate) as publishdate
            from subTVDetails std
            group by std.tfttitlelong
          ),
          tvDetails as
          (
            -- Select unique records
            select
            substring(dbo.OmitCharacters(std.tfttitlelong, @omitTitleLong), 1, 255) as titlelong,
            substring(dbo.OmitCharacters(std.tfttitleshort, @omitTitleShort), 1, 255) as titleshort,
            substring(dbo.OmitCharacters(std.tftpublishdate, @omitPublishDate), 1, 255) as publishdate,
            std.tfasactionstatus as actionstatus,
            std.tftfID as tfID
            from subTVDetails std
            join filteredTVDetails ftd on ftd.titlelong = std.tfttitlelong and ftd.publishdate = std.tftpublishdate
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelong like concat('%', mve.videoencode, '%')
            group by std.tfttitlelong, std.tfttitleshort, std.tftpublishdate, std.tfasactionstatus, std.tftfID
          )

          -- Insert records
          insert into dbo.TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          td.titlelong,
          td.titleshort,
          cast(td.publishdate as datetime2(6)),
          iif(td.actionstatus is null, 0, td.actionstatus),
          cast(getdate() as datetime2(6)),
          cast(getdate() as datetime2(6))
          from tvDetails td
          left join dbo.TVFeed tf on tf.tfID = td.tfID
          group by td.titlelong, td.titleshort, td.publishdate, td.actionstatus

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
