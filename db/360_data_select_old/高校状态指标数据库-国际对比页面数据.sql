WITH A AS (
	SELECT
		* 
	FROM
		`temporary_rank_tbl_school_target_info` 
	WHERE
		data_year = original_year 
		AND target_val != '' 
		AND target_val IS NOT NULL 
		AND target_code IN (
			'i1',
			'i2',
			'i3',
			'i4',
			'i34',
			'i14',
			'i15',
			'i16',
			'i17',
			'i215',
			'i18',
			'i19',
			'i29',
			'i30',
			'i49',
			'i50',
			'i80',
			'i81' 
		)) SELECT
	B.unified_code AS institutionCode,
	B.school_neme AS institutionName,
	'中国' AS country,
	C.indicatorCode,
	A.target_val AS indicatorValue,
	A.data_year,
	A.original_year AS real_year,
	A.original_source AS data_source_id 
FROM
	A
	INNER JOIN _world_school_code B ON A.school_code = B.school_code
	LEFT JOIN world_target_code C ON A.target_code = C.target_code;