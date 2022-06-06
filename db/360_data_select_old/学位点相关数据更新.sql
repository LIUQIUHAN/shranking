#

SELECT * FROM `rank_tbl_school_bulid_subject` WHERE edition_year = '202202' AND data_year = '2020'; -- 已入库（在建学位点明细）
SELECT * FROM `rank_tbl_school_subject_layout` WHERE edition_year = '202202' AND data_year = '2020' AND degree_level IN ('硕士','博士'); -- 已入库（硕士博士点门类分布明细）
SELECT * FROM `rank_tbl_school_four_selection` WHERE edition_year = '202202';
SELECT * FROM `rank_tbl_school_subject_rank` WHERE edition_year = '202202';

-- 第四轮学科评估结果仍在建数量统计：

WITH C AS ( SELECT A.*
            FROM `rank_tbl_school_four_selection`   A
                 JOIN rank_tbl_school_bulid_subject B
                      ON A.school_code = B.school_code AND A.subject_code = B.subject_code
            WHERE A.edition_year = '202202'
              AND B.edition_year = '202202'
              AND B.data_year = '2020' )
SELECT issue_year,school_code,'i1108'  AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE performance IN ('A+','A','A-') GROUP BY school_code UNION ALL
SELECT issue_year,school_code,'i1208'  AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE performance IN ('A+','A','A-','B+','B','B-') GROUP BY school_code UNION ALL
SELECT issue_year,school_code,'i1008'  AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE performance = 'A+' GROUP BY school_code UNION ALL
SELECT issue_year,school_code,'i21208' AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C GROUP BY school_code;

-- 软科学科历史排名结果仍在建数量统计：
WITH C AS ( SELECT A.*
            FROM `rank_tbl_school_subject_rank`     A
                 JOIN rank_tbl_school_bulid_subject B
                      ON A.school_code = B.school_code AND A.subject_code = B.subject_code
            WHERE A.edition_year = '202202'
              AND B.edition_year = '202202'
              AND B.data_year = '2020' )
SELECT issue_year,school_code,'b2308'  AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.02) GROUP BY issue_year,school_code UNION ALL	 
SELECT issue_year,school_code,'i20508' AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.05) GROUP BY issue_year,school_code UNION ALL
SELECT issue_year,school_code,'i20608' AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.1) GROUP BY issue_year,school_code UNION ALL
SELECT issue_year,school_code,'c308'   AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.2) GROUP BY issue_year,school_code UNION ALL
SELECT issue_year,school_code,'c208'   AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.3) GROUP BY issue_year,school_code UNION ALL
SELECT issue_year,school_code,'c108'   AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.4) GROUP BY issue_year,school_code UNION ALL
SELECT issue_year,school_code,'i20308' AS target_code,COUNT(*) AS target_val,0 AS data_source_id FROM C WHERE (ranks<=2 OR (ranks/rank_number)<=0.5) GROUP BY issue_year,school_code;









	

	
	
	