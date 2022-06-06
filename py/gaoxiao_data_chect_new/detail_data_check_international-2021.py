#! /usr/bin/python
# -*- coding: utf-8 -*-

import requests
import pandas as pd
import re
import json
import time

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/85.0.4183.121 Safari/537.36'
}


target_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getInternationalMenu'

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=njtu927&password=1212'
headers['Content-Type'] = 'application/json'
headers['Authorization'] = 'Bearer %s'

query_school_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getInternationalSchoolInfo'

# 每个页面的query_url不同，指标数据接口不同
query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getInternationalVsData'
query_data = {"indicatordata":["34"],"rangeyear":"2017-2021","institution":[],"pageIndex":1,"pageSize":3000,"sort":"asc","sortColumn":"defaultSort","isContain":"true"}
# 省市页面的详细数据接口
detail_query_data_year = {"indicatorid":"34","rangeyear":"2017-2021","institution":["RI02779"],"school_name": "麻省理工学院",
                    "pageIndex":1,"pageSize":3000}
detail_query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getInternationalVsDataDetails' #getProvincesDataDetails
# 登录并获取指标清单
login = requests.post(url=login_url, headers=headers).json()
headers['Authorization'] = 'Bearer %s' % login['jwtToken']
target_info = requests.post(url=target_url, headers=headers, data=json.dumps({"membername": "cufe1228"})).json()
id_list = [target['indicatorid'] for target in target_info['data']['allTarget']]
name_list = [target['indicatorname'] for target in target_info['data']['allTarget']]
have_detail = [target['havedetail'] for target in target_info['data']['allTarget']]
year_range = [target.get('yearrange', '0') for target in target_info['data']['allTarget']]
sumtype = [target.get('sumtype', '0') for target in target_info['data']['allTarget']]
data_df = pd.DataFrame(data={'id': id_list, 'name': name_list, 'have_detail': have_detail, 'year_range': year_range,
                             'sumtype': sumtype})
data_df = data_df.loc[(data_df['have_detail'] == 1) & (data_df['sumtype'].isin(['jishu', 'qiuhe']))]
check_list = data_df.values.tolist()

#获取所有学校列表当参数
login = requests.post(url=login_url, headers=headers).json()
headers['Authorization'] = 'Bearer %s' % login['jwtToken']
school_list = requests.post(url=query_school_url, headers=headers, data=json.dumps({})).json()
query_data['institution'] = [school.get('schoolCode', '') for school in school_list['data']]

# 验证数据
count = 0
while count < len(check_list):
    login = requests.post(url=login_url, headers=headers).json()
    headers['Authorization'] = 'Bearer %s' % login['jwtToken']
    try:
        for i in range(count, len(check_list)):
            print(i)

            check = check_list[i]
            query_data['indicatordata'] = [str(check[0])]
            if check[3] is None: #新加的判断条件
                range_list = [2019]
            elif len(check[3]) == 4:
                range_list = list(range(int(check[3]), int(check[3])))
            elif len(check[3]) < 4:
                range_list = [2019]
            else:
                range_list = list(range(int(check[3][:4]), int(check[3][5:])+1))

            for yy in range_list:
                query_data['rangeyear'] = str(yy) + '-' + str(yy)
                data_page = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()
                if data_page['data'] is not None:
                    for dic in data_page['data']['data']:
                        if str(dic[str(check[0])]) != '0':
                            detail_query_data_year['institution'] = [dic['institutionCode']]
                            detail_query_data_year['school_name'] = [dic['institutionName']]
                            detail_query_data_year['indicatorid'] = str(check[0])
                            detail_query_data_year['rangeyear'] = str(yy) + '-' + str(yy)
                            detail_data = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data_year)).json()
                            # 计数
                            if check[-1] == 'jishu':
                                if str(dic[str(check[0])]) != str(detail_data['data']['total']):
                                    print(check, dic['institutionName'], yy)
                            # 求和
                            else:
                                #新加的判断条件
                                if float(dic[str(check[0])].replace(',', '')) != sum([float(p['indicatorValue'].replace(',', '')) for p in detail_data['data']['personInfo']]):
                                    aa = float(dic[str(check[0])].replace(',', '')) - sum([float(p['indicatorValue'].replace(',', '')) for p in detail_data['data']['personInfo']])
                                    print(check, dic['institutionName'], yy, aa)

        count = len(check_list)
    # 出现错误时，从错误处中断，再从该处开始
    except Exception as err:
        print('ERROR:%s' % err)
        count = i
        time.sleep(10)


