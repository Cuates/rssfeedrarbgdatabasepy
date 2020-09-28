-- Database Connect
\c <databasename>;

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

-- Procedure Create Or Replace
create or replace procedure insertupdatedeleteMediaFeed(in optionMode text, in titlelong text default null, in titleshort text default null, in publishDate text default null, inout status text default null)
as $$
  -- Declare variable
  declare yearString varchar(255) := '';

  begin
    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    optionMode := trim(regexp_replace(regexp_replace(optionMode, '[^a-zA-Z]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if optionMode = '' then
      -- Set parameter to null if empty string
      optionMode := nullif(optionMode, '');
    end if;

    -- Set character limit
    optionMode := substring(optionMode, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    titlelong := trim(regexp_replace(regexp_replace(titlelong, '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if titlelong = '' then
      -- Set parameter to null if empty string
      titlelong := nullif(titlelong, '');
    end if;

    -- Set character limit
    titlelong := substring(titlelong, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    titleshort := trim(regexp_replace(regexp_replace(titleshort, '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]', ' '), '[ ]{2,}', ' '));

    -- Check if empty string
    if titleshort = '' then
      -- Set parameter to null if empty string
      titleshort := nullif(titleshort, '');
    end if;

    -- Set character limit
    titleshort := substring(titleshort, 1, 255);

    -- Omit characters, multi space to single space, and trim leading and trailing spaces
    publishDate := trim(regexp_replace(regexp_replace(publishDate, '[^0-9\-: ]', ' '), '[ ]{2,}', ' '));

    -- Check if the parameter cannot be casted into a date time
    if to_timestamp(publishDate, 'YYYY-MM-DD HH24:MI:SS') is null then
      -- Set the string as empty to be nulled below
      publishDate := '';
    end if;

    -- Check if empty string
    if publishDate = '' then
      -- Set parameter to null if empty string
      publishDate := nullif(publishDate, '');
    end if;

    -- Set character limit
    publishDate := substring(publishDate, 1, 255);

    -- Check if option mode is delete temp movie
    if optionMode = 'deleteTempMovie' then
      -- Delete records
      delete from MovieFeedTemp;

      -- Select message
      select
      'Success~Record(s) deleted' into status;

    -- Else check if option mode is delete temp tv
    elseif optionMode = 'deleteTempTV' then
      -- Delete records
      delete from TVFeedTemp;

      -- Select message
      select
      'Success~Record(s) deleted' into status;

    -- Check if option mode is insert temp movie
    elseif optionMode = 'insertTempMovie' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into MovieFeedTemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp);

        -- Select message
        select
        'Success~Record(s) inserted' into status;
      else
        -- Select message
        select
        'Error~Process halted, titlelong, titleshort, and or publish date were not provided' into status;
      end if;

    -- Check if option mode is insert temp tv
    elseif optionMode = 'insertTempTV' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into TVFeedTemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp);

        -- Select message
        select
        'Success~Record(s) inserted' into status;
      else
        -- Select message
        select
        'Error~Process halted, titlelong, titleshort, and or publish date were not provided' into status;
      end if;

    -- Else check if option mode is update bulk movie
    elseif optionMode = 'updateBulkMovie' then
      -- Set variable
      yearString :=
      case
        when to_char(current_timestamp + interval '0 month', 'MM') <= '03'
          then
            concat(to_char(current_timestamp + interval '-1 year', 'YYYY'), '|', to_char(current_timestamp + interval '0 year', 'YYYY'))
        else
          to_char(current_timestamp + interval '0 year', 'YYYY')
      end;

      -- Remove duplicate records based on group by
      with subMovieDetails as
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
          cast(mft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
          cast(mft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
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
        join MediaAudioEncode mae on mae.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
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

      -- Update records
      update MovieFeed
      set
      publish_date = cast(md.mftpublishdate as timestamp),
      modified_date = cast(current_timestamp as timestamp)
      from movieDetails md
      join MovieFeed mf on mf.mfID = md.mfmfID;

      -- Select message
      select
      'Success~Record(s) updated' into status;

    -- Else check if option mode is update bulk tv
    elseif optionMode = 'updateBulkTV' then
      -- Remove duplicate records based on group by
      with subTVDetails as
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
          cast(tft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
          cast(tft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
        )
        group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as tfttitlelong,
        std.tfttitleshort as tfttitleshort,
        cast(max(std.tftpublishdate) as timestamp) as tftpublishdate,
        case
          when std.tfactionstatus is null
            then
              cast(0 as int)
          else
            cast(std.tfactionstatus as int)
        end as tfactionstatus,
        std.tftfID as tftfID
        from subTVDetails std
        join MediaAudioEncode mae on mae.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
        where
        (
          std.tfttitlelonglower = std.tftitlelonglower
        )
        group by std.tfttitlelong, std.tfttitleshort, std.tfactionstatus, std.tftfID
      )

      -- Update records
      update TVFeed
      set
      publish_date = cast(td.tftpublishdate as timestamp),
      modified_date = cast(current_timestamp as timestamp)
      from tvDetails td
      join TVFeed tf on tf.tfID = td.tftfID;

      -- Select message
      select
      'Success~Record(s) updated' into status;

    -- Else check if option mode is insert bulk movie
    elseif optionMode = 'insertBulkMovie' then
      -- Set variable
      yearString :=
      case
        when to_char(current_timestamp + interval '0 month', 'MM') <= '03'
          then
            concat(to_char(current_timestamp + interval '-1 year', 'YYYY'), '|', to_char(current_timestamp + interval '0 year', 'YYYY'))
        else
          to_char(current_timestamp + interval '0 year', 'YYYY')
      end;

      -- Insert records
      insert into MovieFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subMovieDetails as
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
        --   cast(mft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
        --   cast(mft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
        -- )
        group by mft.titlelong, mft.titleshort, mft.publish_date, mf.titlelong, mf.titleshort, mf.actionstatus, mf.actionstatus, mf.mfID
      ),
      movieDetails as
      (
        -- Select unique records
        select
        smd.mfttitlelong as mfttitlelong,
        smd.mfttitleshort as mfttitleshort,
        cast(max(smd.mftpublishdate) as timestamp) as mftpublishdate,
        case
          when smd.mfactionstatus is null
            then
              cast(0 as int)
          else
            cast(smd.mfactionstatus as int)
        end as mfactionstatus,
        smd.mfmfID as mfmfID
        from subMovieDetails smd
        join MediaAudioEncode mae on mae.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.movieInclude in ('1') and smd.mfttitlelonglower like concat('%', mve.videoencode, '%')
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
      cast(current_timestamp as timestamp),
      cast(current_timestamp as timestamp)
      from movieDetails md
      left join MovieFeed mf on mf.titlelong = md.mfttitlelong
      where
      mf.titlelong is null
      group by md.mfttitlelong, md.mfttitleshort, md.mftpublishdate, md.mfactionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' into status;

    -- Else check if option mode is insert bulk tv
    elseif optionMode = 'insertBulkTV' then
      -- Insert records
      insert into TVFeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subTVDetails as
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
        --   cast(tft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
        --   cast(tft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
        -- )
        group by tft.titlelong, tft.titleshort, tft.publish_date, tf.titlelong, tf.titleshort, tf.actionstatus, tf.tfID
      ),
      tvDetails as
      (
        -- Select unique records
        select
        std.tfttitlelong as tfttitlelong,
        std.tfttitleshort as tfttitleshort,
        cast(max(std.tftpublishdate) as timestamp) as tftpublishdate,
        case
          when std.tfactionstatus is null
            then
              cast(0 as int)
          else
            cast(std.tfactionstatus as int)
        end as tfactionstatus,
        std.tftfID as tftfID
        from subTVDetails std
        join MediaAudioEncode mae on mae.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mae.audioencode, '%')
        left join MediaDynamicRange mdr on mdr.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mdr.dynamicrange, '%')
        join MediaResolution mr on mr.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mr.resolution, '%')
        left join MediaStreamSource mss on mss.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mss.streamsource, '%')
        join MediaVideoEncode mve on mve.tvInclude in ('1') and std.tfttitlelonglower like concat('%', mve.videoencode, '%')
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
      cast(current_timestamp as timestamp),
      cast(current_timestamp as timestamp)
      from tvDetails td
      left join TVFeed tf on tf.titlelong = td.tfttitlelong
      where
      tf.titlelong is null
      group by td.tfttitlelong, td.tfttitleshort, td.tftpublishdate, td.tfactionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' into status;
    end if;
  end; $$
language plpgsql;