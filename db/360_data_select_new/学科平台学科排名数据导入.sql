# 教育部学科评估入学科平台变量明细库
USE ub_details_raw;

# 更新univ_code
/*UPDATE moe_subject_rank A
SET A.univ_code = (
    SELECT B.`code`
    FROM univ_ranking_dev.univ_cn B
    WHERE A.school_code = B._code_old
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;*/

# 检查univ_code
-- SELECT * FROM `doc_master_established_year` where univ_code is null;


INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, talent_name, agg_from, _eversions_, created_at,
                                         created_by, updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL         dtl_id,
       0            revision,
       (CASE
            WHEN var_code = 'moe1' THEN 173
            WHEN var_code = 'moe2' THEN 174
            WHEN var_code = 'moe3' THEN 175
            WHEN var_code = 'moe4' THEN 176
           END)     var_id,
       var_code,
       0            source_id,
       2021         ver_no,
       univ_code,
       0            lev,
       0            val,
       JSON_OBJECT(
               'subject_code', subject_code,
               'data_year', data_year,
               'subject_rank', subject_rank,
               'subject_level', subject_level,
               'rank_section', rank_section,
               'subject_score', subject_score
           )        detail,
       subject_code subj_code,
       ''           talent_code,
       NULL         talent_name,
       0            agg_from,
       202208       _eversions_,
       NOW()        created_at,
       -1           created_by,
       NOW()        updated_at,
       NULL         updated_by,
       NULL         deleted_at,
       NULL         deleted_by
FROM moe_subject_rank
WHERE univ_code IS NOT NULL;


# 硕士点、博士点获批年份入库学科变量明细库

# 更新univ_code
/*UPDATE doc_master_established_year A
SET A.univ_code = (
    SELECT B.`code`
    FROM univ_ranking_dev.univ_cn B
    WHERE A.school_code = B._code_old
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;*/

# 检查univ_code
-- SELECT * FROM `doc_master_established_year` where univ_code is null;

INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, talent_name, agg_from, _eversions_, created_at,
                                         created_by, updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL         dtl_id,
       0            revision,
       (CASE
            WHEN var_code = 'doctby' THEN 120
            WHEN var_code = 'masterby' THEN 172
           END)     var_id,
       var_code,
       0            source_id,
       ver_no,
       univ_code,
       0            lev,
       0            val,
       JSON_OBJECT(
               'established_year', established_year,
               'batch', batch
           )        detail,
       subject_code subj_code,
       ''           talent_code,
       NULL         talent_name,
       0            agg_from,
       202208       _eversions_,
       NOW()        created_at,
       -1           created_by,
       NOW()        updated_at,
       NULL         updated_by,
       NULL         deleted_at,
       NULL         deleted_by
FROM doc_master_established_year
WHERE univ_code IS NOT NULL;


# ESI等机构学科排名入学科平台变量明细库

# 更新其他机构学科排名数据中的univ_code信息
/*UPDATE other_subject_rank A
SET A.univ_code = (
    SELECT B.`code`
    FROM univ_ranking_dev.univ_cn B
    WHERE A.institution_code = B._code_old
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;*/

-- SELECT * FROM `other_subject_rank` where univ_code is null;

INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, talent_name, agg_from, _eversions_, created_at,
                                         created_by, updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL                     dtl_id,
       0                        revision,
       (CASE
            WHEN var_code = 'esisubrank' THEN 125
            WHEN var_code = 'thesubrank' THEN 275
            WHEN var_code = 'qssubrank' THEN 231
            WHEN var_code = 'usnewssub' THEN 277
           END)                 var_id,
       var_code,
       0                        source_id,
       ver_no,
       univ_code,
       0                        lev,
       0                        val,
       JSON_OBJECT(
               'elected_year', elected_year,
               'issue_time', issue_time,
               'institution_name', institution_name,
               'ranking_subject_name', ranking_subject_name,
               'ranking', ranking,
               'enter_subject_no', enter_subject_no,
               'is_one_thounds', IF(is_one_thounds != '0', '1', '0'),
               'is_one_million', IF(is_one_million != '0', '1', '0'),
               'data_year', data_year
           )                    detail,
       IFNULL(subject_code, '') subj_code,
       ''                       talent_code,
       NULL                     talent_name,
       0                        agg_from,
       202208                   _eversions_,
       NOW()                    created_at,
       -1                       created_by,
       NOW()                    updated_at,
       NULL                     updated_by,
       NULL                     deleted_at,
       NULL                     deleted_by
FROM other_subject_rank
WHERE univ_code IS NOT NULL;


# GRAS入学科平台变量明细库

INSERT INTO spm_details_0208.var_detail (dtl_id, revision, var_id, var_code, source_id, ver_no, univ_code, lev, val,
                                         detail, subj_code, talent_code, talent_name, agg_from, _eversions_, created_at,
                                         created_by, updated_at, updated_by, deleted_at, deleted_by)
SELECT NULL   AS                   dtl_id,
       0      AS                   revision,
       250    AS                   var_id,
       var_code,
       0      AS                   source_id,
       ver_no,
       univ_code,
       lev,
       val,
       detail,
       (SELECT B.subject_code
        FROM other_rank_subject_mapping B
        WHERE A.detail ->> '$.first_level_subject_name' = B.other_rank_subject_name
          AND B.var_code = 'gras') subj_code,
       ''                          talent_code,
       NULL                        talent_name,
       0      AS                   agg_from,
       202208 AS                   _eversions_,
       NOW()  AS                   created_at,
       -1     AS                   created_by,
       NOW()  AS                   updated_at,
       NULL   AS                   updated_by,
       NULL   AS                   deleted_at,
       NULL   AS                   deleted_by
FROM ub_details_0429.var_detail A
WHERE var_code = 'gras'
  AND _eversions_ = 202208;


