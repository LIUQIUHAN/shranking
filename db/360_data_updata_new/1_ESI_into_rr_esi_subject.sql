# ESI学科信息更新：

USE ub_details_raw;

SET @Ver_no = 202205; -- 更改需要更新的ESI发布版本

INSERT INTO univ_ranking_dev.rr_esi_subject ( ver_no, name_cn, name_en, num_institution, citation_threshold )
SELECT ver_no, name_cn, name_en, num_institution, citation_threshold
FROM esi_subject_data
WHERE ver_no = @Ver_no;

# ESI学科排名指标更新：

INSERT INTO univ_ranking_dev.rr_esi_indicator ( ver_no, code, name_cn, name_en, ord_no )
SELECT @Ver_no AS ver_no, code, name_cn, name_en, ord_no
FROM univ_ranking_dev.rr_esi_indicator
WHERE ver_no = (@Ver_no - 2);

INSERT INTO univ_ranking_dev.dataset_subj_level ( dataset_id, ver_no, top_def, top_desc, first_class_def,
                                                  first_class_desc, include_ranking )
SELECT dataset_id, @Ver_no AS ver_no, top_def, top_desc, first_class_def, first_class_desc, include_ranking
FROM univ_ranking_dev.dataset_subj_level
WHERE dataset_id = 40
  AND ver_no = (@Ver_no - 2);