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
FROM ub_details_raw.provincial_awards_20220613 A
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
FROM ub_details_raw.`provincial_first_class_data_2019-2021`
WHERE 1;



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
               'pysaward',
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

