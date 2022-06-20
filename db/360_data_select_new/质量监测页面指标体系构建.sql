# 质量监测

USE ub_ranking_0520;

SET @rVerNo = 202203;
DROP TEMPORARY TABLE IF EXISTS ind_zhiliang;
CREATE TEMPORARY TABLE ind_zhiliang
(
    id       int AUTO_INCREMENT PRIMARY KEY,
    r_ver_no int         NOT NULL COMMENT '版本',
    name     varchar(50) NOT NULL COMMENT '指标名称',
    code     varchar(20) DEFAULT '' COMMENT '指标代码',
    ind_lev  varchar(10) DEFAULT 0 COMMENT '排名指标/参考指标',
    weight   int         DEFAULT 0 COMMENT '权重',
    ind_type varchar(10) DEFAULT '' COMMENT '指标类型',
    INDEX (name)

) COMMENT '质量监测指标信息临时表';

INSERT INTO ind_zhiliang ( r_ver_no, name, ind_lev, weight, ind_type )
VALUES ( @rVerNo, '研本比', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '本专比', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '顶尖学科精度（A+占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '顶尖学科精度（软科前2%占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '一流学科精度（A类占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '一流学科精度（软科前10%占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '优势学科精度（上榜占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '优势学科精度（软科前50%占比）', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '学校收入（生均）', '排名指标', '20', '生均指标' ),
       ( @rVerNo, '自主收入比例（其他渠道收入占比）', '参考指标', '0', '比值指标' ),
       ( @rVerNo, '社会捐赠收入（生均）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '师生比', '排名指标', '10', '比值指标' ),
       ( @rVerNo, '教师学历结构（博士学位教师占比）', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '教师职称结构（高级职称教师占比）', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '模范先进教师（生均折合数）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '模范先进教师（生均折合数-医）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '模范先进学生（生均折合数）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '思政课程名师（生均折合数）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '思政教育队伍（生均折合数）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '思政教育基地（生均折合数）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '直接生师比', '参考指标', '0', '比值指标' ),
       ( @rVerNo, '国家级与认证专业（生均）', '排名指标', '10', '生均指标' ),
       ( @rVerNo, '本科课程（生均）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '国家一流本科课程（生均）', '排名指标', '10', '生均指标' ),
       ( @rVerNo, '规划与马工程教材（生均）', '排名指标', '5', '生均指标' ),
       ( @rVerNo, '国家教学名师（生均）', '排名指标', '10', '生均指标' ),
       ( @rVerNo, '教授授课率', '排名指标', '10', '比值指标' ),
       ( @rVerNo, '授课教授比例', '排名指标', '10', '比值指标' ),
       ( @rVerNo, '国家教学基地（生均折合数）', '排名指标', '10', '生均指标' ),
       ( @rVerNo, '国家教学成果奖（师均折合数）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '研究生教育成果奖（师均折合数）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '科创竞赛奖（生均折合数）', '排名指标', '20', '生均指标' ),
       ( @rVerNo, '本科毕业生就业率', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '本科毕业生深造率', '排名指标', '20', '比值指标' ),
       ( @rVerNo, '造就学术人才（生均）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '造就医学人才（生均）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '造就财经人才（生均）', '参考指标', '0', '生均指标' ),
       ( @rVerNo, '科研经费（师均）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '自科面上青年项目（师均）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '社科一般青年项目（师均）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '国家科研项目（师均）', '排名指标', '20', '师均指标' ),
       ( @rVerNo, '国际期刊论文（师均）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '中文期刊论文（师均）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '科研平台（师均折合数）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '企业科研经费（师均）', '排名指标', '15', '师均指标' ),
       ( @rVerNo, '发明专利申请（师均）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '发明专利授权（师均）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, 'PCT国际专利申请（师均）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '专利获奖（师均折合数）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '技术转让收入（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '资深学术权威（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '中年领军专家（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '青年拔尖英才（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '文科学术骨干（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '国际知名学者（师均）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '学术人才（师均）', '排名指标', '25', '师均指标' ),
       ( @rVerNo, '自科重大项目（师均额度）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '社科重大项目（师均折合数）', '排名指标', '5', '师均指标' ),
       ( @rVerNo, '国家重大项目（师均折合数）', '排名指标', '10', '师均指标' ),
       ( @rVerNo, '国家重大奖励（师均折合数）', '排名指标', '30', '师均指标' ),
       ( @rVerNo, '教育部科学技术奖（师均折合数）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '教育部人文社科奖（师均折合数）', '参考指标', '0', '师均指标' ),
       ( @rVerNo, '教育部奖励（师均折合数）', '排名指标', '20', '师均指标' ),
       ( @rVerNo, '留学生比例', '排名指标', '5', '比值指标' ),
       ( @rVerNo, '国际教师比例', '参考指标', '0', '比值指标' ),
       ( @rVerNo, '国际合作论文比例', '排名指标', '5', '比值指标' );

# 对模范先进教师（生均折合数） 暂时进行区分：
UPDATE indicator
SET name = '模范先进教师（生均折合数-医）'
WHERE code = 'cate0508022'
  AND r_ver_no = @rVerNo;

# 质量监测指标体系入库：
-- 维度（生均、师均、比例值）
SET FOREIGN_KEY_CHECKS = 0;
DELETE
FROM derived_indicator
WHERE code IN ('S_AVG', 'T_AVG', 'RATIO');
INSERT INTO derived_indicator
VALUES ( 151, 0, 1, @rVerNo, 'S_AVG', '生均指标', '', '', 1, NULL, 0, 0, 0, 0, '', '', '', '', NULL, NULL, NULL, NULL, 1,
         '',
         '2022-05-16 20:01:05', -1, '2022-05-16 20:01:05', NULL, NULL, NULL ),
       ( 152, 0, 1, @rVerNo, 'T_AVG', '师均指标', '', '', 1, NULL, 0, 0, 0, 0, '', '', '', '', NULL, NULL, NULL, NULL, 2,
         '',
         '2022-05-16 20:01:05', -1, '2022-05-16 20:01:05', NULL, NULL, NULL ),
       ( 153, 0, 1, @rVerNo, 'RATIO', '比值指标', '', '', 1, NULL, 0, 0, 0, 0, '', '', '', '', NULL, NULL, NULL, NULL, 3,
         '',
         '2022-05-16 20:01:05', -1, '2022-05-16 20:01:05', NULL, NULL, NULL );

-- 指标
DELETE
FROM derived_indicator
WHERE remark IN ('生均指标', '师均指标', '比值指标');
INSERT INTO derived_indicator ( pid,
                                r_leaf_id,
                                r_ver_no,
                                code,
                                name,
                                abbr,
                                path,
                                level,
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
                                remark,
                                created_at,
                                created_by,
                                updated_at,
                                updated_by,
                                deleted_at,
                                deleted_by )
SELECT (CASE WHEN A.ind_type = '生均指标' THEN 151
             WHEN A.ind_type = '师均指标' THEN 152
             WHEN A.ind_type = '比值指标' THEN 153 END) AS pid,
       1                                               r_leaf_id,
       A.r_ver_no,
       B.code,
       B.name,
       B.abbr,
       ''                                              path,
       2                                               level,
       NULL                                            var_id,
       B.ind_lev,
       B.is_full_sample,
       B.detail_def_id,
       B.change_type,
       B.definition,
       B.editable,
       B.shows,
       B.tags,
       B.ui,
       B.detail,
       B.val,
       CONCAT('{"defaultWeight": ', A.weight, '}')  AS score,
       B.ord_no,
       A.ind_type                                   AS remark,
       B.created_at,
       B.created_by,
       B.updated_at,
       B.updated_by,
       B.deleted_at,
       B.deleted_by
FROM ind_zhiliang   A
     JOIN indicator B ON A.name = B.name AND A.r_ver_no = B.r_ver_no
WHERE B.level = 3
ORDER BY pid, B.ord_no;

SET FOREIGN_KEY_CHECKS = 1;

# 还原指标名称：
UPDATE indicator
SET name = '模范先进教师（生均折合数）'
WHERE code = 'cate0508022'
  AND r_ver_no = @rVerNo;
UPDATE derived_indicator
SET name = '模范先进教师（生均折合数）'
WHERE code = 'cate0508022';