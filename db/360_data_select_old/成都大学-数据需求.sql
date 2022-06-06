#

SELECT
    -- A.school_code,
    -- A.target_code,
    B.target_name                                                    指标名称,
    A.data_year                                                      监测年份,
    IFNULL(( SELECT fixed_value
             FROM rank_tbl_ranking_fixed_val C
             WHERE C.edition_year = A.edition_year
               AND C.school_code = A.school_code
               AND C.target_code = A.target_code ), A.target_val) AS `指标值（替代值）`,
    (A.type_score_rank + 0)                                          指标排名
FROM `rank_tbl_school_target_info_rank_2022`   A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
WHERE edition_year = '202204'
  AND A.target_code IN ( SELECT target_code FROM rank_tbl_module_info_no_edition WHERE is_rank = '1' )
  AND A.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '综合类' )
  -- AND A.type_score_rank = '148'
  -- AND A.target_code = 'i115'
ORDER BY 指标名称, 指标排名;


SELECT module_id 模块, score 维度得分, type_score_rank 维度排名（综合类）
FROM `rank_tbl_module_score_info`
WHERE edition_year = '202204'
  AND type_code = '0001'
  AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '综合类' );
	
	
