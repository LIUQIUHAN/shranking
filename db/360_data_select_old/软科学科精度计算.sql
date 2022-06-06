SELECT
	A.school_code,
	'b35' AS target_code,
	( A.target_val / B.target_val ) AS target_val,
	NULL AS target_rank,
	A.target_rank_range,
	NULL AS target_score,
	A.rank_expresion,
	A.province_expresion,
	A.same_type_expresion,
	A.data_year,
	A.data_source_id,
	A.original_year,
	A.original_source,
	A.data_source_mu,
	A.data_source_mu_year 
FROM
	( SELECT * FROM `temporary_rank_tbl_school_target_info` WHERE target_code = 'b23' AND data_year = '2017' ) AS A,
	( SELECT * FROM `temporary_rank_tbl_school_target_info` WHERE target_code = 'i214' AND data_year = '2017' ) AS B 
WHERE
	A.school_code = B.school_code 
GROUP BY
	A.school_code;