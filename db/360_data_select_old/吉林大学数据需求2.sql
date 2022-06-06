#

SELECT school_code, target_code, target_val, target_rank, target_rank_range, original_year, data_year
FROM `temporary_rank_tbl_school_target_info`
WHERE target_code = 'i82'
  AND target_val != ''
  AND data_year IN ('2014-2018', '2015-2019')
UNION ALL
SELECT school_code, target_code, target_val, target_rank, target_rank_range, original_year, data_year
FROM `temporary_rank_tbl_school_target_info`
WHERE target_code = 'i14'
  AND target_val != ''
  AND data_year BETWEEN 2015 AND 2019
UNION ALL
SELECT school_code, target_code, target_val, target_rank, target_rank_range, original_year, data_year
FROM `temporary_rank_tbl_school_target_info`
WHERE target_code = 'i215'
  AND target_val != ''
  AND data_year BETWEEN 2015 AND 2019
UNION ALL
SELECT school_code, target_code, target_val, target_rank, target_rank_range, original_year, data_year
FROM `temporary_rank_tbl_school_target_info`
WHERE target_code = 'i103'
  AND target_val != ''
  AND data_year IN ('2014-2018', '2015-2019');