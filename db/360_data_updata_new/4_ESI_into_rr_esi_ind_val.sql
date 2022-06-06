# ESI学科排名指标数据更新：

USE ub_details_raw;

SET @Ver_no = 202205; -- 更改需要更新的ESI发布版本
SET @Issue_year = '2022.05' COLLATE utf8mb4_unicode_ci; -- 更改需要更新的ESI发布年月

INSERT INTO univ_ranking_dev.rr_esi_ind_val ( rank_id, ind_id, val )
WITH val AS ( SELECT ( SELECT id
                       FROM univ_ranking_dev.rr_esi_rank C
                       WHERE A.school_code_word = C.univ_code
                         AND A.subj_id = C.subj_id
                         AND C.ver_no = @Ver_no )                         rank_id,
                     ( SELECT id
                       FROM univ_ranking_dev.rr_esi_indicator B
                       WHERE A.ind_code = B.code AND B.ver_no = @Ver_no ) ind_id,
                     val
              FROM ( SELECT ( SELECT id
                              FROM univ_ranking_dev.rr_esi_subject G
                              WHERE F.subject_name_cn = G.name_cn AND G.ver_no = @Ver_no ) subj_id,
                            school_code_word,
                            'web_of_science_documents' AS                                  ind_code,
                            wsd_no                     AS                                  val
                     FROM esi_basics_data F
                     WHERE issue_year = @Issue_year
                       AND parts_cn IN ('中国', '中国香港', '中国澳门', '中国台湾')
                       AND school_code_word IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 )
                     UNION ALL
                     SELECT ( SELECT id
                              FROM univ_ranking_dev.rr_esi_subject G
                              WHERE F.subject_name_cn = G.name_cn AND G.ver_no = @Ver_no ) subj_id,
                            school_code_word,
                            'cites' AS                                                     ind_code,
                            cites   AS                                                     val
                     FROM esi_basics_data F
                     WHERE issue_year = @Issue_year
                       AND parts_cn IN ('中国', '中国香港', '中国澳门', '中国台湾')
                       AND school_code_word IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 )
                     UNION ALL
                     SELECT ( SELECT id
                              FROM univ_ranking_dev.rr_esi_subject G
                              WHERE F.subject_name_cn = G.name_cn AND G.ver_no = @Ver_no ) subj_id,
                            school_code_word,
                            'cites_paper' AS                                               ind_code,
                            cites_ave     AS                                               val
                     FROM esi_basics_data F
                     WHERE issue_year = @Issue_year
                       AND parts_cn IN ('中国', '中国香港', '中国澳门', '中国台湾')
                       AND school_code_word IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 )
                     UNION ALL
                     SELECT ( SELECT id
                              FROM univ_ranking_dev.rr_esi_subject G
                              WHERE F.subject_name_cn = G.name_cn AND G.ver_no = @Ver_no ) subj_id,
                            school_code_word,
                            'highly_cited_papers' AS                                       ind_code,
                            hcp_no                AS                                       val
                     FROM esi_basics_data F
                     WHERE issue_year = @Issue_year
                       AND parts_cn IN ('中国', '中国香港', '中国澳门', '中国台湾')
                       AND school_code_word IN ( SELECT code FROM univ_ranking_dev.univ WHERE outdated = 0 ) ) A )

SELECT rank_id, ind_id, val
FROM val;