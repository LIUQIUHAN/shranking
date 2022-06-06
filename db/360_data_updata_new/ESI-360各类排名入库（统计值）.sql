# 老360平台各类排名数据表入库：rank_tbl_other_org_ranking

USE ub_details_raw;
SELECT issue_year          AS rank_year,
       issue_time,
       '上榜学科'              AS rank_type,
       'F008'              AS rank_id,
       school_code_word    AS rank_school_code,
       school_code_ranking AS school_code,
       c91                 AS subject_num
FROM `esi_count_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND c91 != 0
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data )
UNION ALL
SELECT issue_year          AS rank_yeat,
       issue_time,
       '一流学科'              AS rank_type,
       'F008'              AS rank_id,
       school_code_word    AS rank_school_code,
       school_code_ranking AS school_code,
       c92                 AS subject_num
FROM `esi_count_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND c92 != 0
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data );