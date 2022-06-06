WITH a AS ( SELECT * FROM `rank_tbl_module_info` WHERE edition_year = '202104' AND is_rank = 1 )
   , b AS ( SELECT * FROM `rank_tbl_module_info` WHERE edition_year = '202202' AND is_rank = 1 ) 

SELECT
	b.target_name 指标名称,
	b.default_year `版本202202`,
	a.default_year `版本202104`,
IF
	( b.default_year = a.default_year, '全体未更新', '全体已更新' ) 状态 
FROM
	b
	LEFT JOIN a USING ( target_code );