SELECT
	(
	CASE
			
			WHEN B.rank_type = '财经类' THEN
			A.remark3 
			WHEN B.rank_type = '医药类' THEN
			A.remark6 
			WHEN B.rank_type = '体育类' THEN
			A.remark8 
			WHEN B.rank_type = '语言类' THEN
			A.remark9 
			WHEN B.rank_type = '政法类' THEN
			A.remark10 
			WHEN B.rank_type = '民族类' THEN
			A.remark12 
			WHEN B.rank_type = '合作办学' THEN
			A.remark16
			WHEN B.rank_type = '综合类' THEN
			A.ranking_val
		END 
		) AS `2022排名`,
		A.school_code AS `学校代码`,
		B.unified_code AS `统一编码`,
		B.school_name AS `学校名称`,
		B.province AS 省市,
		B.school_type AS 学校类型,
	IF
		( B.rank_type IN ( '财经类', '医药类', '体育类', '语言类', '政法类', '民族类', '合作办学' ), NULL, A.ranking_score ) AS 总得分 
	FROM
		`rank_tbl_school_ranking` A,
		rank_tbl_school_info B 
	WHERE
		A.school_code = B.school_code 
		AND A.ranking_year = '202204' 
		AND B.rank_type IS NOT NULL 
		AND B.rank_type != '艺术类' 
		AND A.remark1 IS NOT NULL 
ORDER BY
	( `2022排名` + 0 );