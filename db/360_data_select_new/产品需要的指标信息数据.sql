USE ub_ranking_0520;

# 指标层面
SELECT -- id,
       -- pid,
       mod_code                                                                                  模块代码,
       mod_name                                                                                  模块名称,
       dim_code                                                                                  维度代码,
       dim_name                                                                                  维度名称,
       `code`                                                                                    指标代码,
       `name`                                                                                    指标名称,
       abbr                                                                                      指标简称,
       detail_target_ver                                                                         默认监测年份,
       detail_avail_ver                                                                          指标年份范围,
       IF(val_unit_code IS NULL, 'zhehe/bizhi', val_unit_code)                                   指标单位,
       IF(var_codes IS NULL, val_formula_codes, var_codes)                                       变量代码集,
       IF(var_names IS NULL, val_formula_desc, var_names)                                        `变量名称集/公式`,
       detail_access_rule                                                                        计算类型（包含了去重规则）,
       IF(is_full_sample = 0, '否', '是')                                                          是否全样本,
       val_alt_group                                                                             替代值计算分组,
       val_alt_use                                                                               替代值取值,
       (CASE WHEN ind_lev = - 5 THEN '弃用指标' WHEN ind_lev = 8 THEN '排名指标' ELSE '参考指标' END)        指标类型,
       (CASE WHEN (ind_lev = - 5 OR ind_lev = 2 OR ind_lev = 6 OR ind_lev = 8) THEN '核心指标'
             WHEN ind_lev = 0 THEN '非核心指标'
             ELSE '非核心指标' END)                                                                   关联页面,-- -5=弃用指标，2=核心指标，6=排名推演页面可能显示，8=可能是排名指标；这里说「可能」的原因是不同排名类型下，指标的权重可能不同，比如判断是否排名指标 is_rank = (ind_lev>=8 && r_type_ind_weight>0)
       (CASE WHEN shows = '' THEN '对客户开放' WHEN shows = '^' THEN '不对客户开放' ELSE '根据排名类型对客户开放' END) 是否开放,-- 显示条件；空代表总是显示；`^`代表总是不显示；`^1,3`表示仅排名类型 1,3 隐藏(其余显示)；`2`表示仅对排名类型 2 显示(其余隐藏)；后端过滤好数据给前端，前端不需要了解
       definition                                                                                指标定义
FROM v_ind_lat_l3_flat_wide;

# 变量层面
SELECT -- id,
       -- pid,
       ind_code           指标代码,
       ind_name           指标名称,
       code               变量代码,
       name               变量名称,
       detail_target_ver  默认监测年份,
       detail_avail_ver   变量年份范围,
       detail_ver_rule    变量取值规则,
       detail_sources     变量来源优先级,
       detail_access_rule 计算类型（包含了去重规则）,
       detail_filter      变量过滤条件,
       detail_weight      变量权重
FROM v_ind_lat_l4_flat_wide;

# 数据源层面
SELECT A.ind_code 指标代码, B.name 指标名称, A.name 来源名称, A._new_src_id 新平台来源ID, A._old_src_id 老平台来源ID
FROM c_ind_source               A
     LEFT JOIN indicator_latest B ON A.ind_code = B.code
WHERE B.name IS NOT NULL
  AND A._new_src_id IS NOT NULL;








































