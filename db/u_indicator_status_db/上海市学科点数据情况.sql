#

SELECT A.*, B.province, C.subjectRank
FROM `data_detail_degree_level_new` A
     LEFT JOIN institution          B ON A.institutionCode = B.school_code
     LEFT JOIN data_detail_moe_rank C ON A.institutionCode = C.institutionCode AND A.subjectCode = C.subjectCode
WHERE A.indicatorCode = 'i214'
  AND B.province = '上海市'
  AND if_effective = '1';