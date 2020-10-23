-- Database Connect
use <databasename>;

-- =================================================
--        File: insertupdatedeletebulkmediafeed
--     Created: 08/26/2020
--     Updated: 10/22/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert update delete bulk media feed
-- =================================================

-- Procedure Drop
drop procedure if exists insertupdatedeletebulkmediafeed;

-- Procedure Create
delimiter //
create procedure `insertupdatedeletebulkmediafeed`(in optionMode text, in titlelong text, in titleshort text, in publishDate text)
  begin
    -- Declare variable
    declare yearString varchar(255);
    declare omitOptionMode varchar(255);
    declare omitTitleLong varchar(255);
    declare omitTitleShort varchar(255);
    declare omitPublishDate varchar(255);
    declare maxLengthOptionMode int;
    declare maxLengthTitleLong int;
    declare maxLengthTitleShort int;
    declare maxLengthPublishDate int;

    -- Set variable
    set yearString = '';
    set omitOptionMode = '[^a-zA-Z]';
    set omitTitleLong = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitTitleShort = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitPublishDate = '[^0-9\-: ]';
    set maxLengthOptionMode = 255;
    set maxLengthTitleLong = 255;
    set maxLengthTitleShort = 255;
    set maxLengthPublishDate = 255;

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
    if titleLong is not null then
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
    if titleShort is not null then
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
    if publishDate is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set publishDate = regexp_replace(regexp_replace(publishDate, omitPublishDate, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      set publishDate = trim(substring(publishDate, 1, maxLengthPublishDate));

      -- Check if the parameter cannot be casted into a date time
      if str_to_date(publishDate, '%Y-%m-%d %H:%i:%S') is null then
        -- Set the string as empty to be nulled below
        set publishDate = '';
      end if;

      -- Check if empty string
      if publishDate = '' then
        -- Set parameter to null if empty string
        set publishDate = nullif(publishDate, '');
      end if;
    end if;

    -- Check if option mode is delete temp movie
    if optionMode = 'deleteTempMovie' then
      -- Delete records
      delete from moviefeedtemp;

      -- Select message
      select
      'Success~Record(s) deleted' as `status`;

    -- Else check if option mode is delete temp tv
    elseif optionMode = 'deleteTempTV' then
      -- Delete records
      delete from tvfeedtemp;

      -- Select message
      select
      'Success~Record(s) deleted' as `status`;

    -- Check if option mode is insert temp movie
    elseif optionMode = 'insertTempMovie' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into moviefeedtemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp(6));

        -- Select message
        select
        'Success~Record(s) inserted' as `status`;
      else
        -- Select message
        select
        'Error~Process halted, titlelong, titleshort, and or publish date were not provided' as `status`;
      end if;

    -- Check if option mode is insert temp tv
    elseif optionMode = 'insertTempTV' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into tvfeedtemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp(6));

        -- Select message
        select
        'Success~Record(s) inserted' as `status`;
      else
        -- Select message
        select
        'Error~Process halted, titlelong, titleshort, and or publish date were not provided' as `status`;
      end if;

    -- Else check if option mode is update bulk movie
    elseif optionMode = 'updateBulkMovie' then
      -- Set variable
      select
      if(date_format(date_add(current_timestamp(), interval 0 month), '%m') <= '03', concat(date_format(date_add(current_timestamp(), interval -1 year), '%Y'), '|', date_format(date_add(current_timestamp(), interval 0 year), '%Y')), date_format(date_add(current_timestamp(), interval 0 year), '%Y'))
      into yearString;

      -- Create temporary table
      create temporary table if not exists MovieFeedTempTable
      (
        `mfID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `publish_date` datetime(6) not null,
        `actionstatus` int(11) null
      );

      -- Insert records
      insert into MovieFeedTempTable (titlelong, titleshort, publish_date, actionstatus, mfID)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
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
        ) and
        (
          cast(mft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
          cast(mft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        )
        group by mft.titlelong, mft.titleshort, mft.publish_date
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.titlelong as `titlelong`,
        smd.titleshort as `titleshort`,
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
        group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
      )

      -- Select records
      select
      md.titlelong as `titlelong`,
      md.titleshort as `titleshort`,
      md.publish_date as `publish_date`,
      md.actionstatus as `actionstatus`,
      md.mfID as `mfID`
      from movieDetails md;

      -- Update records
      update moviefeed mf
      inner join MovieFeedTempTable mftt on mftt.mfID = mf.mfID
      set
      mf.publish_date = cast(mftt.publish_date as datetime(6)),
      mf.modified_date = cast(current_timestamp(6) as datetime(6));

      -- Drop temporary table
      drop temporary table MovieFeedTempTable;

      -- Select message
      select
      'Success~Record(s) updated' as `status`;

    -- Else check if option mode is update bulk tv
    elseif optionMode = 'updateBulkTV' then
      -- Create temporary table
      create temporary table if not exists TVFeedTempTable
      (
        `tfID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `publish_date` datetime(6) not null,
        `actionstatus` int(11) null
      );

      -- Insert records
      insert into TVFeedTempTable (titlelong, titleshort, publish_date, actionstatus, tfID)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
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
        ) and
        (
          cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
          cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        )
        group by tft.titlelong, tft.titleshort, tft.publish_date
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.titlelong as `titlelong`,
        std.titleshort as `titleshort`,
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
        group by std.titlelong, std.titleshort, std.publish_date, tfas.actionstatus, tf.tfID
      )

      -- Select records
      select
      td.titlelong as `titlelong`,
      td.titleshort as `titleshort`,
      td.publish_date as `publish_date`,
      td.actionstatus as `actionstatus`,
      td.tfID as `tfID`
      from tvDetails td;

      -- Update records
      update tvfeed tf
      inner join TVFeedTempTable tftt on tftt.tfID = tf.tfID
      set
      tf.publish_date = cast(tftt.publish_date as datetime(6)),
      tf.modified_date = cast(current_timestamp(6) as datetime(6));

      -- Select message
      select
      'Success~Record(s) updated' as `status`;

    -- Else check if option mode is insert bulk movie
    elseif optionMode = 'insertBulkMovie' then
      -- Set variable
      select
      if(date_format(date_add(current_timestamp(), interval 0 month), '%m') <= '03', concat(date_format(date_add(current_timestamp(), interval -1 year), '%Y'), '|', date_format(date_add(current_timestamp(), interval 0 year), '%Y')), date_format(date_add(current_timestamp(), interval 0 year), '%Y'))
      into yearString;

      -- Insert records
      insert into moviefeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
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
        ) -- and
        -- (
        --   cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
        --   cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        -- )
        group by mft.titlelong, mft.titleshort, mft.publish_date
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.titlelong as `titlelong`,
        smd.titleshort as `titleshort`,
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
        group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
      )

      -- Select records
      select
      md.titlelong,
      md.titleshort,
      cast(md.publish_date as datetime(6)),
      if(md.actionstatus is null, 0, md.actionstatus),
      cast(current_timestamp(6) as datetime(6)),
      cast(current_timestamp(6) as datetime(6))
      from movieDetails md
      group by md.titlelong, md.titleshort, md.publish_date, md.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' as `status`;

    -- Else check if option mode is insert bulk tv
    elseif optionMode = 'insertBulkTV' then
      -- Insert records
      insert into tvfeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleLong)) as `titlelong`,
        trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '), 1, maxLengthTitleShort)) as `titleshort`,
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
        ) -- and
        -- (
        --   cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
        --   cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        -- ) and
        group by tft.titlelong, tft.titleshort, tft.publish_date
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.titlelong as `titlelong`,
        std.titleshort as `titleshort`,
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
        group by std.titlelong, std.titleshort, std.publish_date, tfas.actionstatus, tf.tfID
      )

      -- Select records
      select
      td.titlelong,
      td.titleshort,
      cast(td.publish_date as datetime(6)),
      if(td.actionstatus is null, 0, td.actionstatus),
      cast(current_timestamp(6) as datetime(6)),
      cast(current_timestamp(6) as datetime(6))
      from tvDetails td
      group by td.titlelong, td.titleshort, td.publish_date, td.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' as `status`;
    end if;
  end
// delimiter ;
