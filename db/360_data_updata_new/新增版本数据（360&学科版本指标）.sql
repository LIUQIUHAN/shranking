# 添加360指标版本数据
USE ub_ranking_dev;

-- ALTER TABLE indicator AUTO_INCREMENT 0; -- 让自增id连贯
SET @v_num = 202208;

INSERT INTO indicator(id, pid, r_ver_no, code, name, abbr, path, level, var_id, ind_lev, centrality, is_full_sample, detail_def_id,
                      change_type, definition, editable, shows, tags, ui, detail, val, score, ord_no, remark,
                      created_at, created_by, updated_at, updated_by, deleted_at, deleted_by)
WITH m AS ( -- 获取实际最大 id，作为本次计算新增记录所用 id 的偏移量
    SELECT MAX(id) mid
    FROM indicator)
     -- 给 id/pid 字段加上偏移量
SELECT (m.mid + i.id)                                       AS id,
       IF(i.pid = 0, 0, m.mid + i.pid)                      AS pid,
       @v_num                                               AS r_ver_no,
       IF(code = '', CONCAT('ub-', @v_num), code)           AS code,
       IF(name = '最新指标体系-0', CONCAT('指标体系-', @v_num), name) AS name,
       abbr,
       ''                                                   AS path,
       level,
       var_id,
       ind_lev,
       centrality,
       is_full_sample, detail_def_id, change_type, definition, editable, shows,
       tags, ui, detail, val, score, ord_no, remark, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
FROM indicator_latest i
         JOIN m
WHERE name != '大学360';
# 模块十一的省级指标需标记删除
UPDATE indicator SET deleted_at = NOW() WHERE name RLIKE '省级';
-- 更新path：
WITH
    RECURSIVE tree AS (
    SELECT id,
           CAST(NULL AS CHAR(50)) new_path /* 故意给 null，方便 后面进行 CONCAT_WS 时忽略根节点的 path；如果不这样处理，后续层级的节点，path 最前面会多一个逗号 */
    FROM indicator i
    WHERE level = 0
    UNION ALL
    SELECT i.id, CONCAT_WS(',', tree.new_path, tree.id)
    FROM tree
             JOIN indicator i ON i.pid = tree.id
)
UPDATE indicator i JOIN tree t ON i.id = t.id
SET i.path = IFNULL(t.new_path, '')
WHERE i.id > 0;

# ranking_version（略）

# ranking_instance
INSERT INTO ranking_instance (ver_no, type_id, name, code, num_listed, ord_no, deleted_at)
SELECT @v_num AS ver_no,
       type_id,
       name,
       code,
       num_listed,
       ord_no,
       deleted_at
FROM ranking_instance
WHERE ver_no = (@v_num - 1);

# weight_scheme
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO weight_scheme (r_ver_no, r_type_id, name, created_at, created_by, updated_at, updated_by, deleted_at,
                           deleted_by)
SELECT @v_num AS r_ver_no,
       r_type_id,
       name,
       NOW()  AS created_at,
       created_by,
       NOW()  AS updated_at,
       NULL   AS updated_by,
       NULL   AS deleted_at,
       NULL   AS deleted_by
FROM weight_scheme
WHERE r_ver_no = (@v_num - 1);

SET FOREIGN_KEY_CHECKS = 1;

# 更新ranking_instance.weight_scheme_id
UPDATE ranking_instance A JOIN weight_scheme B ON A.type_id = B.r_type_id AND A.ver_no = B.r_ver_no
SET A.weight_scheme_id = B.id
WHERE A.ver_no = @v_num;

# weight_scheme_detail
INSERT INTO weight_scheme_detail (scheme_id, ind_id, ind_code, weight)
WITH SR AS (SELECT A.*,
                   (SELECT type_id
                    FROM ranking_instance B
                    WHERE A.scheme_id = B.weight_scheme_id AND B.ver_no = (@v_num - 1)) t_id
            FROM weight_scheme_detail A
            WHERE scheme_id IN (SELECT id FROM weight_scheme WHERE r_ver_no = (@v_num - 1))),
     RI AS (SELECT SR.*,
                   (SELECT weight_scheme_id
                    FROM ranking_instance N
                    WHERE N.type_id = SR.t_id AND N.ver_no = @v_num) weight_scheme_id
            FROM SR)

SELECT weight_scheme_id,
       (SELECT B.id FROM indicator B WHERE RI.ind_code = B.code AND B.level = 3 AND B.r_ver_no = @v_num) AS ind_id,
       ind_code,
       weight
FROM RI;


# var_lev_conv
INSERT INTO var_lev_conv (r_ver_no, var_id, var_code, province_code, conv_val, lev, lev_name, var_name_full, remark,
                          created_at, updated_at)
SELECT @v_num AS r_ver_no,
       var_id,
       var_code,
       province_code,
       conv_val,
       lev,
       lev_name,
       var_name_full,
       remark,
       NOW()  AS created_at,
       NOW()  AS updated_at
FROM var_lev_conv
WHERE r_ver_no = (@v_num - 1);

# ranking_list
INSERT INTO ranking_list (r_ver_no, r_leaf_id, univ_cn_id, univ_code, is_same_type)
SELECT @v_num AS r_ver_no,
       r_leaf_id,
       univ_cn_id,
       univ_code,
       is_same_type
FROM ranking_list
WHERE r_ver_no = (@v_num - 1);


-- 更新标签
UPDATE ub_ranking_dev.indicator SET change_type = 0
WHERE r_ver_no = @v_num;

UPDATE ub_ranking_dev.indicator_latest SET change_type = 0
WHERE 1;
















