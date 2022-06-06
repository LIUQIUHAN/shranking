#

SELECT *
FROM ( SELECT '2021_41-45' id, A.school_code, A.target_code, B.target_name, A.data_year, A.target_val
       FROM `temporary_rank_tbl_school_target_info`   A
            LEFT JOIN rank_tbl_module_info_no_edition B USING (target_code)
       WHERE B.is_kernel = '1'
         AND A.school_code IN ('A0593', 'A0501', 'A0257', 'A0267', 'A0239')
       UNION ALL
       SELECT '2021_46-50' id, A.school_code, A.target_code, B.target_name, A.data_year, A.target_val
       FROM `temporary_rank_tbl_school_target_info`   A
            LEFT JOIN rank_tbl_module_info_no_edition B USING (target_code)
       WHERE B.is_kernel = '1'
         AND A.school_code IN ('A0503', 'A0288', 'A0496', 'A0194', 'A0213') ) D
ORDER BY id, school_code, target_code, data_year, target_val;