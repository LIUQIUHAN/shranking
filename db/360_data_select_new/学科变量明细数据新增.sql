# 省级认证本科专业原始数据入库（略）
# 更新省份字段
USE ub_details_raw;
UPDATE province_first_major_data_20220708 A JOIN univ_cn B ON A.univ_code = B.code JOIN gi_province C ON C.code = B.province_code
SET A.province = C.name
WHERE province IS NULL;

UPDATE province_first_major_data_20220708 A JOIN univ_cn_academy B ON A.univ_code = B.code JOIN gi_province C ON C.code = B.province_code
SET A.province = C.name
WHERE province IS NULL;

UPDATE province_first_major_data_20220708 A JOIN univ_cn_academy B ON A.univ_name = B.name_cn JOIN gi_province C ON C.code = B.province_code
SET A.province = C.name
WHERE province IS NULL;

SELECT * FROM province_first_major_data_20220708 WHERE province IS NULL; -- 无法匹配到省份的数据为高职院校，叶鹏告知可无需匹配

# 入学科平台明细库
INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, agg_from, _eversions_, created_at, created_by,
                                         updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL                       dtl_id,
       0                          revision,
       319                        var_id,
       'pccourse'                 var_code,
       5                          source_id,
       ver_no,
       univ_code,
       1                          lev,
       0                          val,
       JSON_OBJECT(
               'remark1', CONCAT(province, var_name),
               'project_name', major_name,
               'remark2', major_code,
               'elected_code', univ_code,
               'elected_name', univ_name,
               'elected_year', ver_no,
               'effective', '1'
           )                      detail,
       IFNULL(subject_code_1, '') subj_code,
       ''                         talent_code,
       0                          agg_from,
       202207                     _eversions_,
       NOW()                      created_at,
       -2                         created_by,
       NOW()                      updated_at,
       NULL                       updated_by,
       NULL                       deleted_at,
       NULL                       deleted_by
FROM province_first_major_data_20220708;



# 省级教学成果奖补充更新（本次徐涵了给全样本数据，告知需替换之前的所有数据）
SELECT * FROM spm_details_0208.var_detail where _eversions_ = 202208 AND var_code = 'ptaward2';

INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, agg_from, _eversions_, created_at, created_by,
                                         updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL                       dtl_id,
       0                          revision,
       230                        var_id,
       'ptaward2'                 var_code,
       5                          source_id,
       yr                         ver_no,
       univ_code,
       (CASE
            WHEN level = '特等奖' THEN 1
            WHEN level = '特等奖培育项目' THEN 2
            WHEN level = '一等奖' THEN 3
            WHEN level = '二等奖' THEN 4
            WHEN level = '三等奖' THEN 5
            WHEN level = '优秀奖' THEN 6
           END
           )                      lev,
       0                          val,
       JSON_OBJECT(
               'remark1', province,
               'remark2', CONCAT(var_name, level),
               'born_year', NULL,
               'dead_year', NULL,
               'effective', 1,
               'award_level', level,
               'talent_name', talent_name,
               'current_code', NULL,
               'current_name', NULL,
               'elected_code', univ_code,
               'elected_name', elected_name,
               'elected_year', yr,
               'project_name', project_name,
               'subject_code', subject_code_1,
               'project_money', NULL,
               'effective_last', '',
               'current_code_last', '',
               'current_name_last', NULL,
               'subject_code_last', ''
           )                      detail,
       IFNULL(subject_code_1, '') subj_code,
       ''                         talent_code,
       0                          agg_from,
       202208                     _eversions_,
       NOW()                      created_at,
       -2                         created_by,
       NOW()                      updated_at,
       NULL                       updated_by,
       NULL                       deleted_at,
       NULL                       deleted_by
FROM ub_details_raw.pro_teaching_achievement_award_20220708;














