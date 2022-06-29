# 新增数据：学科单指标得分
USE univ_ranking_raw;

SELECT *
FROM univ_ranking_dev.gras_indicator
WHERE yr = 2022;

# 1. 原始数据表
CREATE TABLE univ_ranking_raw.raw_220628_gras_ind_score
(
    id             int AUTO_INCREMENT PRIMARY KEY,
    univ_code      varchar(20)   NOT NULL COMMENT '标准代码（发布时删除）',
    category_code  varchar(20)   NOT NULL COMMENT 'Field',
    subj_name      varchar(100)  NOT NULL COMMENT 'Subject',
    subj_code      varchar(20)   NOT NULL COMMENT '学科代码（发布时删除）',
    univ_name_en   varchar(200)  NOT NULL COMMENT 'Institution',
    country_en     varchar(50)   NOT NULL COMMENT 'Country/Region',
    ind_01_score   decimal(4, 1) NOT NULL COMMENT 'Score on Q1',
    ind_02_score   decimal(4, 1) NOT NULL COMMENT 'Score on CNCI',
    ind_03_score   decimal(4, 1) NOT NULL COMMENT 'Score on IC',
    ind_04_score   decimal(4, 1) NULL COMMENT 'Score on Top',
    ind_05_score   decimal(4, 1) NULL COMMENT 'Score on Award',
    total_score    decimal(5, 1) NULL COMMENT 'Total Score',
    ranking        varchar(10)   NULL COMMENT 'Rank 2022',
    ranking_region varchar(10)   NULL COMMENT 'National/Regional Rank 2022',
    _univ_id       int           NULL COMMENT '补充：univ.id',
    UNIQUE uk_raw_gras_ind_score_0628_3 (univ_code, subj_code)
);
/*
导入原始数据；OK in 7.21s
*/

SELECT *
FROM univ_ranking_raw.raw_220628_gras_ind_score;



# 3. 转移原始数据
# 3.1. 匹配 _univ_id
UPDATE univ_ranking_raw.raw_220628_gras_ind_score ris
SET _univ_id=(SELECT univ_id
              FROM gras_rank r
              WHERE r.yr = 2022
                AND r.subj_code = ris.subj_code
                AND r.univ_code = ris.univ_code)
WHERE ris._univ_id IS NULL;
SELECT *
FROM univ_ranking_raw.raw_220628_gras_ind_score
WHERE _univ_id IS NULL;


# 3.2. 插入单指标排名数据
INSERT INTO gras_ind_score(/*id,*/ yr, subj_code, ind_id, univ_id, univ_code, score)
WITH c AS (
    SELECT ris.*, i.id ind_id, i.ord_no ind_ord_no, i.yr
    FROM univ_ranking_raw.raw_220628_gras_ind_score ris
             JOIN gras_indicator i ON i.yr = 2022
),
     g AS (
         SELECT yr,
                subj_code,
                ind_id,
                _univ_id,
                univ_code,
                ind_01_score,
                id,
                ind_ord_no
         FROM c
         WHERE ind_ord_no = 1
         UNION ALL
         SELECT yr,
                subj_code,
                ind_id,
                _univ_id,
                univ_code,
                ind_02_score,
                id,
                ind_ord_no
         FROM c
         WHERE ind_ord_no = 2
         UNION ALL
         SELECT yr,
                subj_code,
                ind_id,
                _univ_id,
                univ_code,
                ind_03_score,
                id,
                ind_ord_no
         FROM c
         WHERE ind_ord_no = 3
         UNION ALL
         SELECT yr,
                subj_code,
                ind_id,
                _univ_id,
                univ_code,
                ind_04_score,
                id,
                ind_ord_no
         FROM c
         WHERE ind_ord_no = 4
         UNION ALL
         SELECT yr,
                subj_code,
                ind_id,
                _univ_id,
                univ_code,
                ind_05_score,
                id,
                ind_ord_no
         FROM c
         WHERE ind_ord_no = 5
     )
SELECT yr, subj_code, ind_id, _univ_id, univ_code, ind_01_score
FROM g
ORDER BY id, ind_ord_no;


