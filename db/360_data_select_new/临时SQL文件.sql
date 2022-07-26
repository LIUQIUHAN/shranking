# -*- coding:utf-8 -*-
# 业鹏中法提出的将造就学术人才头衔里面的最新年份提取出来
USE spm_details_0208;
/*SELECT MAX(yr)
FROM JSON_TABLE(CONCAT('[', TRIM(',' FROM REGEXP_REPLACE('长江特聘（2012），科技领军（2017），国家杰青（2011）', '\\D+', ',')), ']')
         , '$[*]' COLUMNS (yr int PATH '$')) jt;*/

/*CREATE
    FUNCTION `ExtractNumber`(in_string VARCHAR(1000)) RETURNS text CHARSET utf8mb4
BEGIN
    DECLARE finNumber VARCHAR(1000) DEFAULT '';
    SELECT MAX(yr)
    INTO finNumber
    FROM JSON_TABLE(CONCAT('[', TRIM(',' FROM REGEXP_REPLACE(in_string, '\\D+', ',')), ']')
             , '$[*]' COLUMNS (yr int PATH '$')) jt;
    RETURN finNumber;
END;*/



UPDATE var_detail
SET ver_no = ExtractNumber(detail ->> '$.remark1')
WHERE var_code = 'doct'
AND _eversions_ IN (202206,202207,202208)
;


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
FROM JSON_TABLE(
             '[
               {
                 "a": "3"
               },
               {
                 "a": 2
               },
               {
                 "b": 1
               },
               {
                 "a": 0
               },
               {
                 "a": [
                   1,
                   2
                 ]
               }
             ]',
             '$[*]'
             COLUMNS (
                 rowid FOR ORDINALITY,
                 ac VARCHAR(100) PATH '$.a' DEFAULT '999' ON ERROR DEFAULT '111' ON EMPTY,
                 aj JSON PATH '$.a' DEFAULT '{"x": 333}' ON EMPTY,
                 bx INT EXISTS PATH '$.b'
                 )
         ) AS tt;


# 排名团队数据需求
/*SELECT school_code                                                                                     学校代码,
       (SELECT school_name FROM rank_tbl_school_info B WHERE A.school_code = B.school_code)            学校名称,
       target_code                                                                                     指标代码,
       (SELECT target_name FROM rank_tbl_module_info_no_edition C WHERE A.target_code = C.target_code) 指标名称,
       target_val                                                                                      指标值,
       data_year                                                                                       数据年份,
       data_source_id                                                                                  来源ID,
       '2019-2020本科教学质量报告' AS                                                                          来源
FROM `rank_tbl_basics_target_data` A
WHERE data_year = '2020'
  AND data_source_id = '12';*/


# 产品数据需求
/*刘勇你好：
    曹梦沁工作中用到的一些排名数据，平台页面上无法查到，需要麻烦你帮忙拉取一下。

    一、软科世界大学学术排名2016-2021，
    1.国内高校
    2.全球发布排名、全球精确排名、国内发布排名、国内精确排名

    二、软科世界一流学科排名2017-2021
    1.国内高校
    2.所有发布学科
    3.总排名、所有指标明细

    三、U.S news学科排名
        国内高校。
        分学科，2016、2017、2018三年的数据。

    四、QS大学精确排名
    1.国内高校
    2.所有发布学科
    3.总排名、所有指标明细

    五、ESI
        自2016.11开始
        中国大学上榜学科明细

    曹梦沁的邮箱：mengqin.cao@shanghairanking.com*/

USE univ_ranking_dev;
# 一、软科世界大学学术排名2016-2021
SELECT yr                     AS                           版本年份,
       univ_id                AS                           学校ID,
       (SELECT name_cn FROM univ b WHERE a.univ_id = b.id) 学校名称,
       ranking                AS                           全球发布排名,
       rank_country           AS                           国内发布排名,
       ranking___precise      AS                           全球精确排名,
       rank_country___precise AS                           国内精确排名
FROM arwu_rank a
WHERE yr BETWEEN 2016 AND 2021
  AND EXISTS(SELECT * FROM univ_cn c WHERE a.univ_code = c.code);


# 二、软科世界一流学科排名2017-2021
SELECT yr                                                                              版本年份,
       subj_code                                                                       学科代码,
       (SELECT name_cn FROM gras_subject s WHERE a.subj_code = s.code AND a.yr = s.yr) 学科名称,
       univ_id                                                                         学校ID,
       (SELECT name_cn FROM univ b WHERE a.univ_id = b.id)                             学校名称,
       ranking                                                                         全球发布排名,
       ranking___precise                                                               全球精确排名,
       rank_country                                                                    国内发布排名,
       rank_country___precise                                                          国内精确排名
FROM gras_rank a
WHERE yr BETWEEN 2017 AND 2021
  AND EXISTS(SELECT * FROM univ_cn c WHERE a.univ_code = c.code);

SELECT yr                                                                              版本年份,
       subj_code                                                                       学科代码,
       (SELECT name_cn FROM gras_subject s WHERE a.subj_code = s.code AND a.yr = s.yr) 学科名称,
       ind_id                                                                          指标ID,
       (SELECT name_cn FROM gras_indicator i WHERE i.id = a.ind_id)                    指标名称,
       univ_id                                                                         学校ID,
       score                                                                           得分
FROM gras_ind_score a
WHERE yr BETWEEN 2017 AND 2021
  AND EXISTS(SELECT * FROM univ_cn c WHERE a.univ_code = c.code);

# 三、U.S news学科排名
SELECT yr                                                                     版本年份,
       subj_id                                                                学科ID,
       (SELECT name_cn FROM rr_usnews_bgusr_subject b WHERE a.subj_id = b.id) 学科名称,
       univ_id                                                                学校ID,
       (SELECT name_cn FROM univ u WHERE a.univ_id = u.id)                    学校名称,
       ranking                                                                全球发布排名,
       score                                                                  得分,
       rank_country                                                           国内发布排名,
       rank_country_precise                                                   国内精确排名
FROM rr_usnews_bgusr_rank a
WHERE EXISTS(SELECT * FROM univ_cn c WHERE a.univ_code = c.code);

# 四、QS大学精确排名
SELECT yr                   版本年份,
       univ_id              学校ID,
       score                得分,
       ranking              全球发布排名,
       rank_country         国内发布排名,
       ranking_precise      全球精确排名,
       rank_country_precise 国内精确排名
FROM rr_qs_wur_rank a
WHERE EXISTS(SELECT * FROM univ_cn c WHERE a.univ_code = c.code);

# 指标数据库：自然指数（Nature Index）学科排名
USE univ_ranking_raw;
# 历史年份向前推1年（略）
/*UPDATE data_detail_rank_list_detail_world
SET real_year = real_year + 1,
    data_year = data_year + 1
WHERE indicatorCode = 'r8'
  AND data_year != '2022';*/

# 2022年数据入库
SELECT NULL                                AS id,
       yr                                  AS real_year,
       yr                                  AS data_year,
       'r8'                                AS indicatorCode,
       univ_code                           AS institutionCode,
       NULL                                AS institutionName,
       subject_name_en                     AS indicatorSubName,
       NULL                                AS awardee,
       NULL                                AS awardName,
       `rank`                              AS indicatorValue,
       NULL                                AS totalInstitution,
       NULL                                AS isTop1000,
       NULL                                AS isTop10000,
       NULL                                AS esiTotalCites,
       NULL                                AS subjectCode,
       IF((`rank` + 0) > 50, NULL, '35')   AS indicatorCodeSub,
       NULL                                AS levelCode,
       NOW()                               AS crt_time
FROM univ_ranking_raw.raw_nature_index_wsr_20220630
WHERE yr = 2022
ORDER BY univ_code;


# 原360平台202005/202007/202009版本计算学校类型模块排名
USE gaoji_360_platform;
# 模块
WITH TSR AS (SELECT A.edition_year,
                    A.school_code,
                    A.type_code,
                    A.module_id,
                    A.score,
                    A.score_rank,
                    RANK() OVER ( PARTITION BY A.edition_year, A.type_code, A.module_id,(SELECT B.rank_type
                                                                                         FROM rank_tbl_school_info B
                                                                                         WHERE A.school_code = B.school_code) ORDER BY (A.score + 0) DESC ) AS new_type_score_rank
             FROM rank_tbl_module_score_info A
             WHERE A.edition_year IN ('202005', '202007', '202009','202011'))
UPDATE rank_tbl_module_score_info V JOIN TSR USING (edition_year, school_code, type_code, module_id)
SET V.type_score_rank = TSR.new_type_score_rank
WHERE V.edition_year IN ('202005', '202007', '202009','202011')
  AND v.type_score_rank IS NULL;

# 维度
WITH TSR AS (SELECT A.edition_year,
                    A.school_code,
                    A.type_code,
                    A.target_type,
                    A.score,
                    A.score_rank,
                    RANK() OVER ( PARTITION BY A.edition_year, A.type_code, A.target_type,(SELECT B.rank_type
                                                                                         FROM rank_tbl_school_info B
                                                                                         WHERE A.school_code = B.school_code) ORDER BY (A.score + 0) DESC ) AS new_type_score_rank
             FROM rank_tbl_module_dimension_score_info A
             WHERE A.edition_year IN ('202005', '202007', '202009','202011'))
UPDATE rank_tbl_module_dimension_score_info V JOIN TSR USING (edition_year, school_code, type_code, target_type)
SET V.type_score_rank = TSR.new_type_score_rank
WHERE V.edition_year IN ('202005', '202007', '202009','202011')
  AND v.type_score_rank IS NULL;










# 新360平台202005/202007/202009版本计算学校类型模块排名
USE ub_ranking_dev;

SELECT r_ver_no, r_leaf_id, ind_code, univ_code, score_rank_typ
FROM ind_score_2020
WHERE r_ver_no IN (202005, 202007, 202009, 202011)
  AND univ_code = 'RC00225'
ORDER BY ind_code;

WITH N AS (
    SELECT r_ver_no,
           r_leaf_id,
           ind_code,
           univ_code,
           RANK() OVER (PARTITION BY r_ver_no,r_leaf_id,ind_code,(SELECT B.r_leaf_id
                                                                  FROM ranking_list B
                                                                  WHERE A.univ_code = B.univ_code
                                                                    AND A.r_ver_no = B.r_ver_no
                                                                    AND B.is_same_type = 1) ORDER BY score DESC ) new_score_rank_typ
    FROM ind_score_2020 A
    WHERE r_ver_no IN (202005, 202007, 202009, 202011))
UPDATE ind_score_2020 V JOIN N USING (r_ver_no, univ_code, r_leaf_id, ind_code)
SET V.score_rank_typ = N.new_score_rank_typ
WHERE V.r_ver_no IN ('202005', '202007', '202009','202011')
  AND v.score_rank_typ = 0;



WITH N AS (
    SELECT r_ver_no,
           r_leaf_id,
           ind_code,
           univ_code,
           (SELECT B.r_leaf_id
            FROM ranking_list B
            WHERE A.univ_code = B.univ_code
              AND A.r_ver_no = B.r_ver_no
              AND B.is_same_type = 1) univ_rank_type
    FROM ind_score_2020 A
    WHERE r_ver_no IN (202005, 202007, 202009, 202011))
UPDATE ind_score_2020 V JOIN N USING (r_ver_no,r_leaf_id,ind_code,univ_code)
SET V.is_same_type = 1
WHERE v.r_leaf_id = N.univ_rank_type;


UPDATE ind_score_2020 SET score_rank_typ = 0 WHERE is_same_type = 0;





USE univ_ranking_raw;
# 高校状态指标数据库指标查看：自然指数排名
SELECT id,
       yr         AS data_year,
       issue_time AS pub_date,
       'world'    AS rank_type,
       'nindex'   AS target_code,
       (SELECT B._code_old
        FROM univ_ranking_dev.univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)  AS institutionCode,
       rank_world AS urank,
       NULL       AS institutionName,
       NULL       AS indicatorName
FROM `raw_nature_index_wur_20220630` A;


# 高校状态指标数据库国际对比：自然指数排名
SELECT id,
       yr                    AS real_year,
       yr                    AS data_year,
       univ_code             AS institutionCode,
       univ_name_cn          AS institutionName,
       region_en             AS country,
       '7'                   AS indicatorCode,
       rank_world            AS indicatorValue,
       NULL                  AS data_source_id,
       '2022-07-07 18:39:01' AS crt_time
FROM `raw_nature_index_wur_20220630`;


# 产品需求：学科平台指标表头信息
SELECT A.def_id,
       idd.name,
       idd.remark,
       A.field_key,
       A.field_name,
       A.align,
       A.ord_no
FROM ind_detail_field A
         JOIN ind_detail_def idd ON A.def_id = idd.id;







# 学科变量明细表提取人才姓名
USE spm_details_0208;
INSERT INTO _b2_talen_name (dtl_id, var_code, univ_code, _eversions_, talent_name)
SELECT dtl_id, var_code, univ_code, _eversions_, detail ->> '$.talent_name' AS talent_name
FROM var_detail
WHERE var_code IN (SELECT `code` FROM spm_ranking_dev.dpa_ranking_ind WHERE pid = 13)
AND _eversions_ = '202208';

UPDATE var_detail A JOIN _b2_talen_name TM ON A.dtl_id = TM.dtl_id AND A._eversions_ = TM._eversions_ AND
                                                     A.var_code = TM.var_code AND A.univ_code = TM.univ_code
SET A.talent_name = TM.talent_name
WHERE A.var_code IN (SELECT `code` FROM spm_ranking_dev.dpa_ranking_ind WHERE pid = 13)
AND A._eversions_ = '202208';


# 项目类变量无获批金额的数据，根据产品给的规则批量插入金额
UPDATE var_detail SET val = 20, detail = json_set(detail,'$.project_money',20) WHERE var_code = 'add1'    AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val = 15, detail = json_set(detail,'$.project_money',15) WHERE var_code = 'add1056' AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val = 40, detail = json_set(detail,'$.project_money',40) WHERE var_code = 'add27'   AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val = 70, detail = json_set(detail,'$.project_money',70) WHERE var_code = 'add7'    AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val = 20, detail = json_set(detail,'$.project_money',20) WHERE var_code = 'west1'   AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val =  3, detail = json_set(detail,'$.project_money', 3) WHERE var_code = 'west2'   AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val =  5, detail = json_set(detail,'$.project_money', 5) WHERE var_code = 'x41'     AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val = 30, detail = json_set(detail,'$.project_money',30) WHERE var_code = 'add1111' AND val = 0 AND _eversions_ = '202208';
UPDATE var_detail SET val =  7, detail = json_set(detail,'$.project_money', 7) WHERE var_code = 'c115'    AND val = 0 AND _eversions_ = '202208';


UPDATE var_detail
SET val    = IF(detail ->> '$.award_level' = '重大项目',20,10),
    detail = JSON_SET(detail, '$.project_money', IF(detail ->> '$.award_level' = '重大项目',20,10))
WHERE var_code = 'o11'
  AND val = 0
  AND _eversions_ = '202208';


UPDATE var_detail
SET val    = IF(subj_code IN (
                              '0701',
                              '0702',
                              '0703',
                              '0704',
                              '0705',
                              '0706',
                              '0707',
                              '0708',
                              '0709',
                              '0710',
                              '0711',
                              '0712',
                              '0713',
                              '0714',
                              '0801',
                              '0802',
                              '0803',
                              '0804',
                              '0805',
                              '0806',
                              '0807',
                              '0808',
                              '0809',
                              '0810',
                              '0811',
                              '0812',
                              '0813',
                              '0814',
                              '0815',
                              '0816',
                              '0817',
                              '0818',
                              '0819',
                              '0820',
                              '0821',
                              '0822',
                              '0823',
                              '0824',
                              '0825',
                              '0826',
                              '0827',
                              '0828',
                              '0829',
                              '0830',
                              '0831',
                              '0832',
                              '0833',
                              '0834',
                              '0835',
                              '0836',
                              '0837',
                              '0838',
                              '0839',
                              '0901',
                              '0902',
                              '0903',
                              '0904',
                              '0905',
                              '0906',
                              '0907',
                              '0908',
                              '0909',
                              '1001',
                              '1002',
                              '1003',
                              '1004',
                              '1005',
                              '1006',
                              '1007',
                              '1008',
                              '1009',
                              '1010',
                              '1011'
    ), 18, 15),
    detail = JSON_SET(detail, '$.project_money', IF(subj_code IN (
                                                                  '0701',
                                                                  '0702',
                                                                  '0703',
                                                                  '0704',
                                                                  '0705',
                                                                  '0706',
                                                                  '0707',
                                                                  '0708',
                                                                  '0709',
                                                                  '0710',
                                                                  '0711',
                                                                  '0712',
                                                                  '0713',
                                                                  '0714',
                                                                  '0801',
                                                                  '0802',
                                                                  '0803',
                                                                  '0804',
                                                                  '0805',
                                                                  '0806',
                                                                  '0807',
                                                                  '0808',
                                                                  '0809',
                                                                  '0810',
                                                                  '0811',
                                                                  '0812',
                                                                  '0813',
                                                                  '0814',
                                                                  '0815',
                                                                  '0816',
                                                                  '0817',
                                                                  '0818',
                                                                  '0819',
                                                                  '0820',
                                                                  '0821',
                                                                  '0822',
                                                                  '0823',
                                                                  '0824',
                                                                  '0825',
                                                                  '0826',
                                                                  '0827',
                                                                  '0828',
                                                                  '0829',
                                                                  '0830',
                                                                  '0831',
                                                                  '0832',
                                                                  '0833',
                                                                  '0834',
                                                                  '0835',
                                                                  '0836',
                                                                  '0837',
                                                                  '0838',
                                                                  '0839',
                                                                  '0901',
                                                                  '0902',
                                                                  '0903',
                                                                  '0904',
                                                                  '0905',
                                                                  '0906',
                                                                  '0907',
                                                                  '0908',
                                                                  '0909',
                                                                  '1001',
                                                                  '1002',
                                                                  '1003',
                                                                  '1004',
                                                                  '1005',
                                                                  '1006',
                                                                  '1007',
                                                                  '1008',
                                                                  '1009',
                                                                  '1010',
                                                                  '1011'
        ), 18, 15))
WHERE var_code = 'b43'
  AND val IN (10,6.5)
  AND _eversions_ = '202208';


# 更新周佳提出的 detail ->> '$.elected_year' 年份问题
UPDATE var_detail
SET detail = JSON_SET(detail, '$.elected_year', LEFT(detail ->> '$.elected_year', 4))
WHERE detail ->> '$.elected_year' IN ('2014.0', '2015.0', '2016.0', '2017.0', '2018.0', '2019.0', '2020.0','2021.0')
AND _eversions_ = '202208';


























