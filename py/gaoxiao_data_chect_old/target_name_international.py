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

target_url = 'http://121.36.12.98:9081/rank-subject-server/instinApi/getInternationalMenu'

login_url = 'http://121.36.12.98:9081/rank-subject-server/login?username=cufe1228&password=1212'
headers['Content-Type'] = 'application/json'
login = requests.post(url=login_url, headers=headers).json()
headers['Authorization'] = 'Bearer %s' % login['jwtToken']
target_info = requests.post(url=target_url, headers=headers, data=json.dumps({"membername": "cufe1228"})).json()
for target_dic in target_info['data']['allTarget']:
    if 'unit' in target_dic and target_dic['unit'] != '%' and target_dic['unit'] != '':
        target_dic['title'] = target_dic['indicatorShort'] + '（' + target_dic['unit'] + '）'
        target_dic['title2'] = target_dic['indicatorShort'] + '</div><div>' + '（' + target_dic['unit'] + '）'
    else:
        target_dic['title'] = target_dic['indicatorShort']
        target_dic['title2'] = target_dic['indicatorShort']

# 浏览器选项
options = ChromeOptions()
# 添加代理地址
options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                     'Chrome/81.0.4044.138 Safari/537.36')

driver = webdriver.Chrome(driver_path, options=options)
driver.maximize_window()
url = 'http://121.36.12.98:9081/#/home'
driver.get(url=url)
driver.find_elements_by_tag_name('input')[0].send_keys('cufe1228')
driver.find_elements_by_tag_name('input')[1].send_keys('1212')
driver.find_element_by_tag_name('button').click()
time.sleep(4)
driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[1]/div/div[2]/div[6]').click()
time.sleep(2)
for i, target_dic in enumerate(target_info['data']['allTarget']):
    print(i)
    driver.find_element_by_xpath('//*[@id="searchInput22"]/div/input').click()
    driver.find_element_by_xpath('//*[@id="searchInput22"]/div/input').send_keys(target_dic['indicatorname'])
    time.sleep(2)
    if target_dic['indicatorname'] in ['马工程教材合计', '教育部人文社会科学重点研究基地', '菲尔兹奖']:
        driver.find_element_by_xpath('//*[@id="searchContent"]/div[2]/div[2]/div[2]/div').click()
    else:
        driver.find_element_by_xpath('//*[@id="searchContent2"]/div[2]/div[1]/div[1]/div').click()
    time.sleep(2)
    # 指标表头+单位对比
    if target_dic['title'] not in driver.page_source and target_dic['title2'] not in driver.page_source:
        print(target_dic['indicatorname'] + '表格表头显示有误')

    driver.find_element_by_xpath('//*[@id="searchInput22"]/div/input').clear()
    driver.find_element_by_xpath('//*[@id="app"]/div/div[1]/div[2]/div/div[2]/div[1]/div[2]/div[3]/div[2]').click()
    time.sleep(1)
    driver.find_element_by_class_name('layui-layer-btn0').click()

driver.close()

