#! /usr/bin/python
# -*- coding: utf-8 -*-

import requests
import pandas as pd
import re
import json
import time

from src.Scopus_Crawler.scopus_config import headers


target_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getinstindimenu'

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=cufe1228&password=1212'
headers['Content-Type'] = 'application/json'
headers['Authorization'] = 'Bearer %s'
# 每个页面的query_url不同，指标数据接口不同
query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getinstVSIndicatorData'
query_data = {"pageIndex":1,"pageSize":3000,"sort":"asc","rangeyear":"2017-2021",
              "indicatordata":["33"],"institution":["A0001",""],"sortColumn":"institutionName"}
# 每个页面的详细数据接口都相同
detail_query_data_year = {"institution":["A0311"],"indicatorid":33,"rangeyear":"2017-2021","pageIndex":1,"pageSize":3000}
detail_query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getdetailData'
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

# 获取学校清单
school_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getFilterInfo'
school_info = requests.post(url=school_url, headers=headers, data=json.dumps({"membername": "cufe1228",
                                                                              "statusCd": "0"})).json()
school_list = [school['schoolCode'] for school in school_info['data']['schoolList']]

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
            if len(check[3]) == 4:
                range_list = list(range(int(check[3]), int(check[3])))
            elif len(check[3]) < 4:
                range_list = [2019]
            else:
                range_list = list(range(int(check[3][:4]), int(check[3][5:])+1))

            for school_code in school_list:
                for yy in range_list:
                    query_data['rangeyear'] = str(yy) + '-' + str(yy)
                    query_data['institution'] = [school_code, '']
                    data_page = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()
                    for dic in data_page['data']['indidata']['data']:
                        if str(dic['school1']) != '0':
                            detail_query_data_year['institution'] = [school_code]
                            detail_query_data_year['indicatorid'] = check[0]
                            detail_query_data_year['rangeyear'] = str(yy) + '-' + str(yy)
                            detail_data = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data_year)).json()
                            # 计数
                            if check[-1] == 'jishu':
                                if str(dic['school1']) != str(detail_data['data']['total']):
                                    print(check, dic['institutionname'], yy)
                            # 求和
                            else:
                                if str(dic['school1']) != sum([p['projectWeight'] for p in detail_data['data']['personInfo']]):
                                    print(check, dic['institutionname'], yy)

        count = len(check_list)
    # 出现错误时，从错误处中断，再从该处开始
    except Exception as err:
        print('ERROR:%s' % err)
        count = i
        time.sleep(60)


