SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202104' 
	AND B.edition_year = '202104' 
	AND C.edition_year = '202104' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0001' 
	AND C.target_weight != '0' 
	AND A.school_code IN (
		'A0268',
		'A0311',
		'A0239',
		'A0588',
		'A0024',
		'A0323',
		'A0714',
		'A0558',
		'A0580',
		'A0394',
		'A0662',
		'A0275',
		'A0238',
		'A0272',
		'A0270',
		'A0247',
		'A0185',
		'A0637',
		'A0619',
		'A0319',
		'A0243',
		'A0215',
		'A0276',
		'A0375',
		'A0557',
		'A0593',
		'A0716',
		'A0420',
		'A0008',
		'A0190',
		'A0527',
		'D0091',
		'A0186',
		'A0312',
		'A0047',
		'A0784',
		'A0594',
		'A0723',
		'A0004',
		'A0242',
		'A0636',
		'A0314',
		'A0494',
		'A0005',
		'A0007',
		'A0590',
		'A0194',
		'A0578',
	  'A0131'	
	) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2022` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202202' 
	AND B.edition_year = '202202' 
	AND C.edition_year = '202202' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0001' 
	AND C.target_weight != '0' 
	AND A.school_code IN (
		'A0268',
		'A0311',
		'A0239',
		'A0588',
		'A0024',
		'A0323',
		'A0714',
		'A0558',
		'A0580',
		'A0394',
		'A0662',
		'A0275',
		'A0238',
		'A0272',
		'A0270',
		'A0247',
		'A0185',
		'A0637',
		'A0619',
		'A0319',
		'A0243',
		'A0215',
		'A0276',
		'A0375',
		'A0557',
		'A0593',
		'A0716',
		'A0420',
		'A0008',
		'A0190',
		'A0527',
		'D0091',
		'A0186',
		'A0312',
		'A0047',
		'A0784',
		'A0594',
		'A0723',
		'A0004',
		'A0242',
		'A0636',
		'A0314',
		'A0494',
		'A0005',
		'A0007',
		'A0590',
		'A0194',
		'A0578',
	  'A0131' 
	) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202104' 
	AND B.edition_year = '202104' 
	AND C.edition_year = '202104' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0003' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0439', 'A0404', 'A0264' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2022` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202202' 
	AND B.edition_year = '202202' 
	AND C.edition_year = '202202' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0003' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0439', 'A0404', 'A0264' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202104' 
	AND B.edition_year = '202104' 
	AND C.edition_year = '202104' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0006' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0566', 'A0622', 'A0318', 'A0425', 'A0083', 'A0246', 'A0517' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2022` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202202' 
	AND B.edition_year = '202202' 
	AND C.edition_year = '202202' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0006' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0566', 'A0622', 'A0318', 'A0425', 'A0083', 'A0246', 'A0517' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202104' 
	AND B.edition_year = '202104' 
	AND C.edition_year = '202104' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0009' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0589' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2022` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202202' 
	AND B.edition_year = '202202' 
	AND C.edition_year = '202202' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0009' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'A0589' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202104' 
	AND B.edition_year = '202104' 
	AND C.edition_year = '202104' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0016' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'B0054' ) UNION ALL
SELECT
	A.edition_year 版本,
	A.school_code 学校代码,
	B.module_id 模块,
	B.Dimension_names 维度,
	B.target_name 指标,
	C.target_weight 权重,
	A.data_year 监测年份,
	A.target_val 指标值,
	IFNULL( A.target_score * C.target_weight, 0 ) 得分,
	CONCAT('#',A.type_score_rank) `类型排名`,
IF
	( A.data_year = A.original_year, '本校已更新', '本校待更新' ) 更新状态 
FROM
	`rank_tbl_school_target_info_rank_2022` A
	LEFT JOIN rank_tbl_module_info B USING ( edition_year, target_code )
	LEFT JOIN rank_tbl_edition_school_type_weight C USING ( edition_year, target_code ) 
WHERE
	A.edition_year = '202202' 
	AND B.edition_year = '202202' 
	AND C.edition_year = '202202' AND target_val != '0' AND target_val IS NOT NULL
	AND B.is_rank = '1' 
	AND C.type_code = '0016' 
	AND C.target_weight != '0' 
	AND A.school_code IN ( 'B0054' );