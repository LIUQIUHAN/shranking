#

SELECT *
FROM `data_detail_rank_list_world`
WHERE country IN ('中国', 'China')
  AND institutionCode NOT IN ('RC00061', 'RC00082', 'RC00084', 'RC00099')
  AND indicatorCode IN ('39',
                        '40',
                        '41',
                        '42',
                        '43',
                        '51',
                        '52',
                        '53',
                        '54',
                        '56',
                        '57',
                        '62',
                        '70',
                        '71',
                        '86',
                        '87',
                        '96',
                        '99'
    );