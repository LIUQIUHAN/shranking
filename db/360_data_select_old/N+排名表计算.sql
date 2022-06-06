#

/*DELETE
FROM `temporary_rank_tbl_school_target_info_zero`
WHERE target_code IN ('i33', 'i38', 'i41', 'c57', 'c58', 'i42')
  AND data_year != '2016-2020';


INSERT INTO temporary_rank_tbl_school_target_info_zero ( id,
                                                         target_code,
                                                         data_year,
                                                         target_val,
                                                         target_rank,
                                                         original_year,
                                                         data_source_id,
                                                         data_source_mu,
                                                         data_source_mu_year,
                                                         original_source )
SELECT id,
       target_code,
       data_year,
       0                      AS target_val,
       COUNT(school_code) + 1 AS target_rank,
       data_year              AS original_year,
       data_source_id,
       data_source_mu,
       data_source_mu_year,
       data_source_id         AS original_source
FROM temporary_rank_tbl_school_target_info
WHERE target_val != '0'
  AND target_code IN ('i33', 'i38', 'i41', 'c57', 'c58', 'i42')
  AND data_year != '2016-2020'
GROUP BY target_code, data_year;*/