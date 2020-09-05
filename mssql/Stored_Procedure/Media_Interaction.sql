USE [media]
GO
/****** Object:  StoredProcedure [dbo].[Media_Interaction]    Script Date: 2020-09-05 09:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==============================
--        File: Media_Interaction
--     Created: 08/26/2020
--     Updated: 09/05/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Media interaction
-- ==============================
ALTER procedure [dbo].[Media_Interaction]
	-- Add the parameters for the stored procedure here
	@optionMode nvarchar(255),
  @titleLong nvarchar(255) = null,
  @titleShort nvarchar(255) = null,
  @publishDate nvarchar(255) = null,
  @audioEncode nvarchar(255) = null,
  @dynamicRange nvarchar(255) = null,
  @resolution nvarchar(255) = null,
  @streamSource nvarchar(255) = null,
  @videoEncode nvarchar(255) = null
as
begin
	-- Set nocount on added to prevent extra result sets from interfering with select statements
	set nocount on

	-- Declare variables
	declare @attempts as smallint
  declare @yearString as nvarchar(255)

	-- Set variables
	set @attempts = 1
  set @yearString = ''

	-- Omit characters
	set @optionMode = dbo.OmitCharacters(@optionMode, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

	-- Check if empty string
	if @optionMode = ''
		begin
			-- Set parameter to null if empty string
			set @optionMode = nullif(@optionMode, '')
		end

	-- Omit characters
	set @titleLong = dbo.OmitCharacters(@titleLong, '45,46,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,93,95,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

	-- Check if empty string
	if @titleLong = ''
		begin
			-- Set parameter to null if empty string
			set @titleLong = nullif(@titleLong, '')
		end

	-- Omit characters
	set @titleShort = dbo.OmitCharacters(@titleShort, '45,46,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,93,95,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

	-- Check if empty string
	if @titleShort = ''
		begin
			-- Set parameter to null if empty string
			set @titleShort = nullif(@titleShort, '')
		end

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

  -- Omit characters
  set @audioEncode = dbo.OmitCharacters(@audioEncode, '45,46,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @audioEncode = ''
    begin
      -- Set parameter to null if empty string
      set @audioEncode = nullif(@audioEncode, '')
    end

  -- Omit characters
  set @dynamicRange = dbo.OmitCharacters(@dynamicRange, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @dynamicRange = ''
    begin
      -- Set parameter to null if empty string
      set @dynamicRange = nullif(@dynamicRange, '')
    end

  -- Omit characters
  set @resolution = dbo.OmitCharacters(@resolution, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @resolution = ''
    begin
      -- Set parameter to null if empty string
      set @resolution = nullif(@resolution, '')
    end

  -- Omit characters
  set @streamSource = dbo.OmitCharacters(@streamSource, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @streamSource = ''
    begin
      -- Set parameter to null if empty string
      set @streamSource = nullif(@streamSource, '')
    end

  -- Omit characters
  set @videoEncode = dbo.OmitCharacters(@videoEncode, '48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if empty string
  if @videoEncode = ''
    begin
      -- Set parameter to null if empty string
      set @videoEncode = nullif(@videoEncode, '')
    end

  -- Check if option mode is extract media audio encode
  if @optionMode = 'extractMediaAudioEncode'
    begin
      -- Select records
      select
      ltrim(rtrim(mae.audioencode)) as [Audio Encode],
      iif(mae.movieInclude = 1, 'Yes', 'No') as [Movie Include],
      iif(mae.tvInclude = 1, 'Yes', 'No') as [TV Include]
      from dbo.MediaAudioEncode mae
      where
      mae.audioencode = @audioEncode
    end

  -- Else check if option mode is extract media dynamic range
  else if @optionMode = 'extractMediaDynamicRange'
    begin
      -- Select records
      select
      ltrim(rtrim(mdr.dynamicrange)) as [Dynamic Range],
      iif(mdr.movieInclude = 1, 'Yes', 'No') as [Movie Include],
      iif(mdr.tvInclude = 1, 'Yes', 'No') as [TV Include]
      from dbo.MediaDynamicRange mdr
      where
      mdr.dynamicrange = @dynamicRange
    end

  -- Else check if option mode is extract media resolution
  else if @optionMode = 'extractMediaResolution'
    begin
      -- Select records
      select
      ltrim(rtrim(mr.resolution)) as [Resolution],
      iif(mr.movieInclude = 1, 'Yes', 'No') as [Movie Include],
      iif(mr.tvInclude = 1, 'Yes', 'No') as [TV Include]
      from dbo.MediaResolution mr
      where
      mr.resolution = @resolution
    end

  -- Else check if option mode is extract media stream source
  else if @optionMode = 'extractMediaStreamSource'
    begin
      -- Select records
      select
      ltrim(rtrim(mss.streamsource)) as [Stream Source],
      iif(mss.movieInclude = 1, 'Yes', 'No') as [Movie Include],
      iif(mss.tvInclude = 1, 'Yes', 'No') as [TV Include]
      from dbo.MediaStreamSource mss
      where
      mss.streamsource = @streamSource
    end

  -- Else check if option mode is extract media video encode
  else if @optionMode = 'extractMediaVideoEncode'
    begin
      -- Select records
      select
      ltrim(rtrim(mve.videoencode)) as [Video Encode],
      iif(mve.movieInclude = 1, 'Yes', 'No') as [Movie Include],
      iif(mve.tvInclude = 1, 'Yes', 'No') as [TV Include]
      from dbo.MediaVideoEncode mve
      where
      mve.videoencode = @videoEncode
    end

  -- Else check if option mode is extract action status
  else if @optionMode = 'extractActionStatus'
    begin
      select
      ltrim(rtrim(ast.actionNumber)) as [Action Number],
      ltrim(rtrim(ast.actiondescription)) as [Action Description]
      from dbo.ActionStatus ast
      group by ast.actionnumber, ast.actiondescription
      order by ast.actionnumber asc, ast.actiondescription asc
    end

  -- Else check if option mode is extract media movie
  else if @optionMode = 'extractMediaMovie'
    begin
      -- Select records
      select
      ltrim(rtrim(mf.titlelong)) as [Title Long],
      ltrim(rtrim(mf.titleshort)) as [Title Short],
      format(cast(mf.publish_date as datetime2(7)), 'yyyy-MM-dd HH:mm:ss', 'en-us') as [Publish Date],
      ltrim(rtrim(ast.actiondescription)) as [Action Description]
      from dbo.MovieFeed mf
      left join dbo.ActionStatus ast on ast.actionnumber = mf.actionstatus
    end

  -- Else check if option mode is extract media tv
  else if @optionMode = 'extractMediaTV'
    begin
      -- Select records
      select
      ltrim(rtrim(tvf.titlelong)) as [Title Long],
      ltrim(rtrim(tvf.titleshort)) as [Title Short],
      format(cast(tvf.publish_date as datetime2(7)), 'yyyy-MM-dd HH:mm:ss', 'en-us') as [Publish Date],
      ltrim(rtrim(ast.actiondescription)) as [Action Description]
      from dbo.TVFeed tvf
      left join dbo.ActionStatus ast on ast.actionnumber = tvf.actionstatus
    end

	-- Else check if option mode is delete temp movie
	else if @optionMode = 'deleteTempMovie'
		begin
			-- Loop until condition is met
			while @attempts <= 5
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

							-- Break out of the loop
							break
						end try
						-- End try block
						-- Begin catch block
						begin catch
							-- Only display an error message if it is on the final attempt of the execution
							if @attempts = 5
								begin
									-- Select error number, line, and message
									select
									'Error~deleteTempMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
								end

							-- Check if there is trans count
							if @@trancount > 0
								begin
									-- Rollback to the previous state before the transaction was called
									rollback
								end

							-- Increments the loop control for attempts
							set @attempts = @attempts + 1

							-- Wait for delay for x amount of time
							waitfor delay '00:00:04'

							-- Continue the loop
							continue
						end catch
						-- End catch block
				end
		end

	-- Else check if option mode is delete temp tv
	else if @optionMode = 'deleteTempTV'
		begin
			-- Loop until condition is met
			while @attempts <= 5
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

							-- Break out of the loop
							break
						end try
						-- End try block
						-- Begin catch block
						begin catch
							-- Only display an error message if it is on the final attempt of the execution
							if @attempts = 5
								begin
									-- Select error number, line, and message
									select
									'Error~deleteTempTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
								end

							-- Check if there is trans count
							if @@trancount > 0
								begin
									-- Rollback to the previous state before the transaction was called
									rollback
								end

							-- Increments the loop control for attempts
							set @attempts = @attempts + 1

							-- Wait for delay for x amount of time
							waitfor delay '00:00:04'

							-- Continue the loop
							continue
						end catch
						-- End catch block
				end
		end

	-- Else check if option mode is insert temp movie
	else if @optionMode = 'insertTempMovie'
		begin
      -- Check if parameters are null
      if @titleLong is null or @titleShort is null or @publishDate is null
        begin
          -- Select message
          select
          'Error~Process halted, title long, title short, and or publish date were not provided' as [Status]
        end
      else
        begin
			    -- Loop until condition is met
			    while @attempts <= 5
				    begin
					    -- Begin the tranaction
					    begin tran
						    -- Begin the try block
						    begin try
                  -- Insert record
                  insert into dbo.MovieFeedTemp (titlelong, titleshort, publish_date, created_date) values (@titleLong, @titleShort, @publishDate, getdate())

							    -- Select message
							    select
							    'Success~Record(s) inserted' as [Status]

							    -- Check if there is trans count
							    if @@trancount > 0
								    begin
									    -- Commit transactional statement
									    commit tran
								    end

							    -- Break out of the loop
							    break
						    end try
						    -- End try block
						    -- Begin catch block
						    begin catch
							    -- Only display an error message if it is on the final attempt of the execution
							    if @attempts = 5
								    begin
									    -- Select error number, line, and message
									    select
									    'Error~insertTempMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
								    end

							    -- Check if there is trans count
							    if @@trancount > 0
								    begin
									    -- Rollback to the previous state before the transaction was called
									    rollback
								    end

							    -- Increments the loop control for attempts
							    set @attempts = @attempts + 1

							    -- Wait for delay for x amount of time
							    waitfor delay '00:00:04'

							    -- Continue the loop
							    continue
						    end catch
						    -- End catch block
				    end
        end
		end

	-- Else check if option mode is insert temp tv
	else if @optionMode = 'insertTempTV'
		begin
      -- Check if parameters are null
      if @titleLong is null or @titleShort is null or @publishDate is null
        begin
          -- Select message
          select
          'Error~Process halted, title long, title short, and or publish date were not provided' as [Status]
        end
      else
        begin
			    -- Loop until condition is met
			    while @attempts <= 5
				    begin
					    -- Begin the tranaction
					    begin tran
						    -- Begin the try block
						    begin try
                  -- Insert record
                  insert into dbo.TVFeedTemp (titlelong, titleshort, publish_date, created_date) values (@titleLong, @titleShort, @publishDate, getdate())

							    -- Select message
							    select
							    'Success~Record(s) inserted' as [Status]

							    -- Check if there is trans count
							    if @@trancount > 0
								    begin
									    -- Commit transactional statement
									    commit tran
								    end

							    -- Break out of the loop
							    break
						    end try
						    -- End try block
						    -- Begin catch block
						    begin catch
							    -- Only display an error message if it is on the final attempt of the execution
							    if @attempts = 5
								    begin
									    -- Select error number, line, and message
									    select
									    'Error~insertTempTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
								    end

							    -- Check if there is trans count
							    if @@trancount > 0
								    begin
									    -- Rollback to the previous state before the transaction was called
									    rollback
								    end

							    -- Increments the loop control for attempts
							    set @attempts = @attempts + 1

							    -- Wait for delay for x amount of time
							    waitfor delay '00:00:04'

							    -- Continue the loop
							    continue
						    end catch
						    -- End catch block
				    end
        end
		end

  -- Else check if option mode is update bulk movie
  else if @optionMode = 'updateBulkMovie'
    begin
      -- Loop until condition is met
      while @attempts <= 5
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Update records
              update mf
              set
              mf.titleshort = ltrim(rtrim(mft.titleshort)),
              mf.publish_date = cast(mft.publish_date as datetime2(7)),
              mf.modified_date = getdate()
              from dbo.MovieFeedTemp mft
              left join dbo.MovieFeed mf on mf.titleshort = mft.titleshort
              where
              (
                ltrim(rtrim(mft.titlelong)) <> '' and
                ltrim(rtrim(mft.titleshort)) <> '' and
                ltrim(rtrim(mft.publish_date)) <> ''
              ) and
              (
                mf.actionstatus not in (1) or
                mf.actionstatus is null
              ) and
              (
                mft.publish_date >= dateadd(minute, -60, getdate()) and
                mft.publish_date <= dateadd(minute, 0, getdate())
              ) and
              mf.titlelong is not null

              -- Select message
              select
              'Success~Record(s) updated' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end

              -- Break out of the loop
              break
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Only display an error message if it is on the final attempt of the execution
              if @attempts = 5
                begin
                  -- Select error number, line, and message
                  select 'Error~updateBulkMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
                end

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end

              -- Increments the loop control for attempts
              set @attempts = @attempts + 1

              -- Wait for delay for x amount of time
              waitfor delay '00:00:04'

              -- Continue the loop
              continue
            end catch
        end
    end

  -- Else check if option mode is insert bulk movie
  else if @optionMode = 'insertBulkMovie'
    begin
      -- Set variables
      set @yearString = iif(datepart(month, getdate()) <= 3, cast(datepart(year, dateadd(year, -1, getdate())) as nvarchar) + '|' + cast(datepart(year, getdate()) as nvarchar), cast(datepart(year, getdate()) as nvarchar))

      -- Loop until condition is met
      while @attempts <= 5
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Remove duplicate records based on group by
              ;with movieDetails as
              (
                -- Select unique records
                select
                distinct
                max(mft.publish_date) as [publish_date],
                mft.titlelong as [titlelong],
                mft.titleshort as [titleshort]
                from dbo.MovieFeedTemp mft
                join dbo.MediaAudioEncode mae on mae.movieInclude in (1) and mft.titlelong like '%' + mae.audioencode + '%'
                left join dbo.MediaDynamicRange mdr on mdr.movieInclude in (1) and mft.titlelong like '%' + mdr.dynamicrange + '%'
                join dbo.MediaResolution mr on mr.movieInclude in (1) and mft.titlelong like '%' + mr.resolution + '%'
                left join dbo.MediaStreamSource mss on mss.movieInclude in (1) and mft.titlelong like '%' + mss.streamsource + '%'
                join dbo.MediaVideoEncode mve on mve.movieInclude in (1) and mft.titlelong like '%' + mve.videoencode + '%'
                where
                (
                  (
                    @yearString like '%|%' and
                    (
                      mft.titlelong like '%' + substring(@yearString, 1, 4) + '%' or
                      mft.titlelong like '%' + substring(@yearString, 6, 9) + '%'
                    )
                  ) or
                  (
                    mft.titlelong like '%' + substring(@yearString, 1, 4) + '%'
                  )
                ) --and
                --(
                --  mft.publish_date >= dateadd(minute, -60, getdate()) and
                --  mft.publish_date <= dateadd(minute, 0, getdate())
                --)
                group by mft.titlelong, mft.titleshort
              )

              -- Insert records
              insert into dbo.MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
              select
              distinct
              ltrim(rtrim(md.titlelong)),
              ltrim(rtrim(md.titleshort)),
              cast(md.publish_date as datetime2(7)),
              cast(0 as int),
              getdate(),
              getdate()
              from movieDetails md
              left join dbo.MovieFeed mf on mf.titleshort = md.titleshort
              where
              (
                ltrim(rtrim(md.titlelong)) <> '' and
                ltrim(rtrim(md.titleshort)) <> '' and
                ltrim(rtrim(md.publish_date)) <> ''
              ) and
              (
                mf.actionstatus not in (1) or
                mf.actionstatus is null
              ) and
              mf.titlelong is null

              -- Select message
              select
              'Success~Record(s) inserted' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end

              -- Break out of the loop
              break
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Only display an error message if it is on the final attempt of the execution
              if @attempts = 5
                begin
                  -- Select error number, line, and message
                  select 'Error~insertBulkMovie: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
                end

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end

              -- Increments the loop control for attempts
              set @attempts = @attempts + 1

              -- Wait for delay for x amount of time
              waitfor delay '00:00:04'

              -- Continue the loop
              continue
            end catch
        end
    end

  -- Else check if option mode is update bulk tv
  else if @optionMode = 'updateBulkTV'
    begin
      -- Loop until condition is met
      while @attempts <= 5
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Update records
              update tf
              set
              tf.titleshort = ltrim(rtrim(tft.titleshort)),
              tf.publish_date = cast(tft.publish_date as datetime2(7)),
              tf.modified_date = getdate()
              from dbo.TVFeedTemp tft
              left join dbo.TVFeed tf on tf.titleshort = tft.titleshort
              where
              (
                ltrim(rtrim(tft.titlelong)) <> '' and
                ltrim(rtrim(tft.titleshort)) <> '' and
                ltrim(rtrim(tft.publish_date)) <> ''
              ) and
              (
                tf.actionstatus not in (1) or
                tf.actionstatus is null
              ) and
              (
                tft.publish_date >= dateadd(minute, -60, getdate()) and
                tft.publish_date <= dateadd(minute, 0, getdate())
              ) and
              tf.titlelong is not null

              -- Select message
              select
              'Success~Record(s) updated' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end

              -- Break out of the loop
              break
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Only display an error message if it is on the final attempt of the execution
              if @attempts = 5
                begin
                  -- Select error number, line, and message
                  select 'Error~updateBulkTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
                end

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end

              -- Increments the loop control for attempts
              set @attempts = @attempts + 1

              -- Wait for delay for x amount of time
              waitfor delay '00:00:04'

              -- Continue the loop
              continue
            end catch
        end
    end

  -- Else check if option mode is insert bulk tv
  else if @optionMode = 'insertBulkTV'
    begin
      -- Loop until condition is met
      while @attempts <= 5
        begin
          -- Begin the tranaction
          begin tran
            -- Begin the try block
            begin try
              -- Remove duplicate records based on group by
              ;with tvDetails as
              (
                -- Select unique records
                select
                distinct
                max(tft.publish_date) as [publish_date],
                tft.titlelong as [titlelong],
                tft.titleshort as [titleshort]
                from dbo.TVFeedTemp tft
                join dbo.MediaAudioEncode mae on mae.tvInclude in (1) and tft.titlelong like '%' + mae.audioencode + '%'
                left join dbo.MediaDynamicRange mdr on mdr.tvInclude in (1) and tft.titlelong like '%' + mdr.dynamicrange + '%'
                join dbo.MediaResolution mr on mr.tvInclude in (1) and tft.titlelong like '%' + mr.resolution + '%'
                left join dbo.MediaStreamSource mss on mss.tvInclude in (1) and tft.titlelong like '%' + mss.streamsource + '%'
                join dbo.MediaVideoEncode mve on mve.tvInclude in (1) and tft.titlelong like '%' + mve.videoencode + '%'
                --where
                --(
                --  tft.publish_date >= dateadd(minute, -60, getdate()) and
                --  tft.publish_date <= dateadd(minute, 0, getdate())
                --)
                group by tft.titlelong, tft.titleshort
              )

              -- Insert records
              insert into dbo.TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)
              select
              distinct
              ltrim(rtrim(td.titlelong)),
              ltrim(rtrim(td.titleshort)),
              cast(td.publish_date as datetime2(7)),
              cast(0 as int),
              getdate(),
              getdate()
              from tvDetails td
              left join dbo.TVFeed tf on tf.titleshort = td.titleshort
              where
              (
                ltrim(rtrim(td.titlelong)) <> '' and
                ltrim(rtrim(td.titleshort)) <> '' and
                ltrim(rtrim(td.publish_date)) <> ''
              ) and
              (
                tf.actionstatus not in (1) or
                tf.actionstatus is null
              ) and
              tf.titlelong is null

              -- Select message
              select
              'Success~Record(s) inserted' as [Status]

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Commit transactional statement
                  commit tran
                end

              -- Break out of the loop
              break
            end try
            -- End try block
            -- Begin catch block
            begin catch
              -- Only display an error message if it is on the final attempt of the execution
              if @attempts = 5
                begin
                  -- Select error number, line, and message
                  select 'Error~insertBulkTV: Error Number: ' + cast(error_number() as nvarchar) + ' Error Line: ' + cast(error_line() as nvarchar) + ' Error Message: ' + error_message() as [Status]
                end

              -- Check if there is trans count
              if @@trancount > 0
                begin
                  -- Rollback to the previous state before the transaction was called
                  rollback
                end

              -- Increments the loop control for attempts
              set @attempts = @attempts + 1

              -- Wait for delay for x amount of time
              waitfor delay '00:00:04'

              -- Continue the loop
              continue
            end catch
        end
    end
end
