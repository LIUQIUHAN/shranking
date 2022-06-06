
# 第一步：更新内测全部指标表指标年份 rank_tbl_module_info_no_edition ;

# 第二步：更新基础数据表数据 rank_tbl_basics_target_data;

# 第三步：页面操作 - 历史数据运算;

# 第四步：更改标签表版本号 rank_tbl_batch_update_record_re , 更新发版指标信息表 rank_tbl_module_info_issue; 删除要操作版本的替代值数据
                         
#					          →  页面操作 - 版本发布:

-- 1. 重置数据

-- 2. SQL - '发版：i49b&i51b发版时补充最小值为替代值'（计算均值之前插入 - 替代值页面）   --> 继续发版

-- 3. 发版完成 --> 标签表切换回 rank_tbl_batch_update_record

-- 第五步：SQL - '发版：c特殊处理-教育部奖励折合数等'

-- 第六步：SQL - '发版：d指标标签更新'

-- 第七步：版本切换 rank_tbl_issue_month; 同步至正式平台时, 须在页面操作  →  同步正式平台, 然后再进行版本切换

-- 第八步：排名指标消息推送（APP + 平台）

# 删除要操作版本的替代值数据
# 删除要操作版本的临时数据（核心指标数据）
# 获取核心指标信息,插入要发版数据表	rank_tbl_module_info_issue

-- SET @Edition_year = '202206';
-- DELETE
--   FROM rank_tbl_ranking_fixed_val_issue
--  WHERE edition_year = @Edition_year;
-- DELETE
--   FROM rank_tbl_ranking_fixed_val
--  WHERE edition_year = @Edition_year;
-- 
-- DELETE
--   FROM rank_tbl_module_info_issue
--  WHERE edition_year = @Edition_year;
-- INSERT INTO rank_tbl_module_info_issue (edition_year,
--                                         order_num,
--                                         type1No,
--                                         module_id,
--                                         module_nm, module_detail_name,
--                                         dimension_sort,
--                                         Dimension_names,
--                                         target_code,
--                                         target_name,
--                                         target_nm,
--                                         target_explain,
--                                         target_level,
--                                         default_year,
--                                         data_year_range,
--                                         year_choose_type,
--                                         parent_code,
--                                         unit,
--                                         decimalPoint,
--                                         indiMax,
--                                         mu_id,
--                                         numerator,
--                                         is_date_box,
--                                         is_increment,
--                                         is_rank,
--                                         is_kernel,
--                                         haveDetail,
--                                         table_type,
--                                         isEditable,
--                                         zero_meaning,
--                                         verification,
--                                         ranking_Type,
--                                         max_zonghe,
--                                         max_minban,
--                                         max_duli,
--                                         is_flashback,
--                                         is_pdf_show)
-- SELECT @Edition_year AS edition_year,
--        order_num,
--        type1No,
--        module_id,
--        module_nm,
--        module_detail_name,
--        dimension_sort,
--        Dimension_names,
--        target_code,
--        target_name,
--        target_nm,
--        target_explain,
--        target_level,
--        default_year,
--        data_year_range,
--        year_choose_type,
--        parent_code,
--        unit,
--        decimalPoint,
--        indiMax,
--        mu_id,
--        numerator,
--        is_date_box,
--        is_increment,
--        is_rank,
--        is_kernel,
--        haveDetail,
--        table_type,
--        isEditable,
--        zero_meaning,
--        verification,
--        ranking_Type,
--        max_zonghe,
--        max_minban,
--        max_duli,
--        is_flashback,
--        is_pdf_show
--   FROM rank_tbl_module_info_no_edition
--  WHERE is_kernel = '1';