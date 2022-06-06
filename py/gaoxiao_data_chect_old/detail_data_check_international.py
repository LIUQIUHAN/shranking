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

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=njtu928&password=1212'
headers['Content-Type'] = 'application/json'
headers['Authorization'] = 'Bearer %s'
# 每个页面的query_url不同，指标数据接口不同
query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getProvincesData'
query_data = {"indicatorIds":["34"],"rangeyear":"2017-2021","filterList":[{"name":"主管部门","filterList1":[{"name":"教育部","filterList2":[]},{"name":"其他部委","filterList2":["工业和信息化部","国家卫生健康委员会","外交部","公安部","国家体育总局","国家民委","中华妇女联合会","共青团中央","中华全国总工会","中国科学院","交通运输部（中国民用航空局）","应急管理部","中国地震局","司法部","交通运输部","海关总署","上海市 中国科学院","中央统战部","中央办公厅","中国社会科学院","空军装备部"]},{"name":"地方","filterList2":["北京市","天津市","河北省","山西省","内蒙古自治区","辽宁省","吉林省","黑龙江省","上海市","上海市教委","江苏省","浙江省","安徽省","福建省","江西省","山东省","河南省","湖北省","湖南省","广东省","广西壮族自治区","海南省","重庆市","四川省","贵州省","云南省","西藏自治区","陕西省","甘肃省","青海省","宁夏回族自治区","新疆维吾尔自治区","新疆生产建设兵团","河南省教育厅","浙江省教育厅","北京市教委","四川省教育厅","天津市教委","河北省教育厅","山西省教育厅","辽宁省教育厅","吉林省教育厅","黑龙江省教育厅","江苏省教育厅","安徽省教育厅","福建省教育厅","江西省教育厅","山东省教育厅","湖北省教育厅","湖南省教育厅","广东省教育厅","广西壮族自治区教育厅","海南省教育厅","重庆市教委","云南省教育厅","陕西省教育厅","宁夏自治区教育厅","贵州省教育厅","内蒙古自治区教育厅","甘肃省教育厅","青海省教育厅","新疆自治区教育厅","新疆生产建设兵团教育局"]},{"name":"军校","filterList2":["中国人民解放军空军","中国人民解放军火箭军","中国人民解放军海军","中国人民解放军陆军","中国人民解放军战略支援部队网络系统部","中国人民解放军总政治部","中国人民解放军战略支援部队航天系统部","中国人民武装警察部队后勤部","中国人民武装警察部队总部","中华人民共和国中央军事委员会"]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校类型","filterList1":[{"name":"综合类","filterList2":[]},{"name":"理工类","filterList2":[]},{"name":"财经类","filterList2":[]},{"name":"艺术类","filterList2":[]},{"name":"农业类","filterList2":[]},{"name":"林业类","filterList2":[]},{"name":"医药类","filterList2":[]},{"name":"师范类","filterList2":[]},{"name":"体育类","filterList2":[]},{"name":"语文类","filterList2":[]},{"name":"政法类","filterList2":[]},{"name":"民族类","filterList2":[]},{"name":"军事类","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校层次","filterList1":[{"name":"博士","filterList2":[]},{"name":"硕士","filterList2":[]},{"name":"本科","filterList2":[]},{"name":"专科","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校性质","filterList1":[{"name":"公办","filterList2":[]},{"name":"民办","filterList2":[]},{"name":"合作办学","filterList2":[]},{"name":"民办独立学院","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校特性","filterList1":[{"name":"重点建设","filterList2":["一流大学","一流学科","985","211"]},{"name":"学校分组","filterList2":["部省合建","副部","强基计划试点高校","强军计划高校","省部共建","34所自主划线高校","研究生院","北京高科大学联盟","高水平行业特色大学优质资源共享联盟","国防七子","华东五校","建筑老八校","建筑新八校","金融四校","九校联盟（C9）","两财一贸","两电一邮","南药北药","全国地方高水平大学联盟","全国九所地方综合性大学协作会（SC9）","全国政法类大学立格联盟","四大工学院","外语九大名校","五院四系","武汉七校联盟","中西部“一省一校”国家重点建设大学联盟(Z14)","卓越大学联盟（E9）"]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"国家/地区","filterList1":[],"filter1":[],"filter2":[],"isContain":True,"text":""},{"name":"国际学校类型","filterList1":[],"filter1":[],"filter2":[],"isContain":True,"text":""}],"provinceNames":[],"cityNames":[],
              "pageIndex":1,"pageSize":3000,"sort":"asc","sortColumn":"cityCode","isContain":"true"}
# 省市页面的详细数据接口
detail_query_data_year = {"indicatorIds":["34"],"cityNames":[],"provinceNames":["北京市"],"rangeyear":"2017-2021",
                          "unit":"个","category":[],"type":[],"hierarchy":[],"pageIndex":1,"pageSize":3000}
detail_query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getProvincesDataDetails'
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
# 验证数据
count = 0
while count < len(check_list):
    login = requests.post(url=login_url, headers=headers).json()
    headers['Authorization'] = 'Bearer %s' % login['jwtToken']
    try:
        for i in range(count, len(check_list)):
            print(i)
            check = check_list[i]
            query_data['indicatorIds'] = [str(check[0])]
            if len(check[3]) == 4:
                range_list = list(range(int(check[3]), int(check[3])))
            elif len(check[3]) < 4:
                range_list = [2019]
            else:
                range_list = list(range(int(check[3][:4]), int(check[3][5:])+1))

            for yy in range_list:
                query_data['rangeyear'] = str(yy) + '-' + str(yy)
                data_page = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()
                for dic in data_page['data']['data']:
                    if str(dic[str(check[0])]) != '0':
                        detail_query_data_year['provinceNames'] = [dic['province']]
                        detail_query_data_year['indicatorIds'] = [str(check[0])]
                        detail_query_data_year['rangeyear'] = str(yy) + '-' + str(yy)
                        detail_data = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data_year)).json()
                        # 计数
                        if check[-1] == 'jishu':
                            if str(dic[str(check[0])]) != str(detail_data['data']['total']):
                                print(check, dic['province'], yy)
                        # 求和
                        else:
                            if int(dic[str(check[0])]) != sum([p['projectWeight'] for p in detail_data['data']['personInfo']]):
                                print(check, dic['province'], yy)

        count = len(check_list)
    # 出现错误时，从错误处中断，再从该处开始
    except Exception as err:
        print('ERROR:%s' % err)
        count = i
        time.sleep(60)


