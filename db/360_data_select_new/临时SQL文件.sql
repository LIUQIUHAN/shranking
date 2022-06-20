# QS世界大学排名指标作为高校状态指标数据库指标
USE u_indicator_status_db;

SELECT * FROM indicator_world WHERE indicatorname RLIKE 'QS';
-- DELETE FROM data_detail_rank_list_world WHERE indicatorCode IN ('63','97','100','104','105');

INSERT INTO data_detail_rank_list_world (/*id, */real_year, data_year, institutionCode, institutionName, country,
                                                 indicatorCode, indicatorValue, data_source_id, crt_time)
SELECT real_year,
       data_year,
       institutionCode,
       institutionName,
       NULL  country,
       (CASE
            WHEN indicatorSubName = '学术声誉' THEN '104'
            WHEN indicatorSubName = '雇主声誉' THEN '105'
            WHEN indicatorSubName = '师生比' THEN '63'
            WHEN indicatorSubName = '国际教师比例' THEN '100'
            WHEN indicatorSubName = '国际学生比例' THEN '97'
           END
           ) indicatorCode,
       indicatorValue,
       NULL  data_source_id,
       crt_time
FROM data_detail_rank_list_detail_world
WHERE indicatorCode = '2'
  AND indicatorSubName IN ('学术声誉', '雇主声誉', '师生比', '国际教师比例', '国际学生比例')
  AND indicatorValue IS NOT NULL;



/*USE ub_ranking_dev;
SELECT val ->> '$.resetEffectVer'
FROM indicator_latest
WHERE `code` IN (
                 'pccourse',
                 'pacourse',
                 'ptadwt',
                 'ptaward',
                 'posaward',
                 'psadwt',
                 'psaward',
                 'psaward1',
                 'psaward2',
                 'psaward3',
                 'psaward4',
                 'psaward5',
                 'psaward6',
                 'psaward7',
                 'psaward8',
                 'psaward9',
                 'pysaward',
                 'ppsaward',
                 'ppsawarw'
    )
  AND `level` = 3;

UPDATE indicator_latest
SET val = JSON_SET(val, '$.resetEffectVer', 'true')
WHERE `code` IN (
                 'pccourse',
                 'pacourse',
                 'ptadwt',
                 'ptaward',
                 'posaward',
                 'psadwt',
                 'psaward',
                 'psaward1',
                 'psaward2',
                 'psaward3',
                 'psaward4',
                 'psaward5',
                 'psaward6',
                 'psaward7',
                 'psaward8',
                 'psaward9',
                 'pysaward',
                 'ppsaward',
                 'ppsawarw'
    )
  AND `level` = 3;

UPDATE ind_value_latest SET effect_ver = target_ver
WHERE ind_code in  (
                 'pccourse',
                 'pacourse',
                 'ptadwt',
                 'ptaward',
                 'posaward',
                 'psadwt',
                 'psaward',
                 'psaward1',
                 'psaward2',
                 'psaward3',
                 'psaward4',
                 'psaward5',
                 'psaward6',
                 'psaward7',
                 'psaward8',
                 'psaward9',
                 'pysaward',
                 'ppsaward',
                 'ppsawarw'
    );
*/



