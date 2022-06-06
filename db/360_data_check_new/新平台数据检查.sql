# 数据一致性检查（新老平台对比-202205）
USE ub_ranking_dev;

SELECT NEW.r_ver_no, NEW.ind_code, NEW.univ_code, NEW.val, OLD.val, (NEW.val - OLD.val) `D-value`
FROM ind_value_2022 NEW
         LEFT JOIN ub_ranking_0520.ind_value_2022 OLD USING (r_ver_no, ind_code, univ_code)
WHERE r_ver_no = 202205
--  AND NEW.ind_code IN ('i2', 'i3', 'i4', 'i34', 'i5', 'b6', 'i18')
  AND (NEW.val - OLD.val) > 0.01;


SELECT NEW.r_ver_no, NEW.ind_code, NEW.univ_code, NEW.val, OLD.val, (NEW.val - OLD.val) `D-value`
FROM ind_value_2022 NEW
         RIGHT JOIN ub_ranking_0520.ind_value_2022 OLD USING (r_ver_no, ind_code, univ_code)
WHERE r_ver_no = 202205
--  AND NEW.ind_code IN ('i2', 'i3', 'i4', 'i34', 'i5', 'b6', 'i18')
  AND (NEW.val - OLD.val) > 0.01;



/*******************************************************************************************************************/


# 指标明细检查（点击页面指标值查看具体明细）
-- 检查页面：总体定位页面
-- 检测版本：202203
-- 检查对象：上海交通大学（A0238·RC00005）
-- 指标：国际顶尖学科（软科前50名） & 国际一流学科（软科上榜）明细无法显示

-- 检查该学校样本数据库是否有明细：有明细
USE ub_details_dev;
SELECT * FROM var_detail WHERE univ_code = 'RC00005' AND var_code = 'gras' ORDER BY VER_NO DESC;

/*{
"ranking" : "76-100",
"issue_time" : "2021-05-26",
"issue_year" : "2021",
"school_code" : "RC00005",
"school_name" : "上海交通大学",
"subject_area" : "社会科学",
"subject_code" : "RS0515",
"first_level_subject_name" : "图书情报科学"
}*/

-- 检查指标表头表 detail_def_id: 94 & 95
USE ub_ranking_0520;
SELECT *
FROM ind_detail_field
WHERE def_id IN (
    SELECT detail_def_id
    FROM indicator
    WHERE name IN ('国际顶尖学科（软科前50名）', '国际一流学科（软科上榜）')
      AND level = 3
      AND r_ver_no = '202203')
ORDER BY id, ord_no;


-- 指标：国家教学成果奖（折合数） 明细无法显示

-- 检查该学校样本数据库是否有明细：有明细
USE ub_details_dev;
SELECT * FROM var_detail WHERE univ_code = 'RC00005' AND var_code = 'g1' AND ver_no = '2018' ORDER BY VER_NO DESC;
SELECT * FROM var_detail WHERE univ_code = 'RC00005' AND var_code = 'g1' AND ver_no = '2018' AND dtl_id = 34067437;

-- 检查数据表ind_value_2022.var_details与明细id是否一致:不一致
USE ub_ranking_0520;
SELECT * FROM ind_value_2022 WHERE univ_code = 'RC00005' AND ind_code = 'b64' AND r_ver_no = 202203;



-- 检查指标表头表
USE ub_ranking_0520;
SELECT *
FROM ind_detail_field
WHERE def_id IN (
    SELECT detail_def_id
    FROM indicator
    WHERE name IN ('服务社会基地（折合数）')
      AND level = 3
      AND r_ver_no = '202203')
ORDER BY id, ord_no;




-- 指标：服务社会基地（折合数） 明细显示异常

-- 检查该学校样本数据库是否有明细：有明细
USE ub_details_dev;
SELECT * FROM var_detail WHERE univ_code = 'RC00005' AND var_code IN ('fwsh001','fwsh002','fwsh006','fwsh003','fwsh004','fwsh005') AND ver_no = '2021' ORDER BY VER_NO DESC;

/*{
"remark1" : "第一批",
"effective" : "1",
"elected_code" : "RC00005",
"elected_name" : "上海交通大学",
"elected_year" : 2021,
"project_name" : "上海交通大学",
"project_money" : 1.0
}*/

SELECT * FROM var_detail WHERE univ_code = 'RC00005' AND ver_no = '2021' AND dtl_id = 34131621;

-- 检查数据表ind_value_2022.var_details与明细id是否一致:不一致
USE ub_ranking_0520;
SELECT * FROM ind_value_2022 WHERE univ_code = 'RC00005' AND ind_code = 'i49c' AND r_ver_no = 202203;



-- 检查指标表头表
USE ub_ranking_0520;
SELECT *
FROM ind_detail_field
WHERE def_id IN (
    SELECT detail_def_id
    FROM indicator
    WHERE name IN ('服务社会基地（折合数）')
      AND level = 3
      AND r_ver_no = '202203')
ORDER BY id, ord_no;


/****************************************************************************************************************/


# 查询全部指标值差异数据
  WITH i AS ( -- 最新指标节点
      SELECT id, code, name
           , ind_lev >= 8 is_rank                                           -- 是排名指标
           , detail ->> '$.targetVer' target_ver                            -- 默认监测年份
           , is_full_sample                                                 -- 是否全样本
           , val ->> '$.formula' formula                                    -- 计算公式
           , ui ->> '$.selector' IS NULL no_selector                        -- 无年份选择下拉框
           , SUBSTRING_INDEX(detail ->> '$.availVer', '-', 1) avail_ver0    -- 可用明细起始版本
           , SUBSTRING_INDEX(detail ->> '$.availVer', '-', -1) avail_ver1   -- 可用明细结束版本
           , code IN ('b112' --	    资深学术权威（师均）	    i57/i18       i57-资深学术权威（总数）-全样本
/*                */, 'b121' --	    中年领军专家（师均）	    i58/i18       i58-中年领军专家（总数）-全样本
/*                */, 'b127' --	    青年拔尖英才（师均）	    i63/i18       i63-青年拔尖英才（总数）-全样本
/*                */, 'b129' --	    国际知名学者（师均）	    i106/i18      i106-国际知名学者（总数）-全样本
/*                */, 'b1318' --	高端人才（师均）	        b1308/i18     b1308-高端人才（总数）-全样本
/*                */, 'b151' --	    文科学术骨干（师均）	    b150/i18      b150-文科学术骨干（总数）-全样本
/*                */, 'i110' --	    国际期刊论文（师均）	    i103/i18      i103-国际期刊论文（总数）-全样本
/*                */, 'i48' --	    中文期刊论文（师均）	    i47/i18       i47-中文期刊论文（总数）-全样本
/*                */, 'patent10' --	PCT国际专利申请（师均）	patent9/i18   patent9-PCT国际专利申请（总数）-全样本
/*                */, 'patent12' --	专利获奖（师均折合数）	patent11/i18  patent11-专利获奖（折合数）-全样本
/*                */, 'patent2' --	发明专利授权（师均）	    patent1/i18   patent1-发明专利授权（总数）-全样本
/*                */, 'patent21' --	专利权转移（师均）	    patent20/i18  patent20-专利权转移（总数）-全样本
/*                */, 'patent6' --	实用新型专利授权（师均）	patent5/i18   patent5-实用新型专利授权（总数）-全样本
/*                */, 'patent8' --	外观设计专利授权（师均）	patent7/i18   patent7-外观设计专利授权（总数）-全样本
/*                */, 'b43' --      社会捐赠收入（生均）     i215/i1       i215-社会捐赠收入（总额）-全样本
/*                */, 'b78' --     	造就学术人才（生均）     b77/i1        b77-造就学术人才（总数）-全样本
/*                                                    */) ignore_old_absent -- 忽略New-Old存在性差异；大部分是全样本指标均值
           , code IN ('b41' --     	b41	自主收入比例（其他渠道收入占比）    i17/i14     i17-其他渠道收入-非全样本；老平台缺少计算（分母取到默认监测年份的替代值，就没计算）
/*                                                    */) ignore_old_zero   -- 忽略差异：老平台有真实值0，新平台有真实值
           , code IN ('i14', 'i15') ignore_old_alt                          -- 忽略老平台的替代值，学校收入相关的结果，有些不应该算出替代值
           , code IN ('i6', 'b8', 'b29', 'b35', 'i213', 'i209',
                      'i210', 'i13', 'b27', 'c7', 'c6', 'c5',
                      'i208', 'b41', 'i19', 'c13', 'i80') ignore_ratio_diff -- 比例类复合指标，新老平台计算使用的分母不同；17 个指标已跟业鹏确认
           , code IN ('i1') ignore_new_absent                               -- 忽略差异：老平台有真实值或替代值，而新平台没有记录
           , code IN ('i1') ignore_real_alt_eq                              -- 当old真实值与new替代值相等时，可认为没有差异
           , code IN ('i28') ignore_real_alt_ne                             -- 当old真实值与new替代值不等时，也可以忽略差异
           , code IN ('i23') ignore_exceed_avail                            -- 老平台有部分超出 availVer 的指标值
        FROM ub_ranking_dev.indicator_latest
       WHERE level = 3 -- 指标节点
         AND ind_lev >= 0 -- 排除弃用指标
  )
     , diff AS (
-- a. 默认监测年份-指标值显著差异
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , o.target_ver, o.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_0520.ind_value_latest o
                 JOIN ub_ranking_dev.ind_value_latest n USING (ind_code, target_ver, univ_code)
       WHERE o.ind_code = i.code
         AND o.target_ver = i.target_ver
         AND ABS(n.val - o.val) > 0.000001 -- 绝对差异足够大，否则判断相对差异无意义，因为指标值只存8位小数
         AND (ABS(n.val - o.val) / o.val > 0.0001 -- 相对差异也足够大
           OR ABS(n.val - o.val) / n.val > 0.0001)
       UNION ALL
-- b1. 默认监测年份数据-指标值存在性差异 -- Old-New
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , o.target_ver, o.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_0520.ind_value_latest o
                 LEFT JOIN ub_ranking_dev.ind_value_latest n USING (ind_code, target_ver, univ_code)
       WHERE o.ind_code = i.code
         AND o.target_ver = i.target_ver
         AND n.id IS NULL
         AND IF(i.is_full_sample, NOT (o.val = 0), TRUE) -- 全样本指标 0 跟 null 等价
         -- 老平台为了满足项目团队那边的趋势分析数据需求，为不需要下拉选择监测年份的指标，算出了与指标默认监测年份不匹配的数据，这些数据可以忽略
         AND IF(no_selector, o.target_ver = i.target_ver, TRUE)
       UNION ALL
-- b2. 默认监测年份数据-指标值存在性差异 -- New-Old
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , n.target_ver, n.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_dev.ind_value_latest n
                 LEFT JOIN ub_ranking_0520.ind_value_latest o USING (ind_code, target_ver, univ_code)
       WHERE n.ind_code = i.code
         AND n.target_ver = i.target_ver
         AND o.id IS NULL
         AND IF(i.is_full_sample, NOT (n.val = 0), TRUE) -- 全样本指标 0 跟 null 等价
         -- 由于某些指标在老库中没有替代值（但是又有得分），所以此处需要忽略新平台有替代值，但是老平台没有指标值记录（即替代值记录）的情况
         AND n.alt_val IS NULL
         -- 某些复合指标，计算时用到了全样本指标和替代值作为参数，所以应该得出 0 或替代值，但是老平台是空，这种差别也可以忽略掉
         -- 也有可能是老平台没有为此非排名指标使用替代值代入公式计算，所以也可以忽略存在性差异
         AND IF(ignore_old_absent, NOT (n.val = 0), TRUE)
       UNION ALL
-- c. 非默认监测年份数据-指标值显著差异
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , o.target_ver, o.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_0520.ind_value_latest o
                 JOIN ub_ranking_dev.ind_value_latest n USING (ind_code, target_ver, univ_code)
       WHERE o.ind_code = i.code
         AND o.target_ver != i.target_ver  -- 非默认监测年份数据
         AND ABS(n.val - o.val) > 0.000001 -- 绝对差异足够大，否则判断相对差异无意义，因为指标值只存8位小数
         AND (ABS(n.val - o.val) / o.val > 0.0001 -- 相对差异也足够大
           OR ABS(n.val - o.val) / n.val > 0.0001)
         -- 部分比例类指标，新平台计算时，使用的分母也是跟复合指标的动态监测年份一致
         --    而不是跟老平台一样处理（分母总是使用分母指标默认监测年份的指标值）
         -- 对于这部分指标，按如下标准忽略：新老平台的两个值，要么同时为 0，要么同时不为 0
         AND IF(ignore_ratio_diff, (IF(IFNULL(n.alt_val, n.val) > 0, 1, 0) + IF(IFNULL(o.alt_val, o.val) > 0, 1, 0)) = 1, TRUE)
         -- 部分复合指标，由于老平台在计算时，忽略了参数中不存在的值(即用0代入公式计算)，直接得出了真实值结果
         -- 而新平台在计算时，参数中出现了替代值，就认为计算结果是替代值
         -- 因此对于此类指标，如果老平台真实值与新平台替代值相等，则可认为没有差异
         AND IF(ignore_real_alt_eq, ABS(n.alt_val - o.val) > 0.0001, TRUE)
         -- 部分复合指标，由于老平台在计算时，忽略了参数中不存在的值(即用0代入公式计算)，直接得出了真实值结果
         -- 而新平台在计算时，参数中出现了替代值，就认为计算结果是替代值
         -- 对于此类指标，新平台应该计算出了替代值，老平台有真实值，这样的差异可以忽略
         AND IF(ignore_real_alt_ne, NOT (o.alt_val IS NULL AND n.alt_val IS NOT NULL), TRUE)
         -- 老平台在计算相关复合指标值时，参数复合指标的替代值还没有计算，所以得出结果为0
         --   老平台类似这样取不到参数指标值时，代入0计算公式得到的结果都当作了真实值
         AND IF(ignore_old_zero, NOT (o.alt_val IS NULL AND o.val = 0 AND n.val > 0 AND n.alt_val IS NULL), TRUE)
       UNION ALL
-- d1. 非默认监测年份数据-指标值存在性差异 -- Old-New
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , o.target_ver, o.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_0520.ind_value_latest o
                 LEFT JOIN ub_ranking_dev.ind_value_latest n USING (ind_code, target_ver, univ_code)
       WHERE o.ind_code = i.code
         AND o.target_ver != i.target_ver                -- 非默认监测年份数据
         AND n.id IS NULL
         AND IF(i.is_full_sample, NOT (o.val = 0), TRUE) -- 全样本指标 0 跟 null 等价
         -- 老平台为了满足项目团队那边的趋势分析数据需求，为不需要下拉选择监测年份的指标，算出了与指标默认监测年份不匹配的数据，这些数据可以忽略
         AND IF(no_selector, o.target_ver = i.target_ver, TRUE)
         -- 老平台在计算比例值时，分母取到了参数指标默认监测年份的指标值，所以能计算出结果
         -- 而新平台在计算比例值时，分母会取跟复合指标动态监测年份相同的指标值，由于没有取到此分母，所以计算结果为空
         AND IF(ignore_ratio_diff, NOT (o.alt_val IS NULL), TRUE)
         -- 老平台在计算复合指标时，计算公式中的参数指标值缺失，会代入0去计算得到真实值
         AND IF(ignore_new_absent, FALSE, TRUE)
         -- 老平台有部分超出 availVer 的指标值，直接忽略掉
         AND IF(ignore_exceed_avail, (o.target_ver BETWEEN avail_ver0 AND avail_ver1), TRUE)
         -- 忽略老平台的替代值，学校收入相关的结果，有些不应该算出替代值
         AND IF(ignore_old_alt, (o.alt_val IS NULL), TRUE)
       UNION ALL
-- d2. 非默认监测年份数据-指标值存在性差异 -- New-Old
      SELECT i.code, i.name
           , i.is_rank, i.target_ver dft_target_ver, i.is_full_sample
           , n.target_ver, n.univ_code
           , o.val val_old, n.val val_new
           , (n.val - o.val) val_diff
           , o.alt_val alt_val_old, n.alt_val alt_val_new
        FROM i
           , ub_ranking_dev.ind_value_latest n
                 LEFT JOIN ub_ranking_0520.ind_value_latest o USING (ind_code, target_ver, univ_code)
       WHERE n.ind_code = i.code
         AND n.target_ver != i.target_ver                -- 非默认监测年份数据
         AND o.id IS NULL
         AND IF(i.is_full_sample, NOT (n.val = 0), TRUE) -- 全样本指标 0 跟 null 等价
         -- 由于某些指标在老库中没有替代值（但是又有得分），所以此处需要忽略新平台有替代值，但是老平台没有指标值记录（即替代值记录）的情况
         AND n.alt_val IS NULL
         -- 某些复合指标，计算时用到了全样本指标和替代值作为参数，所以应该得出 0 或替代值，但是老平台是空，这种差别也可以忽略掉
         -- 也有可能是老平台没有为此非排名指标使用替代值代入公式计算，所以也可以忽略存在性差异
         AND IF(ignore_old_absent, NOT (n.val = 0), TRUE)
      /**/)
SELECT code, name, is_rank, is_full_sample, dft_target_ver = target_ver is_dft_tv, target_ver, univ_code
     , (SELECT uc.name_cn FROM univ_ranking_dev.univ_cn uc WHERE uc.code = diff.univ_code ORDER BY uc.outdated > 0, ABS(uc.outdated) DESC LIMIT 1) univ_name
     , val_old, val_new, val_diff, alt_val_old, alt_val_new
  FROM diff;









# 数据一致性检查（新老平台对比-202205）
USE ub_ranking_dev;

SELECT N.ind_code,
       ( SELECT id.name FROM ub_ranking_dev.indicator_latest id WHERE id.code = N.ind_code LIMIT 1 ) name,
       N.univ_code,
       ( SELECT uc.name_cn
         FROM univ_ranking_dev.univ_cn uc
         WHERE uc.code = N.univ_code
         ORDER BY uc.outdated > 0, ABS(uc.outdated) DESC
         LIMIT 1 )                                                                                   univ_name,
       N.target_ver,
       N.val AS                                                                                      `N.val`,
       O.val AS                                                                                      `OLD.val`,
       (N.val - O.val)                                                                               `D-value`
FROM ind_value_latest                           N
     LEFT JOIN ub_ranking_0520.ind_value_latest O USING (target_ver, ind_code, univ_code)
WHERE ABS(N.val - O.val) > 0.0001;



# 检查初始得分差异
SELECT r_ver_no, ind_id, n.ind_code,
       (SELECT name FROM ub_ranking_0520.indicator_latest A WHERE A.code =  n.ind_code LIMIT 1) name,
       univ_code
     , o.val val_old
     , n.val val_new
     , o.pre_score pre_score_old
     , n.pre_score pre_score_new
     , (n.pre_score - o.pre_score) pre_score_diff
  FROM ub_ranking_dev.ind_value_2022 n
           JOIN ub_ranking_0520.ind_value_2022 o USING (r_ver_no, univ_code, ind_id)
 WHERE n.r_ver_no = 202205
   AND ((n.pre_score - o.pre_score) / o.pre_score > 0.00001
     OR (n.pre_score - o.pre_score) / n.pre_score > 0.00001)
#    AND n.ind_code IN (SELECT code FROM indicator_latest WHERE ind_lev >= 8)
   AND n.ind_code IN (select ind_code from weight_scheme_detail where scheme_id in (select id from weight_scheme ws WHERE ws.r_ver_no=202205))
 ORDER BY ABS(pre_score_diff) DESC;



# 计算指标替代值基础数据
USE ub_ranking_old;
# 老平台：
SELECT school_code,
       target_code,
       target_val,
       ( SELECT school_level FROM rank_tbl_school_info A WHERE A.school_code = B.school_code ) school_level,
       ( SELECT school_type FROM rank_tbl_school_info A WHERE A.school_code = B.school_code )  school_type
FROM `temporary_rank_tbl_school_target_info` B
WHERE data_year = '2020'
  AND target_code = 'i15'
  AND target_val != 0
  AND fixed_value IS NULL;


# 新平台：
SELECT ind_code,
       univ_code,
       target_ver,
       val,
       ( SELECT school_level FROM rank_tbl_school_info A WHERE A.unified_code = B.univ_code ) school_level,
       ( SELECT school_type FROM rank_tbl_school_info A WHERE A.unified_code = B.univ_code )  school_type
FROM ub_ranking_dev.ind_value_latest B
WHERE ind_code = 'i15'
  AND target_ver = '2020'
--  AND val != 0;







