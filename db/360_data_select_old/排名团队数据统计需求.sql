-- 有数据学校数：

SELECT ( SELECT id FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code )          id,
       target_code,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code ) target_name,
       COUNT(school_code)                                                                                count
FROM rank_tbl_school_target_info_issue B
WHERE edition_year = '202203'
  AND target_code IN ( SELECT target_code
                       FROM rank_tbl_edition_school_type_weight_issue
                       WHERE edition_year = '202203' AND target_weight != 0 )
  AND school_code IN ( SELECT school_code FROM rank_tbl_school_info )
GROUP BY target_code
ORDER BY id;

-- 分年有数据数据量：

SELECT ( SELECT id FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code )           id,
       target_code                                                                                        指标代码,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code )  指标名称,
       original_year                                                                                      数据真实年份,
       ( SELECT default_year FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code ) 监测年份,
       COUNT(DISTINCT school_code)                                                                        使用该年份数据量
FROM rank_tbl_school_target_info_rank_2022 B
WHERE B.edition_year = '202203'
  AND B.target_val IS NOT NULL
  AND B.original_year IS NOT NULL
  AND B.target_code IN ( SELECT target_code
                         FROM rank_tbl_edition_school_type_weight_issue
                         WHERE edition_year = '202203' AND target_weight != 0 )
GROUP BY target_code, original_year
ORDER BY id, original_year;


SELECT target_code                                                                                       指标代码,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code ) 指标名称,
       original_year                                                                                     数据真实年份,
       data_year                                                                                         监测年份,
       COUNT(*)                                                                                          统计值
FROM `temporary_rank_tbl_school_target_info` B
WHERE target_code IN ('i2', 'i34', 'i5', 'b6')
  AND data_year = '2021'
  AND B.target_val IS NOT NULL
  AND B.original_year IS NOT NULL
GROUP BY target_code, original_year
ORDER BY target_code, original_year;

SELECT target_code                                                                                       指标代码,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition A WHERE A.target_code = B.target_code ) 指标名称,
       original_year                                                                                     数据真实年份,
       data_year                                                                                         监测年份,
       COUNT(*)                                                                                          统计值
FROM `temporary_rank_tbl_school_target_info` B
WHERE target_code IN ('i49', 'i50', 'i51', 'i52')
  AND data_year = '2019'
  AND B.target_val IS NOT NULL
  AND B.original_year IS NOT NULL
GROUP BY target_code, original_year
ORDER BY target_code, original_year;