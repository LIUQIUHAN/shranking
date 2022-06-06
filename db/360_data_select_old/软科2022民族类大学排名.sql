SELECT
	* 
FROM
	(
	SELECT
		RANK ( ) OVER ( PARTITION BY A.type_code ORDER BY ( ROUND( SUM( score ) + 0, 1 ) ) DESC ) AS `2022排名计算`,
		M.remark12 AS 全国参考排名,
		A.school_code AS 学校代码,
		B.unified_code AS 统一编码,
		B.school_name AS 学校名称,
		B.province AS 省市,
		B.school_type AS 学校类型,
		ROUND( SUM( A.score ), 1 ) AS 总得分,
		RANK ( ) OVER ( PARTITION BY B.province ORDER BY ( ROUND( SUM( score ) + 0, 1 ) ) DESC ) AS 分省排名,
		C.`办学层次得分`,
		D.`学科水平得分`,
		E.`办学资源得分`,
		F.`师资规模与结构得分`,
		G.`人才培养得分`,
		H.`科学研究得分`,
		I.`服务社会得分`,
		J.`高端人才得分`,
		K.`重大项目与成果得分`,
		L.`国际竞争力得分`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( C.`办学层次得分` ) DESC ) AS `办学层次排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( D.`学科水平得分` ) DESC ) AS `学科水平排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( E.`办学资源得分` ) DESC ) AS `办学资源排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( F.`师资规模与结构得分` ) DESC ) AS `师资规模与结构排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( G.`人才培养得分` ) DESC ) AS `人才培养排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( H.`科学研究得分` ) DESC ) AS `科学研究排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( I.`服务社会得分` ) DESC ) AS `服务社会排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( J.`高端人才得分` ) DESC ) AS `高端人才排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( K.`重大项目与成果得分` ) DESC ) AS `重大项目与成果排名`,
		RANK ( ) OVER ( PARTITION BY '' ORDER BY ( L.`国际竞争力得分` ) DESC ) AS `国际竞争力排名` 
	FROM
		`rank_tbl_module_score_info` A
		LEFT JOIN rank_tbl_school_info B ON A.school_code = B.school_code
		LEFT JOIN rank_tbl_school_ranking M ON A.school_code = M.school_code AND M.ranking_year = '202204'
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `办学层次得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '1' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) C ON A.school_code = C.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `学科水平得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '2' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) D ON A.school_code = D.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `办学资源得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '3' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) E ON A.school_code = E.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `师资规模与结构得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '4' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) F ON A.school_code = F.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `人才培养得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '5' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) G ON A.school_code = G.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `科学研究得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '6' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) H ON A.school_code = H.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `服务社会得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '7' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) I ON A.school_code = I.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `高端人才得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '8' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) J ON A.school_code = J.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `重大项目与成果得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '9' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) K ON A.school_code = K.school_code
		LEFT JOIN (
		SELECT
			school_code,
			ROUND( score, 1 ) AS `国际竞争力得分` 
		FROM
			rank_tbl_module_score_info 
		WHERE
			module_id = '10' 
			AND edition_year = '202204' 
			AND type_code = '0012' 
			AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type = '民族类' ) 
		GROUP BY
			school_code 
		) L ON A.school_code = L.school_code 
	WHERE
		A.edition_year = '202204' 
		AND A.type_code = '0012' 
		AND B.rank_type = '民族类' 
	GROUP BY
		A.school_code 
	) Z 
ORDER BY
	`2022排名计算`;