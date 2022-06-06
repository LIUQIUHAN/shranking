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



































