# 国际对标明细数据入库
USE ub_details_0429;
# 自然指数（Nature Index）排名
INSERT INTO intl_var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                             rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by, updated_at, updated_by,
                             deleted_at, deleted_by)
SELECT NULL                            dtl_id,
       0                               revision,
       222                             var_id,
       '7'                             var_code,
       1                               source_id,
       yr                              ver_no,
       univ_code,
       0                               lev,
       0                               val,
       JSON_OBJECT('indicatorValue', ranking,
            'country', region_cn,
            'data_year', yr,
            'data_source_id', 1,
            'indicatorCode', '7')        detail,
       ''                              rel_code,
       0                               agg_from,
       ''                              _eversions_,
       0                               _r_ver_no,
       NOW()                           created_at,
       -2                              created_by,
       NOW()                           updated_at,
       NULL                            updated_by,
       NULL                            deleted_at,
       NULL                            deleted_by
FROM ub_details_raw.nature_index_world_univ_ranking_20220623
WHERE yr = 2022;



# 删除排名数据库中历史数据
DELETE
FROM ub_ranking_dev.derived_ind_value_latest
WHERE ind_code = '7';

# 计算统计值数据
INSERT INTO ub_ranking_dev.derived_ind_value_latest (derived_ind_id, ind_code, univ_code, target_ver, effect_ver,
                                                     eff_src_ids, val_calc_src, val, val_rank_typ, val_rank_all,
                                                     var_details, ref_detail, alt_id, alt_val, created_at, updated_at,
                                                     deleted_at)
SELECT var_id derived_ind_id,
       var_code ind_code,
       univ_code,
       ver_no target_ver,
       ver_no effect_ver,
       source_id eff_src_ids,
       0 val_calc_src,
       val,
       0 val_rank_typ,
       0 val_rank_all,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY()) AS var_details,
       JSON_OBJECT('ranking',detail ->> '$.indicatorValue') AS ref_detail,
       0 alt_id,
       NULL alt_val,
       NOW() AS created_at,
       NOW() AS updated_at,
       NULL  AS deleted_at
FROM intl_var_detail
WHERE var_code = '7'
GROUP BY univ_code,var_code,ver_no;

























/*
UPDATE intl_var_detail SET detail = REPLACE(detail,'研究','科研') WHERE var_code = '20' AND ver_no = 2022;
UPDATE intl_var_detail SET detail = REPLACE(detail,'国际展望','国际化') WHERE var_code = '20' AND ver_no = 2022;
UPDATE intl_var_detail SET detail = REPLACE(detail,'行业收入','企业收入') WHERE var_code = '20' AND ver_no = 2022;
*/











