# 添加360指标版本数据
USE ub_ranking_dev;

-- ALTER TABLE indicator AUTO_INCREMENT 0; -- 让自增id连贯
SET @v_num = 202208;
INSERT INTO indicator(id, pid, r_ver_no, code, name, abbr, path, level, var_id, ind_lev, is_full_sample, detail_def_id,
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
       is_full_sample, detail_def_id, change_type, definition, editable, shows,
       tags, ui, detail, val, score, ord_no, remark, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
FROM indicator_latest i
         JOIN m
WHERE name != '大学360';

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







# 更新指标表数据年份信息
-- 变量
UPDATE ub_ranking_dev.indicator_latest
SET detail = JSON_SET(detail, '$.availVer', '2015-2021', '$.targetVer', '2017-2021')
WHERE code IN (
               'posaward',
               'psaward2',
               'psaward4',
               'psaward6',
               'psaward8',
               'psaward9',
               'ptaward'
    ) AND level = 4;

UPDATE ub_ranking_dev.indicator_latest
SET detail = JSON_SET(detail, '$.availVer', '2016-2021', '$.targetVer', '2017-2021')
WHERE code = 'pysaward' AND level = 4;

-- 指标
UPDATE ub_ranking_dev.indicator_latest
SET detail = JSON_SET(detail, '$.availVer', '2015-2021', '$.targetVer', '2017-2021')
WHERE code IN (
               -- 'pacourse', 0-2021
               'ptaward',
               'ptadwt',
               'psaward',
               'psadwt',
               'psaward9',
               'psaward2',
               'psaward1',
               'psaward4',
               'psaward3',
               'psaward6',
               'psaward5',
               'psaward8',
               'psaward7',
               'posaward'
    )
  AND level = 3;

UPDATE ub_ranking_dev.indicator_latest
SET detail = JSON_SET(detail, '$.availVer', '2016-2021', '$.targetVer', '2017-2021')
WHERE code = 'pysaward' AND level = 3;


-- 更新标签
UPDATE ub_ranking_dev.indicator_latest SET change_type = 1
WHERE code IN (
               'pacourse',
               'ptaward',
               'ptadwt',
               'psaward',
               'psadwt',
               'psaward9',
               'psaward2',
               'psaward1',
               'psaward4',
               'psaward3',
               'psaward6',
               'psaward5',
               'psaward8',
               'psaward7',
               'pysaward',
               'posaward',
               'pysaward'
    )
  AND level = 3;

-- 检测指标信息