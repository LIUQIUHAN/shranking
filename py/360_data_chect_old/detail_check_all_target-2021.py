#! /usr/bin/python
# -*- coding: utf-8 -*-

# 测试【全部指标】页面默认的【列表数据】和对应【明细数据的统计】是否一致

import requests
import json
import time
import hashlib
import math
import xlsxwriter

def MD5_demo(str):
    md= hashlib.md5()# 创建md5对象
    md.update(str.encode(encoding='utf-8'))
    return md.hexdigest()

# todo 配置：内测地址
url_base = 'http://www.gaojidata.com/gddata/360data'

# todo 配置：线上地址
# url_base = 'http://product.gaojidata.com/360'

# todo 配置：测试账号及密码（可多个）
user_id = ["sjtu0904"]
password = ["47ec2dd791e31e2ef2076caf64ed9b3d"]

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/85.0.4183.121 Safari/537.36'
}
headers['Content-Type'] = 'application/json'

login_url = url_base + '/userlogin'
version_url = url_base + '/selfInspctionGetEditionYearNew'

# 模块接口
query_list_url = url_base + '/moreDataGetModuleInfo'
query_list_data = {"edition_year": "202108", "is_open": "1", "is_our_open": "1"}

# 模块数据接口
query_url = url_base + '/moreDataDataContrast'
query_data = {"edition_year": "202108", "is_open": "1", "is_our_open": "1"}

# 明细数据接口
detail_query_url = url_base + '/getTargetTableHeadAndDataInfo'
detail_query_data = {
    "dataSourceId": "0",
    "data_year": "2019",
    "edition_year": "202108",
    "is_open": "1",
    "is_our_open": "1",
    "original_year": "2019",
    "school_code_list": ["A0238"],
    "target_code": "i214"
}

# 遍历账号
for index in range(len(user_id)):
    print('用户：',user_id[index],' ----------------------------------------------')
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
    detail_query_data['edition_year'] = version_code

    query_list_data['is_our_open'] = is_our_open
    query_data['is_our_open'] = is_our_open

    query_list_data['is_open'] = is_open
    query_data['is_open'] = is_open

    # 获取指标列表(haveDetail=='1'可展开明细)
    module_list = requests.post(url=query_list_url, headers=headers, data=json.dumps(query_list_data)).json()
    target_list = []
    for module in module_list['data']['moduleStructure']:
        for dimension in module['dimension_list']:
            for target in dimension['target_list']:
                # 过滤掉没有明细的指标
                if target['haveDetail'] == '1':
                    target_list.append(target)

    # 获取指标的学校数据并拼接（默认）
    data_list = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()['data']['dataList']
    for target in target_list:
        # 单个测试（打断点用）
        # if target['target_code'] == 'i68':
        #     print('断点')
        # else:
        #     continue
        try:
            if data_list[target['target_code']] is not None:
                print(target['target_code'])
                # 每个指标暂停时间，防止请求过快，另外，捕获异常
                time.sleep(0.5)
                target['schoolDataList'] = data_list[target['target_code']]
                for schoolData in target['schoolDataList']:
                    detail_query_data['dataSourceId'] = schoolData['original_source']
                    detail_query_data['original_year'] = schoolData['original_year']
                    detail_query_data['school_code_list'] = [schoolData['school_code']]
                    detail_query_data['data_year'] = target["data_year"]
                    detail_query_data['target_code'] = target["target_code"]
                    detail_query = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data)).json()
                    if detail_query['data']['targetdetail'][0]['targetdetaillist'] is not None:
                        detail_query_list = detail_query['data']['targetdetail'][0]['targetdetaillist']
                        if '亿元' in target['unit'] or '万元' in target['unit']:
                            if float(schoolData['target_val']) != sum([float(p['projectMoney']) for p in detail_query_list]):
                                dis = float(schoolData['target_val']) - sum([float(p['projectMoney']) for p in detail_query_list])
                                # 屏蔽内置函数导致的小数点差
                                if math.fabs(dis) >= 0.01:
                                    print(target['target_code'],'：',target['target_name'],'：',schoolData['school_name'],' => 列表数据和明细数据不匹配！',' => ',dis)
                        elif '折合数' in target['target_name']:
                            if float(schoolData['target_val']) != sum([float(p['projectWeight']) for p in detail_query_list]):
                                dis = float(schoolData['target_val']) - sum([float(p['projectWeight']) for p in detail_query_list])
                                # 屏蔽内置函数导致的小数点差
                                if math.fabs(dis) >= 0.01:
                                    print(target['target_code'],'：',target['target_name'],'：',schoolData['school_name'],' => 列表数据和明细数据不匹配！',' => ',dis)
                        # 此处为不处理的指标：含“门类分布”；b60：国家教学名师（总数）；cate080601：国家级与认证专业（总数）；i23：生源质量（新生高考成绩得分）；b91：本科生增值
                        elif (
                            ('门类分布' in target['target_name'])
                            or (target['target_code'] == 'b60')
                            or (target['target_code'] == 'cate080601')
                            or (target['target_code'] == 'i23')
                            or (target['target_code'] == 'b91')
                        ):
                            print('该指标暂不处理 => ',target['target_code'],'：',target['target_name'])
                        else:
                            if float(schoolData['target_val']) != len(detail_query_list):
                                dis = float(schoolData['target_val']) - len(detail_query_list)
                                print(target['target_code'],'：',target['target_name'],'：',schoolData['school_name'],' => 列表数据和明细个数不匹配！',' => ',dis)
                    else:
                        print(target['target_code'],'：',target['target_name'],'：',schoolData['school_name'],' => 没有明细数据！')
            else:
                print(target['target_code'],'：',target['target_name'],' => 该指标没有匹配到数据！')
        # 捕获异常
        except Exception as err:
            print('ERROR:%s' % err)
            time.sleep(5)