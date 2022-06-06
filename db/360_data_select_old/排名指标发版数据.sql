#

SELECT A.school_code       学校代码,
       C.school_name       学校名称,
       C.province          省份,
       C.school_type       学校类型,
       C.school_level_name 学校层次,
       A.target_code       指标代码,
       B.target_name       指标名称,
       B.is_rank           排名指标,
       A.data_year         监测年份,
       A.target_val        指标数值
       -- D.indicatorSourceName 来源
FROM `rank_tbl_school_target_info_issue`       A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
     LEFT JOIN rank_tbl_school_info            C ON A.school_code = C.school_code
     -- LEFT JOIN indicatorsource D ON A.target_code = D.indicatorId AND A.original_source = D.indicatorSourceId
WHERE A.edition_year = '202204'
      -- AND A.target_code IN ( SELECT target_code FROM rank_tbl_module_info_no_edition WHERE is_rank = 1 )
      -- AND A.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE school_level IN ( '8','9' ) )
      -- AND A.target_code IN ( 'i2','i3','i4','i34','b6' )
      -- AND A.school_code IN ( 'B0066','D0055' )
ORDER BY 学校代码, 排名指标 DESC;


SELECT A.school_code       学校代码,
       C.school_name       学校名称,
       C.province          省份,
       C.school_type       学校类型,
       C.school_level_name 学校层次,
       A.target_code       指标代码,
       B.target_name       指标名称,
       B.is_rank           排名指标,
       A.target_year       监测年份,
       A.fixed_value       替代值,
       A.fixed_value_ave   `教师规模均值替代值`
FROM `rank_tbl_ranking_fixed_val_issue`        A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
     LEFT JOIN rank_tbl_school_info            C ON A.school_code = C.school_code
WHERE A.edition_year = '202204'
      -- AND A.target_code IN ( SELECT target_code FROM rank_tbl_module_info_no_edition WHERE is_rank = 1 )
      -- AND A.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE school_level IN ( '8','9' ) )
      -- AND A.target_code IN ( 'i2','i3','i4','i34','b6' )
ORDER BY 学校代码, 排名指标 DESC;