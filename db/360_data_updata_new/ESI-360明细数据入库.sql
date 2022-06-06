# 老360平台ESI明细数据表入库：rank_tbl_school_esi_info

-- 根据360平台版本修改：edition_year;
USE ub_details_raw;
SELECT '202206'            AS edition_year,
       issue_year,
       issue_time,
       school_code_ranking AS school_code,
       institution_cn      AS school_name,
       subject_name_cn     AS ESI_subject_name,
       ranking,
       enter_subject_no,
       is_one_thounds,
       is_one_million
FROM `esi_basics_data`
WHERE school_code_ranking IS NOT NULL
  AND school_code_ranking != ''
  AND subject_name_cn != '整体'
  AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data );