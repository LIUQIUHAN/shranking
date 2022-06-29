# GRAS-2021 新版排名数据
USE univ_ranking_dev;
# 1. 原始数据
CREATE TABLE univ_ranking_raw.raw_220628_gras_subject
(
    id               int         NOT NULL COMMENT '序号' PRIMARY KEY,
    yr               int         NOT NULL COMMENT '年份',
    category_code    varchar(4)  NOT NULL COMMENT '学科领域编码',
    category_name_cn varchar(20) NOT NULL COMMENT '学科领域名称(中文)',
    subj_code        varchar(10) NOT NULL COMMENT '学科编码',
    subj_name_cn     varchar(20) NOT NULL COMMENT '学科名称(中文)',
    subj_name_en     varchar(50) NOT NULL COMMENT '学科名称(英文)',
    num_univ_pub     varchar(20) NOT NULL COMMENT '发布高校数量',
    CONSTRAINT uk_raw_gras_subject_0622_2 UNIQUE (yr, subj_code)
);
/*
导入原始数据；0.36s
*/
CREATE TABLE univ_ranking_raw.raw_220628_gras_rank
(
    id                     int PRIMARY KEY COMMENT '序号',
    yr                     int           NOT NULL COMMENT '年份',
    subj_code              varchar(10)   NOT NULL COMMENT '学科代码',
    univ_code              varchar(20)   NOT NULL COMMENT '标准代码',
    univ_name_cn           varchar(50)   NOT NULL COMMENT '学校名称',
    univ_name_en           varchar(100)  NOT NULL COMMENT 'Institution',
    country_cn             varchar(50)   NOT NULL COMMENT '国家/地区',
    country_en             varchar(50)   NOT NULL COMMENT 'Country/Region',
    score                  decimal(4, 1) NULL COMMENT '总得分',
    ranking                varchar(10)   NOT NULL COMMENT '总排名-官方',
    ranking___precise      varchar(10)   NOT NULL COMMENT '总排名-精确',
    rank_country           varchar(10)   NOT NULL COMMENT '地区排名-官方',
    rank_country___precise varchar(10)   NOT NULL COMMENT '地区排名-精确',
    rank_top_n             varchar(10)   NOT NULL COMMENT '学科排名前N',
    _uw_id                 int           NULL COMMENT '补充：univ.id',
    _country_id            int           NULL COMMENT '补充：gi_country.id',
    UNIQUE uk_raw_gras_rank_0622_3 (yr, subj_code, univ_code)
);
/*
导入原始数据；9.01s
*/
CREATE TABLE univ_ranking_raw.raw_220628_gras_stats
(
    id             int PRIMARY KEY COMMENT '序号',
    yr             int            NOT NULL COMMENT '年份',
    uw_code        varchar(20)    NOT NULL COMMENT '学校编码',
    univ_name_cn   varchar(50)    NOT NULL COMMENT '学校名称(中文)',
    country_cn     varchar(50)    NOT NULL COMMENT '国家/地区',
    num_on_list    int            NOT NULL COMMENT '上榜学科总数',
    ranking        int            NOT NULL COMMENT '世界排名',
    rank_country   int            NOT NULL COMMENT '地区排名',
    pct_on_list    decimal(10, 9) NOT NULL COMMENT '上榜学科占排名学科总数的比例',
    num_top10      int            NULL COMMENT '前10名学科数',
    num_top11_50   int            NULL COMMENT '前50名学科数（11-50）',
    num_top51_100  int            NULL COMMENT '前100名学科数（51-100）',
    num_top101_200 int            NULL COMMENT '前200名学科数（101-200）',
    num_top201_500 int            NULL COMMENT '前500名学科数（201-500）',
    _uw_id         int            NULL COMMENT '补充：univ.id',
    _country_id    int            NULL COMMENT '补充：gi_country.id',
    UNIQUE uk_raw_gras_stats_2 (yr, uw_code)
);
/*
导入原始数据；0.52s
*/


# 2. 转移数据
# 2.1. 学科
SELECT *
FROM univ_ranking_raw.raw_220628_gras_subject
WHERE category_code NOT IN (SELECT code FROM gras_subject_category);
INSERT INTO gras_subject(id, yr, category_code, code, name_cn, name_en, weights, num_univ_pub)
SELECT NULL id, yr, category_code, subj_code, subj_name_cn, subj_name_en, NULL weights, num_univ_pub
FROM univ_ranking_raw.raw_220628_gras_subject;



# 2.2. 学科排名
# 2.2.1. 学校信息补充
UPDATE univ_ranking_raw.raw_220628_gras_rank rr
SET rr._country_id=(
    SELECT gc.id
    FROM gi_country gc
    WHERE gc.name_en = rr.country_en
    #  WHERE concat('China-', gc.name_en) = rr.country_en
)
WHERE rr._country_id IS NULL;


-- 补充 univ 记录
  INSERT INTO univ(/*id,*/ code, name_cn, name_en, logo, up, country_id
    /*, region, found_year, address, website, intro, programs, key_stats*/
                ,        outdated, remark/*, updated_at*/)
WITH um AS (
    SELECT DISTINCT rr.univ_code, rr.univ_name_cn, rr.univ_name_en, rr._country_id
    FROM univ_ranking_raw.raw_220628_gras_rank rr
    WHERE NOT EXISTS(
            SELECT *
            FROM univ u
            WHERE u.code = rr.univ_code
              AND u.name_cn = rr.univ_name_cn
              AND u.name_en = rr.univ_name_en
              AND u.country_id = rr._country_id
        ))
SELECT univ_code, univ_name_cn, univ_name_en, SUBSTR(SHA2(univ_code, 256), 50, 9) logo,
       func_calc_univ_up(univ_name_en, '') up, _country_id,
       0 outdated,'220628处理 GRAS-2021 数据时补充' remark
FROM um  ;
/*SELECT *
FROM univ WHERE exists(SELECT * from um WHERE um.univ_code=univ.code) ORDER BY code;*/
# 检查up码是否唯一
SELECT code, COUNT(DISTINCT up) ct
FROM univ
GROUP BY code
HAVING ct > 1;
# 补充新建记录的学校专业课程和关键统计信息

WITH uv AS (
    SELECT *
FROM univ WHERE outdated<0 and( key_stats is NOT  NULL or programs is not NULL or region is NOT  NULL
    or found_year is not NULL or address is not NULL or website is not NULL or intro is not NULL)
)
 /*, region, found_year, address, website, intro, programs, key_stats*/
/* UPDATE univ join uv on univ.code=uv.code set univ.key_stats=uv.key_stats,univ.programs=uv.programs,
                                              univ.region=uv.region,univ.found_year=uv.found_year,
                                              univ.address=uv.address,univ.website=uv.website,
                                              univ.intro=uv.intro
WHERE not univ.outdated;*/
SELECT *
FROM uv;



# 2.2.2. 更新 原始数据表的 _uw_id
UPDATE univ_ranking_raw.raw_220628_gras_rank rr
SET rr._uw_id=(SELECT u.id
               FROM univ u
               WHERE u.code = rr.univ_code
                 AND u.name_cn = rr.univ_name_cn
                 AND u.name_en = rr.univ_name_en
                 AND u.country_id = rr._country_id)
WHERE rr._uw_id IS NULL;
SELECT *
FROM univ_ranking_raw.raw_220628_gras_rank rr WHERE rr._uw_id is NULL;

# 2.2.3. 数据转移
-- 中国内地高校的3个数据特征
SELECT DISTINCT univ_code
FROM univ_ranking_raw.raw_220628_gras_rank rr
WHERE univ_code LIKE 'RC%'
  AND EXISTS(SELECT * FROM univ_cn uc WHERE uc.code = rr.univ_code)
  AND country_cn = '中国';
-- 转移
INSERT INTO gras_rank(/*id,*/ yr, subj_code, univ_id, univ_code, score, ranking, ranking___precise, rank_country,
                              rank_country___precise, rank_top_n, order_priority)
SELECT yr, subj_code, _uw_id, univ_code, score, ranking,
       IF(univ_code LIKE 'RC%', ranking___precise, NULL) rp,       -- 这次给的只有中国内地高校的精确排名值
       rank_country,                                               -- 这次新给的字段
       IF(univ_code LIKE 'RC%', rank_country___precise, NULL) rcp, -- 这次给的只有中国内地高校的精确排名值
       SUBSTRING_INDEX(rank_top_n, '前', -1) rank_top_n,
       SUBSTRING_INDEX(ranking, '-', -1) order_priority
FROM univ_ranking_raw.raw_220628_gras_rank rr;

-- 检查中国高校是否插入有遗漏
WITH base AS (
    SELECT DISTINCT univ_code
FROM univ_ranking_raw.raw_220628_gras_rank rr
WHERE univ_code LIKE 'RC%'
  AND EXISTS(SELECT * FROM univ_cn uc WHERE uc.code = rr.univ_code)
  AND country_cn = '中国'
)
SELECT *
FROM base WHERE !exists(SELECT *
FROM gras_rank r WHERE r.yr=2022 and base.univ_code=r.univ_code and r.ranking___precise is not NULL );




# 2.3. gras_stats
# 2.3.1. 为原始数据表补充字段：_uw_id/_country_id
UPDATE univ_ranking_raw.raw_220628_gras_stats rs
SET _uw_id=(SELECT DISTINCT r.univ_id
            FROM gras_rank r
            WHERE r.yr = rs.yr
              AND r.univ_code = rs.uw_code)
WHERE _uw_id IS NULL;
UPDATE univ_ranking_raw.raw_220628_gras_stats rs
SET _country_id=(SELECT uw.country_id
                 FROM univ uw
                 WHERE uw.id = rs._uw_id)
WHERE _country_id IS NULL;
SELECT *
FROM univ_ranking_raw.raw_220628_gras_stats rs
WHERE _uw_id IS NULL
   OR _country_id IS NULL;

# 2.3.2. 转入数据
# DELETE FROM gras_stats WHERE yr = 2020;
# ALTER TABLE gras_stats    AUTO_INCREMENT 0;
# INSERT INTO gras_stats(/*id,*/ yr, univ_id, univ_code, ranking, rank_country, num_on_list, pct_on_list, num_top10,
#                                num_top50, num_top100, num_top200, num_top500, ord_num_top)
SELECT yr, _uw_id, uw_code, ranking, rank_country, num_on_list, pct_on_list,
       (IFNULL(num_top10, 0)) num_top10,
       (IFNULL(num_top10, 0) + IFNULL(num_top11_50, 0)) num_top50,
       (IFNULL(num_top10, 0) + IFNULL(num_top11_50, 0) +
        IFNULL(num_top51_100, 0)) num_top100,
       (IFNULL(num_top10, 0) + IFNULL(num_top11_50, 0) + IFNULL(num_top51_100, 0) +
        IFNULL(num_top101_200, 0)) num_top200,
       (IFNULL(num_top10, 0) + IFNULL(num_top11_50, 0) + IFNULL(num_top51_100, 0) + IFNULL(num_top101_200, 0) +
        IFNULL(num_top201_500, 0)) num_top500,
       RANK()
               OVER (ORDER BY num_top10 DESC, num_top11_50 DESC, num_top51_100 DESC, num_top101_200 DESC, num_top201_500 DESC, (SELECT CONVERT(name_cn USING gbk)
                                                                                                                                FROM univ_cn uc
                                                                                                                                WHERE NOT outdated
                                                                                                                                  AND uc.code = rs.uw_code)) ord_no
FROM univ_ranking_raw.raw_220628_gras_stats rs
WHERE _country_id = 103
ORDER BY ranking;


# 3. 排名版本记录
SELECT *
FROM dataset_type WHERE id=2;
SELECT *
FROM dataset_version WHERE dataset_id=2 ORDER BY version;
SELECT t.name_cn, t.name_en, t.name_id, v.dataset_id, CONCAT(t.name_id, '/', v.ver_no, '/') file_dir
FROM dataset_type t
         LEFT JOIN dataset_version v ON v.dataset_id = t.id
WHERE t.name_id = 'GRAS'
ORDER BY v.version;
/*
2,GRAS/2017/
2,GRAS/2018/
2,GRAS/2019/
2,GRAS/2020/
*/

# 4. 报告文件记录
INSERT INTO dataset_univ_report(/*id,*/ dataset_id, ver_no, univ_id, univ_code, univ_cn_id, file_dir/*, file_size, file_hash, report_status, uploaded_at, updated_at, updated_by, copy_from*/)
SELECT 2 dataset_id, 2022 ver_no, univ_id, univ_code,
       (SELECT uc.id FROM univ_cn uc WHERE not uc.outdated  AND uc.code = st.univ_code) uc_id, 'GRAS/2022/' file_dir
FROM gras_stats st
WHERE st.yr = 2022
  AND st.univ_code LIKE 'RC%'
ORDER BY st.id;
-- 还需要带广告的版本，存入 rk_dataset_univ_report 表中，存储目录多了一级 _RK/
INSERT INTO rk_dataset_univ_report(/*id,*/ dataset_id, ver_no, univ_id, univ_code, univ_cn_id, file_dir/*, file_size, file_hash, report_status, uploaded_at, updated_at, updated_by, copy_from*/)
SELECT 2 dataset_id, 2022 ver_no, univ_id, univ_code,
       (SELECT uc.id FROM univ_cn uc WHERE not uc.outdated AND uc.code = st.univ_code) uc_id, '_RK/GRAS/2022/' file_dir
FROM gras_stats st
WHERE st.yr = 2022
  AND st.univ_code LIKE 'RC%'
ORDER BY st.id;

# 5. 分校区拷贝数据；不需要
SELECT *
FROM gras_stats
WHERE yr = 2022
  AND univ_code IN (SELECT main_code FROM pd_subs_ub_univ);
# 5.1. 学科排名
# 5.2. 统计数据
# 5.3. 报告文件

/*SELECT *
FROM univ_cn_history;*/


/*-- -----------------------------------------------------------------------------------------
SELECT uc.name_cn, st.*
  FROM gras_stats st
           JOIN univ_cn uc ON uc.valid_to = 0 AND uc.code = st.univ_code
 WHERE yr = 2020;
SELECT uc.name_cn, dur.*
  FROM dataset_univ_report dur
           JOIN univ_cn uc ON dur.univ_cn_id = uc.id
 WHERE dataset_id = 2
   AND ver_no = 2020;

# delete from dataset_univ_report WHERE dataset_id=2 and ver_no=2020;
# alter table dataset_univ_report AUTO_INCREMENT 0;*/








