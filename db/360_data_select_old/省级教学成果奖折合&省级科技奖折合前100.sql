#

SELECT ( SELECT school_name FROM rank_tbl_school_info C WHERE A.school_code = C.school_code )            学校名称,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition B WHERE A.target_code = B.target_code ) 指标名称,
       target_val                                                                                        折合数,
       data_year                                                                                         年份,
       target_rank                                                                                       排名
FROM `temporary_rank_tbl_school_target_info` A
WHERE target_code IN ('ptadwt', 'psadwt')
  AND data_year = '2015-2020'
  AND target_rank + 0 <= 100
ORDER BY target_code, target_rank + 0;