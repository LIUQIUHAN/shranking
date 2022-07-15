# ESI学科统计值更新：

USE ub_details_raw;

SET @Ver_no = 202207; -- 更改需要更新的ESI发布版本
SET @Issue_year = '2022.07' COLLATE utf8mb4_unicode_ci; -- 更改需要更新的ESI发布年月

INSERT INTO univ_ranking_dev.rr_esi_stats ( ver_no, univ_id, univ_code, univ_name_en, ranking, rank_country,
                                            num_on_list, num_top_1_in_10000, num_top_1_in_1000, num_top_1_in_100,
                                            is_mc_univ, is_copy )
SELECT @Ver_no                                                                                         AS ver_no,
       ( SELECT id FROM univ_ranking_dev.univ B WHERE A.school_code_world = B.code AND B.outdated = 0 ) AS univ_id,
       school_code_world                                                                                AS univ_code,
       institution_en                                                                                  AS univ_name_en,
       ranking,
       rank_p                                                                                          AS rank_country,
       subject_num                                                                                     AS num_on_list,
       c93                                                                                             AS num_top_1_in_10000,
       c92                                                                                             AS num_top_1_in_1000,
       c91                                                                                             AS num_top_1_in_100,
       IF(school_code_world IN ( SELECT code FROM univ_ranking_dev.univ_cn ), 1, 0)                     AS is_mc_univ,
       0                                                                                               AS is_copy
FROM esi_count_data A
WHERE issue_year = @Issue_year
  AND parts_cn IN ('中国','中国香港','中国澳门','中国台湾')
  AND school_code_world IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 );