# 国际对标明细数据入库
USE ub_details_0429;
# 自然指数（Nature Index）排名
INSERT INTO intl_var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                             rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by, updated_at, updated_by,
                             deleted_at, deleted_by)
SELECT NULL                              dtl_id,
       0                                 revision,
       222                               var_id,
       '7'                               var_code,
       1                                 source_id,
       yr                                ver_no,
       univ_code,
       0                                 lev,
       0                                 val,
       JSON_OBJECT('indicatorValue', rank_world,
                   'country', region_cn,
                   'data_year', yr,
                   'data_source_id', 1,
                   'indicatorCode', '7') detail,
       ''                                rel_code,
       0                                 agg_from,
       ''                                _eversions_,
       0                                 _r_ver_no,
       NOW()                             created_at,
       -2                                created_by,
       NOW()                             updated_at,
       NULL                              updated_by,
       NULL                              deleted_at,
       NULL                              deleted_by
FROM ub_details_raw.raw_nature_index_wur_20220630
WHERE yr = 2022;


# 删除排名数据库中历史数据
DELETE
FROM ub_ranking_dev.derived_ind_value_latest
WHERE ind_code = '7';

# 计算统计值数据：自然指数（Nature Index）排名
INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT var_id                                                         derived_ind_id,
       var_code                                                       ind_code,
       univ_code,
       ver_no                                                         target_ver,
       ver_no                                                         effect_ver,
       source_id                                                      eff_src_ids,
       0                                                              val_calc_src,
       val,
       0                                                              val_rank_typ,
       0                                                              val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       JSON_OBJECT('ranking', detail ->> '$.indicatorValue')       AS ref_detail,
       0                                                              alt_id,
       NULL                                                           alt_val,
       NOW()                                                       AS created_at,
       NOW()                                                       AS updated_at,
       NULL                                                        AS deleted_at
FROM intl_var_detail
WHERE var_code = '7'
GROUP BY univ_code, var_code, ver_no;


# Scimago世界大学排名
INSERT INTO intl_var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                             rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by, updated_at, updated_by,
                             deleted_at, deleted_by)
SELECT NULL                              dtl_id,
       0                                 revision,
       224                               var_id,
       '9'                               var_code,
       1                                 source_id,
       yr                                ver_no,
       univ_code,
       0                                 lev,
       0                                 val,
       JSON_OBJECT('indicatorValue', ranking,
                   'country', region_cn,
                   'data_year', yr,
                   'data_source_id', 1,
                   'indicatorCode', '9') detail,
       ''                                rel_code,
       0                                 agg_from,
       ''                                _eversions_,
       0                                 _r_ver_no,
       NOW()                             created_at,
       -2                                created_by,
       NOW()                             updated_at,
       NULL                              updated_by,
       NULL                              deleted_at,
       NULL                              deleted_by
FROM ub_details_raw.scimago_world_univ_ranking_20220623
WHERE yr = 2022;


# 计算统计值数据：Scimago世界大学排名
INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT var_id                                                         derived_ind_id,
       var_code                                                       ind_code,
       univ_code,
       ver_no                                                         target_ver,
       ver_no                                                         effect_ver,
       source_id                                                      eff_src_ids,
       0                                                              val_calc_src,
       val,
       0                                                              val_rank_typ,
       0                                                              val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       JSON_OBJECT('ranking', detail ->> '$.indicatorValue')       AS ref_detail,
       0                                                              alt_id,
       NULL                                                           alt_val,
       NOW()                                                       AS created_at,
       NOW()                                                       AS updated_at,
       NULL                                                        AS deleted_at
FROM intl_var_detail
WHERE var_code = '9'
  AND ver_no = 2022
GROUP BY univ_code;


# 计算统计值数据：自然指数大学排名
SELECT *
FROM ub_ranking_dev.derived_ind_value_latest
WHERE ind_code = '7';

INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT var_id                                                         derived_ind_id,
       var_code                                                       ind_code,
       univ_code,
       ver_no                                                         target_ver,
       ver_no                                                         effect_ver,
       source_id                                                      eff_src_ids,
       0                                                              val_calc_src,
       val,
       0                                                              val_rank_typ,
       0                                                              val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       JSON_OBJECT('ranking', detail ->> '$.rank_world')           AS ref_detail,
       0                                                              alt_id,
       NULL                                                           alt_val,
       NOW()                                                       AS created_at,
       NOW()                                                       AS updated_at,
       NULL                                                        AS deleted_at
FROM intl_var_detail
WHERE var_code = '7'
GROUP BY ver_no, univ_code;



# 自然指数学科排名-2022
# 原始数据入库（略）
# 根据产品（兰涛）要求，将历史年份数据后推一年
-- SELECT * FROM intl_var_detail WHERE var_code = '36' ORDER BY ver_no,univ_code;
-- UPDATE intl_var_detail SET ver_no = ver_no + 1 WHERE var_code = '36';
-- UPDATE intl_var_detail SET detail = JSON_SET(detail,'$.data_year',ver_no) WHERE var_code = '36';

# 数据入明细库
INSERT INTO intl_var_detail (revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail, rel_code,
                             agg_from, _eversions_, _r_ver_no, created_at, created_by, updated_at, updated_by,
                             deleted_at, deleted_by)
SELECT 0     revision,
       252   var_id,
       36    var_code,
       1     source_id,
       yr    ver_no,
       univ_code,
       0     lev,
       0     val,
       JSON_OBJECT(
               'awardee', NULL,
               'country', NULL,
               'awardName', NULL,
               'data_year', yr,
               'isTop1000', NULL,
               'levelCode', NULL,
               'indicators', NULL,
               'isTop10000', NULL,
               'subjectCode', NULL,
               'esiTotalCites', NULL,
               'indicatorCode', '36',
               'data_source_id', '1',
               'indicatorValue', `rank`,
               'rankingPrecise', NULL,
               'institutionCode', univ_code,
               'institutionName', NULL,
               'indicatorCodeSub', IF((`rank`+ 0) > 50, NULL, '35'),
               'indicatorSubName', subject_name_en,
               'totalInstitution', NULL
           ) detail,
       ''    rel_code,
       0     agg_from,
       ''    _eversions_,
       0     _r_ver_no,
       NOW() created_at,
       0     created_by,
       NOW() updated_at,
       NULL  updated_by,
       NULL  deleted_at,
       NULL  deleted_by
FROM univ_ranking_raw.raw_nature_index_wsr_20220630
WHERE yr = 2022;


# 指标表监测年份更新
UPDATE ub_ranking_dev.derived_indicator
SET detail = JSON_SET(detail, '$.targetVer', '2022', '$.availVer', '2016-2022')
WHERE r_leaf_id = 5
  AND code IN ('35', '36');


# 指标数据表更新
DELETE
FROM ub_ranking_dev.derived_ind_value_latest
WHERE ind_code IN ('35', '36');

INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT 252                                                            derived_ind_id,
       '36'                                                           ind_code,
       univ_code,
       ver_no                                                         target_ver,
       ver_no                                                         effect_ver,
       source_id                                                      eff_src_ids,
       0                                                              val_calc_src,
       COUNT(*)                                                    AS val,
       0                                                              val_rank_typ,
       0                                                              val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       NULL                                                        AS ref_detail,
       0                                                              alt_id,
       NULL                                                           alt_val,
       NOW()                                                       AS created_at,
       NOW()                                                       AS updated_at,
       NULL                                                        AS deleted_at
FROM intl_var_detail
WHERE var_code = '36'
GROUP BY ver_no, univ_code;

INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT 251                                                            derived_ind_id,
       '35'                                                           ind_code,
       univ_code,
       ver_no                                                         target_ver,
       ver_no                                                         effect_ver,
       source_id                                                      eff_src_ids,
       0                                                              val_calc_src,
       COUNT(*)                                                    AS val,
       0                                                              val_rank_typ,
       0                                                              val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       NULL                                                        AS ref_detail,
       0                                                              alt_id,
       NULL                                                           alt_val,
       NOW()                                                       AS created_at,
       NOW()                                                       AS updated_at,
       NULL                                                        AS deleted_at
FROM intl_var_detail
WHERE var_code = '36'
  AND detail ->> '$.indicatorCodeSub' = '35'
GROUP BY ver_no, univ_code;


































