#

SELECT NULL AS 序号, A.school_name AS 学校, A.subject_name AS 学科, A.ranks AS 排名, A.remark1 AS 百分段位
FROM `rank_tbl_school_subject_rank` A
     LEFT JOIN institution          B ON A.school_code = B.school_code
WHERE A.edition_year = '202104'
  AND A.issue_year = '2020'
  AND B.province = '山东省'
ORDER BY 学校, (排名 + 0);