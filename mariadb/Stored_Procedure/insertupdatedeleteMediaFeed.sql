-- Database Connect
use <databasename>;

-- ============================================
--        File: insertupdatedeleteMediaFeed
--     Created: 08/26/2020
--     Updated: 09/27/2020
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

    -- Set variable
    set yearString = '';

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    set optionMode = trim(regexp_replace(regexp_replace(optionMode, '[^a-zA-Z]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if optionMode = '' then
      -- Set parameter to null if empty string
      set optionMode = nullif(optionMode, '');
    end if;

    -- Set character limit
    set optionMode = substring(optionMode, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    set titlelong = trim(regexp_replace(regexp_replace(titlelong, '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if titlelong = '' then
      -- Set parameter to null if empty string
      set titlelong = nullif(titlelong, '');
    end if;

    -- Set character limit
    set titlelong = substring(titlelong, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    set titleshort = trim(regexp_replace(regexp_replace(titleshort, '[^a-zA-Z0-9 !"\#$%&\'()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if titleshort = '' then
      -- Set parameter to null if empty string
      set titleshort = nullif(titleshort, '');
    end if;

    -- Set character limit
    set titleshort = substring(titleshort, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    set publishDate = trim(regexp_replace(regexp_replace(publishDate, '[^0-9\-: ]', ' '), '[ ]{2,}', ' '));

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

    -- Set character limit
    set publishDate = substring(publishDate, 1, 255);

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
        `mfttID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `actionstatus` varchar(255) collate utf8mb4_unicode_520_ci default null,
        `publish_date` datetime not null
      );

      -- Insert records
      insert into MovieFeedTempTable (titlelong, titleshort, actionstatus, publish_date, mfttID)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        trim(mft.titlelong) as `mfttitlelong`,
        lower(trim(mft.titlelong)) as `mfttitlelonglower`,
        trim(mft.titleshort) as `mfttitleshort`,
        mft.publish_date as `mftpublishdate`,
        mf.mfID as `mfmfID`,
        trim(mf.titlelong) as `mftitlelong`,
        lower(trim(mf.titlelong)) as `mftitlelonglower`,
        trim(mf.titleshort) as `mftitleshort`,
        mf.actionstatus as `mfactionstatus`
        from MovieFeedTemp mft
        left join MovieFeed mf on mf.titleshort = mft.titleshort
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
          cast(mft.publish_date as datetime) >= date_add(current_timestamp(), interval -1 hour) and
          cast(mft.publish_date as datetime) <= date_add(current_timestamp(), interval 0 hour)
        )
        group by mft.titlelong, mft.titleshort, mft.publish_date, mf.titlelong, mf.titleshort, mf.actionstatus, mf.mfID
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.mfttitlelong as `mfttitlelong`,
        smd.mfttitlelonglower as `mfttitlelonglower`,
        smd.mfttitleshort as `mfttitleshort`,
        max(smd.mftpublishdate) as `mftpublishdate`,
        smd.mfactionstatus as `mftactionstatus`,
        smd.mfmfID as `mfmfID`
        from subMovieDetails smd
        join MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
        where
        (
          smd.mfttitlelonglower = smd.mftitlelonglower
        ) and
        (
          (
            yearString like '%|%' and
            (
              smd.mfttitlelonglower like concat('%', substring(yearString, 1, 4), '%') or
              smd.mfttitlelonglower like concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.mfttitlelonglower like concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.mfttitlelong, smd.mfttitlelonglower, smd.mfttitleshort, smd.mfactionstatus, smd.mfmfID
      )

      -- Select records
      select
      md.mfttitlelong as `titlelong`,
      md.mfttitleshort as `titleshort`,
      md.mftactionstatus as `actionstatus`,
      md.mftpublishdate as `publishdate`,
      md.mfmfID as `mfID`
      from movieDetails md;

      -- Update records
      update MovieFeed mf
      join MovieFeedTempTable mftt on mftt.mfttID = mf.mfID
      set
      mf.publish_date = cast(mftt.publish_date as datetime),
      mf.modified_date = cast(current_timestamp(6) as datetime);

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
        `tfttID` bigint(20) default null,
        `titlelong` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `titleshort` varchar(255) collate utf8mb4_unicode_520_ci not null,
        `actionstatus` varchar(255) collate utf8mb4_unicode_520_ci default null,
        `publish_date` datetime not null
      );

      -- Insert records
      insert into TVFeedTempTable (titlelong, titleshort, actionstatus, publish_date, tfttID)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        trim(tft.titlelong) as `tfttitlelong`,
        lower(trim(tft.titlelong)) as `tfttitlelonglower`,
        trim(tft.titleshort) as `tfttitleshort`,
        tft.publish_date as `tftpublishdate`,
        tf.tfID as `tftfID`,
        trim(tf.titlelong) as `tftitlelong`,
        lower(trim(tf.titlelong)) as `tftitlelonglower`,
        trim(tf.titleshort) as `tftitleshort`,
        tf.actionstatus as `tfactionstatus`
        from TVFeedTemp tft
        left join TVFeed tf on tf.titleshort = tft.titleshort
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
          cast(tft.publish_date as datetime) >= date_add(current_timestamp(), interval -1 hour) and
          cast(tft.publish_date as datetime) <= date_add(current_timestamp(), interval 0 hour)
        )
        group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as `tfttitlelong`,
        std.tfttitleshort as `tfttitleshort`,
        cast(max(std.tftpublishdate) as datetime) as `tftpublishdate`,
        if(std.tfactionstatus is null, 0, std.tfactionstatus) as `tfactionstatus`,
        std.tftfID as `tftfID`
        from subTVDetails std
        join MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
        where
        (
          std.tfttitlelonglower = std.tftitlelonglower
        )
        group by std.tfttitlelong, std.tfttitleshort, std.tfactionstatus, std.tftfID
      )

      -- Select records
      select
      td.tfttitlelong as `titlelong`,
      td.tfttitleshort as `titleshort`,
      td.tfactionstatus as `actionstatus`,
      td.tftpublishdate as `publish_date`,
      td.tftfID as `tfID`
      from tvDetails td;

      -- Update records
      update TVFeed tf
      join TVFeedTempTable tftt on tftt.tfttID = tf.tfID
      set
      tf.publish_date = cast(tftt.publish_date as datetime),
      tf.modified_date = cast(current_timestamp(6) as datetime);

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
        lower(trim(mft.titlelong)) as `mfttitlelonglower`,
        trim(mft.titleshort) as `mfttitleshort`,
        mft.publish_date as `mftpublishdate`,
        mf.mfID as `mfmfID`,
        trim(mf.titlelong) as `mftitlelong`,
        lower(trim(mf.titlelong)) as `mftitlelonglower`,
        trim(mf.titleshort) as `mftitleshort`,
        mf.actionstatus as `mfactionstatus`
        from MovieFeedTemp mft
        left join MovieFeed mf on mf.titleshort = mft.titleshort
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
        --   cast(tft.publish_date as datetime) >= date_add(current_timestamp(), interval -1 hour) and
        --   cast(tft.publish_date as datetime) <= date_add(current_timestamp(), interval 0 hour)
        -- )
        group by mft.titlelong, mft.titleshort, mft.publish_date, mf.titlelong, mf.titleshort, mf.actionstatus, mf.actionstatus, mf.mfID
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.mfttitlelong as `mfttitlelong`,
        smd.mfttitleshort as `mfttitleshort`,
        cast(max(smd.mftpublishdate) as datetime) as `mftpublishdate`,
        if(smd.mfactionstatus is null, 0, smd.mfactionstatus) as `mfactionstatus`,
        smd.mfmfID as `mfmfID`
        from subMovieDetails smd
        join MediaAudioEncode mae on mae.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in (1) and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
        where
        (
          smd.mfttitlelonglower <> smd.mftitlelonglower or
          smd.mftitlelong is null
        ) and
        (
          (
            yearString like '%|%' and
            (
              smd.mfttitlelonglower like concat('%', substring(yearString, 1, 4), '%') or
              smd.mfttitlelonglower like concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.mfttitlelonglower like concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.mfttitlelong, smd.mfttitlelonglower, smd.mfttitleshort, smd.mfactionstatus, smd.mfmfID
      )

      -- Select records
      select
      md.mfttitlelong,
      md.mfttitleshort,
      md.mftpublishdate,
      md.mfactionstatus,
      cast(current_timestamp(6) as datetime),
      cast(current_timestamp(6) as datetime)
      from movieDetails md
      left join MovieFeed mf on mf.titlelong = md.mfttitlelong
      where
      mf.titlelong is null
      group by md.mfttitlelong, md.mfttitleshort, md.mftpublishdate, md.mfactionstatus;

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
        lower(trim(tft.titlelong)) as `tfttitlelonglower`,
        trim(tft.titleshort) as `tfttitleshort`,
        tft.publish_date as `tftpublishdate`,
        tf.tfID as `tftfID`,
        trim(tf.titlelong) as `tftitlelong`,
        lower(trim(tf.titlelong)) as `tftitlelonglower`,
        trim(tf.titleshort) as `tftitleshort`,
        tf.actionstatus as `tfactionstatus`
        from TVFeedTemp tft
        left join TVFeed tf on tf.titleshort = tft.titleshort
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
        --   cast(tft.publish_date as datetime) >= date_add(current_timestamp(), interval -1 hour) and
        --   cast(tft.publish_date as datetime) <= date_add(current_timestamp(), interval 0 hour)
        -- ) and
        group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as `tfttitlelong`,
        std.tfttitleshort as `tfttitleshort`,
        cast(max(std.tftpublishdate) as datetime) as `tftpublishdate`,
        if(std.tfactionstatus is null, 0, std.tfactionstatus) as `tfactionstatus`,
        std.tftfID as `tftfID`
        from subTVDetails std
        join MediaAudioEncode mae on mae.tvInclude in (1) and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in (1) and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in (1) and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in (1) and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
        where
        (
          std.tfttitlelonglower <> std.tftitlelonglower or
          std.tftitlelong is null
        )
        group by std.tfttitlelong, std.tfttitleshort, std.tfactionstatus, std.tftfID
      )

      -- Select records
      select
      td.tfttitlelong,
      td.tfttitleshort,
      td.tftpublishdate,
      td.tfactionstatus,
      cast(current_timestamp(6) as datetime),
      cast(current_timestamp(6) as datetime)
      from tvDetails td
      left join TVFeed tf on tf.titlelong = td.tfttitlelong
      where
      tf.titlelong is null
      group by td.tfttitlelong, td.tfttitleshort, td.tftpublishdate, td.tfactionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' as `status`;
    end if;
  end
// delimiter ;