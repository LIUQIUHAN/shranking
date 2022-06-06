#

SELECT B.target_name         变量名称,
       D.school_name         学校名称,
       D.unified_code        院校编码,
       D.school_code         院校代码,
       A.target_val          数据值,
       C.indicatorSourceName 数据来源,
       A.original_year       数据年份
FROM `rank_tbl_school_target_info_issue`       A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
     LEFT JOIN indicatorsource                 C
               ON A.target_code = C.indicatorId AND A.original_source = C.indicatorSourceId
     LEFT JOIN rank_tbl_school_info            D ON A.school_code = D.school_code
WHERE edition_year = '202106'
  AND A.target_code IN ('i26', 'i15', 'i19', 'i20', 'i113', 'i115')
UNION ALL
SELECT B.target_name  变量名称,
       D.school_name  学校名称,
       D.unified_code 院校编码,
       D.school_code  院校代码,
       A.fixed_value  数据值,
       '替代值' AS       数据来源,
       A.target_year  数据年份
FROM `rank_tbl_ranking_fixed_val_issue`        A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
     LEFT JOIN rank_tbl_school_info            D ON A.school_code = D.school_code
WHERE edition_year = '202106'
  AND A.target_code IN ('i26', 'i15', 'i19', 'i20', 'i113', 'i115');