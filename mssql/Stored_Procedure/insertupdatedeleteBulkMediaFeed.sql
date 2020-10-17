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
drop procedure if exists dbo.insertupdatedeleteBulkMediaFeed
go

-- =================================================
--        File: insertupdatedeleteBulkMediaFeed
--     Created: 08/26/2020
--     Updated: 10/17/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert Update Delete Bulk Media Feed
-- =================================================

-- Procedure Create
create procedure [dbo].[insertupdatedeleteBulkMediaFeed]
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
  declare @yearString as nvarchar(max)
  declare @omitOptionMode as nvarchar(max)
  declare @omitTitleLong as nvarchar(max)
  declare @omitTitleShort as nvarchar(max)
  declare @omitPublishDate as nvarchar(max)
  declare @maxLengthOptionMode as int
  declare @maxLengthTitleLong as int
  declare @maxLengthTitleShort as int
  declare @maxLengthPublishDate as int

  -- Set variables
  set @yearString = ''
  set @omitOptionMode = N'0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitleLong = N'-,.,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,[,],_,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitTitleShort = N'-,.,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,[,],_,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  set @omitPublishDate = N' ,-,/,0,1,2,3,4,5,6,7,8,9,:'
  set @maxLengthOptionMode = 255
  set @maxLengthTitleLong = 255
  set @maxLengthTitleShort = 255
  set @maxLengthPublishDate = 255

  -- Check if parameter is not null
  if @optionMode is not null
    begin
      -- Omit characters
      set @optionMode = dbo.OmitCharacters(@optionMode, @omitOptionMode)

      -- Set character limit
      set @optionMode = trim(substring(@optionMode, 1, @maxLengthOptionMode))

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
      set @titleLong = trim(substring(@titleLong, 1, @maxLengthTitleLong))

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
      set @titleShort = trim(substring(@titleShort, 1, @maxLengthTitleShort))

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
      set @publishDate = trim(substring(@publishDate, 1, @maxLengthPublishDate))

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
            trim(substring(dbo.OmitCharacters(mft.titlelong, @omitTitleLong), 1, @maxLengthTitleLong)) as titlelong,
            trim(substring(dbo.OmitCharacters(mft.titleshort, @omitTitleShort), 1, @maxLengthTitleShort)) as titleshort,
            trim(substring(dbo.OmitCharacters(mft.publish_date, @omitPublishDate), 1, @maxLengthPublishDate)) as publish_date
            from dbo.MovieFeedTemp mft
            where
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
            group by mft.titlelong, mft.titleshort, mft.publish_date
          ),
          movieDetails as
          (
            -- Select unique records
            select
            smd.titlelong as titlelong,
            smd.titleshort as titleshort,
            smd.publish_date as publish_date,
            mfas.actionstatus as actionstatus,
            mf.mfID as mfID
            from subMovieDetails smd
            left join dbo.MovieFeed mf on mf.titlelong = smd.titlelong
            left join dbo.MovieFeed mfas on mfas.titleshort = smd.titleshort
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.titlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.titlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.titlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.titlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.titlelong like concat('%', mve.videoencode, '%')
            inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
            where
            mfas.actionstatus not in (1) and
            mf.mfID is not null and
            (
              (
                @yearString like '%|%' and
                (
                  smd.titlelong like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.titlelong like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.titlelong like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
          )

          -- Update records
          update dbo.MovieFeed
          set
          publish_date = cast(md.publish_date as datetime2(6)),
          modified_date = cast(getdate() as datetime2(6))
          from movieDetails md
          where
          md.mfID = dbo.MovieFeed.mfID

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
            trim(substring(dbo.OmitCharacters(tft.titlelong, @omitTitleLong), 1, @maxLengthTitleLong)) as titlelong,
            trim(substring(dbo.OmitCharacters(tft.titleshort, @omitTitleShort), 1, @maxLengthTitleShort)) as titleshort,
            trim(substring(dbo.OmitCharacters(tft.publish_date, @omitPublishDate), 1, @maxLengthPublishDate)) as publish_date
            from dbo.TVFeedTemp tft
            where
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
            group by tft.titlelong, tft.titleshort, tft.publish_date
          ),
          tvDetails as
          (
            -- Select unique records
            select
            std.titlelong as titlelong,
            std.titleshort as titleshort,
            std.publish_date as publish_date,
            tfas.actionstatus as actionstatus,
            tf.tfID as tfID
            from subTVDetails std
            left join dbo.TVFeed tf on tf.titlelong = std.titlelong
            left join dbo.TVFeed tfas on tfas.titleshort = std.titleshort
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.titlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.titlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.titlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.titlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.titlelong like concat('%', mve.videoencode, '%')
            inner join (select stdii.titlelong, max(stdii.publish_date) as publish_date from subTVDetails stdii group by stdii.titlelong) as stdi on stdi.titlelong = std.titlelong and stdi.publish_date = std.publish_date
            where
            tfas.actionstatus not in (1) and
            tf.tfID is not null
            group by std.titlelong, std.titleshort, std.publish_date, tfas.actionstatus, tf.tfID
          )

          -- Update records
          update dbo.TVFeed
          set
          publish_date = cast(td.publish_date as datetime2(6)),
          modified_date = cast(getdate() as datetime2(6))
          from tvDetails td
          where
          td.tfID = dbo.TVFeed.tfID

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
            trim(substring(dbo.OmitCharacters(mft.titlelong, @omitTitleLong), 1, @maxLengthTitleLong)) as titlelong,
            trim(substring(dbo.OmitCharacters(mft.titleshort, @omitTitleShort), 1, @maxLengthTitleShort)) as titleshort,
            trim(substring(dbo.OmitCharacters(mft.publish_date, @omitPublishDate), 1, @maxLengthPublishDate)) as publish_date
            from dbo.MovieFeedTemp mft
            where
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
            group by mft.titlelong, mft.titleshort, mft.publish_date
          ),
          movieDetails as
          (
            -- Select unique records
            select
            substring(dbo.OmitCharacters(smd.titlelong, @omitTitleLong), 1, 255) as titlelong,
            substring(dbo.OmitCharacters(smd.titleshort, @omitTitleShort), 1, 255) as titleshort,
            substring(dbo.OmitCharacters(smd.publish_date, @omitPublishDate), 1, 255) as publish_date,
            mfas.actionstatus as actionstatus,
            mf.mfID as mfID
            from subMovieDetails smd
            left join dbo.MovieFeed mf on mf.titlelong = smd.titlelong
            left join dbo.MovieFeed mfas on mfas.titleshort = smd.titleshort
            join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and smd.titlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.titlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.movieInclude in (1) and smd.titlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and smd.titlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and smd.titlelong like concat('%', mve.videoencode, '%')
            inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
            where
            (
              mfas.actionstatus not in (1) or
              mfas.actionstatus is null
            ) and
            mf.mfID is null and
            (
              (
                @yearString like '%|%' and
                (
                  smd.titlelong like concat('%', substring(@yearString, 1, 4), '%') or
                  smd.titlelong like concat('%', substring(@yearString, 6, 9), '%')
                )
              ) or
              (
                smd.titlelong like concat('%', substring(@yearString, 1, 4), '%')
              )
            )
            group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
          )

          -- Insert records
          insert into dbo.MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          md.titlelong,
          md.titleshort,
          cast(md.publish_date as datetime2(6)),
          iif(md.actionstatus is null, 0, md.actionstatus),
          cast(getdate() as datetime2(6)),
          cast(getdate() as datetime2(6))
          from movieDetails md
          group by md.titlelong, md.titleshort, md.publish_date, md.actionstatus

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
            trim(substring(dbo.OmitCharacters(tft.titlelong, @omitTitleLong), 1, @maxLengthTitleLong)) as titlelong,
            trim(substring(dbo.OmitCharacters(tft.titleshort, @omitTitleShort), 1, @maxLengthTitleShort)) as titleshort,
            trim(substring(dbo.OmitCharacters(tft.publish_date, @omitPublishDate), 1, @maxLengthPublishDate)) as publish_date
            from dbo.TVFeedTemp tft
            where
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
            group by tft.titlelong, tft.titleshort, tft.publish_date
          ),
          tvDetails as
          (
            -- Select unique records
            select
            std.titlelong as titlelong,
            std.titleshort as titleshort,
            std.publish_date as publish_date,
            tfas.actionstatus as actionstatus,
            tf.tfID as tfID
            from subTVDetails std
            left join dbo.TVFeed tf on tf.titlelong = std.titlelong
            left join dbo.TVFeed tfas on tfas.titleshort = std.titleshort
            join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and std.titlelong like concat('%', mae.audioencode, '%')
            left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and std.titlelong like concat('%', mdr.dynamicrange, '%')
            join dbo.MediaResolution mr on mr.tvInclude in (1) and std.titlelong like concat('%', mr.resolution, '%')
            left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and std.titlelong like concat('%', mss.streamsource, '%')
            join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and std.titlelong like concat('%', mve.videoencode, '%')
            inner join (select stdii.titlelong, max(stdii.publish_date) as publish_date from subTVDetails stdii group by stdii.titlelong) as stdi on stdi.titlelong = std.titlelong and stdi.publish_date = std.publish_date
            where
            (
              tfas.actionstatus not in (1) or
              tfas.actionstatus is null
            ) and
            tf.tfID is null
            group by std.titlelong, std.titleshort, std.publish_date, tfas.actionstatus, tf.tfID
          )

          -- Insert records
          insert into dbo.TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
          select
          td.titlelong,
          td.titleshort,
          cast(td.publish_date as datetime2(6)),
          iif(td.actionstatus is null, 0, td.actionstatus),
          cast(getdate() as datetime2(6)),
          cast(getdate() as datetime2(6))
          from tvDetails td
          group by td.titlelong, td.titleshort, td.publish_date, td.actionstatus

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
