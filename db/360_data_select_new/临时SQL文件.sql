# QS世界大学排名指标作为高校状态指标数据库指标
-- USE u_indicator_status_db;

-- SELECT * FROM indicator_world WHERE indicatorname RLIKE 'QS';
-- DELETE FROM data_detail_rank_list_world WHERE indicatorCode IN ('63','97','100','104','105');*/

/*INSERT INTO data_detail_rank_list_world ( real_year, data_year, institutionCode, institutionName, country,
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
*/



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
SET val = JSON_SET(val, '$.resetEffectVer', true)
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

# 业鹏中法提出的将造就学术人才头衔里面的最新年份提取出来

SELECT MAX(yr)
FROM JSON_TABLE(CONCAT('[', TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ',')), ']')
         , '$[*]' COLUMNS (yr int PATH '$')) jt;

USE spm_details_0208;

/*CREATE
    FUNCTION `ExtractNumber`(in_string VARCHAR(1000)) RETURNS text CHARSET utf8mb4
BEGIN
    DECLARE finNumber VARCHAR(1000) DEFAULT '';
    SELECT MAX(yr)
    INTO finNumber
    FROM JSON_TABLE(CONCAT('[', TRIM(',' FROM REGEXP_REPLACE(in_string, '\\D+', ',')), ']')
             , '$[*]' COLUMNS (yr int PATH '$')) jt;
    RETURN finNumber;
END;
*/
UPDATE var_detail
SET ver_no = ExtractNumber(detail ->> '$.remark1')
WHERE var_code = 'doct'
;

# 检查
SELECT ver_no,detail ->> '$.remark1' FROM var_detail WHERE var_code = 'doct';





SELECT REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\d+', ',');
SELECT REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ',');

SELECT TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\d+', ','));
SELECT TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ','));

SELECT CONCAT('[', TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ',')), ']');


SELECT *
FROM JSON_TABLE(
             CONCAT('[', TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ',')), ']'),
             '$[*]' COLUMNS (yr int PATH '$')
         ) YR;


SELECT *
FROM
  JSON_TABLE(
    '[{"a":"3"},{"a":2},{"b":1},{"a":0},{"a":[1,2]}]',
    '$[*]'
    COLUMNS(
      rowid FOR ORDINALITY,
      ac VARCHAR(100) PATH '$.a' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
      aj JSON PATH '$.a' DEFAULT '{"x": 333}' ON EMPTY,
      bx INT EXISTS PATH '$.b'
    )
  ) AS tt;


