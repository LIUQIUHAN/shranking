USE ub_details_raw;

# 导入本次更新的数据

-- 注： 更新 @Date_import 后执行
SET @Date_import = '2022-05-19';
INSERT INTO ub_details_0429.var_detail ( dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         agg_from, created_by )
WITH dtls AS ( SELECT ( SELECT var_id
                        FROM ub_ranking_0520.v_ind_lat_l4_flat_wide C
                        WHERE A.target_code = C.code )                    AS var_id,
                      target_code                                         AS var_code,

                      ( SELECT _new_src_id
                        FROM ub_ranking_0520.c_ind_source B
                        WHERE A.data_source_id = B._old_src_id
                          AND A.target_code = B.ind_code
                          AND b._new_src_id IS NOT NULL )                 AS source_id,
                      IF(target_code = 'i101', 0, LEFT(data_year, 4))     AS ver_no,
                      func_school_code_tr_now_code(school_code)           AS univ_code,
                      0                                                   AS lev,
                      target_val                                          AS val,
                      IF(LENGTH(target_code) > 4, RIGHT(data_year, 4), 0) AS agg_from
               FROM rank_tbl_basics_target_data A
               WHERE DATE_FORMAT(import_date, '%Y-%m-%d') = @Date_import
                 AND target_code IN ('i2',
                                     'i3',
                                     'i4',
                                     'i34',
                                     'i5',
                                     'b6',
                                     'i14',
                                     'i16',
                                     'i17',
                                     'i215',
                                     'i18',
                                     'i20',
                                     'i113',
                                     'c10',
                                     'c12',
                                     'i23',
                                     'i24',
                                     'i115',
                                     'i116',
                                     'i26',
                                     'c36',
                                     'i27',
                                     'b73',
                                     'b74',
                                     'c37',
                                     'c39',
                                     'c40',
                                     'c41',
                                     'c42',
                                     'c43',
                                     'c44',
                                     'i29',
                                     'i103',
                                     'i47',
                                     'i49',
                                     'i49b',
                                     'patent3',
                                     'patent1',
                                     'patent5',
                                     'patent7',
                                     'patent9',
                                     'i51',
                                     'i51b',
                                     'i81',
                                     'i82',
                                     'i104',
                                     'i105',
                                     'b178',
                                     'i101',
                                     'i89'
                   ) )

SELECT B.dtl_id,
       IFNULL(( SELECT MAX(revision) + 1
                FROM ub_details_0429.var_detail B
                WHERE A.var_code = B.var_code
                  AND A.source_id = B.source_id
                  AND A.ver_no = B.ver_no
                  AND A.univ_code = B.univ_code
                  AND A.agg_from = B.agg_from ), 0) AS revision,
       A.var_id,
       A.var_code,
       A.source_id,
       A.ver_no,
       A.univ_code,
       A.lev,
       A.val,
       A.agg_from,
       -1                                           AS created_by
FROM dtls                                 A
     LEFT JOIN ub_details_0429.var_detail B
               ON A.var_code = B.var_code AND A.source_id = B.source_id AND A.ver_no = B.ver_no AND
                  A.univ_code = B.univ_code AND A.agg_from = B.agg_from
;




