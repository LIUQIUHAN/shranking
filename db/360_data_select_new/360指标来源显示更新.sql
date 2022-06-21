USE ub_ranking_dev;

UPDATE indicator_latest A JOIN ub_details_raw._generalsources_new_name B ON A.code = B.code
SET A.detail = JSON_SET(A.detail, '$.generalSources', B.generalSources)
WHERE A.level = 3
  AND A.shows IN ('', '^21', '21');

UPDATE indicator A JOIN ub_details_raw._generalsources_new_name B ON A.code = B.code
SET A.detail = JSON_SET(A.detail, '$.generalSources', B.generalSources)
WHERE A.level = 3
  AND A.shows IN ('', '^21', '21');

UPDATE indicator SET detail = JSON_SET(detail, '$.generalSources', '见指标“模范先进学生（总数）”和“本科生数”')
WHERE name = '模范先进学生（生均）';

UPDATE indicator SET detail = JSON_SET(detail, '$.generalSources', '见指标“学术人才（总数）”和“教师规模”')
WHERE name = '学术人才（师均）';

SELECT DISTINCT name
FROM c_ind_source
WHERE name IN (
               '学校硕士生招生目录；教育部',
               '教育部',
               '科睿唯安官网',
               '“挑战杯”官网',
               '中国“互联网+”大学生创新创业官网',
               '《毕业生就业质量报告》；学校在其他权威渠道发布；各省市教育厅',
               '高绩数据库',
               '科技部',
               '发改委',
               '国防科技工业局；解放军总装备部',
               '各学校官网',
               '国家知识产权局',
               '国家知识产权局',
               '世界知识产权组织',
               '国家知识产权局',
               '中国科学院',
               '中国工程院',
               '何梁何利基金会官网',
               '各省市教育厅',
               '各省市科技厅',
               '学校博士生招生目录；教育部'
    );

UPDATE c_ind_source SET name = '学校硕士生招生目录；教育部' WHERE name = '学校硕士生招生目录；教育部网站';
UPDATE c_ind_source SET name = '教育部' WHERE name = '教育部网站';
UPDATE c_ind_source SET name = '科睿唯安官网' WHERE name = '科睿唯安高被引科学家网';
UPDATE c_ind_source SET name = '“挑战杯”官网' WHERE name = '“挑战杯”官方网站';
UPDATE c_ind_source SET name = '中国“互联网+”大学生创新创业官网' WHERE name = '中国“互联网+”大学生创新创业官方网站';
UPDATE c_ind_source SET name = '《毕业生就业质量报告》；学校在其他权威渠道发布；各省市教育厅' WHERE name = '各高校发布的《毕业生就业质量报告》；各高校通过其他权威渠道发布的就业率数据；省级教育主管部门发布的各高校就业率数据';
UPDATE c_ind_source SET name = '高绩数据库' WHERE name = '独立采集';
UPDATE c_ind_source SET name = '科技部' WHERE name = '科技部网站';
UPDATE c_ind_source SET name = '发改委' WHERE name = '国家发改委';
UPDATE c_ind_source SET name = '国防科技工业局；解放军总装备部' WHERE name = '国家国防科技工业局；解放军总装备部';
UPDATE c_ind_source SET name = '各学校官网' WHERE name = '各学校网站';
UPDATE c_ind_source SET name = '国家知识产权局' WHERE name = '国家知识产权局办公室';
UPDATE c_ind_source SET name = '国家知识产权局' WHERE name = '国家知识产权局网站';
UPDATE c_ind_source SET name = '世界知识产权组织' WHERE name = '世界知识产权组织网站';
UPDATE c_ind_source SET name = '国家知识产权局' WHERE name = '中国国家知识产权局';
UPDATE c_ind_source SET name = '中国科学院' WHERE name = '中国科学院网站';
UPDATE c_ind_source SET name = '中国工程院' WHERE name = '中国工程院网站';
UPDATE c_ind_source SET name = '何梁何利基金会官网' WHERE name = '何梁何利基金会网站';
UPDATE c_ind_source SET name = '各省市教育厅' WHERE name = '各省市教育厅网站';
UPDATE c_ind_source SET name = '各省市科技厅' WHERE name = '各省市科技厅网站';
UPDATE c_ind_source SET name = '学校博士生招生目录；教育部' WHERE name = '学校博士生招生目录；教育部网站';



SELECT * FROM ub_details_raw._generalsources_new_name WHERE generalSources RLIKE '见指标';

/*UPDATE c_ind_source A JOIN ub_details_raw._generalsources_new_name B ON A.ind_code = B.code
SET A.name = B.generalSources,
    A.abbr = B.generalSources
WHERE A.ind_code IN (SELECT C.code FROM ub_details_raw._generalsources_new_name C WHERE C.generalSources RLIKE '见指标');*/


UPDATE indicator_latest
SET val = JSON_SET(val, '$.resetEffSrcIds', '88')
WHERE level = 3
  AND code IN (SELECT C.code FROM ub_details_raw._generalsources_new_name C WHERE C.generalSources RLIKE '见指标');

UPDATE indicator
SET val = JSON_SET(val, '$.resetEffSrcIds', '88')
WHERE level = 3
  AND code IN (SELECT C.code FROM ub_details_raw._generalsources_new_name C WHERE C.generalSources RLIKE '见指标');


UPDATE indicator SET val = JSON_SET(val, '$.resetEffSrcIds', '88')
WHERE name = '模范先进学生（生均）';

UPDATE indicator SET val = JSON_SET(val, '$.resetEffSrcIds', '88')
WHERE name = '学术人才（师均）';

INSERT INTO c_ind_source (_id, ind_code, src_id, priority, name, abbr, _old_src_id, _new_src_id)
SELECT NULL AS _id,
       code AS ind_code,
       88   AS src_id,
       -1   AS priority,
       generalSources AS name,
       generalSources AS abbr,
       -1   AS _old_src_id,
       88   AS _new_src_id
FROM ub_details_raw._generalsources_new_name
WHERE generalSources RLIKE '见指标';











