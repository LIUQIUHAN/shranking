# 更新版本号：@Edition_year

SET @Edition_year = '202206';

INSERT INTO rank_tbl_ranking_fixed_val_issue ( edition_year, school_code, target_code, fixed_value, target_year,
                                               fixed_value_ave, is_sure )
WITH c AS ( SELECT a.school_code, b.target_code, b.target_val, b.data_year, b.data_source_id
            FROM rank_tbl_school_info                  a
                 LEFT JOIN rank_tbl_basics_target_data b
                           ON a.school_code = b.school_code AND b.target_code = 'i49b' AND b.data_year = '2019' )
SELECT @Edition_year                                     edition_year,
       school_code,
       'i49b'                                       target_code,
       IF(target_val IS NULL, '0.0011', target_val) fixed_value,
       '2019'                                       target_year,
       NULL                                         fixed_value_ave,
       '1'                                          is_sure
FROM c
WHERE school_code NOT IN ( SELECT DISTINCT school_code
                           FROM rank_tbl_basics_target_data
                           WHERE target_code = 'i49b'
                             AND data_year IN ('2017', '2018', '2019', '2020') );


INSERT INTO rank_tbl_ranking_fixed_val_issue ( edition_year, school_code, target_code, fixed_value, target_year,
                                               fixed_value_ave, is_sure )
WITH c AS ( SELECT a.school_code, b.target_code, b.target_val, b.data_year, b.data_source_id
            FROM rank_tbl_school_info                  a
                 LEFT JOIN rank_tbl_basics_target_data b
                           ON a.school_code = b.school_code AND b.target_code = 'i51b' AND b.data_year = '2019' )
SELECT @Edition_year                                edition_year,
       school_code,
       'i51b'                                  target_code,
       IF(target_val IS NULL, '3', target_val) fixed_value,
       '2019'                                  target_year,
       NULL                                    fixed_value_ave,
       '1'                                     is_sure
FROM c
WHERE school_code NOT IN ( SELECT DISTINCT school_code
                           FROM rank_tbl_basics_target_data
                           WHERE target_code = 'i51b'
                             AND data_year IN ('2017', '2018', '2019', '2020') );
 
