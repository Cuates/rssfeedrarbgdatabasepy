-- Database Connect
-- use <databasename>;

-- =================================================
--        File: insertupdatedeletebulkmediafeed
--     Created: 08/26/2020
--     Updated: 09/15/2023
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert update delete bulk media feed
-- =================================================

-- Procedure Drop
drop procedure if exists insertupdatedeletebulkmediafeed;

-- Procedure Create
delimiter //
create procedure `insertupdatedeletebulkmediafeed`(in optionMode text, in titlelong text, in titleshort text, in publishdate text, in infourl text)
  begin
    -- Declare variable
    declare yearString varchar(255);
    declare omitOptionMode varchar(255);
    declare omitTitleLong varchar(255);
    declare omitTitleShort varchar(255);
    declare omitPublishDate varchar(255);
    declare omitInfoUrl varchar(8000);
    declare maxLengthOptionMode int;
    declare maxLengthTitleLong int;
    declare maxLengthTitleShort int;
    declare maxLengthPublishDate int;
    declare maxLengthInfoUrl int;
    declare code varchar(5) default '00000';
    declare msg text;
    declare result text;
    declare successcode varchar(5);

    -- Declare exception handler for failed insert
    declare CONTINUE HANDLER FOR SQLEXCEPTION
      begin
        GET DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
      end;

    -- Set variable
    set yearString = '';
    set omitOptionMode = '[^a-zA-Z]';
    set omitTitleLong = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitTitleShort = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitPublishDate = '[^0-9\-:./ ]';
    set omitInfoUrl = '[^a-zA-Z0-9\-./%?=&]';
    set maxLengthOptionMode = 255;
    set maxLengthTitleLong = 255;
    set maxLengthTitleShort = 255;
    set maxLengthPublishDate = 255;
    set maxLengthInfoUrl = 8000;
    set successcode = '00000';

    -- Check if parameter is not null
    if optionMode is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set optionMode = regexp_replace(regexp_replace(optionMode, omitOptionMode, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set optionMode = trim(substring(optionMode, 1, maxLengthOptionMode));

      -- Check if empty string
      if optionMode = '' then
        -- Set parameter to null if empty string
        set optionMode = nullif(optionMode, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titlelong is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set titlelong = regexp_replace(regexp_replace(titlelong, omitTitleLong, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set titlelong = trim(substring(titlelong, 1, maxLengthTitleLong));

      -- Check if empty string
      if titlelong = '' then
        -- Set parameter to null if empty string
        set titlelong = nullif(titlelong, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titleshort is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set titleshort = regexp_replace(regexp_replace(titleshort, omitTitleShort, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set titleshort = trim(substring(titleshort, 1, maxLengthTitleShort));

      -- Check if empty string
      if titleshort = '' then
        -- Set parameter to null if empty string
        set titleshort = nullif(titleshort, '');
      end if;
    end if;

    -- Check if parameter is not null
    if publishdate is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set publishdate = regexp_replace(regexp_replace(publishdate, omitPublishDate, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set publishdate = trim(substring(publishdate, 1, maxLengthPublishDate));

      -- Check if the parameter cannot be casted into a date time
      if str_to_date(publishdate, '%Y-%m-%d %H:%i:%S') is null then
        -- Set the string as empty to be nulled below
        set publishdate = '';
      end if;

      -- Check if empty string
      if publishdate = '' then
        -- Set parameter to null if empty string
        set publishdate = nullif(publishdate, '');
      end if;
    end if;

    -- Check if parameter is not null
    if infourl is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set infourl = regexp_replace(regexp_replace(infourl, omitInfoUrl, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set infourl = trim(substring(infourl, 1, maxLengthInfoUrl));

      -- Check if empty string
      if infourl = '' then
        -- Set parameter to null if empty string
        set infourl = nullif(infourl, '');
      end if;
    end if;

    -- Check if option mode is delete temp movie
    if optionMode = 'deleteTempMovie' then
      -- Start the transaction
      start transaction;
        -- Delete records
        delete mft
        from moviefeedtemp mft;

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) Delete"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

      -- Select message
      select
      result as `status`;

    -- Else check if option mode is delete temp tv
    elseif optionMode = 'deleteTempTV' then
      -- Start the transaction
      start transaction;
        -- Delete records
        delete tft
        from tvfeedtemp tft;

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) Delete"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

      -- Select message
      select
      result as `status`;

    -- Check if option mode is insert temp movie
    elseif optionMode = 'insertTempMovie' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishdate is not null then
        -- Start the transaction
        start transaction;
          -- Insert record
          insert into moviefeedtemp
          (
            titlelong,
            titleshort,
            info_url,
            publish_date,
            created_date
          )
          values
          (
            titlelong,
            lower(titleshort),
            infourl,
            publishdate,
            current_timestamp(6)
          );

          -- Check whether the insert was successful
          if code = successcode then
            -- Commit transactional statement
            commit;

            -- Set message
            set result = concat('{"Status": "Success", "Message": "Record(s) inserted"}');
          else
            -- Rollback to the previous state before the transaction was called
            rollback;

            -- Set message
            set result = concat('{"Status": "Error", "Message": "', msg, '"}');
          end if;
      else
        -- Else parameters were not given
        -- Set message
        set result = concat('{"Status": "Error", "Message": "Process halted, titlelong, titleshort, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result as `status`;

    -- Check if option mode is insert temp tv
    elseif optionMode = 'insertTempTV' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishdate is not null then
        -- Insert record
        insert into tvfeedtemp
        (
          titlelong,
          titleshort,
          info_url,
          publish_date,
          created_date
        )
        values
        (
          titlelong,
          lower(titleshort),
          infourl,
          publishdate,
          current_timestamp(6)
        );

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) inserted"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;
      else
        -- Else parameters were not given
        -- Set message
        set result = concat('{"Status": "Error", "Message": "Process halted, titlelong, titleshort, and or publish date were not provided"}');
      end if;

      -- Select message
      select
      result as `status`;

    -- Else check if option mode is update bulk movie
    elseif optionMode = 'updateBulkMovie' then
      -- Set variable
      select
      if(date_format(date_add(current_timestamp(6), interval 0 month), '%m') <= '03', concat(date_format(date_add(current_timestamp(6), interval -1 year), '%Y'), '|', date_format(date_add(current_timestamp(6), interval 0 year), '%Y')), date_format(date_add(current_timestamp(6), interval 0 year), '%Y'))
      into yearString;

      -- Create temporary table
      create temporary table if not exists MovieFeedTempTable
      (
        `mfID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `info_url` varchar(8000) collate utf8mb4_unicode_520_ci null,
        `publish_date` datetime not null,
        `actionstatus` int(11) null
      );

      -- Insert records
      insert into MovieFeedTempTable (titlelong, titleshort, info_url, publish_date, actionstatus, mfID)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
        trim(substring(regexp_replace(regexp_replace(mft.info_url, omitInfoUrl, ' '), '[ ]{2,}', ' '), 1, maxLengthInfoUrl)) as `info_url`,
        trim(substring(regexp_replace(regexp_replace(mft.publish_date, omitPublishDate, ' '), '[ ]{2,}', ' '), 1, maxLengthPublishDate)) as `publish_date`
        from moviefeedtemp mft
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
        )
        group by mft.titlelong, mft.titleshort, mft.info_url, mft.publish_date
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.titlelong as `titlelong`,
        smd.titleshort as `titleshort`,
        smd.info_url as `info_url`,
        smd.publish_date as `publish_date`,
        mfas.actionstatus as `actionstatus`,
        mf.mfID as `mfID`
        from subMovieDetails smd
        left join moviefeed mf on mf.titlelong = smd.titlelong
        left join moviefeed mfas on mfas.titleshort = smd.titleshort
        join mediaaudioencode mae on mae.movieInclude in (1) and smd.titlelong like concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.movieInclude in (1) and smd.titlelong like concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.movieInclude in (1) and smd.titlelong like concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.movieInclude in (1) and smd.titlelong like concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.movieInclude in (1) and smd.titlelong like concat('%', mve.videoencode, '%')
        inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
        where
        mfas.actionstatus not in (1) and
        mf.mfID is not null and
        (
          (
            yearString like '%|%' and
            (
              smd.titlelong like concat('%', substring(yearString, 1, 4), '%') or
              smd.titlelong like concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.titlelong like concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.titlelong, smd.titleshort, smd.info_url, smd.publish_date, mfas.actionstatus, mf.mfID
      )

      -- Select records
      select
      md.titlelong as `titlelong`,
      md.titleshort as `titleshort`,
      md.info_url as `info_url`,
      md.publish_date as `publish_date`,
      md.actionstatus as `actionstatus`,
      md.mfID as `mfID`
      from movieDetails md;

      -- Start the tranaction
      start transaction;
        -- Update records
        update moviefeed mf
        inner join MovieFeedTempTable mftt on mftt.mfID = mf.mfID
        set
        mf.publish_date = cast(mftt.publish_date as datetime),
        mf.modified_date = cast(current_timestamp(6) as datetime);

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) updated"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

        -- Drop temporary table
        drop temporary table MovieFeedTempTable;

      -- Select message
      select
      result as `status`;

    -- Else check if option mode is update bulk tv
    elseif optionMode = 'updateBulkTV' then
      -- Create temporary table
      create temporary table if not exists TVFeedTempTable
      (
        `tfID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `info_url` varchar(8000) collate utf8mb4_unicode_520_ci null,
        `publish_date` datetime not null,
        `actionstatus` int(11) null
      );

      -- Insert records
      insert into TVFeedTempTable (titlelong, titleshort, info_url, publish_date, actionstatus, tfID)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
        trim(substring(regexp_replace(regexp_replace(tft.info_url, omitInfoUrl, ' '), '[ ]{2,}', ' '), 1, maxLengthInfoUrl)) as `info_url`,
        trim(substring(regexp_replace(regexp_replace(tft.publish_date, omitPublishDate, ' '), '[ ]{2,}', ' '), 1, maxLengthPublishDate)) as `publish_date`
        from tvfeedtemp tft
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
        )
        group by tft.titlelong, tft.titleshort, tft.info_url, tft.publish_date
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.titlelong as `titlelong`,
        std.titleshort as `titleshort`,
        std.info_url as `info_url`,
        std.publish_date as `publish_date`,
        tfas.actionstatus as `actionstatus`,
        tf.tfID as `tfID`
        from subTVDetails std
        left join tvfeed tf on tf.titlelong = std.titlelong
        left join tvfeed tfas on tfas.titleshort = std.titleshort
        join mediaaudioencode mae on mae.tvInclude in (1) and std.titlelong like concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.tvInclude in (1) and std.titlelong like concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.tvInclude in (1) and std.titlelong like concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.tvInclude in (1) and std.titlelong like concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.tvInclude in (1) and std.titlelong like concat('%', mve.videoencode, '%')
        inner join (select stdii.titlelong, max(stdii.publish_date) as publish_date from subTVDetails stdii group by stdii.titlelong) as stdi on stdi.titlelong = std.titlelong and stdi.publish_date = std.publish_date
        where
        tfas.actionstatus not in (1) and
        tf.tfID is not null
        group by std.titlelong, std.titleshort, std.info_url, std.publish_date, tfas.actionstatus, tf.tfID
      )

      -- Select records
      select
      td.titlelong as `titlelong`,
      td.titleshort as `titleshort`,
      td.info_url as `info_url`,
      td.publish_date as `publish_date`,
      td.actionstatus as `actionstatus`,
      td.tfID as `tfID`
      from tvDetails td;

      -- Start the tranaction
      start transaction;
        -- Update records
        update tvfeed tf
        inner join TVFeedTempTable tftt on tftt.tfID = tf.tfID
        set
        tf.publish_date = cast(tftt.publish_date as datetime),
        tf.modified_date = cast(current_timestamp(6) as datetime);

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) updated"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

        -- Drop temporary table
        drop temporary table TVFeedTempTable;

      -- Select message
      select
      result as `status`;

    -- Else check if option mode is insert bulk movie
    elseif optionMode = 'insertBulkMovie' then
      -- Set variable
      select
      if(date_format(date_add(current_timestamp(6), interval 0 month), '%m') <= '03', concat(date_format(date_add(current_timestamp(6), interval -1 year), '%Y'), '|', date_format(date_add(current_timestamp(6), interval 0 year), '%Y')), date_format(date_add(current_timestamp(6), interval 0 year), '%Y'))
      into yearString;

      -- Start the tranaction
      start transaction;
        -- Insert records
        insert into moviefeed (titlelong, titleshort, info_url, publish_date, actionstatus, created_date, modified_date)

        -- Remove duplicate records based on group by
        with subMovieDetails as
        (
          -- Select unique records
          select
          trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
          trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
          trim(substring(regexp_replace(regexp_replace(mft.info_url, omitInfoUrl, ' '), '[ ]{2,}', ' '), 1, maxLengthInfoUrl)) as `info_url`,
          trim(substring(regexp_replace(regexp_replace(mft.publish_date, omitPublishDate, ' '), '[ ]{2,}', ' '), 1, maxLengthPublishDate)) as `publish_date`
          from moviefeedtemp mft
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
          )
          group by mft.titlelong, mft.titleshort, mft.info_url, mft.publish_date
        ),
        movieDetails as
        (
          -- Select unique records
          select
          smd.titlelong as `titlelong`,
          smd.titleshort as `titleshort`,
          smd.info_url as `info_url`,
          smd.publish_date as `publish_date`,
          mfas.actionstatus as `actionstatus`,
          mf.mfID as `mfID`
          from subMovieDetails smd
          left join moviefeed mf on mf.titlelong = smd.titlelong
          left join moviefeed mfas on mfas.titleshort = smd.titleshort
          join mediaaudioencode mae on mae.movieInclude in (1) and smd.titlelong like concat('%', mae.audioencode, '%')
          left join mediadynamicrange mdr on mdr.movieInclude in (1) and smd.titlelong like concat('%', mdr.dynamicrange, '%')
          join mediaresolution mr on mr.movieInclude in (1) and smd.titlelong like concat('%', mr.resolution, '%')
          left join mediastreamsource mss on mss.movieInclude in (1) and smd.titlelong like concat('%', mss.streamsource, '%')
          join mediavideoencode mve on mve.movieInclude in (1) and smd.titlelong like concat('%', mve.videoencode, '%')
          inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
          where
          (
            mfas.actionstatus not in (1) or
            mfas.actionstatus is null
          ) and
          mf.mfID is null and
          (
            (
              yearString like '%|%' and
              (
                smd.titlelong like concat('%', substring(yearString, 1, 4), '%') or
                smd.titlelong like concat('%', substring(yearString, 6, 9), '%')
              )
            ) or
            (
              smd.titlelong like concat('%', substring(yearString, 1, 4), '%')
            )
          )
          group by smd.titlelong, smd.titleshort, smd.info_url, smd.publish_date, mfas.actionstatus, mf.mfID
        )

        -- Select records
        select
        md.titlelong,
        md.titleshort,
        md.info_url,
        cast(md.publish_date as datetime),
        if(md.actionstatus is null, 0, md.actionstatus),
        cast(current_timestamp(6) as datetime),
        cast(current_timestamp(6) as datetime)
        from movieDetails md
        group by md.titlelong, md.titleshort, md.info_url, md.publish_date, md.actionstatus;

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) inserted"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

      -- Select message
      select
      result as `status`;

    -- Else check if option mode is insert bulk tv
    elseif optionMode = 'insertBulkTV' then
      -- Start the tranaction
      start transaction;
        -- Insert records
        insert into tvfeed (titlelong, titleshort, info_url, publish_date, actionstatus, created_date, modified_date)

        -- Remove duplicate records based on group by
        with subTVDetails as
        (
          -- Select unique records
          select
          trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
          trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
          trim(substring(regexp_replace(regexp_replace(tft.info_url, omitInfoUrl, ' '), '[ ]{2,}', ' '), 1, maxLengthInfoUrl)) as `info_url`,
          trim(substring(regexp_replace(regexp_replace(tft.publish_date, omitPublishDate, ' '), '[ ]{2,}', ' '), 1, maxLengthPublishDate)) as `publish_date`
          from tvfeedtemp tft
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
          )
          group by tft.titlelong, tft.titleshort, tft.info_url, tft.publish_date
        ),
        tvDetails as
        (
          -- Select unique records
          select
          std.titlelong as `titlelong`,
          std.titleshort as `titleshort`,
          std.info_url as `info_url`,
          std.publish_date as `publish_date`,
          tfas.actionstatus as `actionstatus`,
          tf.tfID as `tfID`
          from subTVDetails std
          left join tvfeed tf on tf.titlelong = std.titlelong
          left join tvfeed tfas on tfas.titleshort = std.titleshort
          join mediaaudioencode mae on mae.tvInclude in (1) and std.titlelong like concat('%', mae.audioencode, '%')
          left join mediadynamicrange mdr on mdr.tvInclude in (1) and std.titlelong like concat('%', mdr.dynamicrange, '%')
          join mediaresolution mr on mr.tvInclude in (1) and std.titlelong like concat('%', mr.resolution, '%')
          left join mediastreamsource mss on mss.tvInclude in (1) and std.titlelong like concat('%', mss.streamsource, '%')
          join mediavideoencode mve on mve.tvInclude in (1) and std.titlelong like concat('%', mve.videoencode, '%')
          inner join (select stdii.titlelong, max(stdii.publish_date) as publish_date from subTVDetails stdii group by stdii.titlelong) as stdi on stdi.titlelong = std.titlelong and stdi.publish_date = std.publish_date
          where
          (
            tfas.actionstatus not in (1) or
            tfas.actionstatus is null
          ) and
          tf.tfID is null
          group by std.titlelong, std.titleshort, std.info_url, std.publish_date, tfas.actionstatus, tf.tfID
        )

        -- Select records
        select
        td.titlelong,
        td.titleshort,
        td.info_url,
        cast(td.publish_date as datetime),
        if(td.actionstatus is null, 0, td.actionstatus),
        cast(current_timestamp(6) as datetime),
        cast(current_timestamp(6) as datetime)
        from tvDetails td
        group by td.titlelong, td.titleshort, td.info_url, td.publish_date, td.actionstatus;

        -- Check whether the insert was successful
        if code = successcode then
          -- Commit transactional statement
          commit;

          -- Set message
          set result = concat('{"Status": "Success", "Message": "Record(s) inserted"}');
        else
          -- Rollback to the previous state before the transaction was called
          rollback;

          -- Set message
          set result = concat('{"Status": "Error", "Message": "', msg, '"}');
        end if;

      -- Select message
      select
      result as `status`;
    end if;
  end
// delimiter ;
