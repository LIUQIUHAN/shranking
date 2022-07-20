# 软科世界一流学科排名 导入360变量明细库中
USE ub_details_raw;

INSERT INTO ub_details_0429.var_detail (revision,
                                        var_id,
                                        var_code,
                                        source_id,
                                        ver_no,
                                        univ_code,
                                        lev,
                                        val,
                                        detail,
                                        rel_code,
                                        agg_from,
                                        _eversions_,
                                        _r_ver_no,
                                        created_by)
SELECT 0      AS revision,
       223    AS var_id,
       'gras' AS var_code,
       23     AS source_id,
       yr     AS ver_no,
       univ_code,
       0      AS lev,
       1      AS val,
       JSON_OBJECT('ranking', rank_issued,
                   'remark1', NULL,
                   'remark2', NULL,
                   'remark3', NULL,
                   'issue_time', '2022-07-19',
                   'issue_year', '2022',
                   'school_code', univ_code,
                   'school_name', univ_name_cn,
                   'subject_area', (CASE
                                        WHEN subject_code IN (
                                                              'RS0101',
                                                              'RS0102',
                                                              'RS0103',
                                                              'RS0104',
                                                              'RS0105',
                                                              'RS0106',
                                                              'RS0107',
                                                              'RS0108'
                                            ) THEN '理学'
                                        WHEN subject_code IN (
                                                              'RS0201',
                                                              'RS0202',
                                                              'RS0205',
                                                              'RS0206',
                                                              'RS0207',
                                                              'RS0208',
                                                              'RS0210',
                                                              'RS0211',
                                                              'RS0212',
                                                              'RS0213',
                                                              'RS0214',
                                                              'RS0215',
                                                              'RS0216',
                                                              'RS0217',
                                                              'RS0219',
                                                              'RS0220',
                                                              'RS0221',
                                                              'RS0222',
                                                              'RS0223',
                                                              'RS0224',
                                                              'RS0226',
                                                              'RS0227'
                                            ) THEN '工学'
                                        WHEN subject_code IN (
                                                              'RS0301',
                                                              'RS0302',
                                                              'RS0303',
                                                              'RS0304'
                                            ) THEN '生命科学'
                                        WHEN subject_code IN (
                                                              'RS0401',
                                                              'RS0402',
                                                              'RS0403',
                                                              'RS0404',
                                                              'RS0405',
                                                              'RS0406'
                                            ) THEN '医学'
                                        WHEN subject_code IN (
                                                              'RS0501',
                                                              'RS0502',
                                                              'RS0503',
                                                              'RS0504',
                                                              'RS0505',
                                                              'RS0506',
                                                              'RS0507',
                                                              'RS0508',
                                                              'RS0509',
                                                              'RS0510',
                                                              'RS0511',
                                                              'RS0512',
                                                              'RS0513',
                                                              'RS0515'
                                            ) THEN '社会科学' END),
                   'subject_code', subject_code,
                   'first_level_subject_name', subject_name_cn
           )  AS detail,
       0      AS rel_code,
       0      AS agg_from,
       202208 AS _eversions_,
       202208 AS _r_ver_no,
       -1     AS created_by
FROM `raw_gras_sr_details_20220704`
WHERE country_or_region_cn = '中国';

# 原360平台明细入库_GRAS-2022：rank_tbl_school_first_level_subject
SELECT 202208                      edition_year,
       2022                        issue_year,
       '2022-07-19'                issue_time,
       (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)                   school_code,
       univ_name_cn                school_name,
       (CASE
            WHEN subject_code IN (
                                  'RS0101',
                                  'RS0102',
                                  'RS0103',
                                  'RS0104',
                                  'RS0105',
                                  'RS0106',
                                  'RS0107',
                                  'RS0108'
                ) THEN '理学'
            WHEN subject_code IN (
                                  'RS0201',
                                  'RS0202',
                                  'RS0205',
                                  'RS0206',
                                  'RS0207',
                                  'RS0208',
                                  'RS0210',
                                  'RS0211',
                                  'RS0212',
                                  'RS0213',
                                  'RS0214',
                                  'RS0215',
                                  'RS0216',
                                  'RS0217',
                                  'RS0219',
                                  'RS0220',
                                  'RS0221',
                                  'RS0222',
                                  'RS0223',
                                  'RS0224',
                                  'RS0226',
                                  'RS0227'
                ) THEN '工学'
            WHEN subject_code IN (
                                  'RS0301',
                                  'RS0302',
                                  'RS0303',
                                  'RS0304'
                ) THEN '生命科学'
            WHEN subject_code IN (
                                  'RS0401',
                                  'RS0402',
                                  'RS0403',
                                  'RS0404',
                                  'RS0405',
                                  'RS0406'
                ) THEN '医学'
            WHEN subject_code IN (
                                  'RS0501',
                                  'RS0502',
                                  'RS0503',
                                  'RS0504',
                                  'RS0505',
                                  'RS0506',
                                  'RS0507',
                                  'RS0508',
                                  'RS0509',
                                  'RS0510',
                                  'RS0511',
                                  'RS0512',
                                  'RS0513',
                                  'RS0515'
                ) THEN '社会科学' END) subject_area,
       subject_code,
       subject_name_cn             first_level_subject_name,
       rank_issued                 ranking,
       NULL                        remark1,
       NULL                        remark2,
       NULL                        remark3,
       NOW()                       crt_time,
       'system'                    crt_user
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国';

# 原360平台各类排名统计值_GRAS-2022：rank_tbl_other_org_ranking
SELECT '2022'       rank_year,
       '2022-07-19' issue_time,
       '上榜学科'       rank_type,
       'D003'       rank_id,
       univ_code    rank_school_code,
       (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)    school_code,
       COUNT(*)     subject_num,
       NOW()        crt_time
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国'
GROUP BY univ_code UNION ALL
SELECT '2022'       rank_year,
       '2022-07-19' issue_time,
       '一流学科'       rank_type,
       'D003'       rank_id,
       univ_code    rank_school_code,
       (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)    school_code,
       COUNT(*)     subject_num,
       NOW()        crt_time
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国'
  AND (rank_precise + 0) <= 50
GROUP BY univ_code;


# 排名统计值入库：rank_tbl_basics_target_data
SELECT (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1) school_code,
       'i201'    target_code,
       '2022'    data_year,
       '0'       data_source_id,
       COUNT(*)  target_val
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国'
GROUP BY univ_code
UNION ALL
SELECT (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1) school_code,
       'i202'    target_code,
       '2022'    data_year,
       '0'       data_source_id,
       COUNT(*)  target_val
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国'
  AND (rank_precise + 0) <= 50
GROUP BY univ_code;


# 高校状态指标数据库：rank_tbl_school_first_level_subject
SELECT 2022                                       data_year,
       '2022-07-19'                               issue_time,
       (SELECT B._code_old
        FROM univ_cn B
        WHERE A.univ_code = B.code
        ORDER BY B.outdated = 0 DESC, B.outdated DESC
        LIMIT 1)                                  institutionCode,
       univ_name_cn                               school_name,
       (CASE
            WHEN subject_code IN (
                                  'RS0101',
                                  'RS0102',
                                  'RS0103',
                                  'RS0104',
                                  'RS0105',
                                  'RS0106',
                                  'RS0107',
                                  'RS0108'
                ) THEN '理学'
            WHEN subject_code IN (
                                  'RS0201',
                                  'RS0202',
                                  'RS0205',
                                  'RS0206',
                                  'RS0207',
                                  'RS0208',
                                  'RS0210',
                                  'RS0211',
                                  'RS0212',
                                  'RS0213',
                                  'RS0214',
                                  'RS0215',
                                  'RS0216',
                                  'RS0217',
                                  'RS0219',
                                  'RS0220',
                                  'RS0221',
                                  'RS0222',
                                  'RS0223',
                                  'RS0224',
                                  'RS0226',
                                  'RS0227'
                ) THEN '工学'
            WHEN subject_code IN (
                                  'RS0301',
                                  'RS0302',
                                  'RS0303',
                                  'RS0304'
                ) THEN '生命科学'
            WHEN subject_code IN (
                                  'RS0401',
                                  'RS0402',
                                  'RS0403',
                                  'RS0404',
                                  'RS0405',
                                  'RS0406'
                ) THEN '医学'
            WHEN subject_code IN (
                                  'RS0501',
                                  'RS0502',
                                  'RS0503',
                                  'RS0504',
                                  'RS0505',
                                  'RS0506',
                                  'RS0507',
                                  'RS0508',
                                  'RS0509',
                                  'RS0510',
                                  'RS0511',
                                  'RS0512',
                                  'RS0513',
                                  'RS0515'
                ) THEN '社会科学' END)                subject_area,
       subject_code,
       subject_name_cn                            first_level_subject_name,
       rank_issued                                ranking,
       NULL                                       remark1,
       NULL                                       remark2,
       NULL                                       remark3,
       IF((rank_precise + 0) <= 50, 'rksb50', '') indicatorCode,
       'rksball'                                  indicatorCode1,
       NOW()                                      crt_time,
       'system'                                   crt_user
FROM `raw_gras_sr_details_20220704` A
WHERE country_or_region_cn = '中国';


# 高校状态指标数据库国际对比：data_detail_rank_list_detail_world
SELECT 2022                                     real_year,
       2022                                     data_year,
       '2022-07-19'                             issue_time,
       'r6'                                     indicatorCode,
       univ_code                                institutionCode,
       NULL                                     institutionName,
       subject_name_en                          indicatorSubName,
       NULL                                     awardee,
       NULL                                     awardName,
       rank_issued                              indicatorValue,
       NULL                                     totalInstitution,
       NULL                                     isTop1000,
       NULL                                     isTop10000,
       NULL                                     esiTotalCites,
       subject_code                             subjectCode,
       IF((rank_precise + 0) <= 50, '21', NULL) indicatorCodeSub,
       NULL                                     levelCode,
       NOW()                                    crt_time
FROM `raw_gras_sr_details_20220704` A;








