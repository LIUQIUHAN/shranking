# 本科教学质量报告数据：

SELECT target_code                                                                                       指标代码,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition B WHERE A.target_code = B.target_code ) 指标名称,
       data_year                                                                                         数据年份,
       COUNT(DISTINCT school_code)                                                                       学校数
FROM rank_tbl_basics_target_data A
WHERE target_code IN ('i1',
                      'i2',
                      'i3',
                      'i4',
                      'i34',
                      'i5',
                      'b6',
                      'i6',
                      'b8',
                      'i18',
                      'i19',
                      'i20',
                      'i113',
                      'c10',
                      'c12',
                      'c13',
                      'i24',
                      'i25',
                      'i115',
                      'i116',
                      'i28',
                      'i80',
                      'i81'
    )
  AND data_year = '2021'
GROUP BY target_code

UNION ALL

# 就业质量报告数据：	
SELECT target_code                                                                                       指标代码,
       ( SELECT target_name FROM rank_tbl_module_info_no_edition B WHERE A.target_code = B.target_code ) 指标名称,
       data_year                                                                                         数据年份,
       COUNT(DISTINCT school_code)                                                                       学校数
FROM rank_tbl_basics_target_data A
WHERE target_code IN ('i26',
                      'c36',
                      'i27',
                      'b73',
                      'b74',
                      'c37',
                      'c38',
                      'c39',
                      'c40',
                      'c41',
                      'c42',
                      'c43',
                      'c44'
    )
  AND data_year = '2021'
GROUP BY target_code;