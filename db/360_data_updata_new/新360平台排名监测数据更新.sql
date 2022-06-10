USE univ_ranking_dev;
# 1.1 导入武书连排名数据
INSERT INTO rr_qjp_rank ( yr, univ_id, univ_code, province_code, score, ranking, rank_province )
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw.univ_rankings_cn
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
                   LIMIT 1)province_code
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
                   LIMIT 1)province_code
           FROM rr_wsl_rank r
           WHERE r.yr = 2022)
UPDATE rr_wsl_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id,r.province_code=d.province_code
WHERE TRUE;








# 2.1 导入邱均平排名数据

INSERT INTO rr_qjp_rank ( yr, univ_id, univ_code, province_code, score, ranking, rank_province )
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw.univ_rankings_cn
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
                   LIMIT 1)province_code
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
                   LIMIT 1)province_code
           FROM rr_qjp_rank r
           WHERE r.yr = 2022)
UPDATE rr_qjp_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id ,r.province_code=d.province_code
WHERE TRUE;











# 3.1 导入校友会排名数据
INSERT INTO rr_qjp_rank ( yr, univ_id, univ_code, province_code, score, ranking, rank_province )
SELECT yr, 0 univ_id, univ_code, 0 province_code, score, ranking, rank_province
FROM ub_details_raw.univ_rankings_cn
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
                   LIMIT 1)province_code
           FROM rr_xyh_rank r
           WHERE r.yr = 2022)
SELECT *
FROM d
WHERE d.univ_id IS NULL;

# 3.3 在univ表添加缺少的记录
SELECT * FROM univ WHERE name_cn = '安徽艺术学院';
SELECT * FROM univ_cn WHERE _code_old = 'A0815';
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
                   LIMIT 1)province_code
           FROM rr_xyh_rank r
           WHERE r.yr = 2022)
UPDATE rr_xyh_rank r JOIN d ON r.id = d.id
SET r.univ_id=d.univ_id,r.province_code=d.province_code
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
UPDATE ub_details_raw.univ_rankings_int A
SET A.univ_id = (
    SELECT B.id
    FROM univ_ranking_dev.univ B
    WHERE A.univ_code = B.`code`
    ORDER BY B.outdated = 0 DESC,
             B.outdated DESC
    LIMIT 1
)
WHERE 1;


UPDATE ub_details_raw.univ_rankings_cn A
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
FROM ub_details_raw.univ_rankings_int
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
    FROM ub_details_raw.univ_rankings_int
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
    FROM ub_details_raw.univ_rankings_int
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
    FROM ub_details_raw.univ_rankings_int
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
    FROM ub_details_raw.univ_rankings_int
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
    FROM ub_details_raw.univ_rankings_int
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
           FROM ub_details_raw.univ_rankings_cn
           WHERE rank_code = 'RK026'
             AND yr = 2022)
UPDATE ub_details_raw.univ_rankings_cn B JOIN A ON A.univ_code = B.univ_code
SET B.rank_province = A.rank_province
           WHERE B.rank_code = 'RK026'
             AND B.yr = 2022;

# 广州日报大学排名
INSERT INTO rr_gzdur_rank (/* id, */yr, type_id, univ_cn_id, univ_code, score, ranking, rank_province,remark)
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
FROM ub_details_raw.univ_rankings_cn
WHERE rank_code = 'RK026'
  AND yr = 2022;
















