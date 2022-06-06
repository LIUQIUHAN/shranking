#

SELECT target_code, target_name, max_zonghe, max_duli, max_minban
FROM `rank_tbl_module_info`
WHERE edition_year = '202204'
  AND target_code IN ( SELECT target_code FROM rank_tbl_module_info_no_edition WHERE is_rank = 1 );