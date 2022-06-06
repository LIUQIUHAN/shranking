SELECT
	edition_year,
	type_code,
	target_type,
	CONCAT('#',COUNT(school_code ),'+' ) `N+`
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year = '202104' 
	AND type_score_rank IS NOT NULL 
	AND score != '0' 
GROUP BY
	type_code,
	target_type UNION ALL
SELECT
	edition_year,
	type_code,
	target_type,
	CONCAT('#',COUNT(school_code ),'+' ) `N+`
FROM
	`rank_tbl_module_dimension_score_info` 
WHERE
	edition_year = '202201' 
	AND type_score_rank IS NOT NULL 
	AND score != '0' 
GROUP BY
	type_code,
	target_type;