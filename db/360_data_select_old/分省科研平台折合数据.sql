#

SELECT B.province, SUM(A.target_val + 0) target_val, A.data_year
FROM `temporary_rank_tbl_school_target_info` A,
     `rank_tbl_school_info`                  B
WHERE A.school_code = B.school_code
  AND B.rank_type IS NOT NULL
  AND A.target_code = 'cate080204'
  AND A.data_year = '截至2021'
GROUP BY B.province
ORDER BY target_val DESC;