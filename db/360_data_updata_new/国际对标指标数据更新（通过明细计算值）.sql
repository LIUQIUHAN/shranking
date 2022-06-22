# 国际对标明细数据入库
USE ub_details_0429;



# 计算统计值数据
-- {"102459-0": [], "112316-0": [], "122739-0": []}
SELECT dtl_id,
       revision,
       univ_code,
       JSON_OBJECTAGG(CONCAT(dtl_id, '-', revision), JSON_ARRAY())
FROM intl_var_detail
WHERE var_code = 32
  AND ver_no = 202001
GROUP BY univ_code
LIMIT 20;









/*UPDATE intl_var_detail SET detail = REPLACE(detail,'研究','科研') WHERE var_code = '20' AND ver_no = 2022;
UPDATE intl_var_detail SET detail = REPLACE(detail,'国际展望','国际化') WHERE var_code = '20' AND ver_no = 2022;
UPDATE intl_var_detail SET detail = REPLACE(detail,'行业收入','企业收入') WHERE var_code = '20' AND ver_no = 2022;

SELECT detail ->> '$.indicators' FROM intl_var_detail WHERE var_code = '15' AND univ_code = 'RC00001';*/











