# 人才培养大类指标得分
WITH R1 AS (
    SELECT ri.ind_id, i.name_cn, ri.score, ri.univ_code
    FROM rugc_indicator i
             LEFT JOIN rugc_ind_rank ri ON i.yr = ri.yr AND i.id = ri.ind_id
    WHERE i.yr = 2019
),
     R2 AS (
         SELECT univ_code,
                max(CASE WHEN ind_id = 177 THEN score END) AS 'IND_177',
                max(CASE WHEN ind_id = 178 THEN score END) AS 'IND_178',
                max(CASE WHEN ind_id = 179 THEN score END) AS 'IND_179',
                max(CASE WHEN ind_id = 180 THEN score END) AS 'IND_180',
                max(CASE WHEN ind_id = 181 THEN score END) AS 'IND_181',
                max(CASE WHEN ind_id = 182 THEN score END) AS 'IND_182',
                max(CASE WHEN ind_id = 183 THEN score END) AS 'IND_183'
         FROM R1
         GROUP BY univ_code
     ),
     R3 AS (
         SELECT r.ranking,
                u.name_cn                                                                 univ_name_cn,
                (SELECT uc.up FROM univ_cn uc WHERE uc.code = u.code AND NOT uc.outdated) univ_up,
                r.region,
                r.score,
                r2.IND_177,
                r2.IND_178,
                r2.IND_179,
                r2.IND_180,
                r2.IND_181,
                r2.IND_182,
                r2.IND_183
         FROM rugc_rank r
                  JOIN univ u ON r.univ_code = u.code AND NOT u.outdated
                  JOIN R2 ON r.univ_code = R2.univ_code
         WHERE r.yr = 2019
         ORDER BY r.ranking, CONVERT(univ_name_cn USING gbk)
     )
SELECT univ_name_cn as '*** Test Cases ***',
        ranking as '${RANKING}',
        univ_name_cn as '${UNIV_NAME}',
        region as '${REGION}',
       score as '${SCORE}',
       ind_177 as '${IND_177}',
       ind_178 as '${IND_178}',
       ind_179 as '${IND_179}',
       ind_180 as '${IND_180}',
       ind_181 as '${IND_181}',
       ind_182 as '${IND_182}',
       ind_183 as '${IND_183}'
FROM R3;