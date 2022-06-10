# 新增360变量明细（新版本）
USE ub_details_0429;

INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subject_code, rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                    updated_at, updated_by, deleted_at, deleted_by)
SELECT revision,
       var_id,
       var_code,
       source_id,
       ver_no,
       univ_code,
       lev,
       val,
       detail,
       subject_code,
       rel_code,
       agg_from,
       202207 _eversions_,
       202207 _r_ver_no,
       created_at,
       -2 created_by,
       updated_at,
       updated_by,
       deleted_at,
       deleted_by
FROM var_detail
WHERE _eversions_ = 202206;

# 省级一流本科课程变量数据：排名团队告知需删除历史所有数据，使用本次给到的最新的数据
-- DELETE FROM var_detail WHERE var_code = 'pacourse' AND _eversions_ = 202207;

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
FROM ub_details_raw.provincial_first_class_data
WHERE 1;


