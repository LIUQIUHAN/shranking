# ESI学科排名明细数据更新：

USE ub_details_raw;

SET @Ver_no = 202205; -- 更改需要更新的ESI发布版本
SET @Issue_year = '2022.05' COLLATE utf8mb4_unicode_ci; -- 更改需要更新的ESI发布年月

INSERT INTO univ_ranking_dev.rr_esi_rank ( ver_no, subj_id, univ_id, univ_code, univ_name_en, ranking, rank_country,
                                           rank_top_pct, is_copy )
SELECT @Ver_no                                                                                                 AS ver_no,
       ( SELECT id
         FROM univ_ranking_dev.rr_esi_subject B
         WHERE A.subject_name_cn = B.name_cn
           AND B.ver_no = @Ver_no )                                                                            AS subj_id,
       ( SELECT id
         FROM univ_ranking_dev.univ B
         WHERE A.school_code_word = B.code
           AND B.outdated = 0 )                                                                                AS univ_id,
       school_code_word                                                                                        AS univ_code,
       institution_en                                                                                          AS univ_name_en,
       ranking,
       rank_p                                                                                                  AS rank_country,
       (CASE WHEN level = '百分之一' THEN 0.01
             WHEN level = '千分之一' THEN 0.001
             WHEN level = '万分之一'
                 THEN 0.0001 END)                                                                              AS rank_top_pct,
       0                                                                                                          is_copy
FROM esi_basics_data A
WHERE issue_year = @Issue_year
  AND parts_cn IN ('中国', '中国香港', '中国澳门', '中国台湾')
  AND school_code_word IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 )
;

