USE univ_ranking_dev;

# 1.1 导入武书连排名数据
INSERT INTO rr_qjp_rank (yr, univ_id, univ_code, province_code, score, ranking, rank_province)
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw._univ_rankings_cn
WHERE rank_code = 'wsl'
  AND yr = 2022;

# 1.2 检查到univ 表中缺少学校记录
WITH d AS (SELECT r.id,
                  r.univ_code,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_wsl_rank r
           WHERE r.yr = 2022)
SELECT *
FROM d
WHERE d.univ_id IS NULL;

# 1.3 在univ表添加缺少的记录


# 1.4 更新武书连的univ_id、province_code
USE univ_ranking_dev;

WITH d AS (SELECT r.id,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_wsl_rank r
           WHERE r.yr = 2022)
UPDATE rr_wsl_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id,
    r.province_code=d.province_code
WHERE TRUE;


# 2.1 导入邱均平排名数据

INSERT INTO rr_qjp_rank (yr, univ_id, univ_code, province_code, score, ranking, rank_province)
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw._univ_rankings_cn
WHERE rank_code = 'qjp'
  AND yr = 2022;

# 2.2 检查到univ 表中缺少学校记录
WITH d AS (SELECT r.id,
                  r.univ_code,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_qjp_rank r
           WHERE r.yr = 2022)
SELECT *
FROM d
WHERE d.univ_id IS NULL;

# 2.3 在univ表添加缺少的记录


# 2.4 更新邱均平univ_id、province_code
WITH d AS (SELECT r.id,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_qjp_rank r
           WHERE r.yr = 2022)
UPDATE rr_qjp_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id,
    r.province_code=d.province_code
WHERE TRUE;


# 3.1 导入校友会排名数据
INSERT INTO rr_qjp_rank (yr, univ_id, univ_code, province_code, score, ranking, rank_province)
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw._univ_rankings_cn
WHERE rank_code = 'xyh'
  AND yr = 2022;

# 3.2 检查到univ 表中缺少学校记录
WITH d AS (SELECT r.id,
                  r.univ_code,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_xyh_rank r
           WHERE r.yr = 2022)
SELECT *
FROM d
WHERE d.univ_id IS NULL;

# 3.3 在univ表添加缺少的记录
SELECT *
FROM univ
WHERE name_cn = '安徽艺术学院';
SELECT *
FROM univ_cn
WHERE _code_old = 'A0815';
INSERT INTO univ(/*id,*/ code, name_cn, name_en, /*logo,*/ up, country_id,/* region, found_year, address, website, intro, programs, key_stats,*/
                         outdated, remark/*, updated_at*/)
SELECT 'RC01552',
       '安徽艺术学院',
       'Anhui University of Arts',
       func_calc_univ_up('Anhui University of Arts', 'anhuiyishuxueyuan'),
       103,
       -20220525,
       '2022.05.15处理校友会排名数据时添加';

# 3.4 更新univ_id
WITH d AS (SELECT r.id,
                  r.univ_code,
                  (SELECT u.id
                   FROM univ u
                   WHERE u.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) univ_id,
                  (SELECT uc.province_code
                   FROM univ_cn uc
                   WHERE uc.code = r.univ_code
                   ORDER BY outdated = 0 DESC, outdated DESC
                   LIMIT 1) province_code
           FROM rr_xyh_rank r
           WHERE r.yr = 2022)
UPDATE rr_xyh_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id,
    r.province_code=d.province_code
WHERE TRUE;



/*# 补充更新分数
USE univ_ranking_dev;

-- 武书连中国大学排名
UPDATE rr_wsl_rank A JOIN ub_details_raw.rr_wsl_rank B ON A.univ_code = B.univ_code
SET A.score = B.score
WHERE A.yr = 2022;

UPDATE rr_xyh_rank A JOIN ub_details_raw.rr_xyh_rank B ON A.univ_code = B.univ_code
SET A.score = B.score
WHERE A.yr = 2022;*/


# 国际大学排名
INSERT INTO univ(/*id,*/ code, name_cn, name_en, /*logo,*/ up, country_id,/* region, found_year, address, website, intro, programs, key_stats,*/
                         outdated, remark/*, updated_at*/)
SELECT 'RI03579',
       '印度国立技术学院',
       'National Institute of Technology Silchar',
       func_calc_univ_up('National Institute of Technology Silchar', 'yinduguolijishuxueyuan'),
       87,
       0,
       '2022.06.07处理THE亚洲大学排名数据时添加';


# 更新学校univ_id:
UPDATE ub_details_raw._univ_rankings_int A
SET A.univ_id = (
    SELECT B.id
    FROM univ_ranking_dev.univ B
    WHERE A.univ_code = B.`code`
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;


UPDATE ub_details_raw._univ_rankings_cn A
SET A.univ_id = (
    SELECT B.id
    FROM univ_ranking_dev.univ B
    WHERE A.univ_code = B.`code`
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;


# THE亚洲大学排名
INSERT INTO rr_the_aur_rank (/*id, */yr, univ_id, univ_code, score, ranking, rank_country, score_precise,
                                     ranking_precise, rank_country_precise, is_copy)
SELECT /*id, */yr,
               univ_id,
               univ_code,
               score,
               ranking,
               rank_region         rank_country,
               score_precise       score_precise,
               ranking_precise,
               rank_region_precise rank_country_precise,
               0                   is_copy
FROM ub_details_raw._univ_rankings_int
WHERE rank_code = 'RK021'
  AND yr = 2022;

# THE亚洲大学指标得分排名
INSERT INTO rr_the_aur_ind_rank (/*id, */yr, ind_id, univ_id, univ_code, score, ranking)
WITH ind_rank AS (
    SELECT /*id, */
        yr,
        78                                                                       ind_id,
        univ_id,
        univ_code,
        remark1 ->> '$."引用"'                                                  AS score,
        (RANK() OVER (PARTITION BY '' ORDER BY (remark1 ->> '$."引用"') DESC )) AS ranking
    FROM ub_details_raw._univ_rankings_int
    WHERE rank_code = 'RK021'
      AND yr = 2022
    UNION ALL
    SELECT /*id, */
        yr,
        79                                                                         ind_id,
        univ_id,
        univ_code,
        remark1 ->> '$."企业收入"'                                                  AS score,
        (RANK() OVER (PARTITION BY '' ORDER BY (remark1 ->> '$."企业收入"') DESC )) AS ranking
    FROM ub_details_raw._univ_rankings_int
    WHERE rank_code = 'RK021'
      AND yr = 2022
    UNION ALL
    SELECT /*id, */
        yr,
        80                                                                        ind_id,
        univ_id,
        univ_code,
        remark1 ->> '$."国际化"'                                                  AS score,
        (RANK() OVER (PARTITION BY '' ORDER BY (remark1 ->> '$."国际化"') DESC )) AS ranking
    FROM ub_details_raw._univ_rankings_int
    WHERE rank_code = 'RK021'
      AND yr = 2022
    UNION ALL
    SELECT /*id, */
        yr,
        81                                                                       ind_id,
        univ_id,
        univ_code,
        remark1 ->> '$."科研"'                                                  AS score,
        (RANK() OVER (PARTITION BY '' ORDER BY (remark1 ->> '$."科研"') DESC )) AS ranking
    FROM ub_details_raw._univ_rankings_int
    WHERE rank_code = 'RK021'
      AND yr = 2022
    UNION ALL
    SELECT /*id, */
        yr,
        82                                                                       ind_id,
        univ_id,
        univ_code,
        remark1 ->> '$."教学"'                                                  AS score,
        (RANK() OVER (PARTITION BY '' ORDER BY (remark1 ->> '$."教学"') DESC )) AS ranking
    FROM ub_details_raw._univ_rankings_int
    WHERE rank_code = 'RK021'
      AND yr = 2022
)
SELECT *
FROM ind_rank;


INSERT INTO univ(/*id,*/ code, name_cn, name_en, /*logo,*/ up, country_id,/* region, found_year, address, website, intro, programs, key_stats,*/
                         outdated, remark/*, updated_at*/)
SELECT 'RC01558',
       '南京工业职业技术大学',
       'Nanjing Vocational University of Industry Technology',
       func_calc_univ_up('Nanjing Vocational University of Industry Technology', 'nanjinggongyezhiyejishudaxue'),
       3201,
       0,
       '2022.06.09处理广州日报大学排名数据时添加';

WITH A AS (SELECT yr,
                  univ_code,
                  score,
                  province_code,
                  RANK() OVER (PARTITION BY province_code ORDER BY score DESC ) rank_province
           FROM ub_details_raw._univ_rankings_cn
           WHERE rank_code = 'RK026'
             AND yr = 2022)
UPDATE ub_details_raw._univ_rankings_cn B JOIN A ON A.univ_code = B.univ_code
SET B.rank_province = A.rank_province
WHERE B.rank_code = 'RK026'
  AND B.yr = 2022;

# 广州日报大学排名
INSERT INTO rr_gzdur_rank (/* id, */yr, type_id, univ_cn_id, univ_code, score, ranking, rank_province, remark)
SELECT /*id, */
    yr,
    (CASE
         WHEN remark3 = '主榜' THEN 65
         WHEN remark3 = '平行榜-医药类' THEN 66
         WHEN remark3 = '平行榜-财经类' THEN 67
         WHEN remark3 = '平行榜-政法类' THEN 68
         WHEN remark3 = '平行榜-语言类' THEN 69
         WHEN remark3 = '平行榜-民族类' THEN 70
         WHEN remark3 = '平行榜-体育类' THEN 71
         WHEN remark3 = '平行榜-合作办学类' THEN 72
        END
        ) type_id,
    univ_id,
    univ_code,
    score,
    ranking,
    rank_province,
    remark2
FROM ub_details_raw._univ_rankings_cn
WHERE rank_code = 'RK026'
  AND yr = 2022;


# QS世界大学排名：rr_qs_wur_indicator、rr_qs_wur_rank、rr_qs_wur_ind_rank
-- 新360平台排名监测：
-- rr_qs_wur_indicator 已完成

-- 添加univ表中缺少的学校
INSERT INTO univ(id, code, name_cn, name_en, /*logo,*/ up, country_id,/* region, found_year, address, website, intro, programs, key_stats,*/
                 outdated, remark/*, updated_at*/)
WITH ranking AS (
    SELECT (SELECT B.id
            FROM univ_ranking_dev.univ B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)                   AS                              univ_id,
           univ_code,
           univ_name_cn,
           univ_name_en,
           func_calc_univ_up(univ_name_en, univ_name_en)               up,
           (SELECT id FROM gi_country C WHERE C.name_cn = A.region_cn) country_id,
           0                           AS                              outdated,
           '2022.06.13处理QS世界大学排名数据时添加' AS                              remark
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A)
SELECT *
FROM ranking
WHERE univ_id IS NULL;


-- rr_qs_wur_rank
INSERT INTO rr_qs_wur_rank (/*id, */yr, univ_id, univ_code, score, ranking, rank_country, score_precise,
                                    ranking_precise, rank_country_precise)
WITH ranking AS (
    SELECT /*id, */yr,
                   (SELECT B.id
                    FROM univ_ranking_dev.univ B
                    WHERE A.univ_code = B.code
                    ORDER BY B.outdated = 0 DESC,
                             B.outdated DESC
                    LIMIT 1)                    AS univ_id,
                   univ_code,
                   IF(score = '-', NULL, score) AS score,
                   ranking,
                   rank_region                  AS rank_country,
                   score_precise,
                   ranking_precise,
                   rank_region_precise          AS rank_country_precise
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A)
SELECT *
FROM ranking
WHERE 1;


-- rr_qs_wur_ind_rank
INSERT INTO rr_qs_wur_ind_rank (/*id, */yr, ind_id, univ_id, univ_code, score, ranking)
WITH score AS (
    SELECT /*id, */
        yr,
        49                       AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                AS univ_id,
        univ_code,
        academic_reputation      AS score,
        academic_reputation_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        50                       AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                AS univ_id,
        univ_code,
        employer_reputation      AS score,
        employer_reputation_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        51                         AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                  AS univ_id,
        univ_code,
        faculty_student_ratio      AS score,
        faculty_student_ratio_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        52                         AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                  AS univ_id,
        univ_code,
        citations_per_faculty      AS score,
        citations_per_faculty_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        53                               AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                        AS univ_id,
        univ_code,
        international_faculty_ratio      AS score,
        international_faculty_ratio_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        54                                AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                         AS univ_id,
        univ_code,
        international_students_ratio      AS score,
        international_students_ratio_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        55                                  AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                           AS univ_id,
        univ_code,
        international_research_network      AS score,
        international_research_network_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
    UNION ALL

    SELECT /*id, */
        yr,
        56                       AS ind_id,
        (SELECT B.id
         FROM univ_ranking_dev.univ B
         WHERE A.univ_code = B.code
         ORDER BY B.outdated = 0 DESC,
                  B.outdated DESC
         LIMIT 1)                AS univ_id,
        univ_code,
        employment_outcomes      AS score,
        employment_outcomes_rank AS ranking
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A
)
SELECT *
FROM score;


-- 更新QS世界大学历史版本指标名称:rr_qs_wur_indicator
SELECT *
FROM rr_qs_wur_indicator
WHERE name_cn = '师均被引次数';
UPDATE rr_qs_wur_indicator
SET name_cn = '单位教员论文引文数'
WHERE name_cn = '师均被引次数';

-- 版本表信息更新：dataset_version
SELECT *
FROM dataset_version
WHERE name_cn = 'QS世界大学排名';


-- 老360平台QS世界大学排名数据：
WITH QS_360 AS (
    SELECT yr                  rank_year,
           issue_time,
           '全球排名'              rank_type,
           'F002'              rank_id,
           univ_code           rank_school_code,
           (SELECT B._code_old
            FROM univ_ranking_dev.univ_cn B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)           school_code,
           ranking             issue_rank_val,
           ranking_precise     rank_val,
           rank_region         cn_issue_rank_val,
           rank_region_precise cn_rank_val
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A)
SELECT *
FROM QS_360
WHERE school_code IS NOT NULL;


WITH qs_ind_360 AS (
    SELECT yr           rank_year,
           '2022-06-09' issue_time,
           'F002'       rank_id,
           (SELECT B._code_old
            FROM univ_ranking_dev.univ_cn B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)    school_code,
           (SELECT B.name_cn
            FROM univ_ranking_dev.univ_cn B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)    school_name,
           (CASE
                WHEN ind_id = 49 THEN '学术声誉'
                WHEN ind_id = 50 THEN '雇主声誉'
                WHEN ind_id = 51 THEN '师生比'
                WHEN ind_id = 52 THEN '师均被引次数'
                WHEN ind_id = 53 THEN '国际教师比例'
                WHEN ind_id = 54 THEN '国际学生比例'
                WHEN ind_id = 55 THEN '国际研究网络'
                WHEN ind_id = 56 THEN '就业成果'
               END
               )        evaluate_name,
           score        evaluate_score
    FROM rr_qs_wur_ind_rank A
    WHERE yr = 2023)
SELECT *
FROM qs_ind_360
WHERE school_code IS NOT NULL;


# 更新高校状态指标数据库国际对比页面
WITH data_detail_rank_list_world AS (
    SELECT /*id, */yr           real_year,
                   yr           data_year,
                   univ_code    institutionCode,
                   univ_name_cn institutionName,
                   region_cn    country,
                   2            indicatorCode,
                   ranking      indicatorValue
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A)
SELECT *
FROM data_detail_rank_list_world;


WITH gxztzbdb_qs_ind_360 AS (
    SELECT yr        real_year,
           yr        data_year,
           '2'       indicatorCode,
           univ_code institutionCode,
           (CASE
                WHEN ind_id = 49 THEN '学术声誉'
                WHEN ind_id = 50 THEN '雇主声誉'
                WHEN ind_id = 51 THEN '师生比'
                WHEN ind_id = 52 THEN '师均被引次数'
                WHEN ind_id = 53 THEN '国际教师比例'
                WHEN ind_id = 54 THEN '国际学生比例'
                WHEN ind_id = 55 THEN '国际研究网络'
                WHEN ind_id = 56 THEN '就业成果'
               END
               )     indicatorSubName,
           score     indicatorValue
    FROM rr_qs_wur_ind_rank A
    WHERE yr = 2023)
SELECT *
FROM gxztzbdb_qs_ind_360;

-- 指标查看页面：
WITH QS_360 AS (
    SELECT yr                                             data_year,
           issue_time,
           '全球排名'                                         rank_type,
           'F002'                                         target_code,
           univ_code                                      rank_school_code,
           (SELECT B._code_old
            FROM univ_ranking_dev.univ_cn B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)                                      institutionCode,
           ranking                                        issue_rank_val,
           ranking_precise                                rank_val,
           rank_region                                    cn_issue_rank_val,
           rank_region_precise                            cn_rank_val,
           'F002'                                         is_top,
           IF((ranking_precise + 0) <= 500, 'F002', NULL) is_top500,
           IF((ranking_precise + 0) <= 200, 'F002', NULL) is_top200,
           IF((ranking_precise + 0) <= 100, 'F002', NULL) is_top100
    FROM ub_details_raw.qs_world_univ_ranking_20220609 A)
SELECT *
FROM QS_360
WHERE institutionCode IS NOT NULL;



# 广州日报学科排名-360排名监测
# rr_gzdsr_rank
INSERT INTO rr_gzdsr_rank (/*id, */yr, subj_code, univ_id, univ_code, ranking, is_copy)
SELECT /*id, */
    yr,
    subject_code AS subj_code,
    (SELECT B.id
     FROM univ_ranking_dev.univ B
     WHERE A.univ_code = B.code
     ORDER BY B.outdated = 0 DESC,
              B.outdated DESC
     LIMIT 1)    AS univ_id,
    univ_code,
    ranking,
    0            AS is_copy
FROM ub_details_raw.gdi_cn_subject_ranking_20220622 A
WHERE yr = 2022
ORDER BY subject_code, (ranking + 0);


# rr_gzdsr_stats
/*WITH gzdsr_stats AS (
    SELECT yr,
           (SELECT B.id
            FROM univ_ranking_dev.univ B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)     AS univ_id,
           univ_code,
           'num_on_list' AS top,
           COUNT(*)      AS num,
           0             AS is_copy,
           ranking
    FROM ub_details_raw.gdi_cn_subject_ranking_20220622 A
    GROUP BY univ_code
    UNION ALL
    SELECT yr,
           (SELECT B.id
            FROM univ_ranking_dev.univ B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)  AS univ_id,
           univ_code,
           'num_top5' AS top,
           COUNT(*)   AS num,
           0          AS is_copy,
           ranking
    FROM ub_details_raw.gdi_cn_subject_ranking_20220622 A
    WHERE (ranking + 0) <= 5
    GROUP BY univ_code
    UNION ALL
    SELECT yr,
           (SELECT B.id
            FROM univ_ranking_dev.univ B
            WHERE A.univ_code = B.code
            ORDER BY B.outdated = 0 DESC,
                     B.outdated DESC
            LIMIT 1)   AS univ_id,
           univ_code,
           'num_top25' AS top,
           COUNT(*)    AS num,
           0           AS is_copy,
           ranking
    FROM ub_details_raw.gdi_cn_subject_ranking_20220622 A
    WHERE (ranking + 0) <= 25
    GROUP BY univ_code)
SELECT yr,
       univ_id,
       univ_code,
       MAX(CASE WHEN top = 'num_on_list' THEN num ELSE 0 END) AS num_on_list,
       MAX(CASE WHEN top = 'num_top5' THEN num ELSE 0 END)    AS num_top5,
       MAX(CASE WHEN top = 'num_top25' THEN num ELSE 0 END)   AS num_top25,
       is_copy
FROM gzdsr_stats
GROUP BY univ_code
;*/
INSERT INTO rr_gzdsr_stats (yr, univ_id, univ_code, num_on_list, num_top5, num_top25, is_copy)
WITH base AS (
    SELECT yr,
           univ_code,
           CASE WHEN (ranking + 0) < 10000 THEN 1 ELSE NULL END AS 'top_all',
           CASE WHEN (ranking + 0) <= 25 THEN 1 ELSE NULL END   AS 'top_25',
           CASE WHEN (ranking + 0) <= 5 THEN 1 ELSE NULL END    AS 'top_5'
    FROM ub_details_raw.gdi_cn_subject_ranking_20220622
    WHERE yr = 2022
)
SELECT yr,
       (SELECT B.id
        FROM univ_ranking_dev.univ B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC,
                 B.outdated DESC
        LIMIT 1) AS   univ_id,
       univ_code,
       COUNT(top_all) num_on_list,
       COUNT(top_5)   num_top5,
       COUNT(top_25)  num_top25,
       0              is_copy
FROM base A
GROUP BY univ_code;








# GRAS世界一流学科排名：
# 1.基础数据入库（略）；
# 2.更新基础数据表中univ_id：
UPDATE univ_ranking_raw.raw_gras_sr_details_20220704 A
SET A.univ_id = (SELECT B.id
                 FROM univ_ranking_dev.univ B
                 WHERE A.univ_code = B.code
                 ORDER BY B.outdated = 0 DESC,
                          B.outdated DESC
                 LIMIT 1)
WHERE yr = 2022;

UPDATE univ_ranking_raw.raw_gras_sr_stats_20220704 A
SET A.univ_id = (SELECT B.id
                 FROM univ_ranking_dev.univ B
                 WHERE A.univ_code = B.code
                 ORDER BY B.outdated = 0 DESC,
                          B.outdated DESC
                 LIMIT 1)
WHERE yr = 2022;

# 检查是否需要补充univ数据：
SELECT *
FROM univ_ranking_raw.raw_gras_sr_details_20220704
WHERE univ_id IS NULL
GROUP BY univ_code; -- 需要
SELECT *
FROM univ_ranking_raw.raw_gras_sr_stats_20220704
WHERE univ_id IS NULL
GROUP BY univ_code; -- 无

INSERT INTO univ (id, code, name_cn, name_en, up, country_id,
                  outdated, remark)
SELECT NULL                                                                   id,
       univ_code                                                              code,
       univ_name_cn                                                           name_cn,
       univ_name_en                                                           name_en,
       func_calc_univ_up(univ_name_en, univ_name_en)                          up,
       (SELECT id FROM gi_country C WHERE C.name_cn = A.country_or_region_cn) country_id,
       0                                                                      outdated,
       '2022.06.28处理gras世界一流学科排名时添加' AS                                       remark
FROM univ_ranking_raw.raw_gras_sr_details_20220704 A
WHERE univ_id IS NULL;


# 1.指标信息（略）
# 2.学科信息：gras_subject
DELETE FROM gras_subject WHERE yr = 2022;

INSERT INTO gras_subject (id, yr, category_code, code, name_cn, name_en, weights, num_univ_pub)
SELECT NULL                                                                                     id,
       yr,
       (SELECT category_code FROM gras_subject B WHERE A.subject_code = B.code AND B.yr = 2021) category_code,
       subject_code                                                                             code,
       subject_name_cn                                                                          name_cn,
       subject_name_en                                                                          name_en,
       NULL                                                                                     weights,
       COUNT(*)                                                                                 num_univ_pub
FROM univ_ranking_raw.raw_gras_sr_details_20220704 A
GROUP BY subject_code, yr;

# 3.统计值数据：gras_stats
DELETE FROM gras_stats WHERE yr = 2022;

INSERT INTO gras_stats (/*id, */yr, univ_id, univ_code, ranking, rank_country, num_on_list, pct_on_list, num_top10,
                                num_top50, num_top100, num_top200, num_top500, ord_num_top)
WITH TOP AS (
    SELECT yr,
           univ_code,
           CASE WHEN type_n = '前10' THEN 1 ELSE NULL END  AS 'num_top_10',
           CASE WHEN type_n = '前50' THEN 1 ELSE NULL END  AS 'num_top_50',
           CASE WHEN type_n = '前100' THEN 1 ELSE NULL END AS 'num_top_100',
           CASE WHEN type_n = '前200' THEN 1 ELSE NULL END AS 'num_top_200',
           CASE WHEN type_n = '前500' THEN 1 ELSE NULL END AS 'num_top_500'
    FROM univ_ranking_raw.raw_gras_sr_details_20220704 A)
   , TOP_NUM AS (
    SELECT yr,
           univ_code,
           COUNT(num_top_10)                                            AS num_top_10,
           (COUNT(num_top_50) + COUNT(num_top_10))                      AS num_top_50,
           (COUNT(num_top_100) + COUNT(num_top_50) + COUNT(num_top_10)) AS num_top_100,
           (COUNT(num_top_200) + COUNT(num_top_100) + COUNT(num_top_50) +
            COUNT(num_top_10))                                          AS num_top_200,
           (COUNT(num_top_500) + COUNT(num_top_200) + COUNT(num_top_100) + COUNT(num_top_50) +
            COUNT(num_top_10))                                          AS num_top_500
    FROM TOP
    GROUP BY univ_code, yr)
SELECT A.yr,
       A.univ_id,
       A.univ_code,
       A.rank_world,
       A.rank_region,
       A.on_list_all,
       A.proportion,
       B.num_top_10,
       B.num_top_50,
       B.num_top_100,
       B.num_top_200,
       B.num_top_500,
       RANK() OVER (ORDER BY B.num_top_10 DESC, B.num_top_50 DESC, B.num_top_100 DESC, B.num_top_200 DESC, B.num_top_500 DESC,
           (SELECT CONVERT(name_cn USING gbk)
            FROM univ_cn uc
            WHERE NOT outdated
              AND uc.code = B.univ_code)) AS ord_no
FROM univ_ranking_raw.raw_gras_sr_stats_20220704 A
         JOIN TOP_NUM B USING (yr, univ_code)
WHERE A.yr = 2022
;

# 4.学科排名数据：gras_rank
DELETE FROM gras_rank WHERE yr = 2022;

INSERT INTO gras_rank (yr, subj_code, univ_id, univ_code, score, ranking, ranking___precise, rank_country,
                       rank_country___precise, rank_top_n, order_priority)
SELECT yr,
       subject_code                              AS subj_code,
       univ_id,
       univ_code,
       IF(score_issued = '', NULL, score_issued) AS score,
       rank_issued                               AS ranking,
       rank_precise                              AS ranking___precise,
       rank_region_issued                        AS rank_country,
       rank_region_percise                       AS rank_country___precise,
       SUBSTRING_INDEX(type_n, '前', -1)          AS rank_top_n,
       SUBSTRING_INDEX(rank_issued, '-', -1)     AS order_priority
FROM univ_ranking_raw.raw_gras_sr_details_20220704
WHERE yr = 2022;

# 5.指标信息：gras_indicator（略）
# 6.指标排名数据
DELETE FROM gras_ind_score WHERE yr = 2022;

INSERT INTO gras_ind_score (/*id, */yr, subj_code, ind_id, univ_id, univ_code, score)
WITH IND_SCORE AS (
    SELECT yr,
           subject_code                        AS subj_code,
           26                                  AS ind_id,
           univ_id,
           univ_code,
           IF(Q1_Score = 'NA', NULL, Q1_Score) AS score
    FROM univ_ranking_raw.raw_gras_sr_details_20220704
    WHERE yr = 2022
    UNION ALL
    SELECT yr,
           subject_code                            AS subj_code,
           27                                      AS ind_id,
           univ_id,
           univ_code,
           IF(CNCI_Score = 'NA', NULL, CNCI_Score) AS score
    FROM univ_ranking_raw.raw_gras_sr_details_20220704
    WHERE yr = 2022
    UNION ALL
    SELECT yr,
           subject_code                        AS subj_code,
           28                                  AS ind_id,
           univ_id,
           univ_code,
           IF(IC_Score = 'NA', NULL, IC_Score) AS score
    FROM univ_ranking_raw.raw_gras_sr_details_20220704
    WHERE yr = 2022
    UNION ALL
    SELECT yr,
           subject_code                          AS subj_code,
           29                                    AS ind_id,
           univ_id,
           univ_code,
           IF(Top_Score = 'NA', NULL, Top_Score) AS score
    FROM univ_ranking_raw.raw_gras_sr_details_20220704
    WHERE yr = 2022
    UNION ALL
    SELECT yr,
           subject_code                              AS subj_code,
           30                                        AS ind_id,
           univ_id,
           univ_code,
           IF(Award_Score = 'NA', NULL, Award_Score) AS score
    FROM univ_ranking_raw.raw_gras_sr_details_20220704
    WHERE yr = 2022)
SELECT *
FROM IND_SCORE;

# 7.dataset_subj_level、dataset_type、dataset_version
# 8.rk_dataset_univ_report、dataset_univ_report
DELETE FROM rk_dataset_univ_report WHERE ver_no = 2022;

INSERT INTO rk_dataset_univ_report (dataset_id, ver_no, univ_id, univ_code, univ_cn_id, file_dir, file_size, file_hash,
                                    report_status, uploaded_at, updated_at, updated_by, copy_from)
SELECT 2                dataset_id,
       yr               ver_no,
       univ_id,
       univ_code,
       (SELECT B.id
        FROM univ_ranking_dev.univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC,
                 B.outdated DESC
        LIMIT 1)        univ_cn_id,
       '_RK/GRAS/2022/' file_dir,
       NULL             file_size,
       NULL             file_hash,
       0                report_status,
       NULL             uploaded_at,
       NULL             updated_at,
       NULL             updated_by,
       NULL             copy_from
FROM univ_ranking_raw.raw_gras_sr_stats_20220704 A
WHERE yr = 2022;

DELETE FROM dataset_univ_report WHERE ver_no = 2022;

INSERT INTO dataset_univ_report (dataset_id, ver_no, univ_id, univ_code, univ_cn_id, file_dir, file_size, file_hash,
                                 report_status, uploaded_at, updated_at, updated_by, copy_from)
SELECT 2            dataset_id,
       yr           ver_no,
       univ_id,
       univ_code,
       (SELECT B.id
        FROM univ_ranking_dev.univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC,
                 B.outdated DESC
        LIMIT 1)    univ_cn_id,
       'GRAS/2022/' file_dir,
       NULL         file_size,
       NULL         file_hash,
       0            report_status,
       NULL         uploaded_at,
       NULL         updated_at,
       NULL         updated_by,
       NULL         copy_from
FROM univ_ranking_raw.raw_gras_sr_stats_20220704 A
WHERE yr = 2022;








# 360平台-排名监测页面-国际大学排名需新增自然指数（Nature Index）排名和Scimago世界大学排名
# 自然指数（Nature Index）排名
USE univ_ranking_dev;
# 指标表
CREATE TABLE rr_nature_index_wur_indicator
(
    id      int AUTO_INCREMENT PRIMARY KEY COMMENT 'id',
    yr      int           NOT NULL COMMENT '年份',
    name_cn varchar(20)   NOT NULL COMMENT '指标名称(中文)',
    name_en varchar(50)   NOT NULL COMMENT '指标名称(英文)',
    weight  decimal(4, 3) NULL COMMENT '权重',
    ord_no  int           NOT NULL COMMENT '排序',
    CONSTRAINT ind_yn UNIQUE (yr, name_en)
)
    COMMENT '自然指数（Nature Index）排名-指标';

# 指标数据表
CREATE TABLE rr_nature_index_wur_ind_rank
(
    id        int AUTO_INCREMENT PRIMARY KEY COMMENT 'id',
    yr        int           NOT NULL COMMENT '年份',
    ind_id    int           NOT NULL COMMENT '指标id',
    univ_id   int           NOT NULL COMMENT '院校id(univ.id)',
    univ_code varchar(20)   NOT NULL COMMENT '院校编码',
    score     decimal(8, 2) NULL COMMENT '得分',
    ranking   int           NULL COMMENT '排名',
    CONSTRAINT ind_rank_uri UNIQUE (univ_code, yr, ind_id)
)
    COMMENT '自然指数（Nature Index）排名-单指标排名';

# 排名数据表
CREATE TABLE rr_nature_index_wur_rank
(
    id                   int AUTO_INCREMENT PRIMARY KEY COMMENT 'id',
    yr                   int           NOT NULL COMMENT '年份',
    univ_id              int           NOT NULL COMMENT '院校id(univ.id)',
    univ_code            varchar(20)   NOT NULL COMMENT '院校编码',
    score                decimal(4, 1) NULL COMMENT '官方得分',
    ranking              varchar(10)   NOT NULL COMMENT '官方排名',
    rank_country         varchar(10)   NOT NULL COMMENT '官方地区排名',
    score_precise        decimal(4, 1) NULL COMMENT '精确得分',
    ranking_precise      int           NULL COMMENT '精确排名',
    rank_country_precise int           NULL COMMENT '精确地区排名',
    CONSTRAINT wur_rank_ur UNIQUE (univ_code, yr)
)
    COMMENT '自然指数（Nature Index）排名';

# 自然指数（Nature Index）排名基础数据入库（略）:univ_ranking_raw.raw_nature_index_wur_20220630
# 更新基础数据表中univ_id
UPDATE univ_ranking_raw.raw_nature_index_wur_20220630 A
SET A.univ_id = (SELECT B.id
                 FROM univ B
                 WHERE A.univ_code = B.code
                 ORDER BY B.outdated = 0 DESC, B.outdated DESC
                 LIMIT 1)
WHERE 1;

# 检测是否需要更新univ表
SELECT *
FROM univ_ranking_raw.raw_nature_index_wur_20220630
WHERE univ_id IS NULL; -- 需要

INSERT INTO univ (id, code, name_cn, name_en, up, country_id,
                  outdated, remark)
SELECT NULL                                                          AS id,
       univ_code                                                     AS code,
       univ_name_cn                                                  AS name_cn,
       univ_name_en                                                  AS name_en,
       func_calc_univ_up(univ_name_en, univ_name_en)                 AS up,
       (SELECT C.id FROM gi_country C WHERE C.name_cn = A.region_cn) AS country_id,
       0                                                             AS outdated,
       '2022.06.30处理nature_index大学排名时添加'                             AS remark
FROM univ_ranking_raw.raw_nature_index_wur_20220630 A
WHERE univ_id IS NULL;

# 排名数据入库：rr_nature_index_wur_rank
INSERT INTO rr_nature_index_wur_rank (yr, univ_id, univ_code, score, ranking, rank_country, score_precise,
                                      ranking_precise, rank_country_precise)
SELECT yr,
       univ_id,
       univ_code,
       NULL                score,
       rank_world          ranking,
       rank_region         rank_country,
       NULL                score_precise,
       rank_world_precise  ranking_precise,
       rank_region_precise rank_country_precise
FROM univ_ranking_raw.raw_nature_index_wur_20220630
WHERE 1;

# 指标入库：rr_nature_index_wur_indicator
INSERT INTO rr_nature_index_wur_indicator (yr, name_cn, name_en, ord_no)
WITH IND AS (SELECT '总论文数' AS name_cn, 'Count' AS name_en, 1 AS ord_no
             UNION ALL
             SELECT '论文分数' AS name_cn, 'Share' AS name_en, 2 AS ord_no),
     YR AS (SELECT yr FROM rr_nature_index_wur_rank GROUP BY yr)
SELECT B.yr, A.*
FROM IND A
         JOIN YR B
ORDER BY B.yr, A.ord_no;

# 指标数据值入库：rr_nature_index_wur_ind_rank
INSERT INTO rr_nature_index_wur_ind_rank (yr, ind_id, univ_id, univ_code, score)
WITH A AS (
    SELECT yr,
           univ_id,
           univ_code,
           count_yr score,
           'Count'  ind_name
    FROM univ_ranking_raw.raw_nature_index_wur_20220630 A
    UNION ALL
    SELECT yr,
           univ_id,
           univ_code,
           share_yr score,
           'Share'  ind_name
    FROM univ_ranking_raw.raw_nature_index_wur_20220630 A)
SELECT A.yr,
       (SELECT B.id FROM rr_nature_index_wur_indicator B WHERE A.yr = B.yr AND A.ind_name = B.name_en) ind_id,
       A.univ_id,
       A.univ_code,
       A.score
FROM A
ORDER BY yr, ind_id, univ_code;



# Scimago世界大学排名
# 排名表：rr_scimago_wur_rank
CREATE TABLE rr_scimago_wur_rank
(
    id                   int AUTO_INCREMENT PRIMARY KEY COMMENT 'id',
    yr                   int           NOT NULL COMMENT '年份',
    univ_id              int           NOT NULL COMMENT '院校id(univ.id)',
    univ_code            varchar(20)   NOT NULL COMMENT '院校编码',
    score                decimal(4, 1) NULL COMMENT '官方得分',
    score_precise        decimal(4, 1) NULL COMMENT '精确得分',
    ranking              varchar(10)   NOT NULL COMMENT '官方排名',
    rank_country         varchar(10)   NOT NULL COMMENT '官方地区排名',
    ranking_precise      int           NULL COMMENT '精确排名',
    rank_country_precise int           NULL COMMENT '精确地区排名',
    CONSTRAINT wur_rank_ur UNIQUE (univ_code, yr)
)
    COMMENT 'Scimago世界大学排名';

# 排名数据入库
# 历史年份没有地区排名，需与产品确认：已与产品兰涛确认2009-2021使用国际对标的数据，缺失的数据等排名团队补充后再更新
# 历史年份数据入库(2009-2022)
INSERT INTO rr_scimago_wur_rank (yr, univ_id, univ_code, score, score_precise, ranking, rank_country, ranking_precise,
                                 rank_country_precise)
SELECT ver_no                        AS yr,
       (SELECT B.id
        FROM univ B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)                     AS univ_id,
       univ_code,
       NULL                             score,
       NULL                             score_precise,
       detail ->> '$.indicatorValue' AS ranking,
       NULL                             rank_country,
       detail ->> '$.indicatorValue' AS ranking_precise,
       NULL                             rank_country_precise
FROM ub_details_0429.intl_var_detail A
WHERE var_code = '9'
  AND EXISTS(SELECT * FROM univ C WHERE A.univ_code = C.code)
ORDER BY ver_no, univ_code;

# 更新2022排名数据的地区排名（只有2022的数据排名团队才给了地区排名）
UPDATE rr_scimago_wur_rank A
SET A.ranking_precise      = (SELECT B.ranking_precise
                              FROM ub_details_raw.scimago_world_univ_ranking_20220630 B
                              WHERE A.univ_code = B.univ_code
                                AND A.yr = B.yr),
    A.rank_country         = (SELECT B.rank_country
                              FROM ub_details_raw.scimago_world_univ_ranking_20220630 B
                              WHERE A.univ_code = B.univ_code
                                AND A.yr = B.yr),
    A.rank_country_precise = (SELECT B.rank_country_precise
                              FROM ub_details_raw.scimago_world_univ_ranking_20220630 B
                              WHERE A.univ_code = B.univ_code
                                AND A.yr = B.yr)
WHERE A.yr = 2022;


# 国际对标页面后续需更新的两个排名数据
SELECT *
FROM ub_details_0429.intl_var_detail
WHERE var_code = '7'; -- 国际对标-自然指数排名

SELECT *
FROM ub_details_0429.intl_var_detail
WHERE var_code = '9'
GROUP BY ver_no;
-- 国际对标-Scimago世界大学排名

# 更新国际对比页面自然指数排名
SELECT *
FROM ub_details_0429.intl_var_detail
WHERE var_code = '7';

INSERT INTO ub_details_0429.intl_var_detail (revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail,
                                             rel_code, agg_from, _eversions_, _r_ver_no, created_at, created_by,
                                             updated_at, updated_by, deleted_at, deleted_by)
SELECT 0     revision,
       222   var_id,
       7     var_code,
       1     source_id,
       yr    ver_no,
       univ_code,
       0     lev,
       0     val,
       JSON_OBJECT(
               'issue_time', issue_time,
               'statistica_period', statistica_period,
               'rank_world', rank_world,
               'rank_world_precise', rank_world_precise,
               'rank_region', rank_region,
               'rank_region_precise', rank_region_precise,
               'share_previous_yr', share_previous_yr,
               'share_yr', share_yr,
               'count_yr', count_yr,
               'change_in_adjusted_chare', change_in_adjusted_chare,
               'source_name',source_name
           ) detail,
       ''    rel_code,
       0     agg_from,
       ''    _eversions_,
       0     _r_ver_no,
       NOW() created_at,
       0     created_by,
       NOW() updated_at,
       NULL  updated_by,
       NULL  deleted_at,
       NULL  deleted_by
FROM univ_ranking_raw.raw_nature_index_wur_20220630
ORDER BY yr, univ_code;






USE univ_ranking_dev;
# 原始数据入库：raw_cwts_wur_20220707
# 更新raw_cwts_wur_20220707.univ_id
UPDATE univ_ranking_raw.raw_cwts_wur_20220707 A
SET A.univ_id = (SELECT B.id
                 FROM univ B
                 WHERE A.univ_code = B.code
                 ORDER BY B.outdated = 0 DESC, B.outdated DESC
                 LIMIT 1)
WHERE 1;

# 检测是否需要新增高校信息
SELECT * FROM univ_ranking_raw.raw_cwts_wur_20220707 WHERE univ_id IS NULL; -- 不需要

# 新建CWTS数据表（略）：rr_cwts_ld_ind_rank、rr_cwts_ld_indicator、rr_cwts_ld_rank
# CWTS指标入库（略）
# CWTS排名数据入库
INSERT INTO rr_cwts_rank (yr, univ_id, univ_code, score, ranking, rank_country, score_precise, ranking_precise,
                             rank_country_precise)
SELECT yr,
       univ_id,
       univ_code,
       NULL score,
       ranking,
       rank_country,
       NULL score_precise,
       ranking_precise,
       rank_country_precise
FROM univ_ranking_raw.raw_cwts_wur_20220707
WHERE 1;

# CWTS指标数据值入库
INSERT INTO rr_cwts_ind_rank (yr, ind_id, univ_id, univ_code, score, ranking)
SELECT yr,
       (CASE
            WHEN yr = 2018 THEN 16
            WHEN yr = 2019 THEN 19
            WHEN yr = 2020 THEN 22
            WHEN yr = 2021 THEN 25
            WHEN yr = 2022 THEN 28
           END
           )    AS ind_id,
       univ_id,
       univ_code,
       impact_p AS score,
       NULL ranking
FROM univ_ranking_raw.raw_cwts_wur_20220707
WHERE 1;

INSERT INTO rr_cwts_ind_rank (yr, ind_id, univ_id, univ_code, score, ranking)
SELECT yr,
       (CASE
            WHEN yr = 2018 THEN 17
            WHEN yr = 2019 THEN 20
            WHEN yr = 2020 THEN 23
            WHEN yr = 2021 THEN 26
            WHEN yr = 2022 THEN 29
           END
           )    AS ind_id,
       univ_id,
       univ_code,
       p_top10 AS score,
       NULL ranking
FROM univ_ranking_raw.raw_cwts_wur_20220707
WHERE 1;

INSERT INTO rr_cwts_ind_rank (yr, ind_id, univ_id, univ_code, score, ranking)
SELECT yr,
       (CASE
            WHEN yr = 2018 THEN 18
            WHEN yr = 2019 THEN 21
            WHEN yr = 2020 THEN 24
            WHEN yr = 2021 THEN 27
            WHEN yr = 2022 THEN 30
           END
           )    AS ind_id,
       univ_id,
       univ_code,
       pp_top10 AS score,
       NULL ranking
FROM univ_ranking_raw.raw_cwts_wur_20220707
WHERE 1;

# 页面显示使用字符串
UPDATE rr_cwts_ind_rank SET score_1 = ROUND(score,0) WHERE ind_id IN (SELECT id FROM rr_cwts_indicator WHERE name_cn RLIKE '数');
UPDATE rr_cwts_ind_rank SET score_1 = CONCAT(ROUND((score * 100),1),'%') WHERE ind_id IN (SELECT id FROM rr_cwts_indicator WHERE name_cn RLIKE '比例');






























