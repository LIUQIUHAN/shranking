#

WITH p AS ( SELECT COUNT(*) OVER ( win1 ) AS cnt, ROW_NUMBER() OVER ( win1 ORDER BY id DESC ) AS row_num, d.*
            FROM rank_tbl_basics_target_data d WINDOW win1 AS ( PARTITION BY school_code, target_code, data_year, data_source_id ) )
SELECT *
FROM p
WHERE cnt = 1
  AND row_num = 1;