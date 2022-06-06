#

SELECT A.edition_year,
       A.school_code,
       C.school_name,
       A.target_code,
       B.target_name,
       A.target_val,
       RANK() OVER ( PARTITION BY edition_year, A.target_code ORDER BY (target_val + 0) DESC ) AS `target_rank`,
       A.data_year,
       A.original_year,
       A.data_source_id,
       A.original_source,
       A.data_source_mu,
       A.data_source_mu_year
FROM `rank_tbl_school_target_info_issue`       A
     LEFT JOIN rank_tbl_module_info_no_edition B ON A.target_code = B.target_code
     LEFT JOIN rank_tbl_school_info            C ON A.school_code = C.school_code
WHERE edition_year = '202104'
  AND A.target_code IN ( SELECT target_code FROM rank_tbl_module_info_no_edition )
  AND A.school_code IN
      ( SELECT school_code FROM rank_tbl_school_info WHERE rank_type IS NOT NULL AND rank_type != '艺术类' )
ORDER BY A.school_code, `target_rank`;