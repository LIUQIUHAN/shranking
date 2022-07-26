# 360平台指标信息更新
USE ub_details_raw;
# 更新中间过程表中ind_code,var_code
/*UPDATE `360_ind_20220726` a JOIN ub_ranking_dev.indicator_latest b ON a.ind_name = b.name AND b.level = 3
SET a.ind_code = b.code
WHERE a.ind_code IS NULL;

UPDATE `360_var_20220726` a JOIN ub_ranking_dev.indicator_latest b ON a.var_name = b.name AND b.level = 4
SET a.var_code = b.code
WHERE a.var_code IS NULL;


UPDATE `sub_ind_20220726` a JOIN spm_ranking_dev.indicator_latest b ON a.ind_name = b.name AND b.level = 3 AND r_root_id = 1
SET a.ind_code = b.code
WHERE a.ind_code IS NULL;

UPDATE `sub_var_20220726` a JOIN spm_ranking_dev.indicator_latest b ON a.var_name = b.name AND b.level = 4 AND r_root_id = 1
SET a.var_code = b.code
WHERE a.var_code IS NULL;

UPDATE `sub_ind_20220726` a JOIN spm_ranking_dev.indicator b ON a.ind_name = b.name AND b.level = 3 AND b.r_root_id = 1 AND b.r_ver_no = 202208
SET a.ind_code = b.code
WHERE a.page = '学科水平';

UPDATE `sub_var_20220726` a JOIN spm_ranking_dev.indicator b ON a.var_name = b.name AND b.level = 4 AND b.r_root_id = 1 AND b.r_ver_no = 202208
SET a.var_code = b.code
WHERE a.var_code IS NULL;*/


UPDATE ub_ranking_dev.indicator_latest a JOIN 360_ind_20220726 b ON a.code = b.ind_code AND a.level = 3
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer)),
    a.change_type = 1
WHERE a.level = 3;

UPDATE ub_ranking_dev.indicator_latest a JOIN 360_var_20220726 b ON a.code = b.var_code AND a.level = 4
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 4;


UPDATE ub_ranking_dev.indicator a JOIN 360_ind_20220726 b ON a.code = b.ind_code AND a.level = 3 AND a.r_ver_no = 202208
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer)),
    a.change_type = 1
WHERE a.level = 3
  AND a.r_ver_no = 202208;

UPDATE ub_ranking_dev.indicator a JOIN 360_var_20220726 b ON a.code = b.var_code AND a.level = 4 AND a.r_ver_no = 202208
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 4
  AND a.r_ver_no = 202208;





# 学科平台指标信息更新
UPDATE spm_ranking_dev.indicator_latest a JOIN sub_ind_20220726 b ON a.code = b.ind_code AND a.level = 3
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 3;

UPDATE spm_ranking_dev.indicator_latest a JOIN sub_ind_20220726 b ON a.code = b.ind_code AND a.level = 4
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 4;


UPDATE spm_ranking_dev.indicator a JOIN sub_ind_20220726 b ON a.code = b.ind_code AND a.level = 3 AND a.r_ver_no = 202208
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 3
  AND a.r_ver_no = 202208
  AND a.r_root_id = 1;

UPDATE spm_ranking_dev.indicator a JOIN sub_var_20220726 b ON a.code = b.var_code AND a.level = 4 AND a.r_ver_no = 202208
SET a.detail = JSON_SET(a.detail, '$.availVer', CONCAT(b.availVer), '$.targetVer', CONCAT(b.targetVer))
WHERE a.level = 4
  AND a.r_ver_no = 202208
  AND a.r_root_id = 1;




















