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
SELECT 0           revision,
       215         var_id,
       var_code,
       5           source_id,
       ver_no,
       univ_code,
       0           lev,
       1           val,
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
       ''          subject_code,
       IFNULL(rel_code,0)    rel_code,
       0           agg_from,
       202207      _eversions_,
       202207      _r_ver_no,
       create_time,
       -2          created_by,
       create_time updated_at,
       NULL        updated_by,
       NULL        deleted_at,
       NULL        deleted_by
FROM ub_details_raw.national_first_major_data_20220613
WHERE var_code = 'pccourse';

-- 国家级一流本科专业
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT 0           revision,
       8           var_id,
       var_code,
       4          source_id,
       ver_no,
       univ_code,
       0           lev,
       1           val,
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
       ''          subject_code,
       rel_code    rel_code,
       0           agg_from,
       202207      _eversions_,
       202207      _r_ver_no,
       create_time,
       -2          created_by,
       create_time updated_at,
       NULL        updated_by,
       NULL        deleted_at,
       NULL        deleted_by
FROM ub_details_raw.national_first_major_data_20220613
WHERE var_code = 'ben1';



# 2022年06月23日新增：五四青年奖
INSERT INTO var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
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
WHERE 1;


UPDATE ub_ranking_dev.indicator_latest SET detail = JSON_SET(detail,'$.availVer','2014-2021','$.targetVer','2017-2021')
WHERE  `name` rlike '中文期刊论文';

UPDATE ub_ranking_dev.indicator SET detail = JSON_SET(detail,'$.availVer','2014-2021','$.targetVer','2017-2021')
WHERE  `name` rlike '中文期刊论文' AND r_ver_no = 202207;



# 省级教学成果奖补充更新（本次徐涵了给全样本数据，告知需替换之前的所有数据）
USE ub_details_0429;
SELECT * FROM ub_details_0429.var_detail where _r_ver_no = 202208 AND var_code = 'ptaward';

INSERT INTO var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                        subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                        updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL              dtl_id,
       0                 revision,
       216               var_id,
       'ptaward'         var_code,
       5                 source_id,
       yr                ver_no,
       univ_code,
       (CASE
            WHEN level = '特等奖' THEN 1
            WHEN level = '特等奖培育项目' THEN 2
            WHEN level = '一等奖' THEN 3
            WHEN level = '二等奖' THEN 4
            WHEN level = '三等奖' THEN 5
            WHEN level = '优秀奖' THEN 6
           END
           )             lev,
       1                 val,
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
       IF(subject_code_1 = '\\','',subject_code_1) AS subject_code,
       ''                rel_code,
       0                 agg_from,
       202208            _eversions_,
       202208            _r_ver_no,
       NOW()             create_time,
       -2                created_by,
       NOW()             updated_at,
       NULL              updated_by,
       NULL              deleted_at,
       NULL              deleted_by
FROM ub_details_raw.pro_teaching_achievement_award_20220708
WHERE 1;




















