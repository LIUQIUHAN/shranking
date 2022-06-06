SELECT
	B.province,
	A.target_code,
	C.target_name,
	SUM( IFNULL( A.target_val, 0 ) ) AS target_val1,
	SUM( IFNULL( A.fixed_value, 0 ) ) AS target_val2,
	( SUM( IFNULL( A.target_val, 0 ) ) + SUM( IFNULL( A.fixed_value, 0 ) ) ) AS target_val3 
FROM
	`temporary_rank_tbl_school_target_info` A
	LEFT JOIN rank_tbl_school_info B ON A.school_code = B.school_code
	LEFT JOIN rank_tbl_module_info_no_edition C ON A.target_code = C.target_code 
WHERE
	A.target_code IN ( 'i1', 'i2', 'i3', 'i4', 'i5', 'b6', 'i18' ) 
	AND A.data_year = '2020' 
GROUP BY
	province,
	target_code 
ORDER BY
	province,
	target_val1 DESC;