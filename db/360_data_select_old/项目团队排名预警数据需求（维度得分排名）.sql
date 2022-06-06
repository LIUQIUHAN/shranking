SELECT
	edition_year 版本,
	school_code 学校代码,
	type_code 学校类型,
	target_type 维度,
	score 得分,
	CONCAT('#',type_score_rank) `类型排名` 
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year IN ( '202104', '202201' ) 
	AND type_score_rank IS NOT NULL 
	AND type_code = '0001' 
	AND school_code IN (
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
		'A0578' 
	) UNION ALL
SELECT
	edition_year 版本,
	school_code 学校代码,
	type_code 学校类型,
	target_type 维度,
	score 得分,
	CONCAT('#',type_score_rank) `类型排名` 
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year IN ( '202104', '202201' ) 
	AND type_score_rank IS NOT NULL 
	AND type_code = '0003' 
	AND school_code IN ( 'A0439', 'A0404', 'A0264' ) UNION ALL
SELECT
	edition_year 版本,
	school_code 学校代码,
	type_code 学校类型,
	target_type 维度,
	score 得分,
	CONCAT('#',type_score_rank) `类型排名` 
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year IN ( '202104', '202201' ) 
	AND type_score_rank IS NOT NULL 
	AND type_code = '0006' 
	AND school_code IN ( 'A0566', 'A0622', 'A0318', 'A0425', 'A0083', 'A0246', 'A0517' ) UNION ALL
SELECT
	edition_year 版本,
	school_code 学校代码,
	type_code 学校类型,
	target_type 维度,
	score 得分,
	CONCAT('#',type_score_rank) `类型排名` 
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year IN ( '202104', '202201' ) 
	AND type_score_rank IS NOT NULL 
	AND type_code = '0009' 
	AND school_code IN ( 'A0589' ) UNION ALL
SELECT
	edition_year 版本,
	school_code 学校代码,
	type_code 学校类型,
	target_type 维度,
	score 得分,
	CONCAT('#',type_score_rank) `类型排名` 
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year IN ( '202104', '202201' ) 
	AND type_score_rank IS NOT NULL 
	AND type_code = '0016' 
	AND school_code IN ( 'B0054' );