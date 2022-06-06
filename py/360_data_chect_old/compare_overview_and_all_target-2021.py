#! /usr/bin/python
# -*- coding: utf-8 -*-

# 测试【数据总览】页面 和【全部指标】页面 最新版相同指标的数值及排名是否一致

import requests
import json
import hashlib
import time
import xlsxwriter

# MD5加密方法
def MD5_demo(str):
    md= hashlib.md5()# 创建md5对象
    md.update(str.encode(encoding='utf-8'))
    return md.hexdigest()

# 判断是否存在该属性
def has_attr(obj,attr):
    attr_list = list(obj.keys())
    if attr in attr_list:
        return True
    else:
        return False

# 页面上的数据展示（仅判断是否是'暂无数据'）
def data_null(target,is_overview):
    if int(target['zero_meaning']) != 0:
        if is_overview:
            if (not has_attr(target,'target_val')) or target['target_val'] == '' or target['target_val'] == '\\':
                return True
        else:
            if (not has_attr(target,'schoolData')) or (not has_attr(target['schoolData'],'target_val')) or target['schoolData']['target_val'] == '' or target['schoolData']['target_val'] == '\\':
                return True
    return False

def my_print(content, excel_list):
    print(content)
    excel_list.append(content)


# todo 配置：内测地址
url_base = 'http://www.gaojidata.com/gddata/360data'

# todo 配置：线上地址
# url_base = 'http://product.gaojidata.com/360'

# todo 配置：测试账号及密码（可多个）
user_id = ["sjtu0904", "fudan0601", "tongji0601", "test11090", "gdufs1105", "zdnblgxy1127"]
password = ["47ec2dd791e31e2ef2076caf64ed9b3d", "5db3eefe46389f747f66cbe190758b6a", "9dd498f528fd6ba77c44b0d032df7299", "5db3eefe46389f747f66cbe190758b6a", "d5777b53c0e8e5f26036f98a3809e628", "63bd96d34d74aa3c0541d24abc723a6c"]

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/85.0.4183.121 Safari/537.36'
}
headers['Content-Type'] = 'application/json'

login_url = url_base + '/userlogin'
version_url = url_base + '/selfInspctionGetEditionYearNew'

# 模块数据接口(数据总览)
query_overview_url = url_base + '/overviewRankTargetInfoOfOneSchool2'
query_overview_data = {"edition_year": "202107","last_edition": "202106","showTypeRank": "1"}

# 模块接口（全部指标）
query_list_url = url_base + '/moreDataGetModuleInfo'
query_list_data = {"edition_year": "202108", "is_open": "1", "is_our_open": "1"}

# 模块数据接口（全部指标）
query_url = url_base + '/moreDataDataContrast'
query_data = {"edition_year": "202108", "is_open": "1", "is_our_open": "1"}

# 导出的内容，长度为1（仅有表头时）不导出
excel_list = []
# 输入表头
my_print(['指标ID', '指标名称', '学校ID', '学校名称', '错误原因', '数据总览', '全部指标', '差值'], excel_list)

# 遍历账号
for index in range(len(user_id)):
    print('用户：'+user_id[index]+'-----------------------------------------------')
    if index != 0:
        time.sleep(2)
    # 登录并获取Cookie (headers['Cookie'] = 'JSESSIONID=01F874295BEEB5F769C6B4D2B553E29C')
    # cookies = requests.post(url=login_url, headers=headers, data=json.dumps({"name": user_id[index], "password":MD5_demo( password[index] ) })).cookies
    cookies = requests.post(url=login_url, headers=headers, data=json.dumps({"name": user_id[index], "password":password[index]})).cookies
    for cookie in cookies:
        if cookie.name == "JSESSIONID":
            headers['Cookie'] = cookie.name+'='+cookie.value

    # 获取版本信息（version_code => '202108'）
    version_list = requests.post(url=version_url, headers=headers,data=json.dumps({})).json()
    version_code = str(version_list['data'][0]['version_code'])
    is_open = str(version_list['data'][0]['is_open'])
    is_our_open = str(version_list['data'][0]['is_our_open'])

    query_list_data['edition_year'] = version_code
    query_data['edition_year'] = version_code
    query_overview_data['edition_year'] = version_code
    query_overview_data['last_edition'] = version_code

    query_list_data['is_our_open'] = is_our_open
    query_data['is_our_open'] = is_our_open

    query_list_data['is_open'] = is_open
    query_data['is_open'] = is_open

    # 获取指标列表(数据总览页面：对比参数 target_val、type_score_rank、target_rank)
    overview_list = requests.post(url=query_overview_url, headers=headers, data=json.dumps(query_overview_data)).json()['data']['dataInfo']
    overview_target_list = []
    for item1 in overview_list:
        for item2 in item1['moduleList']:
            for item3 in item2['dimensionList']:
                overview_target_list.append(item3)

    # 获取指标列表(全部指标页面)
    module_list = requests.post(url=query_list_url, headers=headers, data=json.dumps(query_list_data)).json()
    target_list = []
    for module in module_list['data']['moduleStructure']:
        for dimension in module['dimension_list']:
            for target in dimension['target_list']:
                target_list.append(target)

    # 获取指标默认的学校数据并拼接(全部指标页面)
    data_list = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()['data']['dataList']
    for target in target_list:
        if data_list[target['target_code']] is not None:
            # 自己学校在列表第一个
            target['schoolData'] = data_list[target['target_code']][0]
        else:
            my_print([target['target_code'], target['target_name'], '', '', '全部指标页面没有匹配到数据！'], excel_list)

    # 开始对比（target_val、type_score_rank、target_rank）
    for overview_target in overview_target_list:
        for target in target_list:
            if overview_target['target_code'] == target['target_code']:
                # # 打印当前对比的指标code，看情况是否展示
                # print(overview_target['target_code'])
                try:
                    # # 单个测试（打断点用）
                    # if overview_target['target_code'] == 'patent9':
                    #     print('断点')
                    # else:
                    #     continue

                    # 都是'暂无数据',则不用再判断【数值】、【单科类排名】、【全国所有大学排名】
                    if data_null(overview_target, True) == True and data_null(target, False) == True:
                        continue
                    else:
                        # 判断【数值】是否一致（先判断数据总览页面没有返回 target_val 的情况下）
                        if not has_attr(overview_target, 'target_val') or (not has_attr(target, 'schoolData')) or (not has_attr(target['schoolData'], 'target_val')):
                            if has_attr(target, 'schoolData') and has_attr(target['schoolData'], 'target_val') and target['schoolData']['target_val'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【数值】不匹配！', 'null', target['schoolData']['target_val']], excel_list)
                            if has_attr(overview_target, 'target_val') and overview_target['target_val'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【数值】不匹配！', overview_target['target_val'], 'null'], excel_list)
                        elif float(overview_target['target_val']) != float(target['schoolData']['target_val']):
                            dis = float(overview_target['target_val']) - float(target['schoolData']['target_val'])
                            my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【数值】不匹配！', overview_target['target_val'], target['schoolData']['target_val'], dis], excel_list)

                        # 判断【单科类排名】是否一致
                        if (not has_attr(overview_target, 'type_score_rank')) or (not has_attr(target['schoolData'], 'type_score_rank')):
                            if has_attr(overview_target, 'type_score_rank') and overview_target['type_score_rank'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【单科类排名】不匹配！', overview_target['type_score_rank'], 'null'], excel_list)
                            if has_attr(target['schoolData'], 'type_score_rank') and target['schoolData']['type_score_rank'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【单科类排名】不匹配！', 'null', target['schoolData']['type_score_rank']], excel_list)
                        elif overview_target['type_score_rank'] != target['schoolData']['type_score_rank']:
                            my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【单科类排名】不匹配！', overview_target['type_score_rank'], target['schoolData']['type_score_rank']], excel_list)

                        # 判断【全国所有大学排名】是否一致
                        if (not has_attr(overview_target, 'target_rank')) or (not has_attr(target['schoolData'], 'target_rank')):
                            if has_attr(overview_target, 'target_rank') and overview_target['target_rank'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【全国所有大学排名】不匹配！', overview_target['target_rank'], 'null'], excel_list)
                            if has_attr(target['schoolData'], 'target_rank') and target['schoolData']['target_rank'] != '':
                                my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【全国所有大学排名】不匹配！', 'null', target['schoolData']['target_rank']], excel_list)
                        elif overview_target['target_rank'] != target['schoolData']['target_rank']:
                            my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '数据总览 和 全部指标 的【全国所有大学排名】不匹配！', overview_target['target_rank'], target['schoolData']['target_rank']], excel_list)
                # 捕获异常
                except Exception as err:
                    my_print([target['target_code'], target['target_name'], target['schoolData']['school_code'], target['schoolData']['school_name'], '程序出现异常！'], excel_list)
                    print('ERROR:%s' % err)
                    time.sleep(5)

# 有错误的时候 => 设置并导出生成EXCEL
if len(excel_list) > 1:
    excel_row = 0
    workbook = xlsxwriter.Workbook('compare_result'+time.strftime("%Y-%m-%d-%H%M%S", time.localtime())+'.xlsx') # 建立文件
    worksheet = workbook.add_worksheet(time.strftime("%Y-%m-%d", time.localtime()))
    # 调整EXCEL列宽
    worksheet.set_column(0, 7, 13)
    worksheet.set_column(1, 1, 30)
    worksheet.set_column(3, 3, 22)
    worksheet.set_column(4, 4, 55)
    for content in excel_list:
        for content_index in range(len(content)):
            # 向第excel_row['index']行 插入内容
            worksheet.write(excel_row, content_index, content[content_index])
        excel_row = excel_row + 1
    workbook.close()
else:
    print('没有错误，不生成EXCEL------------------------------')
