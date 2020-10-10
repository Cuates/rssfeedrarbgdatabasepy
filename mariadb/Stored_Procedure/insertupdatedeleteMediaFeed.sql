-- Database Connect
use <databasename>;

-- ============================================
--        File: insertupdatedeleteMediaFeed
--     Created: 08/26/2020
--     Updated: 10/10/2020
--  Programmer: Cuates
--   Update By: Cuates
--     Purpose: Insert Update Delete Media Feed
-- ============================================

-- Procedure Drop
drop procedure if exists insertupdatedeleteMediaFeed;

-- Procedure Create
delimiter //
create procedure `insertupdatedeleteMediaFeed`(in optionMode text, in titlelong text, in titleshort text, in publishDate text)
  begin
    -- Declare variable
    declare yearString varchar(255);
    declare omitOptionMode varchar(255);
    declare omitTitleLong varchar(255);
    declare omitTitleShort varchar(255);
    declare omitPublishDate varchar(255);

    -- Set variable
    set yearString = '';
    set omitOptionMode = '[^a-zA-Z]';
    set omitTitleLong = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitTitleShort = '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
    set omitPublishDate = '[^0-9\-: ]';

    -- Check if parameter is not null
    if optionMode is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set optionMode = trim(regexp_replace(regexp_replace(optionMode, omitOptionMode, ' '), '[ ]{2,}', ' '));

      -- Set character limit
      set optionMode = substring(optionMode, 1, 255);

      -- Check if empty string
      if optionMode = '' then
        -- Set parameter to null if empty string
        set optionMode = nullif(optionMode, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titleLong is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set titlelong = trim(regexp_replace(regexp_replace(titlelong, omitTitleLong, ' '), '[ ]{2,}', ' '));

      -- Set character limit
      set titlelong = substring(titlelong, 1, 255);

      -- Check if empty string
      if titlelong = '' then
        -- Set parameter to null if empty string
        set titlelong = nullif(titlelong, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titleShort is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set titleshort = trim(regexp_replace(regexp_replace(titleshort, omitTitleShort, ' '), '[ ]{2,}', ' '));

      -- Set character limit
      set titleshort = substring(titleshort, 1, 255);

      -- Check if empty string
      if titleshort = '' then
        -- Set parameter to null if empty string
        set titleshort = nullif(titleshort, '');
      end if;
    end if;

    -- Check if parameter is not null
    if publishDate is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      set publishDate = trim(regexp_replace(regexp_replace(publishDate, omitPublishDate, ' '), '[ ]{2,}', ' '));

      -- Set character limit
      set publishDate = substring(publishDate, 1, 255);

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
      delete from MovieFeedTemp;

      -- Select message
      select
      'Success~Record(s) deleted' as `status`;

    -- Else check if option mode is delete temp tv
    elseif optionMode = 'deleteTempTV' then
      -- Delete records
      delete from TVFeedTemp;

      -- Select message
      select
      'Success~Record(s) deleted' as `status`;

    -- Check if option mode is insert temp movie
    elseif optionMode = 'insertTempMovie' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into MovieFeedTemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp(6));

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
        insert into TVFeedTemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp(6));

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
        trim(mft.titlelong) as `mfttitlelong`,
        trim(mft.titleshort) as `mfttitleshort`,
        mft.publish_date as `mftpublishdate`,
        mfas.actionstatus as `mfasactionstatus`,
        mf.mfID as `mfmfID`
        from MovieFeedTemp mft
        left join MovieFeed mf on mf.titlelong = mft.titlelong
        left join MovieFeed mfas on mfas.titleshort = mft.titleshort
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
          cast(mft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
          cast(mft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        )
        group by mft.titlelong, mft.titleshort, mft.publish_date, mfas.actionstatus, mf.mfID
      ),
      filteredMovieDetails as
      (
        -- Select unique records
        select
        smd.mfttitlelong as `titlelong`,
        max(smd.mftpublishdate) as `publishdate`
        from subMovieDetails smd
        group by smd.mfttitlelong
      ),
      movieDetails as
      (
        -- Select unique records
        select
        substring(trim(regexp_replace(regexp_replace(smd.mfttitlelong, omitTitleLong, ' '), '[ ]{2,}', ' ')), 1, 255) as `titlelong`,
        substring(trim(regexp_replace(regexp_replace(smd.mfttitleshort, omitTitleShort, ' '), '[ ]{2,}', ' ')), 1, 255) as `titleshort`,
        substring(trim(regexp_replace(regexp_replace(smd.mftpublishdate, omitPublishDate, ' '), '[ ]{2,}', ' ')), 1, 255) as `publishdate`,
        smd.mfasactionstatus as `actionstatus`,
        smd.mfmfID as `mfID`
        from subMovieDetails smd
        join filteredMovieDetails fmd on fmd.titlelong = smd.mfttitlelong and fmd.publishdate = smd.mftpublishdate
        join MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelong like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelong like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelong like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelong like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelong like concat('%', mve.videoencode, '%')
        where
        (
          (
            yearString like '%|%' and
            (
              smd.mfttitlelong like concat('%', substring(yearString, 1, 4), '%') or
              smd.mfttitlelong like concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.mfttitlelong like concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.mfttitlelong, smd.mfttitleshort, smd.mftpublishdate, smd.mfasactionstatus, smd.mfmfID
      )

      -- Select records
      select
      md.titlelong as `titlelong`,
      md.titleshort as `titleshort`,
      md.publishdate as `publishdate`,
      md.actionstatus as `actionstatus`,
      md.mfID as `mfID`
      from movieDetails md;

      -- Update records
      update MovieFeed mf
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
        trim(tft.titlelong) as `tfttitlelong`,
        trim(tft.titleshort) as `tfttitleshort`,
        tft.publish_date as `tftpublishdate`,
        tfas.actionstatus as `tfasactionstatus`,
        tf.tfID as `tftfID`
        from TVFeedTemp tft
        left join TVFeed tf on tf.titlelong = tft.titlelong
        left join TVFeed tfas on tfas.titleshort = tft.titleshort
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
          cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
          cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        )
        group by tft.titlelong, tft.titleshort, tft.publish_date, tfas.actionstatus, tf.tfID
      ),
      filteredTVDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as `titlelong`,
        max(std.tftpublishdate) as `publishdate`
        from subTVDetails std
        group by std.tfttitlelong
      ),
      tvDetails as
      (
        -- Select unique records
        select
        substring(trim(regexp_replace(regexp_replace(std.tfttitlelong, omitTitleLong, ' '), '[ ]{2,}', ' ')), 1, 255) as `titlelong`,
        substring(trim(regexp_replace(regexp_replace(std.tfttitleshort, omitTitleShort, ' '), '[ ]{2,}', ' ')), 1, 255) as `titleshort`,
        substring(trim(regexp_replace(regexp_replace(std.tftpublishdate, omitPublishDate, ' '), '[ ]{2,}', ' ')), 1, 255) as `publishdate`,
        std.tfasactionstatus as `actionstatus`,
        std.tftfID as `tfID`
        from subTVDetails std
        join filteredTVDetails ftd on ftd.titlelong = std.tfttitlelong and ftd.publishdate = std.tftpublishdate
        join MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
        group by std.tfttitlelong, std.tfttitleshort, std.publishdate, std.tfasactionstatus, std.tftfID
      )

      -- Select records
      select
      td.titlelong as `titlelong`,
      td.titleshort as `titleshort`,
      td.publishdate as `publish_date`,
      td.actionstatus as `actionstatus`,
      td.tfID as `tfID`
      from tvDetails td;

      -- Update records
      update TVFeed tf
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
      insert into MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        trim(mft.titlelong) as `mfttitlelong`,
        trim(mft.titleshort) as `mfttitleshort`,
        mft.publish_date as `mftpublishdate`,
        mfas.actionstatus as `mfasactionstatus`,
        mf.mfID as `mfmfID`
        from MovieFeedTemp mft
        left join MovieFeed mf on mf.titlelong = mft.titlelong
        left join MovieFeed mfas on mfas.titleshort = mft.titleshort
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
        --   cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
        --   cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        -- )
        group by mft.titlelong, mft.titleshort, mft.publish_date, mfas.actionstatus, mf.mfID
      ),
      filteredMovieDetails as
      (
        -- Select unique records
        select
        smd.mfttitlelong as `titlelong`,
        max(smd.mftpublishdate) as `publishdate`
        from subMovieDetails smd
        group by smd.mfttitlelong
      ),
      movieDetails as
      (
        -- Select unique records
        select
        substring(trim(regexp_replace(regexp_replace(smd.mfttitlelong, omitTitleLong, ' '), '[ ]{2,}', ' ')), 1, 255) as `titlelong`,
        substring(trim(regexp_replace(regexp_replace(smd.mfttitleshort, omitTitleShort, ' '), '[ ]{2,}', ' ')), 1, 255) as `titleshort`,
        substring(trim(regexp_replace(regexp_replace(smd.mftpublishdate, omitPublishDate, ' '), '[ ]{2,}', ' ')), 1, 255) as `publishdate`,
        smd.mfasactionstatus as `actionstatus`,
        smd.mfmfID as `mfID`
        from subMovieDetails smd
        join filteredMovieDetails fmd on fmd.titlelong = smd.mfttitlelong and fmd.publishdate = smd.mftpublishdate
        join MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelong like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelong like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelong like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelong like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelong like concat('%', mve.videoencode, '%')
        where
        (
          (
            yearString like '%|%' and
            (
              smd.mfttitlelong like concat('%', substring(yearString, 1, 4), '%') or
              smd.mfttitlelong like concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.mfttitlelong like concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.mfttitlelong, smd.mfttitleshort, smd.mftpublishdate, smd.mfasactionstatus, smd.mfmfID
      )

      -- Select records
      select
      md.titlelong,
      md.titleshort,
      cast(md.publishdate as datetime(6)),
      if(md.actionstatus is null, 0, md.actionstatus),
      cast(current_timestamp(6) as datetime(6)),
      cast(current_timestamp(6) as datetime(6))
      from movieDetails md
      left join MovieFeed mf on mf.mfID = md.mfID
      group by md.titlelong, md.titleshort, md.publishdate, md.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' as `status`;

    -- Else check if option mode is insert bulk tv
    elseif optionMode = 'insertBulkTV' then
      -- Insert records
      insert into TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        trim(tft.titlelong) as `tfttitlelong`,
        trim(tft.titleshort) as `tfttitleshort`,
        tft.publish_date as `tftpublishdate`,
        tfas.actionstatus as `tfasactionstatus`,
        tf.tfID as `tftfID`
        from TVFeedTemp tft
        left join TVFeed tf on tf.titlelong = tft.titlelong
        left join TVFeed tfas on tfas.titleshort = tft.titleshort
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
        --   cast(tft.publish_date as datetime(6)) >= date_add(current_timestamp(6), interval -1 hour) and
        --   cast(tft.publish_date as datetime(6)) <= date_add(current_timestamp(6), interval 0 hour)
        -- ) and
        group by tft.titlelong, tft.titleshort, tft.publish_date, tfas.actionstatus, tf.tfID
      ),
      filteredTVDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as `titlelong`,
        max(std.tftpublishdate) as `publishdate`
        from subTVDetails std
        group by std.tfttitlelong
      ),
      tvDetails as
      (
        -- Select unique records
        select
        substring(trim(regexp_replace(regexp_replace(std.tfttitlelong, omitTitleLong, ' '), '[ ]{2,}', ' ')), 1, 255) as `titlelong`,
        substring(trim(regexp_replace(regexp_replace(std.tfttitleshort, omitTitleShort, ' '), '[ ]{2,}', ' ')), 1, 255) as `titleshort`,
        substring(trim(regexp_replace(regexp_replace(std.tftpublishdate, omitPublishDate, ' '), '[ ]{2,}', ' ')), 1, 255) as `publishdate`,
        std.tfasactionstatus as `actionstatus`,
        std.tftfID as `tfID`
        from subTVDetails std
        join filteredTVDetails ftd on ftd.titlelong = std.tfttitlelong and ftd.publishdate = std.tftpublishdate
        join MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
        group by std.tfttitlelong, std.tfttitleshort, std.tftpublishdate, std.tfasactionstatus, std.tftfID
      )

      -- Select records
      select
      td.titlelong,
      td.titleshort,
      cast(td.publishdate as datetime(6)),
      if(td.actionstatus is null, 0, td.actionstatus),
      cast(current_timestamp(6) as datetime(6)),
      cast(current_timestamp(6) as datetime(6))
      from tvDetails td
      left join TVFeed tf on tf.tfID = td.tfID
      group by td.titlelong, td.titleshort, td.publishdate, td.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' as `status`;
    end if;
  end
// delimiter ;
