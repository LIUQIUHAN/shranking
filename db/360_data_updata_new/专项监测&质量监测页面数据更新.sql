USE ub_ranking_dev;

SET @rLeafId_0 = 101; -- 学科水平排名
SET @rLeafId_1 = 102; -- 师资人才排名
SET @rLeafId_2 = 103; -- 世界一流指标排名
SET @rLeafId_3 = 104; -- 服务社会能力排名
SET @rLeafId_4 = 1; -- 质量监测排名
SET @rVerNo = 202206; -- 产品业鹏告知使用360202203版本的数据
SET @rYear = '2022年06月';
SET @rowNum = 0;

# 指标信息更新 derived_ranking_instance   &   derived_indicator
# derived_ranking_instance
/*
INSERT INTO derived_ranking_instance (id, ver_no, version, type_id, scheme_type_id, name, code, weight_scheme_id,
                                      num_listed, num_published, issue_status, issued_at, issue_date, reviewed_by,
                                      method_file, remark, created_at, created_by, updated_at, updated_by, deleted_at,
                                      deleted_by)
SELECT NULL    AS id,
       @rVerNo AS ver_no,
       @rYear  AS version,
       type_id,
       0       AS scheme_type_id,
       name,
       code,
       -1      AS weight_scheme_id,
       0       AS num_listed,
       0       AS num_published,
       9       AS issue_status,
       NOW()   AS issued_at,
       NOW()   AS issue_date,
       reviewed_by,
       method_file,
       ''      AS remark,
       NOW()   AS created_at,
       -2      AS created_by,
       NOW()   AS updated_at,
       NULL    AS updated_by,
       NULL    AS deleted_at,
       NULL    AS deleted_by
FROM derived_ranking_instance
WHERE type_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
  AND ver_no = @rVerNo - 1;

# derived_indicator
INSERT INTO derived_indicator (id, pid, r_leaf_id, r_ver_no, code, name, abbr, path, level, is_category, var_id,
                               ind_lev, is_full_sample, detail_def_id, change_type, definition, editable, shows, tags,
                               ui, detail, val, score, ord_no, remark, created_at, created_by, updated_at, updated_by,
                               deleted_at, deleted_by)
WITH M AS (SELECT MAX(id) mid FROM derived_indicator)
SELECT (M.mid + DI.id)                   AS id,
       IF(DI.pid = 0, 0, M.mid + DI.pid) AS pid,
       r_leaf_id,
       @rVerNo                           AS r_ver_no,
       CASE
           WHEN code = CONCAT('subject_rank-', @rVerNo - 1) THEN CONCAT('subject_rank-', @rVerNo)
           WHEN code = CONCAT('personnel_rank-', @rVerNo - 1) THEN CONCAT('personnel_rank-', @rVerNo)
           WHEN code = CONCAT('world_rank-', @rVerNo - 1) THEN CONCAT('world_rank-', @rVerNo)
           WHEN code = CONCAT('service_rank-', @rVerNo - 1) THEN CONCAT('service_rank-', @rVerNo)
           WHEN code = CONCAT('S_AVG-', @rVerNo - 1) THEN CONCAT('S_AVG-', @rVerNo)
           WHEN code = CONCAT('T_AVG-', @rVerNo - 1) THEN CONCAT('T_AVG-', @rVerNo)
           WHEN code = CONCAT('RATIO-', @rVerNo - 1) THEN CONCAT('RATIO-', @rVerNo)
           ELSE code
           END
                                         AS code,
       CASE
           WHEN name = CONCAT('学科水平排名-', @rVerNo - 1) THEN CONCAT('学科水平排名-', @rVerNo)
           WHEN name = CONCAT('师资人才排名-', @rVerNo - 1) THEN CONCAT('师资人才-', @rVerNo)
           WHEN name = CONCAT('世界一流指标排名-', @rVerNo - 1) THEN CONCAT('世界一流指标-', @rVerNo)
           WHEN name = CONCAT('服务社会能力排名-', @rVerNo - 1) THEN CONCAT('服务社会能力-', @rVerNo)
           WHEN name = CONCAT('生均指标-', @rVerNo - 1) THEN CONCAT('生均指标-', @rVerNo)
           WHEN name = CONCAT('师均指标-', @rVerNo - 1) THEN CONCAT('师均指标-', @rVerNo)
           WHEN name = CONCAT('比值指标-', @rVerNo - 1) THEN CONCAT('比值指标-', @rVerNo)
           ELSE name
           END
                                         AS name,
       abbr,
       ''                                AS path,
       level,
       is_category,
       var_id,
       ind_lev,
       is_full_sample,
       detail_def_id,
       change_type,
       definition,
       editable,
       shows,
       tags,
       ui,
       detail,
       val,
       score,
       ord_no,
       ''                                AS remark,
       NOW()                             AS created_at,
       -2                                AS created_by,
       NOW()                             AS updated_at,
       NULL                              AS updated_by,
       NULL                              AS deleted_at,
       NULL                              AS deleted_by
FROM derived_indicator DI
         JOIN M
WHERE r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
  AND r_ver_no = (@rVerNo - 1)
ORDER BY id;

# 补充质量监测在新版本上新增的均值比例值指标
INSERT INTO derived_indicator (id, pid, r_leaf_id, r_ver_no, code, name, abbr, path, level, is_category, var_id,
                               ind_lev, is_full_sample, detail_def_id, change_type, definition, editable, shows, tags,
                               ui, detail, val, score, ord_no, remark, created_at, created_by, updated_at, updated_by,
                               deleted_at, deleted_by)
SELECT NULL                   AS id,
       CASE
           WHEN I.name RLIKE '生均' THEN
               (SELECT MAX(id)
                FROM derived_indicator
                WHERE r_ver_no = @rVerNo
                  AND code COLLATE utf8mb4_unicode_ci = CONCAT('S_AVG-', @rVerNo) COLLATE utf8mb4_unicode_ci)
           WHEN I.name RLIKE '师均' THEN
               (SELECT MAX(id)
                FROM derived_indicator
                WHERE r_ver_no = @rVerNo
                  AND code COLLATE utf8mb4_unicode_ci = CONCAT('T_AVG-', @rVerNo) COLLATE utf8mb4_unicode_ci)
           END
                              AS pid,
       @rLeafId_4             AS r_leaf_id,
       r_ver_no,
       code,
       name,
       abbr,
       ''                     AS path,
       2                      AS level,
       0                         is_category,
       var_id,
       ind_lev,
       is_full_sample,
       detail_def_id,
       change_type,
       definition,
       editable,
       shows,
       tags,
       ui,
       detail,
       val,
       '{"defaultWeight": 0}' AS score,
       ord_no,
       ''                     AS remark,
       NOW()                  AS created_at,
       -2                     AS created_by,
       NOW()                  AS updated_at,
       NULL                   AS updated_by,
       NULL                   AS deleted_at,
       NULL                   AS deleted_by
FROM indicator I
WHERE I.r_ver_no = @rVerNo
  AND I.level = 3
  AND I.name RLIKE '均'
  AND I.shows = ''
  AND NOT EXISTS(SELECT * FROM derived_indicator DI WHERE DI.r_ver_no = @rVerNo AND I.code = DI.code AND r_leaf_id = 1);
*/


# 数据更新
SET FOREIGN_KEY_CHECKS = 0;
DELETE
FROM derived_ind_score_2022
WHERE r_ver_no = @rVerNo
  AND r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4);
DELETE
FROM derived_ranking_list
WHERE r_ver_no = @rVerNo
  AND r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4);
# 插入指标得分与排名-专项监测
# TRUNCATE TABLE derived_ind_score_2022;
INSERT INTO derived_ind_score_2022(r_ver_no,
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
       (CASE
            WHEN ind_code IN (SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_0) THEN @rLeafId_0
            WHEN ind_code IN (SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_1) THEN @rLeafId_1
            WHEN ind_code IN (SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_2) THEN @rLeafId_2
            WHEN ind_code IN (SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_3)
                THEN @rLeafId_3 END)                                           AS r_leaf_id,
       (SELECT id
        FROM derived_indicator B
        WHERE B.code = A.ind_code
          AND B.level != 4
          AND B.r_ver_no = @rVerNo
          AND B.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3)) AS ind_id,
       ind_code,
       univ_code,
       0                                                                       AS is_same_type,                  -- 该字段在数据中未体现，用一个默认值替代（正超）
/*       (IFNULL(pre_score, 0) * (SELECT B.score ->> '$.defaultWeight'
                                FROM derived_indicator B
                                WHERE B.code = A.ind_code
                                  AND B.level != 4
                                  AND B.r_ver_no = @rVerNo
                                  AND B.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3))) score,*/ -- 非初始得分： 指标比例得分*指标权重 = 指标最终得分
       0                                                                       AS score,
       0                                                                          score_rank_typ,                -- 该字段在数据中未体现，用一个默认值替代（正超）
       0                                                                       AS score_rank_all,                -- 指标最终得分排名：后面计算更新
       val,
       0,                                                                                                        -- 该字段在数据中未体现，用一个默认值替代（正超）
       val_rank_all,                                                                                             -- 指标数据值排名（需重新计算排名，因为排名对象发生了变化）
       var_details,
       effect_ver,
       0                                                                       AS pre_score,
       alt_val,
       eff_src_ids
FROM ind_value_2022 A
WHERE r_ver_no = @rVerNo
  AND ind_code IN
      (SELECT code
       FROM derived_indicator
       WHERE r_ver_no = @rVerNo
         AND r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3));


# 插入指标得分与排名-质量监测

INSERT INTO derived_ind_score_2022(r_ver_no,
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
       @rLeafId_4 AS r_leaf_id,
       (SELECT id
        FROM derived_indicator B
        WHERE B.code = A.ind_code
          AND B.level != 4
          AND B.r_ver_no = @rVerNo
          AND B.r_leaf_id = @rLeafId_4
       )          AS ind_id,
       ind_code,
       univ_code,
       0          AS is_same_type,                                         -- 该字段在数据中未体现，用一个默认值替代（正超）
/*       (IFNULL(pre_score, 0) * (SELECT B.score ->> '$.defaultWeight'
                                FROM derived_indicator B
                                WHERE B.code = A.ind_code
                                  AND B.level != 4
                                  AND B.r_ver_no = @rVerNo
                                  AND B.r_leaf_id = @rLeafId_4)) score, */ -- 非初始得分： 指标比例得分*指标权重 = 指标最终得分
       0          AS score,
       0          AS score_rank_typ,                                       -- 该字段在数据中未体现，用一个默认值替代（正超）
       0          AS score_rank_all,                                       -- 指标最终得分排名：后面计算更新
       val,
       0,                                                                  -- 该字段在数据中未体现，用一个默认值替代（正超）
       val_rank_all,                                                       -- 指标数据值排名（需重新计算排名，因为排名对象发生了变化）
       var_details,
       effect_ver,
       0          AS pre_score,
       alt_val,
       eff_src_ids
FROM ind_value_2022 A
WHERE r_ver_no = @rVerNo
  AND ind_code IN (SELECT code FROM derived_indicator WHERE r_leaf_id = @rLeafId_4 AND r_ver_no = @rVerNo);

# 计算指标得分（比例值*权重）
WITH M AS (SELECT r_ver_no, ind_code, MAX(val) max_val
           FROM derived_ind_score_2022
           WHERE r_ver_no = @rVerNo
           GROUP BY ind_code)
UPDATE derived_ind_score_2022 A JOIN M ON A.ind_code = M.ind_code AND A.r_ver_no = M.r_ver_no
SET A.pre_score = (A.val / M.max_val),
    A.score     = (A.val / M.max_val) * (SELECT B.score ->> '$.defaultWeight'
                                         FROM derived_indicator B
                                         WHERE B.code = A.ind_code
                                           AND B.level != 4
                                           AND B.r_ver_no = @rVerNo
                                           AND A.r_leaf_id = B.r_leaf_id)
WHERE A.r_ver_no = @rVerNo
  AND A.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
;

# 计算指标得分排名、指标数据值排名
WITH ranks AS (SELECT r_leaf_id,
                      univ_code,
                      ind_code,
                      RANK() OVER ( PARTITION BY r_leaf_id,ind_code ORDER BY score DESC ) AS score_rank_all,
                      RANK() OVER ( PARTITION BY r_leaf_id,ind_code ORDER BY val DESC )   AS val_rank_all
               FROM derived_ind_score_2022
               WHERE r_ver_no = @rVerNo)
UPDATE derived_ind_score_2022 A JOIN ranks ON A.univ_code = ranks.univ_code AND A.ind_code = ranks.ind_code AND
                                              A.r_leaf_id = ranks.r_leaf_id
SET A.score_rank_all = ranks.score_rank_all,
    A.val_rank_all   = ranks.val_rank_all
WHERE r_ver_no = @rVerNo
  AND A.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4);

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
WITH dimension_score AS (SELECT D.dim_code, A.*
                         FROM derived_ind_score_2022 A
                                  JOIN (SELECT B.r_leaf_id, B.code dim_code, C.code indicator_code, B.r_ver_no
                                        FROM derived_indicator B
                                                 JOIN derived_indicator C
                                        WHERE B.id = C.pid
                                          AND C.level != 4
                                          AND B.code != ''
                                          AND B.r_ver_no = @rVerNo
                                          AND C.r_ver_no = @rVerNo) D
                                       ON A.ind_code = D.indicator_code
                                           AND A.r_ver_no = D.r_ver_no
                                           AND A.r_leaf_id = D.r_leaf_id
                         WHERE A.r_ver_no = @rVerNo)
SELECT r_ver_no,
       r_leaf_id,
       (SELECT x.id
        FROM derived_indicator x
        WHERE x.code = z.dim_code
          AND X.level != 4
          AND x.r_ver_no = @rVerNo
          AND x.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)) AS ind_id,
       z.dim_code,
       univ_code,
       0                                                                                   AS is_same_type,
       SUM(score)                                                                          AS score,
       0                                                                                   AS score_rank_typ,
       RANK() OVER ( PARTITION BY z.dim_code ORDER BY SUM(score) DESC )                    AS score_rank_all,
       0                                                                                   AS val,
       0                                                                                   AS val_rank_typ,
       -1                                                                                  AS val_rank_all,
       NULL                                                                                AS var_details,
       ''                                                                                  AS effect_ver,
       0                                                                                   AS pre_score,
       NULL                                                                                AS alt_val
FROM dimension_score z
WHERE z.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
GROUP BY z.univ_code, z.dim_code;

# 学校总得分&排名
# TRUNCATE TABLE derived_ranking_list;
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
       COALESCE((SELECT uc.id
                 FROM univ_ranking_dev.univ_cn uc
                 WHERE uc.code = univ_code
                   AND uc.outdated NOT BETWEEN -9999 AND -1
                 ORDER BY uc.outdated > 0, ABS(uc.outdated) DESC
                 LIMIT 1), -1)                                                   AS univ_cn_id,
       univ_code,
       0                                                                         AS is_same_type,
       ROUND(SUM(score), 1)                                                      AS score,
       0                                                                         AS rank_typ,
       RANK() OVER ( PARTITION BY r_leaf_id ORDER BY ROUND(SUM(score), 1) DESC ) AS rank_all,
       RANK() OVER ( PARTITION BY r_leaf_id ORDER BY SUM(score) DESC )           AS ord_no
FROM derived_ind_score_2022 A
WHERE A.val_rank_all = -1 -- 维度
  AND A.score != 0
  AND A.r_ver_no = @rVerNo
  AND A.r_leaf_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
GROUP BY A.r_leaf_id, A.univ_code
HAVING ROUND(SUM(score), 1) != 0;

# 收尾工作
WITH num AS (SELECT r_leaf_id, COUNT(*) num_listed
             FROM derived_ranking_list
             WHERE score != 0
               AND r_ver_no = @rVerNo
             GROUP BY r_leaf_id)
UPDATE derived_ranking_instance A,num
SET A.num_listed = num.num_listed
WHERE A.type_id = num.r_leaf_id
  AND A.ver_no = @rVerNo
  AND A.type_id IN (@rLeafId_0, @rLeafId_1, @rLeafId_2, @rLeafId_3, @rLeafId_4)
;
SET FOREIGN_KEY_CHECKS = 1;







