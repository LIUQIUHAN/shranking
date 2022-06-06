#

SELECT A.indicatorCode                    AS 指标代码,
       B.indicatorname                    AS 指标名称,
       B.nullmeaning                      AS 全样本标识,
       GROUP_CONCAT(DISTINCT A.data_year) AS 历史年份汇总
FROM `data_detail` A,
     indicator     B
WHERE A.indicatorCode = B.targetcode
  AND B.data_year != '\\'
GROUP BY A.indicatorCode
ORDER BY A.data_year
;

