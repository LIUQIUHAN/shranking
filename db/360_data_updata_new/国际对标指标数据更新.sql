#  高校状态指标数据库 国际对比页面 明细数据系迁移 (耗时：3分钟)
USE ub_ranking_0520;

-- 1.明细表 ub_ranking_old.data_detail_rank_list_detail_world 指标代码替换

UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '22'
WHERE indicatorCode = 'r6';
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '24'
WHERE indicatorCode = 'r2';
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '26'
WHERE indicatorCode = 'r3';
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '27'
WHERE indicatorValue IN ('A+', 'A', 'A-');
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '28'
WHERE indicatorValue IN ('B+', 'B', 'B-');
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '29'
WHERE indicatorValue IN ('C+', 'C', 'C-');
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '31'
WHERE indicatorCode = 'r5';
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '36'
WHERE indicatorCode = 'r8';
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '38'
WHERE indicatorCode = 'r7';

UPDATE ub_ranking_old.data_summary_world
SET data_value = REPLACE(data_value, ',', '');

-- ESI综合排名明细年份更新
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET data_year = REPLACE(real_year, '.', '')
WHERE indicatorCode IN ('5_0',
                        '5_1',
                        '5_2',
                        '5_3',
                        '5_4',
                        '5_5',
                        'r1_0',
                        'r1_1',
                        'r1_2',
                        'r1_3',
                        'r1_4',
                        'r1_5'
    );

-- ESI上榜学科数明细指标code更新
UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '32'
WHERE (indicatorCodeSub IS NULL OR indicatorCodeSub = '')
  AND indicatorCode IN ('r1_0', 'r1_1', 'r1_2', 'r1_3', 'r1_4', 'r1_5');

UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '33'
WHERE indicatorCodeSub IN
      ('r1_0_top1000', 'r1_1_top1000', 'r1_2_top1000', 'r1_3_top1000', 'r1_4_top1000', 'r1_5_top1000')
  AND indicatorCode IN ('r1_0', 'r1_1', 'r1_2', 'r1_3', 'r1_4', 'r1_5');

UPDATE ub_ranking_old.data_detail_rank_list_detail_world
SET indicatorCode = '34'
WHERE indicatorCodeSub IN
      ('r1_0_top10000', 'r1_1_top10000', 'r1_2_top10000', 'r1_3_top10000', 'r1_4_top10000', 'r1_5_top10000')
  AND indicatorCode IN ('r1_0', 'r1_1', 'r1_2', 'r1_3', 'r1_4', 'r1_5');

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE ub_details_0429.intl_var_detail;

INSERT INTO ub_details_0429.intl_var_detail ( dtl_id,
                                              revision,
                                              var_id,
                                              var_code,
                                              source_id,
                                              ver_no,
                                              univ_code,
                                              lev,
                                              val,
                                              detail,
                                              rel_code,
                                              agg_from,
                                              _eversions_,
                                              created_by )

WITH list_detail AS ( SELECT id,
                             data_year,
                             indicatorCode,
                             institutionCode,
                             institutionName,
                             IF(indicatorCode IN ('1', '2', '3', '4', '6', '14', '15', '16', '17', '20'), 'delete',
                                NULL) country, -- 标记这些排名指标明细因聚合而产生的冗余数据，方便后续统一删除
                             indicatorSubName,
                             awardee,
                             awardName,
                             indicatorValue,
                             totalInstitution,
                             isTop1000,
                             isTop10000,
                             esiTotalCites,
                             subjectCode,
                             indicatorCodeSub,
                             levelCode,
                             1        data_source_id
                      FROM ub_ranking_old.data_detail_rank_list_detail_world
                      WHERE /*indicatorCode NOT IN (SELECT indicatorid FROM ub_ranking_old.indicator_world WHERE targettable = 'data_detail_rank_list_world')
         AND*/ indicatorCode IN ( SELECT indicatorid FROM ub_ranking_old.updata_tags_selector )
                      UNION ALL
                      SELECT id,
                             IF(data_year = '' OR data_year IS NULL, real_year, data_year) AS data_year,
                             indicatorCode,
                             institutionCode,
                             institutionName,
                             country,
                             NULL                                                             indicatorSubName,
                             NULL                                                             awardee,
                             NULL                                                             awardName,
                             indicatorValue,
                             NULL                                                             totalInstitution,
                             NULL                                                             isTop1000,
                             NULL                                                             isTop10000,
                             NULL                                                             esiTotalCites,
                             NULL                                                             subjectCode,
                             NULL                                                             indicatorCodeSub,
                             NULL                                                             levelCode,
                             IF(data_source_id IS NULL, 1, data_source_id)                 AS data_source_id
                      FROM ub_ranking_old.data_detail_rank_list_world
                      WHERE indicatorCode NOT IN ( SELECT DISTINCT indicatorid
                                                   FROM ub_ranking_old.indicator_world
                                                   WHERE targettable = 'data_detail_rank_list_detail_world' )
                        AND indicatorCode IN ( SELECT indicatorid FROM ub_ranking_old.updata_tags_selector ) ),
     rank_list   AS ( SELECT *
                      FROM ub_ranking_old.data_detail_rank_list_detail_world
                      WHERE indicatorCode IN ('1', '2', '3', '4', '6', '14', '15', '16', '17', '20') )

SELECT id,
       0                                                          revision,
       1                                                          var_id, -- 跳过 CHECK
       indicatorCode                                              var_code,
       list_detail.data_source_id                              AS source_id,
       IF(data_year RLIKE '-', RIGHT(data_year, 4), data_year) AS ver_no,
       institutionCode                                         AS univ_code,
       0                                                          lev,
       IF((indicatorCode IN ( SELECT indicatorid FROM ub_ranking_old.indicator_world WHERE sumtype != 'qiuhe' ) OR
           indicatorValue IS NULL), 0, indicatorValue)         AS val,
       JSON_OBJECT('data_year', list_detail.data_year, 'indicatorCode',
                   CASE WHEN list_detail.indicatorCode = '107' THEN '72'
                        WHEN list_detail.indicatorCode = '108' THEN '73'
                        WHEN list_detail.indicatorCode = '109' THEN '74'
                        WHEN list_detail.indicatorCode = '110' THEN '75'
                        WHEN list_detail.indicatorCode = '111' THEN '76'
                        WHEN list_detail.indicatorCode = '112' THEN '78'
                        WHEN list_detail.indicatorCode = '106' THEN '101'
                        ELSE list_detail.indicatorCode END, -- 跨5年指标更新到2016-2020的,更改该指标代码为2015-2019的代码
       -- 72  <-- 107
       -- 73  <-- 108
       -- 74  <-- 109
       -- 75  <-- 110
       -- 76  <-- 111
       -- 78  <-- 112
       -- 101 <--  106

                   'institutionCode', list_detail.institutionCode, 'institutionName', list_detail.institutionName,
                   'country', list_detail.country, 'indicatorSubName', list_detail.indicatorSubName, 'awardee',
                   list_detail.awardee, 'awardName', list_detail.awardName, 'indicatorValue',
                   list_detail.indicatorValue, 'totalInstitution', list_detail.totalInstitution, 'isTop1000',
                   list_detail.isTop1000, 'isTop10000', list_detail.isTop10000, 'esiTotalCites',
                   list_detail.esiTotalCites, 'subjectCode', list_detail.subjectCode, 'indicatorCodeSub',
                   list_detail.indicatorCodeSub, 'levelCode', list_detail.levelCode, 'data_source_id',
                   list_detail.data_source_id, 'rankingPrecise',
                   CASE WHEN indicatorCode = 1 THEN ( SELECT IF(ranking___precise IS NULL, ranking, ranking___precise)
                                                      FROM univ_ranking_dev.arwu_rank ar
                                                      WHERE list_detail.data_year = ar.yr
                                                        AND list_detail.institutionCode = ar.univ_code )
                        WHEN indicatorCode = 2 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                      FROM univ_ranking_dev.rr_qs_wur_rank qs
                                                      WHERE list_detail.data_year = qs.yr
                                                        AND list_detail.institutionCode = qs.univ_code )
                        WHEN indicatorCode = 3 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                      FROM univ_ranking_dev.rr_the_wur_rank the
                                                      WHERE list_detail.data_year = the.yr
                                                        AND list_detail.institutionCode = the.univ_code )
                        WHEN indicatorCode = 4 THEN ( SELECT ranking
                                                      FROM univ_ranking_dev.rr_usnews_bgu_rank usnews
                                                      WHERE list_detail.data_year = usnews.yr
                                                        AND list_detail.institutionCode = usnews.univ_code )
                        WHEN indicatorCode = 6 THEN ( SELECT ranking
                                                      FROM univ_ranking_dev.rr_cwur_wur_rank cwur
                                                      WHERE list_detail.data_year = cwur.ver_no
                                                        AND list_detail.institutionCode = cwur.univ_code )
                        WHEN indicatorCode = 14 THEN ( SELECT ranking
                                                       FROM univ_ranking_dev.rugc_rank rugc
                                                       WHERE list_detail.data_year = rugc.yr
                                                         AND list_detail.institutionCode = rugc.univ_code )
                        WHEN indicatorCode = 15 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                       FROM univ_ranking_dev.rr_qs_bur_rank bur
                                                       WHERE list_detail.data_year = bur.yr
                                                         AND list_detail.institutionCode = bur.univ_code )
                        WHEN indicatorCode = 16 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                       FROM univ_ranking_dev.rr_qs_aur_rank aur
                                                       WHERE list_detail.data_year = aur.yr
                                                         AND list_detail.institutionCode = aur.univ_code )
                        WHEN indicatorCode = 17 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                       FROM univ_ranking_dev.rr_the_eeur_rank eeur
                                                       WHERE list_detail.data_year = eeur.yr
                                                         AND list_detail.institutionCode = eeur.univ_code )
                        WHEN indicatorCode = 20 THEN ( SELECT IF(ranking_precise IS NULL, ranking, ranking_precise)
                                                       FROM univ_ranking_dev.rr_the_aur_rank the_aur
                                                       WHERE list_detail.data_year = the_aur.yr
                                                         AND list_detail.institutionCode = the_aur.univ_code )

                        ELSE 'NULL' END, 'indicators',
                   ( -- SELECT JSON_ARRAYAGG(JSON_OBJECT('code', rl.indicatorSubName, 'score', rl.indicatorValue))
                       SELECT JSON_OBJECTAGG(rl.indicatorSubName, rl.indicatorValue)
                       FROM rank_list rl
                       WHERE list_detail.institutionCode = rl.institutionCode
                         AND list_detail.data_year = rl.data_year
                         AND list_detail.indicatorCode = rl.indicatorCode )
           -- 'verListBy', IF(list_detail.indicatorCode IN ('32', '33', '34', '5_0', '5_1', '5_2', '5_3', '5_4', '5_5'), 'ESI', NULL)
           )                                                   AS detail,
       ''                                                         rel_code,
       IF(data_year RLIKE '-', LEFT(data_year, 4), 0)          AS agg_from,
       ''                                                         _eversions_,
       0                                                          created_by
FROM list_detail;

SET FOREIGN_KEY_CHECKS = 1;

-- ESI综合排名明细指标code更新
UPDATE ub_details_0429.intl_var_detail
SET var_code = '5_0'
WHERE var_code IN ('5_1', '5_2', '5_3', '5_4', '5_5');


-- 标记这些排名指标明细因聚合而产生的冗余数据，方便后续统一删除
DELETE
FROM ub_details_0429.intl_var_detail
WHERE detail ->> '$.country' = 'delete';

-- 跨5年指标更新到2016-2020的,更改该指标代码为2015-2019的代码
-- 72  <-- 107
-- 73  <-- 108
-- 74  <-- 109
-- 75  <-- 110
-- 76  <-- 111
-- 78  <-- 112
-- 101 <--  106

UPDATE ub_details_0429.intl_var_detail
SET var_code = CASE WHEN var_code = '107' THEN '72'
                    WHEN var_code = '108' THEN '73'
                    WHEN var_code = '109' THEN '74'
                    WHEN var_code = '110' THEN '75'
                    WHEN var_code = '111' THEN '76'
                    WHEN var_code = '112' THEN '78'
                    WHEN var_code = '106' THEN '101' END
WHERE var_code IN ('107', '108', '109', '110', '111', '112', '106');

UPDATE ub_details_0429.intl_var_detail A
SET var_id = ( SELECT id FROM derived_indicator B WHERE A.var_code = B.code AND B.r_leaf_id = 5 )
WHERE 1;



#  国际对比页面统计值迁移

-- 数据迁移前的准备：
-- 1.删除指标代码为 '77' 且年份字段为 '0' 的历史无用数据
/*DELETE
  FROM ub_ranking_old.data_summary_world
 WHERE indicator_id = '77'
   AND data_year = '0';*/

TRUNCATE derived_ind_value_latest;

INSERT IGNORE INTO derived_ind_value_latest ( derived_ind_id,
                                       ind_code,
                                       univ_code,
                                       target_ver,
                                       effect_ver,
                                       eff_src_ids,
                                       val_calc_src,
                                       val,
                                       val_rank_typ,
                                       val_rank_all,
                                       var_details,
                                       ref_detail,
                                       alt_id,
                                       alt_val )
SELECT 0                                                derived_ind_id,
       indicator_id,
       institution_code,
       data_year,
       data_year,
       data_source_from,
       0                                                val_calc_src,
       IF(indicator_id IN ('1',
                           '2',
                           '3',
                           '4',
                           '6',
                           '7',
                           '8',
                           '9',
                           '10',
                           '11',
                           '12',
                           '13',
                           '14',
                           '15',
                           '16',
                           '17',
                           '18',
                           '19',
                           '20',
                           '5_0',
                           '5_1',
                           '5_2',
                           '5_3',
                           '5_4',
                           '5_5'
           ), 0, data_value)                            val,
       0                                                val_rank_all,
       0                                                var_details,
       detail_info AS                                   var_details, -- 明细关联
       IF(indicator_id IN ('1',
                           '2',
                           '3',
                           '4',
                           '6',
                           '7',
                           '8',
                           '9',
                           '10',
                           '11',
                           '12',
                           '13',
                           '14',
                           '15',
                           '16',
                           '17',
                           '18',
                           '19',
                           '20',
                           '5_0',
                           '5_1',
                           '5_2',
                           '5_3',
                           '5_4',
                           '5_5'
           ), JSON_OBJECT('ranking', data_value), NULL) ref_detail,

       0                                                alt_id,
       NULL                                             alt_val
FROM ub_ranking_old.data_summary_world A
WHERE indicator_id IN ( SELECT indicatorid FROM ub_ranking_old.updata_tags_selector );

-- 更新target_ver、effect_ver为 '0' 的指标（跨度为5年的指标）
UPDATE derived_ind_value_latest di,ub_ranking_old.indicator_world iw
SET di.target_ver = RIGHT(iw.yearrange, 4),
    di.effect_ver = RIGHT(iw.yearrange, 4)
WHERE di.ind_code = iw.indicatorid
  AND di.target_ver = '0'
  AND di.ind_code IN ('72',
                      '73',
                      '74',
                      '75',
                      '76',
                      '78',
                      '79',
                      '80',
                      '81',
                      '82',
                      '83',
                      '84',
                      '85',
                      '89',
                      '90',
                      '101',
                      '102',
                      '103',
                      '106',
                      '107',
                      '108',
                      '109',
                      '110',
                      '111',
                      '112',
                      '113')
;

-- 跨5年指标更新到2016-2020的,更改该指标代码为2015-2019的代码(指标合并)
-- 72  <-- 107
-- 73  <-- 108
-- 74  <-- 109
-- 75  <-- 110
-- 76  <-- 111
-- 78  <-- 112
-- 101 <--  106

UPDATE derived_ind_value_latest
SET ind_code = CASE WHEN ind_code = '107' THEN '72'
                    WHEN ind_code = '108' THEN '73'
                    WHEN ind_code = '109' THEN '74'
                    WHEN ind_code = '110' THEN '75'
                    WHEN ind_code = '111' THEN '76'
                    WHEN ind_code = '112' THEN '78'
                    WHEN ind_code = '106' THEN '101' END
WHERE ind_code IN ('107', '108', '109', '110', '111', '112', '106');

-- 更新ESI年份
UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '01')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '1月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '03')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '3月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '05')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '5月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '07')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '7月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '09')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '9月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET target_ver = CONCAT(RIGHT(target_ver, 4), '11')
WHERE ind_code IN ( SELECT indicatorid
                    FROM ub_ranking_old.updata_tags_selector
                    WHERE REGEXP_REPLACE(indicator_name, '^.+（(.+)）$', '$1') = '11月' )
  AND RIGHT(target_ver, 4) = LEFT(target_ver, 4);

UPDATE derived_ind_value_latest
SET effect_ver = target_ver
WHERE ind_code IN ( SELECT indicatorid FROM ub_ranking_old.updata_tags_selector WHERE indicator_name RLIKE 'ESI' );

-- 修改 derived_ind_value_latest表的target_ve、effect_ver
-- SELECT * FROM derived_ind_value_latest WHERE RIGHT(target_ver, 4) = LEFT(target_ver, 4);
UPDATE derived_ind_value_latest
SET target_ver = RIGHT(target_ver, 4),
    effect_ver = RIGHT(effect_ver, 4)
WHERE RIGHT(target_ver, 4) = LEFT(target_ver, 4);

-- ESI综合排名统计指标code更新
DELETE
FROM derived_ind_value_latest
WHERE target_ver RLIKE '-'
  AND ind_code IN ('5_0', '5_1', '5_2', '5_3', '5_4', '5_5');

UPDATE derived_ind_value_latest
SET ind_code = '5_0'
WHERE ind_code IN ('5_1', '5_2', '5_3', '5_4', '5_5');

-- ESI学科上榜统计值指标code更新
DELETE
FROM derived_ind_value_latest
WHERE target_ver RLIKE '-'
  AND ind_code IN ('32_0',
                   '32_1',
                   '32_2',
                   '32_3',
                   '32_4',
                   '32_5',
                   '33_0',
                   '33_1',
                   '33_2',
                   '33_3',
                   '33_4',
                   '33_5',
                   '34_0',
                   '34_1',
                   '34_2',
                   '34_3',
                   '34_4',
                   '34_5'
    );

UPDATE derived_ind_value_latest
SET ind_code = '32'
WHERE ind_code IN ('32_0', '32_1', '32_2', '32_3', '32_4', '32_5');

UPDATE derived_ind_value_latest
SET ind_code = '33'
WHERE ind_code IN ('33_0', '33_1', '33_2', '33_3', '33_4', '33_5');

UPDATE derived_ind_value_latest
SET ind_code = '34'
WHERE ind_code IN ('34_0', '34_1', '34_2', '34_3', '34_4', '34_5');

UPDATE derived_ind_value_latest A
SET derived_ind_id = ( SELECT id FROM derived_indicator B WHERE A.ind_code = B.code AND B.r_leaf_id = 5 )
WHERE 1;



















