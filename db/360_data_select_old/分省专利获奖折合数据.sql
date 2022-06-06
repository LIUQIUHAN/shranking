#

SELECT B.province, SUM(A.target_val + 0) target_val, A.data_year
FROM `temporary_rank_tbl_school_target_info` A,
     `rank_tbl_school_info`                  B
WHERE A.school_code = B.school_code
  AND B.rank_type IS NOT NULL
  AND A.target_code = 'patent11'
  AND data_year IN ('2016', '2017', '2018', '2019', '2020')
GROUP BY B.province, A.data_year
ORDER BY data_year, target_val DESC;