#

SELECT
	A.school_code,
	B.school_name,
	B.rank_type,
	A.target_val,
	A.target_rank,
	A.type_score_rank 
FROM
	`rank_tbl_school_target_info_rank_2021` A
	LEFT JOIN rank_tbl_school_info B ON A.school_code = B.school_code 
WHERE
	edition_year = '202104' 
	AND target_code = 'i213';