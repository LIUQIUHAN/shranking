SELECT
	B.province,
IF
	( B.school_categories = '央属', '央属', '非央属' ) AS categories,
	A.target_code,
	C.target_name,
	A.original_year,
	SUM( A.target_val ) AS target_val 
FROM
	`temporary_rank_tbl_school_target_info` A
	LEFT JOIN rank_tbl_school_info B ON A.school_code = B.school_code
	LEFT JOIN rank_tbl_module_info_no_edition C ON A.target_code = C.target_code 
WHERE
	A.target_code IN ( 'cate080601', 'cate080602', 'cate080205', 'cate080204', 'i88' ) 
GROUP BY
	province,
	categories,
	target_code,
	original_year 
ORDER BY
	province,
	target_code;