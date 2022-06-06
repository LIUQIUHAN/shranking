#

SELECT school_code, school_name, 'A+' AS 类型, COUNT(*) AS `A+学科数`
FROM `rank_tbl_school_four_selection`
WHERE performance = 'A+'
  AND edition_year = '202104'
GROUP BY school_code
UNION ALL
SELECT school_code, school_name, 'A+ A A-' AS 类型, COUNT(*) AS `A类学科数`
FROM `rank_tbl_school_four_selection`
WHERE performance IN ('A+', 'A', 'A-')
  AND edition_year = '202104'
GROUP BY school_code;