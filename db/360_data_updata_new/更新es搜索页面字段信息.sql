-- 1. migration/ub_ranking_header.sql:1002 到 1040 行 【更新 ES 搜索字段信息】
-- 2. migration/ub_ranking_header.sql:1191 先确认是否需要执行
-- 3. migration/ub_ranking_datamig_ind_l4var.sql:157 【更新 indicator_latest.detail_def_id】
-- 4. migration/ub_ranking_datamig_ind_l4var.sql:394 【更新 indicator.detail_def_id】

-- USE ub_ranking_dev_alpha;

###################################################### ES 明细字段 #####################################################
-- 1:
# 更新 Elastic Search 搜索需要的字段（按变量定义）
# 更新 ind_detail_def
/*ALTER TABLE ind_detail_def
    ADD is_es BOOL NOT NULL DEFAULT 0 COMMENT '是否为 ES 搜索需要的变量明细字段定义';*/
DELETE FROM ind_detail_field WHERE def_id IN (SELECT id FROM ind_detail_def WHERE is_es = 1);

DELETE
  FROM ind_detail_def
 WHERE is_es;
ALTER TABLE ind_detail_def
    AUTO_INCREMENT 0;
INSERT INTO ind_detail_def(id, name, table_width, remark, created_at, updated_at, deleted_at, is_es)
SELECT NULL id, name, table_width, remark, created_at, updated_at, deleted_at, is_es
  FROM univ_ranking_raw.ub_220120_ind_detail_def
 WHERE is_es AND name IS NOT NULL;
# 更新 ind_detail_field
INSERT INTO ind_detail_field(id, def_id, field_key, field_name, field_key_old, field_name_old, is_required, is_editable, char_limit, show_width, tip, align, special, ord_no, created_at, updated_at, deleted_at)
WITH fld AS (
SELECT NULL id
     , (SELECT d.id
          FROM ind_detail_def d
                   JOIN univ_ranking_raw.ub_220120_ind_detail_def od USING (name, remark, created_at, updated_at)
         WHERE d.is_es
           AND od.id = odf.def_id) def_id
     , field_key
     , field_name
     , IFNULL(field_key_old,'') AS field_key_old
     , IFNULL(field_name_old,'') AS field_name_old
     , is_required
     , is_editable
     , char_limit
     , show_width
     , IFNULL(tip,'')
     , align
     , IFNULL(special,'')
     , ord_no
     , created_at
     , updated_at
     , deleted_at
  FROM univ_ranking_raw.ub_220120_ind_detail_field odf
 WHERE odf.def_id IN (SELECT id FROM univ_ranking_raw.ub_220120_ind_detail_def WHERE is_es))
SELECT * FROM fld WHERE def_id IS NOT NULL
;

-- 3:
# 更新变量明细字段定义引用
  WITH ds AS ( -- detail shows
      SELECT id
        FROM indicator_latest
       WHERE level = 3
         AND shows != '^'
         AND detail ->> '$.shows' IS NOT NULL)
UPDATE indicator_latest il
   SET detail_def_id=IFNULL((SELECT d.id FROM ind_detail_def d WHERE d.is_es AND d.remark = il.code), 0) -- note: 这里还有未成功关联上的数据，先走通流程再说
 WHERE il.level = 4
   AND il.pid IN (SELECT id FROM ds)
;

-- 4:
# 更新变量明细字段定义 detail_def_id 引用
  WITH ds AS ( -- detail shows
      SELECT id
        FROM indicator
       WHERE level = 3
         AND shows != '^'
         AND detail ->> '$.shows' IS NOT NULL)
UPDATE indicator i
   SET detail_def_id=IFNULL((SELECT d.id FROM ind_detail_def d WHERE d.is_es AND d.remark = i.code), 0) -- note: 这里还有未成功关联上的数据，先走通流程再说
 WHERE i.level = 4
   AND i.pid IN (SELECT id FROM ds)
;

-- 2:
# 解决产品反馈的搜索页面省级指标明细学校显示的是学校代码的问题：
UPDATE ind_detail_field
SET field_key = 'ElectedName'
WHERE def_id IN ( SELECT id FROM `ind_detail_def` WHERE remark IN ('pccourse', 'pacourse') AND is_es = 1 )
  AND field_key = 'ElectedCode';