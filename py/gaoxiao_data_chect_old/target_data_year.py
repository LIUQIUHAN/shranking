#! /usr/bin/python
# -*- coding: utf-8 -*-

from selenium import webdriver
from selenium.webdriver import ChromeOptions
import requests
import re
import json
import time

from src.Scopus_Crawler.scopus_config import driver_path
from src.Scopus_Crawler.scopus_config import headers

# selenium局部滚动条控制
# driver.execute_script('document.getElementsByClassName("ivu-table-body ivu-table-overflowY ivu-table-overflowX")[0].scrollLeft=10000')
# driver.execute_script('document.getElementsByClassName("ivu-table-body ivu-table-overflowY ivu-table-overflowX")[0].scrollTop=10000')

target_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getinstindimenu'

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=cufe1228&password=1212'
headers['Content-Type'] = 'application/json'
login = requests.post(url=login_url, headers=headers).json()
headers['Authorization'] = 'Bearer %s' % login['jwtToken']
target_info = requests.post(url=target_url, headers=headers, data=json.dumps({"membername": "cufe1228"})).json()
for target_dic in target_info['data']['allTarget']:
    if 'flag1' not in target_dic:
        target_dic['title'] = target_dic['indicatorShort']
    else:
        target_dic['title'] = target_dic['flag1']
    if 'unit' in target_dic and target_dic['unit'] != '%' and target_dic['unit'] != '':
        target_dic['header_title'] = target_dic['indicatorname'] + '（' + target_dic['unit'] + '）'
    else:
        target_dic['header_title'] = target_dic['indicatorname']

# 浏览器选项
options = ChromeOptions()
# 添加代理地址
options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                     'Chrome/81.0.4044.138 Safari/537.36')

driver = webdriver.Chrome(driver_path, options=options)
url = 'http://121.36.12.98:9081/#/home'
driver.get(url=url)
driver.find_elements_by_tag_name('input')[0].send_keys('cufe1228')
driver.find_elements_by_tag_name('input')[1].send_keys('1212')
driver.find_element_by_tag_name('button').click()
time.sleep(3)
driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[1]/div/div[2]/div[2]').click()
time.sleep(2)
for i, target_dic in enumerate(target_info['data']['allTarget']):
    print(i)
    if target_dic['indicatorid'] not in [66, 67, 68, 161, 162, 182, 187, 195, 284, 285, 502,
                                         503, 504, 505, 506, 507, 509, 590]:

        driver.find_element_by_xpath('//*[@id="searchInput2"]/div/input').click()
        driver.find_element_by_xpath('//*[@id="searchInput2"]/div/input').send_keys(target_dic['indicatorname'])
        time.sleep(2)
        if target_dic['indicatorname'] in ['马工程教材合计', '教育部人文社会科学重点研究基地', '菲尔兹奖']:
            driver.find_element_by_xpath('//*[@id="searchContent"]/div[2]/div[1]/div[2]/div/div').click()
        else:
            driver.find_element_by_xpath('//*[@id="searchContent"]/div[2]/div[1]/div/div/div').click()
        time.sleep(2)
        driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[2]/div/div[1]/div[1]/div[1]/div[3]').click()
        time.sleep(2)
        if target_dic['dataYear'] != '\\':
            year_list1 = re.findall(r'''class="Year"><span>(.*?)</span>''', driver.page_source)
            year_list2 = re.findall(r'''class="Year Yearactive"><span>(.*?)</span>''', driver.page_source)
            year_list3 = re.findall(r'''class="Year Yearbetween"><span>(.*?)</span>''', driver.page_source)
            driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[2]/div/div[1]/div[1]/div[5]/div[2]/div/div[1]/div[1]').click()
            time.sleep(2)
            year_list4 = re.findall(r'''class="Year"><span>(.*?)</span>''', driver.page_source)
            year_list5 = re.findall(r'''class="Year Yearactive"><span>(.*?)</span>''', driver.page_source)
            year_list6 = re.findall(r'''class="Year Yearbetween"><span>(.*?)</span>''', driver.page_source)
            year_list = year_list1 + year_list2 + year_list3 + year_list4 + year_list5 + year_list6
            if len(target_dic['dataYear']) == 4:
                check_year = [str(target_dic['dataYear'])]
            else:
                check_year = [str(year) for year in range(int(target_dic['dataYear'][:4]), int(target_dic['dataYear'][5:])+1)]
            if len(check_year) != len(list(set(check_year).intersection(set(year_list)))):
                print(target_dic['indicatorname'] + '可选年份范围有误')
            driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[2]/div/div[1]/div[1]/div[5]/div[2]/div/div[1]/div[3]').click()
            time.sleep(2)
        else:
            if '当前指标无可选年份' not in driver.page_source:
                print(target_dic['indicatorname'] + '可选年份范围有误')

        driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[2]/div/div[1]/div[1]/div[1]/div[1]').click()
        time.sleep(2)
        driver.find_element_by_xpath('//*[@id="searchInput2"]/div/input').clear()

driver.close()

