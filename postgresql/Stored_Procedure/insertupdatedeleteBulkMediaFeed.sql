-- Database Connect
\c <databasename>;

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

-- Procedure Create Or Replace
create or replace procedure insertupdatedeletebulkmediafeed(in optionMode text, in titlelong text default null, in titleshort text default null, in publishDate text default null, inout status text default null)
as $$
  -- Declare and set variable
  declare yearString varchar(255) := '';
  declare omitOptionMode varchar(255) := '[^a-zA-Z]';
  declare omitTitleLong varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitTitleShort varchar(255) := '[^a-zA-Z0-9 !"\#$%&''()*+,\-./:;<=>?@\[\\\]^_‘{|}~¡¢£¥¦§¨©®¯°±´µ¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿıŒœŠšŸŽžƒˆˇ˘˙˚˛ΓΘΣΦΩαδεπστφ–—‘’“”•…€™∂∆∏∑∙√∞∩∫≈≠≡≤≥]';
  declare omitPublishDate varchar(255) := '[^0-9\-: ]';
  declare maxLengthOptionMode int := 255;
  declare maxLengthTitleLong int := 255;
  declare maxLengthTitleShort int := 255;
  declare maxLengthPublishDate int := 255;

  begin
    -- Check if parameter is not null
    if optionMode is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      optionMode := regexp_replace(regexp_replace(optionMode, omitOptionMode, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      optionMode := trim(substring(optionMode, 1, maxLengthOptionMode));

      -- Check if empty string
      if optionMode = '' then
        -- Set parameter to null if empty string
        optionMode := nullif(optionMode, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titleLong is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      titlelong := regexp_replace(regexp_replace(titlelong, omitTitleLong, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      titlelong := trim(substring(titlelong, 1, maxLengthTitleLong));

      -- Check if empty string
      if titlelong = '' then
        -- Set parameter to null if empty string
        titlelong := nullif(titlelong, '');
      end if;
    end if;

    -- Check if parameter is not null
    if titleShort is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      titleshort := regexp_replace(regexp_replace(titleshort, omitTitleShort, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      titleshort := trim(substring(titleshort, 1, maxLengthTitleShort));

      -- Check if empty string
      if titleshort = '' then
        -- Set parameter to null if empty string
        titleshort := nullif(titleshort, '');
      end if;
    end if;

    -- Check if parameter is not null
    if publishDate is not null then
      -- Omit characters, multi space to single space, and trim leading and trailing spaces
      publishDate := regexp_replace(regexp_replace(publishDate, omitPublishDate, ' '), '[ ]{2,}', ' ');

      -- Set character limit
      publishDate := trim(substring(publishDate, 1, maxLengthPublishDate));

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
    end if;

    -- Check if option mode is delete temp movie
    if optionMode = 'deleteTempMovie' then
      -- Delete records
      delete from moviefeedtemp;

      -- Select message
      select
      'Success~Record(s) deleted' into status;

    -- Else check if option mode is delete temp tv
    elseif optionMode = 'deleteTempTV' then
      -- Delete records
      delete from tvfeedtemp;

      -- Select message
      select
      'Success~Record(s) deleted' into status;

    -- Check if option mode is insert temp movie
    elseif optionMode = 'insertTempMovie' then
      -- Check if parameters are not null
      if titlelong is not null and titleshort is not null and publishDate is not null then
        -- Insert record
        insert into moviefeedtemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp);

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
        insert into tvfeedtemp (titlelong, titleshort, publish_date, created_date) values (titlelong, lower(titleshort), publishDate, current_timestamp);

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
        cast(trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titlelong,
        cast(trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleShort)) as citext) as titleshort,
        trim(substring(regexp_replace(regexp_replace(mft.publish_date, omitPublishDate, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthPublishDate)) as publish_date
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
          cast(mft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
          cast(mft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
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
        left join moviefeed mf on mf.titlelong = smd.titlelong
        left join moviefeed mfas on mfas.titleshort = smd.titleshort
        join mediaaudioencode mae on mae.movieInclude in ('1') and smd.titlelong ilike concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.movieInclude in ('1') and smd.titlelong ilike concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.movieInclude in ('1') and smd.titlelong ilike concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.movieInclude in ('1') and smd.titlelong ilike concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.movieInclude in ('1') and smd.titlelong ilike concat('%', mve.videoencode, '%')
        inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
        where
        mfas.actionstatus not in (1) and
        mf.mfID is not null and
        (
          (
            yearString ilike '%|%' and
            (
              smd.titlelong ilike concat('%', substring(yearString, 1, 4), '%') or
              smd.titlelong ilike concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.titlelong ilike concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
      )

      -- Update records
      update moviefeed
      set
      publish_date = cast(md.publish_date as timestamp),
      modified_date = cast(current_timestamp as timestamp)
      from movieDetails md
      where
      md.mfID = moviefeed.mfID;

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
        cast(trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titlelong,
        cast(trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titleshort,
        trim(substring(regexp_replace(regexp_replace(tft.publish_date, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as publish_date
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
          cast(tft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
          cast(tft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
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
        left join tvfeed tf on tf.titlelong = std.titlelong
        left join tvfeed tfas on tfas.titleshort = std.titleshort
        join mediaaudioencode mae on mae.tvInclude in ('1') and std.titlelong ilike concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.tvInclude in ('1') and std.titlelong ilike concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.tvInclude in ('1') and std.titlelong ilike concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.tvInclude in ('1') and std.titlelong ilike concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.tvInclude in ('1') and std.titlelong ilike concat('%', mve.videoencode, '%')
        inner join (select stdii.titlelong, max(stdii.publish_date) as publish_date from subTVDetails stdii group by stdii.titlelong) as stdi on stdi.titlelong = std.titlelong and stdi.publish_date = std.publish_date
        where
        tfas.actionstatus not in (1) and
        tf.tfID is not null
        group by std.titlelong, std.titleshort, std.publish_date, tfas.actionstatus, tf.tfID
      )

      -- Update records
      update tvfeed
      set
      publish_date = cast(td.publish_date as timestamp),
      modified_date = cast(current_timestamp as timestamp)
      from tvDetails td
      where
      td.tfID = tvfeed.tfID;

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
      insert into moviefeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subMovieDetails as
      (
        -- Select unique records
        select
        cast(trim(substring(regexp_replace(regexp_replace(mft.titlelong, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titlelong,
        cast(trim(substring(regexp_replace(regexp_replace(mft.titleshort, omitTitleShort, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleShort)) as citext) as titleshort,
        trim(substring(regexp_replace(regexp_replace(mft.publish_date, omitPublishDate, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthPublishDate)) as publish_date
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
        --   cast(mft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
        --   cast(mft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
        -- )
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
        left join moviefeed mf on mf.titlelong = smd.titlelong
        left join moviefeed mfas on mfas.titleshort = smd.titleshort
        join mediaaudioencode mae on mae.movieInclude in ('1') and smd.titlelong ilike concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.movieInclude in ('1') and smd.titlelong ilike concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.movieInclude in ('1') and smd.titlelong ilike concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.movieInclude in ('1') and smd.titlelong ilike concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.movieInclude in ('1') and smd.titlelong ilike concat('%', mve.videoencode, '%')
        inner join (select smdii.titlelong, max(smdii.publish_date) as publish_date from subMovieDetails smdii group by smdii.titlelong) as smdi on smdi.titlelong = smd.titlelong and smdi.publish_date = smd.publish_date
        where
        (
          mfas.actionstatus not in (1) or
          mfas.actionstatus is null
        ) and
        mf.mfID is null and
        (
          (
            yearString ilike '%|%' and
            (
              smd.titlelong ilike concat('%', substring(yearString, 1, 4), '%') or
              smd.titlelong ilike concat('%', substring(yearString, 6, 9), '%')
            )
          ) or
          (
            smd.titlelong ilike concat('%', substring(yearString, 1, 4), '%')
          )
        )
        group by smd.titlelong, smd.titleshort, smd.publish_date, mfas.actionstatus, mf.mfID
      )

      -- Select records
      select
      md.titlelong,
      md.titleshort,
      cast(md.publish_date as timestamp),
      case
        when md.actionstatus is null
          then
            0
        else
          md.actionstatus
      end,
      cast(current_timestamp as timestamp),
      cast(current_timestamp as timestamp)
      from movieDetails md
      group by md.titlelong, md.titleshort, md.publish_date, md.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' into status;

    -- Else check if option mode is insert bulk tv
    elseif optionMode = 'insertBulkTV' then
      -- Insert records
      insert into tvfeed (titlelong, titleshort, publish_date, actionstatus, created_date, modified_date)

      -- Remove duplicate records based on group by
      with subTVDetails as
      (
        -- Select unique records
        select
        cast(trim(substring(regexp_replace(regexp_replace(tft.titlelong, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titlelong,
        cast(trim(substring(regexp_replace(regexp_replace(tft.titleshort, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as citext) as titleshort,
        trim(substring(regexp_replace(regexp_replace(tft.publish_date, omitTitleLong, ' ', 'g'), '[ ]{2,}', ' ', 'g'), 1, maxLengthTitleLong)) as publish_date
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
        --   cast(tft.publish_date as timestamp) >= current_timestamp + interval '-1 hour' and
        --   cast(tft.publish_date as timestamp) <= current_timestamp + interval '0 hour'
        -- )
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
        left join tvfeed tf on tf.titlelong = std.titlelong
        left join tvfeed tfas on tfas.titleshort = std.titleshort
        join mediaaudioencode mae on mae.tvInclude in ('1') and std.titlelong ilike concat('%', mae.audioencode, '%')
        left join mediadynamicrange mdr on mdr.tvInclude in ('1') and std.titlelong ilike concat('%', mdr.dynamicrange, '%')
        join mediaresolution mr on mr.tvInclude in ('1') and std.titlelong ilike concat('%', mr.resolution, '%')
        left join mediastreamsource mss on mss.tvInclude in ('1') and std.titlelong ilike concat('%', mss.streamsource, '%')
        join mediavideoencode mve on mve.tvInclude in ('1') and std.titlelong ilike concat('%', mve.videoencode, '%')
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
      cast(td.publish_date as timestamp),
      case
        when td.actionstatus is null
          then
            0
        else
          td.actionstatus
      end,
      cast(current_timestamp as timestamp),
      cast(current_timestamp as timestamp)
      from tvDetails td
      group by td.titlelong, td.titleshort, td.publish_date, td.actionstatus;

      -- Select message
      select
      'Success~Record(s) inserted' into status;
    end if;
  end; $$
language plpgsql;
