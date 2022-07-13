# 博士点申报指标变量折合系数
USE spm_ranking_dev;

# 非省级指标
DELETE FROM dpa_var_lev_conv WHERE province_code = 0;
INSERT IGNORE INTO dpa_var_lev_conv (r_root_id, r_ver_no, ind_name, ind_id, var_id, var_code, province_code, conv_val,
                                     lev, lev_name, remark,
                                     created_at, updated_at)
/*WITH IL AS (SELECT var_id, var_code, lev
            FROM spm_details_0208.var_detail
            WHERE _eversions_ = 202208
            GROUP BY var_id, var_code, lev)*/
SELECT 3                                                                                r_root_id,
       202207                                                                           r_ver_no,
       ind_name,
       (SELECT id FROM dpa_ranking_ind B WHERE A.ind_name = B.name)                     ind_id,
       (SELECT B.id FROM spm_details_0208.variable B WHERE A.var_code = B.code LIMIT 1) var_id,
       var_code,
       0                                                                                province_code,
       conv_val,
       IFNULL((SELECT B.lev FROM spm_details_0208.var_detail_lev B WHERE A.var_code = B.var_code AND A.lev_name = B.award_name), 1)        lev,
       IFNULL(lev_name, '') AS                                                          lev_name,
       var_name             AS                                                          remark,
       NOW()                                                                            created_at,
       NOW()                                                                            updated_at
FROM ub_details_raw.dpa_var_lev_conv A
WHERE conv_val IS NOT NULL
  AND conv_val NOT RLIKE '省';


# 省级指标:学术带头人与学术骨干（折合数）
INSERT INTO dpa_var_lev_conv (r_root_id, r_ver_no, ind_name, ind_id, var_id, var_code, province_code, conv_val, lev,
                              lev_name, remark,
                              created_at, updated_at)

SELECT 3                 AS r_root_id,
       202207            AS r_ver_no,
       '学术带头人与学术骨干（折合数）' AS ind_name,
       13                AS ind_id,
       var_id,
       var_code,
       province_code,
       (conv_val / 16)   AS conv_val,
       lev,
       lev_name,
       remark,
       NOW()             AS created_at,
       NOW()             AS updated_at
FROM var_lev_conv A
WHERE var_code IN ('ptaward2',
                   'psaward2',
                   'psaward6',
                   'psaward8',
                   'psaward4'
    ) AND r_root_id = 1 AND r_ver_no = 0 AND province_code != 0;

# 省级指标:省部级及以上科研奖励（折合数）
INSERT INTO dpa_var_lev_conv (r_root_id, r_ver_no, ind_name, ind_id, var_id, var_code, province_code, conv_val, lev,
                              lev_name, remark,
                              created_at, updated_at)

SELECT 3                   AS r_root_id,
       202207              AS r_ver_no,
       '省部级及以上科研奖励（折合数）'   AS ind_name,
       25                  AS ind_id,
       var_id,
       var_code,
       province_code,
       (conv_val / 32 * 6) AS conv_val,
       lev,
       lev_name,
       remark,
       NOW()               AS created_at,
       NOW()               AS updated_at
FROM var_lev_conv A
WHERE var_code IN (
                   'psaward2',
                   'psaward6',
                   'psaward8',
                   'psaward4'
    ) AND r_root_id = 1 AND r_ver_no = 0 AND province_code != 0;

# 省级指标:省部级及以上教学成果奖（折合数）
INSERT INTO dpa_var_lev_conv (r_root_id, r_ver_no, ind_name, ind_id, var_id, var_code, province_code, conv_val, lev,
                              lev_name, remark,
                              created_at, updated_at)

SELECT 3                  AS r_root_id,
       202207             AS r_ver_no,
       '省部级及以上教学成果奖（折合数）' AS ind_name,
       18                 AS ind_id,
       var_id,
       var_code,
       province_code,
       (conv_val / 32)    AS conv_val,
       lev,
       lev_name,
       remark,
       NOW()              AS created_at,
       NOW()              AS updated_at
FROM var_lev_conv A
WHERE var_code = 'ptaward2' AND r_root_id = 1 AND r_ver_no = 0 AND province_code != 0;









