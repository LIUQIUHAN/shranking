# 老360平台基础数据表入库：rank_tbl_basics_target_data

USE ub_details_raw;
SET @data_year = '2022年5月';
SELECT school_code_ranking AS school_code,
       'c91'               AS target_code,
       @data_year          AS data_year,
       '0'                 AS data_source_id,
       c91                 AS target_val
FROM `esi_count_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND c91 != 0
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data )
UNION ALL
SELECT school_code_ranking AS school_code,
       'c92'               AS target_code,
       @data_year          AS data_year,
       '0'                 AS data_source_id,
       c92                 AS target_val
FROM `esi_count_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND c92 != 0
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data )
UNION ALL
SELECT school_code_ranking AS school_code,
       'c93'               AS target_code,
       @data_year          AS data_year,
       '0'                 AS data_source_id,
       c93                 AS target_val
FROM `esi_count_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND c93 != 0
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data );