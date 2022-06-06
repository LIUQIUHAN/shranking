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
query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/dataQuery'
query_data = {"keyWord":"张三"}
# 省市页面的详细数据接口
detail_query_data_year = {"rangeyear":'null',"institution":["A0003"],"school_name":"清华大学","indicatorid":229,
                          "unit":"","keyWord":"张三","pageIndex":1,"pageSize":3000}
detail_query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getdetailData'
# 登录并获取指标清单
login = requests.post(url=login_url, headers=headers).json()
headers['Authorization'] = 'Bearer %s' % login['jwtToken']
target_info = requests.post(url=target_url, headers=headers, data=json.dumps({"membername": "cufe1228"})).json()

keyword_list = ['张三']

# 验证数据
count = 0
while count < len(keyword_list):
    login = requests.post(url=login_url, headers=headers).json()
    headers['Authorization'] = 'Bearer %s' % login['jwtToken']
    try:
        for i in range(count, len(keyword_list)):
            print(i)
            keyword = keyword_list[i]
            query_data['keyWord'] = keyword
            data_page = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()
            for dic in data_page['data']['data']:
                detail_query_data_year['institution'] = [dic['institutionCode']]
                detail_query_data_year['school_name'] = dic['institutionName']
                detail_query_data_year['indicatorid'] = dic['indicatorid']
                detail_query_data_year['keyWord'] = keyword
                detail_data = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data_year)).json()
                if dic['countValue'] != detail_data['data']['total']:
                    print(keyword, dic)

        count = len(keyword_list)
    # 出现错误时，从错误处中断，再从该处开始
    except Exception as err:
        print('ERROR:%s' % err)
        count = i
        time.sleep(60)


