USE ub_details_0429;

# 明细表添加学科字段
ALTER TABLE var_detail
    ADD subject_code varchar(4) DEFAULT '' COMMENT '学科代码' AFTER detail;

# 创建360和学科明细代码映射关系表
CREATE TABLE var_map_ub_spm
(
    id              INT AUTO_INCREMENT PRIMARY KEY,
    var_name        VARCHAR(100) NOT NULL COMMENT '变量名称',
    var_code_ub     VARCHAR(50) NOT NULL COMMENT '360变量代码',
    var_code_spm    VARCHAR(50) NOT NULL COMMENT '学科变量代码',
    match_field_ub  VARCHAR(50) NOT NULL COMMENT 'var_detail.detail.FIELD_UB',
    match_field_spm VARCHAR(50) NOT NULL COMMENT 'var_detail.detail.FIELD_SPM',
    remark          VARCHAR(200) NULL,
    UNIQUE (var_code_ub, match_field_ub)
) COMMENT '360、学科变量映射，及明细匹配关系';

# 插入360领域监测变量数据
INSERT IGNORE INTO var_map_ub_spm ( var_name, var_code_ub, var_code_spm, match_field_ub, match_field_spm )
SELECT name, code, '' var_code_spm, '' match_field_ub, '' match_field_spm
FROM ub_ranking_dev.derived_indicator
WHERE r_leaf_id = 401
  AND level = 3;

# 插入学科明细变量代码
UPDATE var_map_ub_spm A JOIN spm_ranking_dev.indicator_latest B ON A.var_name = B.name AND B.level = 4
SET A.var_code_spm = B.code
WHERE 1;

# 补充关联表中学科变量代码
SELECT * FROM var_map_ub_spm WHERE var_code_spm = '' and remark is null;

-- 变量名称                       var_code_ub         var_code_spm（逐一查询补充）
-- 自然科学基金面上项目	                 p4                    p4
-- 自然科学基金青年项目	                 p5                    p5
-- 社会科学基金一般项目	                 p8                    p8
-- 社会科学基金青年项目	                 p9                    p9
-- 教育部野外科学观测研究站	             moeyw
-- 集成攻关大平台	                     jcgg1
-- 国家教材建设重点研究基地	             jcjsjd1
-- 国家应用数学中心	                 mathctr
-- 中国科学院院士	                     h1                    h1
-- 中国工程院院士	                     h2                    h2
-- 爱思唯尔中国高被引学者	             elsevier              elsevier
-- 青年拔尖人才	                     h8                    h8
-- 国家自然科学基金重大项目	             p2                    p2
-- 国家社会科学基金重大项目	             p6                    p6
-- 国家社会科学基金重点项目	             p7                    p7
-- 国际期刊论文（总数）	                 i103
-- 中文期刊论文（总数）	                 i47

# 更新360明细中已经有学科信息的变量
UPDATE var_detail
SET subject_code = detail ->> '$.subject_code'
WHERE var_code IN ('subt', 'moerank', 'bcsr')
  AND _eversions_ IN (202204, 202205, 202206);

# 补充关联表中的match_field_ub/match_field_spm


# 更新360明细表中的学科信息
UPDATE var_detail A JOIN var_detail_spm_0208 B ON A._eversions_ = B._eversions_ AND A.var_code = B.var_code AND
                                                  A.univ_code = B.univ_code AND
                                               -- A.rel_code = B.talent_code AND
                                                  A.detail ->> '$.project_name' = B.detail ->> '$.project_name'
SET A.subject_code = B.subj_code
WHERE A.var_code IN ( SELECT var_code_ub
                      FROM var_map_ub_spm
                      WHERE match_field_ub = match_field_spm AND match_field_ub = 'project_name' )
  AND A._eversions_ IN (202204,202205, 202206);


UPDATE var_detail A JOIN var_detail_spm_0208 B ON A._eversions_ = B._eversions_ AND A.var_code = B.var_code AND
                                                  A.univ_code = B.univ_code AND
                                               -- A.rel_code = B.talent_code AND
                                                  A.detail ->> '$.talent_name' = B.detail ->> '$.talent_name'
SET A.subject_code = B.subj_code
WHERE A.var_code IN ( SELECT var_code_ub
                      FROM var_map_ub_spm
                      WHERE match_field_ub = match_field_spm AND match_field_ub = 'talent_name' )
  AND A._eversions_ IN (202204, 202205, 202206);



# 数据检查
SELECT *
FROM `var_detail`
WHERE var_code IN ( SELECT var_code_ub
                    FROM var_map_ub_spm
                    WHERE match_field_ub = match_field_spm
                      AND match_field_ub IN ('talent_name', 'project_name') )
  AND subject_code = ''
  AND _eversions_ = 202203
  AND univ_code != 'XXXXX';





























