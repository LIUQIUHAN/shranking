USE ub_details_0429;

CREATE TEMPORARY TABLE diff_val_ben_1
WITH A AS (
    SELECT r_ver_no, univ_code, val
    FROM ub_ranking_dev.ind_value_2020
    WHERE ind_code = 'cate080601'
    UNION ALL
    SELECT r_ver_no, univ_code, val
    FROM ub_ranking_dev.ind_value_2021
    WHERE ind_code = 'cate080601'
    UNION ALL
    SELECT r_ver_no, univ_code, val
    FROM ub_ranking_dev.ind_value_2022
    WHERE ind_code = 'cate080601'
),
     B AS (
         SELECT _eversions_, univ_code, COUNT(DISTINCT rel_code) val_1
         FROM var_detail
         WHERE var_code IN ('ben1', 'engineer1', 'huli1', 'medicine1', 'normal1', 'yaoxue1')
         GROUP BY _eversions_, univ_code)
SELECT A.*, B.val_1, ROUND((A.val - B.val_1), 0) diff_val
FROM A
         JOIN B ON A.r_ver_no = (B._eversions_ + 0) AND A.univ_code = B.univ_code
;



/*DROP PROCEDURE IF EXISTS insert_ben1;

CREATE PROCEDURE insert_ben1()
BEGIN
    DECLARE univ_code VARCHAR(20);
    DECLARE r_ver_no INT;
    DECLARE diff_val INT;
    DECLARE done INT DEFAULT FALSE; -- 将结束标志绑定到游标
    DECLARE univ_diff_cur CURSOR FOR (
        SELECT r_ver_no, univ_code, diff_val
        FROM diff_val_ben_1
        WHERE diff_val > 0);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- 打开游标
    OPEN univ_diff_cur;
    read_loop:
    LOOP
        FETCH univ_diff_cur INTO r_ver_no,univ_code,diff_val;
        IF done THEN
            LEAVE read_loop;
        END IF; -- 关闭游标
        WHILE diff_val > 0
            DO
                INSERT INTO ub_details_0429.var_detail
                (revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail, subject_code, rel_code,
                 agg_from, _eversions_, _r_ver_no, created_by)
                VALUES (0, 8, 'ben1', 4, 2019, univ_code, 0, 1, '{}', '', '', 0, r_ver_no, r_ver_no, -1);
                SET diff_val = diff_val - 1;
            END WHILE;
    END LOOP;
    CLOSE univ_diff_cur;
END;

CALL insert_ben1();*/



# insert into ()
-- 6488
SET @i := 100;
INSERT INTO var_detail
(revision, var_id, var_code, source_id, ver_no, univ_code, lev, val, detail, subject_code, rel_code,
 agg_from, _eversions_, _r_ver_no, created_by)
WITH RECURSIVE max_n AS (
    SELECT 1 n
    UNION ALL
    SELECT n + 1
    FROM max_n
    WHERE n < (SELECT MAX(diff_val) FROM diff_val_ben_1)
)
   , j AS (
    SELECT b.*, m.n
    FROM diff_val_ben_1 b
             JOIN max_n m ON b.diff_val >= m.n
)
SELECT 0                             revision,
       8                             var_id,
       'ben1'                        var_code,
       4                             source_id,
       2019                          ver_no,
       univ_code,
       0                             lev,
       1                             val,
       '{}'                          detail,
       ''                            subject_code,
       CONCAT('TUD', (@i := @i + 1)) rel_code,
       0                             agg_from,
       r_ver_no                      _eversions_,
       r_ver_no                      _r_ver_no,
       -2                            created_by
FROM j
ORDER BY univ_code, j.r_ver_no, n;

/*UPDATE var_detail A
SET detail = JSON_SET(detail,
                      '$.remark1', NULL,
                      '$.remark2', rel_code,
                      '$.born_year', NULL,
                      '$.dead_year', NULL,
                      '$.effective', '1',
                      '$.award_level', NULL,
                      '$.talent_name', NULL,
                      '$.current_code', NULL,
                      '$.current_name', NULL,
                      '$.elected_code', univ_code,
                      '$.elected_name',
                      (SELECT name_cn FROM univ_ranking_dev.univ_cn B WHERE A.univ_code = B.code AND B.outdated = 0),
                      '$.elected_year', 2019,
                      '$.project_name', '专业名称暂缺',
                      '$.project_money', 0)
WHERE created_by = -2;*/



