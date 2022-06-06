#

SELECT target_code, MAX(target_val + 0) AS target_val
FROM `rank_tbl_school_target_info_issue`
WHERE edition_year = '202103'
  AND target_code IN ('i51', 'i52')
  AND school_code IN ( SELECT school_code FROM rank_tbl_school_info WHERE school_level = '1' )
GROUP BY target_code;