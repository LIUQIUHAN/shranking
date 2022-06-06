SELECT
	B.edition_year 版本,
	'综合类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202104' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2021 B 
WHERE
	B.edition_year = '202104' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '综合类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202104' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'综合类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202202' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2022 B 
WHERE
	B.edition_year = '202202' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '综合类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202202' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'语言类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202104' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2021 B 
WHERE
	B.edition_year = '202104' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '语言类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202104' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'语言类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202202' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2022 B 
WHERE
	B.edition_year = '202202' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '语言类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202202' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'医药类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202104' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2021 B 
WHERE
	B.edition_year = '202104' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '医药类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202104' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'医药类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202202' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2022 B 
WHERE
	B.edition_year = '202202' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '医药类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202202' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'合作办学' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202104' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2021 B 
WHERE
	B.edition_year = '202104' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '合作办学' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202104' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'合作办学' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202202' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2022 B 
WHERE
	B.edition_year = '202202' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '合作办学' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202202' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'财经类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202104' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2021 B 
WHERE
	B.edition_year = '202104' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '财经类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202104' AND is_rank = '1' ) 
GROUP BY
	B.target_code UNION ALL
SELECT
	B.edition_year 版本,
	'财经类' `学校类型`,
	B.target_code 指标代码,
	( SELECT A.target_name FROM rank_tbl_module_info A WHERE A.target_code = B.target_code AND A.edition_year = '202202' ) 指标名称,
	CONCAT( '#', COUNT( school_code ), '+' ) `N+` 
FROM
	rank_tbl_school_target_info_rank_2022 B 
WHERE
	B.edition_year = '202202' 
	AND B.target_val != '0' 
	AND B.target_val IS NOT NULL 
	AND B.target_val != '' 
	AND B.school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '财经类' ) 
	AND B.target_code IN ( SELECT target_code FROM rank_tbl_module_info WHERE edition_year = '202202' AND is_rank = '1' ) 
GROUP BY
	B.target_code;