# ESI数据更新至明细数据库中：var_detail

USE ub_details_raw;
SET @Edition_year = 202206; -- 明细数据库中最新的版本号

INSERT INTO ub_details_0429.var_detail ( revision,
                                         var_id,
                                         var_code,
                                         source_id,
                                         ver_no,
                                         univ_code,
                                         lev,
                                         val,
                                         detail,
                                         rel_code,
                                         agg_from,
                                         _eversions_,
                                         _r_ver_no,
                                         created_by )
WITH var_detail_esi AS ( SELECT @Edition_year                AS edition_year,
                                REPLACE(issue_year, '.', '') AS issue_year,
                                issue_time,
                                school_code_ranking          AS school_code,
                                institution_cn               AS school_name,
                                subject_name_cn              AS ESI_subject_name,
                                ranking,
                                enter_subject_no,
                                is_one_thounds,
                                is_one_million
                         FROM `esi_basics_data`
                         WHERE school_code_ranking IS NOT NULL
                           AND school_code_ranking != ''
                           AND subject_name_cn != '整体'
                           AND issue_time = ( SELECT MAX(issue_time) FROM esi_count_data ) )

SELECT 0                                                          AS revision,
       227                                                        AS var_id,
       'esisubrank'                                               AS var_code,
       18                                                         AS source_id,
       issue_year                                                 AS ver_no,
       func_school_code_tr_now_code(school_code)         AS univ_code,
       0                                                          AS lev,
       1                                                          AS val,
       JSON_OBJECT('ranking', ranking,
                   'issue_time', issue_time,
                   'issue_year', issue_year,
                   'school_code', func_school_code_tr_now_code(school_code),
                   'school_name', school_name,
                   'is_one_million', is_one_million,
                   'is_one_thounds', is_one_thounds,
                   'ESI_subject_name', ESI_subject_name,
                   'enter_subject_no', enter_subject_no)         AS detail,
       0                                                         AS ASrel_code,
       0                                                         AS ASagg_from,
       edition_year                                              AS _eversions_,
       edition_year                                              AS _r_ver_no,
       -1                                                        AS created_by
FROM var_detail_esi;







