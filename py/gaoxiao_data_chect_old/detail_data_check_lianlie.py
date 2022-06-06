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


target_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getinstindimenu'

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=njtu928&password=1212'
headers['Content-Type'] = 'application/json'
headers['Authorization'] = 'Bearer %s'
# 每个页面的query_url不同，指标数据接口不同
query_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getmoreIndicatorData'
query_data = {"indicatordata":["39"],"rangeyear":"2017-2021","schoolList":{"schoolCodeList":[],"isContain":True},"groupList":{"schoolCodeList":[],"isContain":True},"filterList":[{"name":"主管部门","filterList1":[{"name":"教育部","filterList2":[]},{"name":"其他部委","filterList2":["工业和信息化部","国家卫生健康委员会","外交部","公安部","国家体育总局","国家民委","中华妇女联合会","共青团中央","中华全国总工会","中国科学院","交通运输部（中国民用航空局）","应急管理部","中国地震局","司法部","交通运输部","海关总署","上海市 中国科学院","中央统战部","中央办公厅","中国社会科学院","空军装备部"]},{"name":"地方","filterList2":["北京市","天津市","河北省","山西省","内蒙古自治区","辽宁省","吉林省","黑龙江省","上海市","上海市教委","江苏省","浙江省","安徽省","福建省","江西省","山东省","河南省","湖北省","湖南省","广东省","广西壮族自治区","海南省","重庆市","四川省","贵州省","云南省","西藏自治区","陕西省","甘肃省","青海省","宁夏回族自治区","新疆维吾尔自治区","新疆生产建设兵团","河南省教育厅","浙江省教育厅","北京市教委","四川省教育厅","天津市教委","河北省教育厅","山西省教育厅","辽宁省教育厅","吉林省教育厅","黑龙江省教育厅","江苏省教育厅","安徽省教育厅","福建省教育厅","江西省教育厅","山东省教育厅","湖北省教育厅","湖南省教育厅","广东省教育厅","广西壮族自治区教育厅","海南省教育厅","重庆市教委","云南省教育厅","陕西省教育厅","宁夏自治区教育厅","贵州省教育厅","内蒙古自治区教育厅","甘肃省教育厅","青海省教育厅","新疆自治区教育厅","新疆生产建设兵团教育局"]},{"name":"军校","filterList2":["中国人民解放军空军","中国人民解放军火箭军","中国人民解放军海军","中国人民解放军陆军","中国人民解放军战略支援部队网络系统部","中国人民解放军总政治部","中国人民解放军战略支援部队航天系统部","中国人民武装警察部队后勤部","中国人民武装警察部队总部","中华人民共和国中央军事委员会"]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"所在地","filterList1":[{"name":"北京市","filterList2":[]},{"name":"天津市","filterList2":[]},{"name":"河北省","filterList2":["石家庄市","唐山市","秦皇岛市","邯郸市","邢台市","保定市","张家口市","承德市","沧州市","廊坊市","衡水市"]},{"name":"山西省","filterList2":["太原市","大同市","阳泉市","长治市","晋城市","朔州市","晋中市","运城市","忻州市","临汾市","吕梁市"]},{"name":"内蒙古自治区","filterList2":["呼和浩特市","包头市","乌海市","赤峰市","通辽市","鄂尔多斯市","呼伦贝尔市","巴彦淖尔市","乌兰察布市","兴安盟","锡林郭勒盟","阿拉善盟"]},{"name":"辽宁省","filterList2":["沈阳市","大连市","鞍山市","抚顺市","本溪市","丹东市","锦州市","营口市","阜新市","辽阳市","盘锦市","铁岭市","朝阳市","葫芦岛市"]},{"name":"吉林省","filterList2":["长春市","吉林市","四平市","辽源市","通化市","白山市","松原市","白城市","延边朝鲜族自治州"]},{"name":"黑龙江省","filterList2":["哈尔滨市","齐齐哈尔市","鸡西市","鹤岗市","双鸭山市","大庆市","伊春市","佳木斯市","七台河市","牡丹江市","黑河市","绥化市","大兴安岭地区"]},{"name":"上海市","filterList2":[]},{"name":"江苏省","filterList2":["南京市","无锡市","徐州市","常州市","苏州市","南通市","连云港市","淮安市","盐城市","扬州市","镇江市","泰州市","宿迁市"]},{"name":"浙江省","filterList2":["杭州市","宁波市","温州市","嘉兴市","湖州市","绍兴市","金华市","衢州市","舟山市","台州市","丽水市"]},{"name":"安徽省","filterList2":["合肥市","芜湖市","蚌埠市","淮南市","马鞍山市","淮北市","铜陵市","安庆市","黄山市","滁州市","阜阳市","宿州市","六安市","亳州市","池州市","宣城市"]},{"name":"福建省","filterList2":["福州市","厦门市","莆田市","三明市","泉州市","漳州市","南平市","龙岩市","宁德市"]},{"name":"江西省","filterList2":["南昌市","景德镇市","萍乡市","九江市","新余市","鹰潭市","赣州市","吉安市","宜春市","抚州市","上饶市"]},{"name":"山东省","filterList2":["大连市","济南市","青岛市","淄博市","枣庄市","东营市","烟台市","潍坊市","济宁市","泰安市","威海市","日照市","临沂市","德州市","聊城市","滨州市","菏泽市"]},{"name":"河南省","filterList2":["郑州市","开封市","洛阳市","平顶山市","安阳市","鹤壁市","新乡市","焦作市","濮阳市","许昌市","漯河市","三门峡市","南阳市","商丘市","信阳市","周口市","驻马店市"]},{"name":"湖北省","filterList2":["武汉市","黄石市","十堰市","宜昌市","襄阳市","鄂州市","荆门市","孝感市","荆州市","黄冈市","咸宁市","随州市","恩施土家族苗族自治州"]},{"name":"湖南省","filterList2":["长沙市","株洲市","湘潭市","衡阳市","邵阳市","岳阳市","常德市","张家界市","益阳市","郴州市","永州市","怀化市","娄底市","湘西土家族苗族自治州"]},{"name":"广东省","filterList2":["广州市","韶关市","深圳市","珠海市","汕头市","佛山市","江门市","湛江市","茂名市","肇庆市","惠州市","梅州市","汕尾市","河源市","阳江市","清远市","东莞市","中山市","潮州市","揭阳市","云浮市"]},{"name":"广西壮族自治区","filterList2":["南宁市","柳州市","桂林市","梧州市","北海市","钦州市","贵港市","玉林市","百色市","贺州市","河池市","来宾市","崇左市"]},{"name":"海南省","filterList2":["海口市","三亚市"]},{"name":"重庆市","filterList2":[]},{"name":"四川省","filterList2":["成都市","自贡市","攀枝花市","泸州市","德阳市","绵阳市","广元市","遂宁市","内江市","乐山市","南充市","眉山市","宜宾市","广安市","达州市","雅安市","巴中市","资阳市","阿坝藏族羌族自治州","甘孜藏族自治州","凉山彝族自治州"]},{"name":"贵州省","filterList2":["贵阳市","六盘水市","遵义市","安顺市","毕节市","铜仁市","黔西南布依族苗族自治州","黔东南苗族侗族自治州","黔南布依族苗族自治州"]},{"name":"云南省","filterList2":["昆明市","曲靖市","玉溪市","保山市","昭通市","丽江市","普洱市","临沧市","楚雄彝族自治州","红河哈尼族彝族自治州","文山壮族苗族自治州","西双版纳傣族自治州","大理白族自治州","德宏傣族景颇族自治州"]},{"name":"西藏自治区","filterList2":["拉萨市","林芝市"]},{"name":"陕西省","filterList2":["西安市","铜川市","宝鸡市","咸阳市","渭南市","延安市","汉中市","榆林市","安康市","商洛市"]},{"name":"甘肃省","filterList2":["兰州市","嘉峪关市","金昌市","白银市","天水市","武威市","张掖市","平凉市","酒泉市","庆阳市","定西市","陇南市","甘南藏族自治州"]},{"name":"青海省","filterList2":["西宁市","海东市","海西蒙古族藏族自治州"]},{"name":"宁夏回族自治区","filterList2":["银川市","石嘴山市","吴忠市","固原市"]},{"name":"新疆维吾尔自治区","filterList2":["乌鲁木齐市","克拉玛依市","吐鲁番市","哈密市","昌吉回族自治州","博尔塔拉蒙古自治州","巴音郭楞蒙古自治州","阿克苏地区","克孜勒苏柯尔克孜自治州","喀什地区","和田地区","伊犁哈萨克自治州","塔城地区","阿勒泰地区"]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校类型","filterList1":[{"name":"综合类","filterList2":[]},{"name":"理工类","filterList2":[]},{"name":"财经类","filterList2":[]},{"name":"艺术类","filterList2":[]},{"name":"农业类","filterList2":[]},{"name":"林业类","filterList2":[]},{"name":"医药类","filterList2":[]},{"name":"师范类","filterList2":[]},{"name":"体育类","filterList2":[]},{"name":"语文类","filterList2":[]},{"name":"政法类","filterList2":[]},{"name":"民族类","filterList2":[]},{"name":"军事类","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校层次","filterList1":[{"name":"博士","filterList2":[]},{"name":"硕士","filterList2":[]},{"name":"本科","filterList2":[]},{"name":"专科","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校性质","filterList1":[{"name":"公办","filterList2":[]},{"name":"民办","filterList2":[]},{"name":"合作办学","filterList2":[]},{"name":"民办独立学院","filterList2":[]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"学校特性","filterList1":[{"name":"重点建设","filterList2":["一流大学","一流学科","985","211"]},{"name":"学校分组","filterList2":["部省合建","副部","强基计划试点高校","强军计划高校","省部共建","34所自主划线高校","研究生院","北京高科大学联盟","高水平行业特色大学优质资源共享联盟","国防七子","华东五校","建筑老八校","建筑新八校","金融四校","九校联盟（C9）","两财一贸","两电一邮","南药北药","全国地方高水平大学联盟","全国九所地方综合性大学协作会（SC9）","全国政法类大学立格联盟","四大工学院","外语九大名校","五院四系","武汉七校联盟","中西部“一省一校”国家重点建设大学联盟(Z14)","卓越大学联盟（E9）"]}],"filter1":[],"filter2":[],"isContain":True,"text":"","filter":[]},{"name":"国家/地区","filterList1":[],"filter1":[],"filter2":[],"isContain":True,"text":""},{"name":"国际学校类型","filterList1":[],"filter1":[],"filter2":[],"isContain":True,"text":""}],
              "pageIndex":1,"pageSize":3000,"sort":"asc","sortColumn":"schoolOrder"}
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
data_df = data_df.loc[(data_df['have_detail'] == 1) & (data_df['sumtype'].isin(['qiuhe', 'jishu']))]
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
            query_data['indicatordata'] = [str(check[0])]
            if len(check[3]) == 4:
                range_list = list(range(int(check[3]), int(check[3])))
            elif len(check[3]) < 4:
                range_list = [2019]
            else:
                range_list = list(range(int(check[3][:4]), int(check[3][5:])+1))

            for yy in range_list:
                query_data['rangeyear'] = str(yy) + '-' + str(yy)
                data_page = requests.post(url=query_url, headers=headers, data=json.dumps(query_data)).json()
                for dic in data_page['data']['indidata']['data']:
                    if str(dic[str(check[0])]) != '0':
                        detail_query_data_year['institution'] = [dic['institutionCode']]
                        detail_query_data_year['indicatorid'] = check[0]
                        detail_query_data_year['rangeyear'] = str(yy) + '-' + str(yy)
                        detail_data = requests.post(url=detail_query_url, headers=headers, data=json.dumps(detail_query_data_year)).json()
                        # 计数
                        if check[-1] == 'jishu':
                            if str(dic[str(check[0])]) != str(detail_data['data']['total']):
                                print(check, dic['institutionName'], yy)
                        # 求和
                        else:
                            try:
                                if int(dic[str(check[0])].replace(',', '')) != sum([p['projectWeight'] for p in detail_data['data']['personInfo']]):
                                    aa = int(dic[str(check[0])].replace(',', '')) - sum([p['projectWeight'] for p in detail_data['data']['personInfo']])
                                    print(check, dic['institutionName'], yy, aa)
                            except Exception:
                                if int(dic[str(check[0])].replace(',', '')) != sum([int(p['projectMoney'].replace(',', '')) for p in detail_data['data']['personInfo']]):
                                    aa = int(dic[str(check[0])].replace(',', '')) - sum([int(p['projectMoney'].replace(',', '')) for p in detail_data['data']['personInfo']])
                                    print(check, dic['institutionName'], yy, aa)

        count = len(check_list)
    # 出现错误时，从错误处中断，再从该处开始
    except Exception as err:
        print('ERROR:%s' % err)
        count = i
        time.sleep(60)


