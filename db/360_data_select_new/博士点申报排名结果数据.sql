USE spm_ranking_dev;

SELECT b.name_cn     AS `学校`,
       a.univ_code   AS `学校code`,
       a.score       AS `总分`,
       a.ranking     AS `排名`,
       c.name        AS `学科`,
       c.`code`      AS `学科code`,
       d.ranking     AS `软科排名2021.10（真实名次）`,
       f.ranking     AS `软科排名2022.07（真实名次）`,
       g.performance AS `第四轮档位`
FROM dpa_ranking_list AS a
         LEFT JOIN univ_ranking_dev.univ_cn AS b ON a.univ_cn_id = b.id
         LEFT JOIN ranking_type AS c ON a.r_leaf_id = c.id
         LEFT JOIN ranking_list AS d
                   ON a.univ_code = d.univ_code AND d.r_leaf_id = c.id AND d.r_ver_no = 202110 AND d.r_root_id = 1
         LEFT JOIN ranking_list AS f
                   ON a.univ_code = f.univ_code AND f.r_leaf_id = c.id AND f.r_ver_no = 202207 AND f.r_root_id = 1
         LEFT JOIN ub_details_raw._rank_tbl_school_four_selection g
                   ON g.school_code = b._code_old AND g.subject_code = c.code AND b.outdated = 0 AND
                      g.edition_year = 202207
ORDER BY 学科code, 排名;








