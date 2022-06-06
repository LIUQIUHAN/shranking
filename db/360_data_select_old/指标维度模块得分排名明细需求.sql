#

SELECT ranking_year 排名版本, school_code 学校代码, school_name 学校名称, '综合类大学排名' 类型排名, ranking_val 排名
FROM rank_tbl_school_ranking
WHERE ranking_year = '202202'
  AND type_code = '0001'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');


SELECT B.school_code     学校代码,
       B.target_code     指标代码,
       A.target_name     指标名称,
       B.target_val      指标数据值,
       B.target_rank     全国排名,
       B.type_score_rank 类型排名,
       B.data_year       监测年份,
       B.original_year   数据年份
FROM `rank_tbl_module_info_no_edition`               A
     LEFT JOIN temporary_rank_tbl_school_target_info B ON A.target_code = B.target_code AND A.default_year = B.data_year
WHERE B.school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578')
ORDER BY B.school_code, A.id;

SELECT edition_year 排名版本, school_code 学校代码, target_type 维度, score 得分, score_rank 全国排名, type_score_rank 类型排名
FROM rank_tbl_module_dimension_score_info
WHERE edition_year = '202202'
  AND type_code = '0001'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');



SELECT edition_year 排名版本, school_code 学校代码, module_id 模块, score 得分, score_rank 全国排名, type_score_rank 类型排名
FROM rank_tbl_module_score_info
WHERE edition_year = '202202'
  AND type_code = '0001'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');

SELECT school_code  学校代码,
       school_name  学校名称,
       subject_code 学科代码,
       subject_name 学科名称,
       `master`     硕士点,
       doctor       博士点,
       full_doctor  一级博士点,
       data_year    数据年份
FROM rank_tbl_school_bulid_subject
WHERE data_year = '2020'
  AND edition_year = '202202'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');

SELECT school_code             学校代码,
       school_name             学校名称,
       degree_level            本科专业、硕士点、博士点门类,
       subject_categories      门类,
       distribution_proportion 占比,
       remark1                 门类数,
       remark2                 本科专业、学位点数
FROM rank_tbl_school_subject_layout
WHERE edition_year = '202202'
  AND data_year = '2020'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');


SELECT '第四轮学科评估'    指标,
       issue_time   发布时间,
       school_code  学校代码,
       school_name  学校名称,
       subject_code 学科代码,
       subject_name 学科名称,
       performance  评估结果,
       part_number  参评对象数,
       remark1      排名
FROM rank_tbl_school_four_selection
WHERE edition_year = '202202'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');


SELECT '软科最好学科排名'   指标,
       issue_time   发布时间,
       school_code  学校代码,
       school_name  学校名称,
       subject_code 学科代码,
       subject_name 学科名称,
       ranks        排名,
       rank_number  参排对象数据,
       remark1      排名段位
FROM rank_tbl_school_subject_rank
WHERE edition_year = '202202'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');


SELECT 'ESI上榜学科'        指标,
       issue_time       发布时间,
       school_code      学校代码,
       school_name      学校名称,
       ESI_subject_name 学科名称,
       ranking          排名,
       enter_subject_no 参排对象数据,
       is_one_thounds   是否千分之一,
       is_one_million   是否万分之一
FROM rank_tbl_school_esi_info
WHERE edition_year = '202202'
  AND school_code IN
      ('A0003', 'A0311', 'A0238', 'A0557', 'A0491', 'A0558', 'A0268', 'A0006', 'A0267', 'A0593', 'A0578');