USE ub_ranking_0520;

SET @rLeafId_0 = 101; -- 学科水平排名
SET @rLeafId_1 = 102; -- 师资人才排名
SET @rLeafId_2 = 103; -- 世界一流指标排名
SET @rLeafId_3 = 104; -- 服务社会能力排名
SET @rLeafId_4 = 1; -- 质量监测排名
SET @rVerNo = 202203; -- 产品业鹏告知使用360202203版本的数据
SET @rYear = '2022年03月';
SET @rowNum = 0;

SET FOREIGN_KEY_CHECKS = 0;

# 插入指标得分与排名-专项监测
TRUNCATE TABLE derived_ind_score_2022;
INSERT INTO derived_ind_score_2022( r_ver_no,
                                    r_leaf_id,
                                    ind_id,
                                    ind_code,
                                    univ_code,
                                    is_same_type,
                                    score,
                                    score_rank_typ,
                                    score_rank_all,
                                    val,
                                    val_rank_typ,
                                    val_rank_all,
                                    var_details,
                                    effect_ver,
                                    pre_score,
                                    alt_val,
                                    eff_src_ids
    -- created_at,
    -- updated_at
)
SELECT r_ver_no,
       (CASE WHEN ind_code IN ( SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_0 ) THEN @rLeafId_0
             WHEN ind_code IN ( SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_1 ) THEN @rLeafId_1
             WHEN ind_code IN ( SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_2 ) THEN @rLeafId_2
             WHEN ind_code IN ( SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_3 )
                 THEN @rLeafId_3 END)                                                                     r_leaf_id,
       ( SELECT id
         FROM derived_indicator B
         WHERE B.code = A.ind_code
           AND B.level != 4
           AND B.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3) )                          ind_id,
       ind_code,
       univ_code,
       0                                                                                                  is_same_type,   -- 该字段在数据中未体现，用一个默认值替代（正超）
       (IFNULL(pre_score, 0) * ( SELECT B.score ->> '$.defaultWeight'
                                 FROM derived_indicator B
                                 WHERE B.code = A.ind_code
                                   AND B.level != 4
                                   AND B.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3) )) score,          -- 非初始得分： 指标比例得分*指标权重 = 指标最终得分
       0                                                                                                  score_rank_typ, -- 该字段在数据中未体现，用一个默认值替代（正超）
       0                                                                                                  score_rank_all, -- 指标最终得分排名：后面计算更新
       val,
       0,                                                                                                                 -- 该字段在数据中未体现，用一个默认值替代（正超）
       val_rank_all,                                                                                                      -- 指标数据值排名（需重新计算排名，因为排名对象发生了变化）
       var_details,
       effect_ver,
       pre_score,
       alt_val,
       eff_src_ids
FROM ind_value_2022 A
WHERE r_ver_no = @rVerNo
  AND ind_code IN
      ( SELECT code FROM derived_indicator WHERE r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3) );


# 插入指标得分与排名-质量监测

INSERT INTO derived_ind_score_2022( r_ver_no,
                                    r_leaf_id,
                                    ind_id,
                                    ind_code,
                                    univ_code,
                                    is_same_type,
                                    score,
                                    score_rank_typ,
                                    score_rank_all,
                                    val,
                                    val_rank_typ,
                                    val_rank_all,
                                    var_details,
                                    effect_ver,
                                    pre_score,
                                    alt_val,
                                    eff_src_ids
    -- created_at,
    -- updated_at
)
SELECT r_ver_no,
       @rLeafId_4 AS                                                               r_leaf_id,
       ( SELECT id
         FROM derived_indicator B
         WHERE B.code = A.ind_code AND B.level != 4 AND B.r_leaf_id = @rLeafId_4 ) ind_id,
       ind_code,
       univ_code,
       0                                                                           is_same_type,   -- 该字段在数据中未体现，用一个默认值替代（正超）
       (IFNULL(pre_score, 0) * ( SELECT B.score ->> '$.defaultWeight'
                                 FROM derived_indicator B
                                 WHERE B.code = A.ind_code
                                   AND B.level != 4
                                   AND B.r_leaf_id = @rLeafId_4 ))                 score,          -- 非初始得分： 指标比例得分*指标权重 = 指标最终得分
       0                                                                           score_rank_typ, -- 该字段在数据中未体现，用一个默认值替代（正超）
       0                                                                           score_rank_all, -- 指标最终得分排名：后面计算更新
       val,
       0,                                                                                          -- 该字段在数据中未体现，用一个默认值替代（正超）
       val_rank_all,                                                                               -- 指标数据值排名（需重新计算排名，因为排名对象发生了变化）
       var_details,
       effect_ver,
       pre_score,
       alt_val,
       eff_src_ids
FROM ind_value_2022 A
WHERE r_ver_no = @rVerNo
  AND ind_code IN ( SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_4 );


# 计算指标得分排名、指标数据值排名
WITH ranks AS ( SELECT r_leaf_id,
                       univ_code,
                       ind_code,
                       RANK() OVER ( PARTITION BY r_leaf_id,ind_code ORDER BY score DESC ) score_rank_all,
                       RANK() OVER ( PARTITION BY r_leaf_id,ind_code ORDER BY val DESC )   val_rank_all
                FROM derived_ind_score_2022
                WHERE r_ver_no = @rVerNo )
UPDATE derived_ind_score_2022 A JOIN ranks ON A.univ_code = ranks.univ_code AND A.ind_code = ranks.ind_code AND
                                              A.r_leaf_id = ranks.r_leaf_id
SET A.score_rank_all = ranks.score_rank_all,
    A.val_rank_all   = ranks.val_rank_all
WHERE r_ver_no = @rVerNo;

# 计算维度得分&排名
INSERT INTO derived_ind_score_2022 (-- id,
    r_ver_no,
    r_leaf_id,
    ind_id,
    ind_code,
    univ_code,
    is_same_type,
    score,
    score_rank_typ,
    score_rank_all,
    val,
    val_rank_typ,
    val_rank_all,
    var_details,
    effect_ver,
    pre_score,
    alt_val
    -- created_at,
    -- updated_at
)
WITH dimension_score AS ( SELECT D.dim_code, A.*
                          FROM derived_ind_score_2022      A
                               JOIN ( SELECT B.r_leaf_id, B.code dim_code, C.code indicator_code
                                      FROM derived_indicator      B
                                           JOIN derived_indicator C
                                      WHERE B.id = C.pid
                                        AND C.level != 4
                                        AND B.code != '' ) D
                                    ON A.ind_code = D.indicator_code AND A.r_ver_no = @rVerNo AND
                                       A.r_leaf_id = D.r_leaf_id )
SELECT r_ver_no,
       r_leaf_id,
       ( SELECT id FROM derived_indicator x WHERE x.code = z.dim_code AND X.level != 4 ) ind_id,
       z.dim_code,
       univ_code,
       0                                                                                 is_same_type,
       SUM(score)                                                                        score,
       0                                                                                 score_rank_typ,
       RANK() OVER ( PARTITION BY z.dim_code ORDER BY SUM(score) DESC )                  score_rank_all,
       0                                                                                 val,
       0                                                                                 val_rank_typ,
       -1                                                                                val_rank_all,
       NULL                                                                              var_details,
       ''                                                                                effect_ver,
       0                                                                                 pre_score,
       NULL                                                                              alt_val
FROM dimension_score z
GROUP BY z.univ_code, z.dim_code;

# 学校总得分&排名
TRUNCATE TABLE derived_ranking_list;
INSERT INTO derived_ranking_list (-- id,
    r_ver_no,
    r_leaf_id,
    univ_cn_id,
    univ_code,
    is_same_type,
    score,
    rank_typ,
    rank_all,
    ord_no
-- created_at,
-- updated_at
)
SELECT r_ver_no,
       r_leaf_id,
       COALESCE(( SELECT uc.id
                  FROM univ_ranking_dev.univ_cn uc
                  WHERE uc.code = univ_code
                    AND uc.outdated NOT BETWEEN -9999 AND -1
                  ORDER BY uc.outdated > 0, ABS(uc.outdated) DESC
                  LIMIT 1 ), -1)                                                    univ_cn_id,
       univ_code,
       0                                                                            is_same_type,
       ROUND(SUM(score), 1)                                                         score,
       0                                                                            rank_typ,
       RANK() OVER ( PARTITION BY r_leaf_id ORDER BY ROUND(SUM(score), 1) DESC ) AS rank_all,
       RANK() OVER ( PARTITION BY r_leaf_id ORDER BY SUM(score) DESC )           AS ord_no
FROM derived_ind_score_2022 A
WHERE A.val_rank_all = -1
  AND A.score != 0
GROUP BY A.r_leaf_id, A.univ_code
HAVING ROUND(SUM(score), 1) != 0;

# 收尾工作
WITH num AS ( SELECT r_leaf_id, COUNT(*) num_listed FROM derived_ranking_list WHERE score != 0 GROUP BY r_leaf_id )
UPDATE derived_ranking_instance A,num
SET A.num_listed = num.num_listed
WHERE A.type_id = num.r_leaf_id;

SET FOREIGN_KEY_CHECKS = 1;






