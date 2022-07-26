# 新增省级科技奖励数据
USE ub_details_0429;
-- 省级奖励
INSERT INTO var_detail (/*dtl_id, */revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_by)
SELECT 0                                                     revision,
       (SELECT id FROM variable B WHERE A.var_code = B.code) var_id,
       var_code,
       IF(var_code = 'ptaward', 5, 6)                        source_id,
       ver_no,
       univ_code,
       (CASE
            WHEN grade = '特等奖' THEN 1
            WHEN grade = '一等奖' THEN 2
            WHEN grade = '二等奖' THEN 3
            WHEN grade = '三等奖' THEN 4
            ELSE '0'
           END
           )                                                 lev,
       1                                                     val,
       (JSON_OBJECT(
               'remark1', province,
               'remark2', remark,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', grade,
               'talent_name', talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0.0
           ))                                                detail,
       ''                                                    subject_code,
       ''                                                    rel_code,
       0                                                     agg_from,
       202207                                                _eversions_,
       202207                                                _r_ver_no,
       -2                                                    created_by
FROM ub_details_raw.provincial_awards_data_20220613 A
WHERE 1;

-- 省级一流本科课程
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0           revision,
       217         var_id,
       var_code,
       5           source_id,
       ver_no,
       univ_code,
       0           lev,
       1           val,
       JSON_OBJECT(
               'remark1', var_name_full,
               'remark2', NULL,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', first_resp_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0.0) AS
                   detail,
       ''          subject_code,
       0           rel_code,
       0           agg_from,
       202207      _eversions_,
       202207      _r_ver_no,
       create_time,
       -2          created_by,
       create_time updated_at,
       NULL        updated_by,
       NULL        deleted_at,
       NULL        deleted_by
FROM ub_details_raw.provincial_first_class_data_20220613
WHERE 1;


-- 省级一流本科专业
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                                revision,
       215                              var_id,
       var_code,
       5                                source_id,
       ver_no,
       univ_code,
       0                                lev,
       1                                val,
       JSON_OBJECT(
               'remark1', remark,
               'remark2', rel_code,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', NULL,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0.0) AS
                                        detail,
       ''                               subject_code,
       IFNULL(rel_code, 0)           AS rel_code,
       0                                agg_from,
       202207                           _eversions_,
       202207                           _r_ver_no,
       create_time,
       -2                               created_by,
       create_time                      updated_at,
       NULL                             updated_by,
       NULL                             deleted_at,
       NULL                             deleted_by
FROM ub_details_raw.first_major_data_20220613
WHERE var_code = 'pccourse';

-- 国家级一流本科专业
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                                revision,
       8                                var_id,
       var_code,
       4                                source_id,
       ver_no,
       univ_code,
       0                                lev,
       1                                val,
       JSON_OBJECT(
               'remark1', NULL,
               'remark2', rel_code,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', NULL,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0.0) AS
                                        detail,
       ''                               subject_code,
       rel_code                      AS rel_code,
       0                                agg_from,
       202207                           _eversions_,
       202207                           _r_ver_no,
       create_time,
       -2                               created_by,
       create_time                      updated_at,
       NULL                             updated_by,
       NULL                             deleted_at,
       NULL                             deleted_by
FROM ub_details_raw.first_major_data_20220613
WHERE var_code = 'ben1';


# 2022年06月23日新增：五四青年奖
/*INSERT INTO var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                        subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                        updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL         dtl_id,
       0            revision,
       43           var_id,
       'add1055'    var_code,
       9            source_id,
       elected_year ver_no,
       univ_code,
       0            lev,
       1            val,
       JSON_OBJECT(
               'remark1', NULL,
               'remark2', NULL,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', elected_name,
               'elected_year', elected_year,
               'project_name', NULL,
               'project_money', 1.0
           )
                    detail,
       ''           subject_code,
       talent_code  rel_code,
       0            agg_from,
       202207       _eversions_,
       202207       _r_ver_no,
       NOW()        create_time,
       -2           created_by,
       NOW()        updated_at,
       NULL         updated_by,
       NULL         deleted_at,
       NULL         deleted_by
FROM ub_details_raw.var_code_add1055_20220623
WHERE 1;*/


UPDATE ub_ranking_dev.indicator_latest
SET detail = JSON_SET(detail, '$.availVer', '2014-2021', '$.targetVer', '2017-2021')
WHERE `name` RLIKE '中文期刊论文';

UPDATE ub_ranking_dev.indicator
SET detail = JSON_SET(detail, '$.availVer', '2014-2021', '$.targetVer', '2017-2021')
WHERE `name` RLIKE '中文期刊论文'
  AND r_ver_no = 202207;


# 省级教学成果奖补充更新（本次徐涵了给全样本数据，告知需替换之前的所有数据）
USE ub_details_0429;
SELECT *
FROM ub_details_0429.var_detail
WHERE _r_ver_no = 202208
  AND var_code = 'ptaward';

INSERT INTO var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                        subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                        updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL                                             dtl_id,
       0                                                revision,
       216                                              var_id,
       'ptaward'                                        var_code,
       5                                                source_id,
       yr                                               ver_no,
       univ_code,
       (CASE
            WHEN level = '特等奖' THEN 1
            WHEN level = '特等奖培育项目' THEN 2
            WHEN level = '一等奖' THEN 3
            WHEN level = '二等奖' THEN 4
            WHEN level = '三等奖' THEN 5
            WHEN level = '优秀奖' THEN 6
           END
           )                                            lev,
       1                                                val,
       JSON_OBJECT(
               'remark1', var_name,
               'remark2', CONCAT(var_name, level),
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', level,
               'talent_name', talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', elected_name,
               'elected_year', yr,
               'project_name', project_name,
               'project_money', 0
           )
                                                        detail,
       IF(subject_code_1 = '\\', '', subject_code_1) AS subject_code,
       ''                                               rel_code,
       0                                                agg_from,
       202208                                           _eversions_,
       202208                                           _r_ver_no,
       NOW()                                            create_time,
       -2                                               created_by,
       NOW()                                            updated_at,
       NULL                                             updated_by,
       NULL                                             deleted_at,
       NULL                                             deleted_by
FROM ub_details_raw.pro_teaching_achievement_award_20220708
WHERE 1;



# 更新现职人才表中univ_code
# 根据软科标准代码匹配univ_cn
UPDATE ub_details_raw.`talents_data_2022.06` A
SET A.elected_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn B
                           WHERE A.elected_code = B._code_old
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1),
    A.current_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn B
                           WHERE A.current_code = B._code_old
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1)
WHERE 1;


# 根据软科标准代码匹配univ_cn_academy
UPDATE ub_details_raw.`talents_data_2022.06` A
SET A.elected_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn_academy B
                           WHERE A.elected_code = B._code_old
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1)
WHERE elected_univ_code IS NULL
  AND elected_code != 'XXXXX';

UPDATE ub_details_raw.`talents_data_2022.06` A
SET A.current_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn_academy B
                           WHERE A.elected_code = B._code_old
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1)
WHERE current_univ_code IS NULL
  AND current_code != 'XXXXX';


# 根据学校名称匹配univ_cn_academy
UPDATE ub_details_raw.`talents_data_2022.06` A
SET A.elected_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn_academy B
                           WHERE A.elected_name = B.name_cn
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1)
WHERE elected_univ_code IS NULL
  AND elected_code != 'XXXXX';

UPDATE ub_details_raw.`talents_data_2022.06` A
SET A.current_univ_code = (SELECT B.code
                           FROM univ_ranking_dev.univ_cn_academy B
                           WHERE A.current_name = B.name_cn
                           ORDER BY B.outdated = 0 DESC,
                                    B.outdated DESC
                           LIMIT 1)
WHERE current_univ_code IS NULL
  AND current_code != 'XXXXX';

# 检测
SELECT *
FROM ub_details_raw.`talents_data_2022.06`
WHERE current_univ_code IS NULL
  AND current_code != 'XXXXX';
SELECT *
FROM ub_details_raw.`talents_data_2022.06`
WHERE elected_univ_code IS NULL
  AND elected_code != 'XXXXX';

# 更新基地中心表中univ_code
# 根据软科标准代码匹配univ_cn
UPDATE ub_details_raw.`base_data_2022.06` A
SET A.univ_code = (SELECT B.code
                   FROM univ_ranking_dev.univ_cn B
                   WHERE A.school_code = B._code_old
                   ORDER BY B.outdated = 0 DESC,
                            B.outdated DESC
                   LIMIT 1)
WHERE 1;

UPDATE ub_details_raw.`base_data_2022.06` A
SET A.univ_code = (SELECT B.code
                   FROM univ_ranking_dev.univ_cn_academy B
                   WHERE A.elected_name = B.name_cn
                   ORDER BY B.outdated = 0 DESC,
                            B.outdated DESC
                   LIMIT 1)
WHERE univ_code IS NULL
  AND school_code != 'XXXXX';

# 检测
SELECT *
FROM ub_details_raw.`base_data_2022.06`
WHERE univ_code IS NULL
  AND school_code != 'XXXXX';



# 7月22日



# 人才基地中心数据入360变量明细库
# 检测所有变量detail结构是否一致（一致）
/*SELECT var_code, var_id, source_id
FROM var_detail
WHERE _eversions_ = 202207
  AND var_code IN (
                   'add1013_1',
                   'elsevier',
                   'h1',
                   'h2',
                   'h3',
                   'h4',
                   'h5',
                   'h6',
                   'h7',
                   'h8',
                   'j10_1',
                   'j1_1',
                   'j3_0',
                   'j3_1',
                   'j3_2',
                   'j3_3',
                   'p10_1',
                   'p11_1',
                   'p11_2',
                   'p11_3',
                   'p12_1',
                   'p12_2',
                   'p13_1',
                   'p2_1',
                   'p3_1',
                   'p6_1',
                   'p7_1',
                   'r10',
                   'r13',
                   'r14',
                   'x16_1',
                   'x21_1',
                   'z1_1',
                   'z1_2',
                   'z2_0',
                   'z2_1',
                   'z2_2',
                   'z2_3',
                   'z3_1',
                   'z3_2',
                   'z4_1',
                   'z4_2',
                   'z4_3',
                   'z4_4',
                   'z4_5')
GROUP BY var_code;*/

# 删除202208版本上的相关变量数据
DELETE
FROM var_detail
WHERE _eversions_ = 202208
  AND var_code = 'elsevier'
  AND ver_no = 2021;

DELETE
FROM var_detail
WHERE _eversions_ = 202208
  AND var_code IN (
                   'add1013_1',
                   'h1',
                   'h2',
                   'h3',
                   'h4',
                   'h5',
                   'h6',
                   'h7',
                   'h8',
                   'j10_1',
                   'j1_1',
                   'j3_0',
                   'j3_1',
                   'j3_2',
                   'j3_3',
                   'p10_1',
                   'p11_1',
                   'p11_2',
                   'p11_3',
                   'p12_1',
                   'p12_2',
                   'p13_1',
                   'p2_1',
                   'p3_1',
                   'p6_1',
                   'p7_1',
                   'r10',
                   'r13',
                   'r14',
                   'x16_1',
                   'x21_1',
                   'z1_1',
                   'z1_2',
                   'z2_0',
                   'z2_1',
                   'z2_2',
                   'z2_3',
                   'z3_1',
                   'z3_2',
                   'z4_1',
                   'z4_2',
                   'z4_3',
                   'z4_4',
                   'z4_5');

# 导入最新数据
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                                    revision,
       B.var_id,
       A.var_code,
       B.source_id,
       A.ver_no,
       IFNULL(A.current_univ_code, 'XXXXX') univ_code,
       0                                    lev,
       1                                    val,
       JSON_OBJECT(
               'remark1', NULL,
               'remark2', NULL,
               'born_year', A.born_year,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', A.talent_name,
               'current_code', A.current_code,
               'current_name', A.current_name,
               'elected_code', A.elected_code,
               'elected_name', A.elected_name,
               'elected_year', A.ver_no,
               'project_name', NULL,
               'project_money', 0
           )
           AS                               detail,
       ''                                   subject_code,
       A.talent_code                        rel_code,
       0                                    agg_from,
       202208                               _eversions_,
       202208                               _r_ver_no,
       NOW()                                create_time,
       -2                                   created_by,
       NOW()                                updated_at,
       NULL                                 updated_by,
       NULL                                 deleted_at,
       NULL                                 deleted_by
FROM ub_details_raw.`talents_data_2022.06` A
         JOIN var_rel_source B ON A.var_code = B.var_code
WHERE 1;

# 删除202208版本上的基地中心相关变量数据
DELETE
FROM var_detail
WHERE _eversions_ = 202208
  AND var_code IN (
                   'add1057',
                   'add1060',
                   'd1',
                   'd11',
                   'd12',
                   'd13',
                   'd14',
                   'd15',
                   'd16',
                   'd17',
                   'd19',
                   'd2',
                   'd20',
                   'd21',
                   'd22',
                   'd3',
                   'd51',
                   'd52',
                   'd53',
                   'd54',
                   'd55',
                   'd56',
                   'd57',
                   'd58',
                   'd59',
                   'd60',
                   'd61',
                   'd62',
                   'd63',
                   'fwsh001',
                   'g16',
                   'jcgg1',
                   'jcjsjd1',
                   'mathctr',
                   'moeyw',
                   'pt1',
                   'pt2',
                   'pt3',
                   'pt4',
                   'pt5',
                   'pt6',
                   'pt7',
                   'sz2',
                   'sz340',
                   'sz5',
                   'sz6',
                   'x4');

# 导入最新数据
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                               revision,
       B.var_id,
       A.var_code,
       B.source_id,
       IFNULL(A.ver_no,0),
       IFNULL(A.univ_code, 'XXXXX') AS univ_code,
       0                               lev,
       1                               val,
       JSON_OBJECT(
               'remark1', NULL,
               'remark2', NULL,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', A.award_level,
               'talent_name', A.talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', A.univ_code,
               'elected_name', A.elected_name,
               'elected_year', A.ver_no,
               'project_name', A.project_name,
               'project_money', 0
           )
                                    AS detail,
       ''                              subject_code,
       0                               rel_code,
       0                               agg_from,
       202208                          _eversions_,
       202208                          _r_ver_no,
       NOW()                           create_time,
       -2                              created_by,
       NOW()                           updated_at,
       NULL                            updated_by,
       NULL                            deleted_at,
       NULL                            deleted_by
FROM ub_details_raw.`base_data_2022.06` A
         JOIN var_rel_source B ON A.var_code = B.var_code
WHERE 1;

# 国家级和省级一流本科专业更新（替换202208版本上的相关数据）

# 省级一流本科专业
# 删除202208版本相关变量数据
DELETE
FROM var_detail
WHERE _eversions_ = 202208
  AND var_code = 'pccourse'
  AND detail ->> '$.remark1' RLIKE '一流本科专业';

SET @m_code = 111111;
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                                                                          revision,
       215                                                                        var_id,
       var_code,
       5                                                                          source_id,
       ver_no,
       univ_code,
       0                                                                          lev,
       1                                                                          val,
       JSON_OBJECT(
               'remark1', CONCAT(province, '一流本科专业'),
               'remark2', rel_code,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', NULL,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0)                                             AS
                                                                                  detail,
       IFNULL(remark, '')                                                         subject_code,
       IF(rel_code = '专业代码暂缺', CONCAT('PC', @m_code := @m_code + 1), rel_code) AS rel_code,
       0                                                                          agg_from,
       202208                                                                     _eversions_,
       202208                                                                     _r_ver_no,
       create_time,
       -2                                                                         created_by,
       create_time                                                                updated_at,
       NULL                                                                       updated_by,
       NULL                                                                       deleted_at,
       NULL                                                                       deleted_by
FROM ub_details_raw.first_major_data_20220722
WHERE var_code = 'pccourse';

# 国家级一流本科专业
# 删除202208版本相关变量数据
DELETE
FROM var_detail
WHERE _eversions_ = 202208
  AND var_code = 'ben1';

INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                                                                          revision,
       8                                                                          var_id,
       var_code,
       4                                                                          source_id,
       ver_no,
       univ_code,
       0                                                                          lev,
       1                                                                          val,
       JSON_OBJECT(
               'remark1', NULL,
               'remark2', rel_code,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', NULL,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'project_name', project_name,
               'project_money', 0)                                             AS
                                                                                  detail,
       IFNULL(remark, '')                                                         subject_code,
       IF(rel_code = '专业代码暂缺', CONCAT('BE', @m_code := @m_code + 1), rel_code) AS rel_code,
       0                                                                          agg_from,
       202208                                                                     _eversions_,
       202208                                                                     _r_ver_no,
       create_time,
       -2                                                                         created_by,
       create_time                                                                updated_at,
       NULL                                                                       updated_by,
       NULL                                                                       deleted_at,
       NULL                                                                       deleted_by
FROM ub_details_raw.first_major_data_20220722
WHERE var_code = 'ben1';


# 模范先进教师数据新增
# 基础数据入库（略）
# 更新基础数据字段univ_code
UPDATE ub_details_raw.`cate050881_data_20220722` A
SET univ_code = (
    SELECT B.code
    FROM univ_ranking_dev.univ_cn B
    WHERE A.institution_code = B._code_old
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;

UPDATE ub_details_raw.`cate050881_data_20220722` A
SET A.univ_code = (SELECT B.code
                   FROM univ_ranking_dev.univ_cn_academy B
                   WHERE A.institution_code = B._code_old
                   ORDER BY B.outdated = 0 DESC,
                            B.outdated DESC
                   LIMIT 1)
WHERE univ_code IS NULL;

UPDATE ub_details_raw.`cate050881_data_20220722` A
SET A.univ_code = (SELECT B.code
                   FROM univ_ranking_dev.univ_cn_academy B
                   WHERE A.institution_name = B.name_cn
                   ORDER BY B.outdated = 0 DESC,
                            B.outdated DESC
                   LIMIT 1)
WHERE univ_code IS NULL;

# 数据入360变量明细库（新增）
-- SELECT * FROM var_detail WHERE var_code IN ('oto7','add1053','add1048','r83') AND _eversions_ = 202208 GROUP BY  var_code;

INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0                               revision,
       B.var_id,
       A.var_code,
       B.source_id,
       A.ver_no,
       IFNULL(A.univ_code, 'XXXXX') AS univ_code,
       0                               lev,
       1                               val,
       JSON_OBJECT(
               'remark1', team_name,
               'remark2', NULL,
               'born_year', NULL,
               'dead_year', NULL,
               'effective', '1',
               'award_level', NULL,
               'talent_name', A.talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', A.univ_code,
               'elected_name', A.institution_name,
               'elected_year', A.ver_no,
               'project_name', NULL,
               'project_money', 0
           )
                                    AS detail,
       A.subject_code,
       A.talent_code                   rel_code,
       0                               agg_from,
       202208                          _eversions_,
       202208                          _r_ver_no,
       NOW()                           create_time,
       -2                              created_by,
       NOW()                           updated_at,
       NULL                            updated_by,
       NULL                            deleted_at,
       NULL                            deleted_by
FROM ub_details_raw.`cate050881_data_20220722` A
         JOIN var_rel_source B ON A.var_code = B.var_code
WHERE 1;























