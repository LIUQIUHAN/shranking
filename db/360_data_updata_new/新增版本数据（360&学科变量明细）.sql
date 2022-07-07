# 新增360变量明细（新版本）
USE ub_details_0429;
-- 将202206版本的数据复制一份作为202207版本数据
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
       202207 AS _eversions_,
       202207 AS _r_ver_no,
       created_at,
       -2     AS created_by, -- -2 为刘勇新增或更新过
       updated_at,
       updated_by,
       deleted_at,
       deleted_by
FROM var_detail
WHERE _eversions_ = 202206;


USE spm_details_0208;
-- 将将202207版本的数据复制一份作为202208版本数据
INSERT INTO var_detail (/*dtl_id,*/ revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                    subj_code,
                                    talent_code, agg_from, _eversions_, created_at, created_by, updated_at, updated_by,
                                    deleted_at,
                                    deleted_by)
SELECT /*dtl_id,*/ revision,
                   var_id,
                   var_code,
                   source_id,
                   ver_no,
                   univ_code,
                   lev,
                   val,
                   detail,
                   subj_code,
                   talent_code,
                   agg_from,
                   202208 AS _eversions_,
                   created_at,
                   -2     AS created_by, -- -2 为刘勇新增或更新过
                   updated_at,
                   updated_by,
                   deleted_at,
                   deleted_by
FROM var_detail
WHERE _eversions_ = 202207

