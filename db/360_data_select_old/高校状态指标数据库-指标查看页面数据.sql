SELECT
	school_code AS institutionCode,
	target_code,
	target_val,
	data_year,
	original_source 
FROM
	`temporary_rank_tbl_school_target_info` 
WHERE
	data_year = original_year 
	AND target_val != '' 
	AND target_val IS NOT NULL 
	AND target_code IN (
		'i7',
		'i111',
		'i112',
		'i14',
		'i16',
		'i17',
		'i215',
		'i29',
		'i49',
		'i51',
		'i18',
		'i19',
		'i116',
		'i81',
		'i20',
		'i113',
		'c10',
		'c12',
		'i1',
		'i2',
		'i3',
		'i4',
		'i5',
		'b6',
		'i6',
		'b8',
		'i80',
		'i23',
		'i115',
		'i26',
		'i27',
		'b73',
		'b74',
		'c38',
		'c39',
		'c40',
		'c41',
		'c42',
		'c43',
	'c44' 
	);