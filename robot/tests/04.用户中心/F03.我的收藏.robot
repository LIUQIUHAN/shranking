*** Settings ***
Library    Collections

Documentation       shanghairanking.cn - 用户登录功能
...
Resource         ../../resources/CommonFunctionality.robot

Suite Setup  准备开始测试用户登录后可操作之功能
Suite Teardown  完成测试用户登出系统

*** Variables ***


*** Test Cases ***
#Sample Test Case
#    [Documentation]     stc
##    生成指定长度的数值列表  10
#    ${list10}=  生成指定长度的数值列表  10
#    FOR  ${itm}  IN  ${list10}
#        log to console  我${itm}
#    END

获取我的收藏中的院校情况
    [Documentation]  取消当前用用户的所有收藏
    [Tags]     Functional   用户中心

#   todo: 需要单独为`直接访问前端路由`编写单独的测试用例
    KW_进入我的收藏（通过菜单）
    sleep  3s
    KW_取消全部我的收藏

在BCUR排名页面收藏学校
     [Documentation]     检查默认收藏页面显示内容；在BCUR排名页面收藏“清华大学”后，会在“我的收藏”页面中看到已收藏的“清华大学”
     [Tags]     Functional   用户中心

     # 本用例执行前需要先清空所有「我的收藏」
     KW_进入我的收藏（通过菜单）
     sleep  2s
     KW_取消全部我的收藏

     # 开始执行收藏用例
     # 1. 在榜单中执行收藏操作
     # 1.1 进入BCUR榜单页面
     # 1.2 点击收藏按钮，收藏清华大学、浙江大学；点击第2页后收藏西安电子科技大学
     # 1.3 进入「我的收藏」，校验收藏列表是否一致
     go to  ${ROOT_URL}/rankings/bcur/2020
     Wait Until Element Contains  css=div.ant-pagination-options-quick-jumper  跳至
     Log To Console  \n\r---------> 成功打开BCUR页面\n\r
     # 确认page1 univ count == 30
     ${rowCount}=  Get Element Count  xpath=//*[@id="content-box"]/div[2]/table/tbody/tr
     Log To Console  \n\r---------> BCUR page1 rowCount:${rowCount}\n\r
     Should Be Equal As Integers  ${rowCount}  30
     Sleep  10ms

     # 清华大学
    #  ${univName}=  Get Text  xpath=//*[@id="content-box"]/div[2]/table/tbody/tr[1]/td[3]/div/div[2]/div[1]/div/div
     ${univName}=  Get Text  css=table.rk-table > tbody > tr:nth-child(1) > td.align-left > div > div.univname > div:nth-child(1) > div > div > a

     Log To Console  \n\r---------> ${univName}\n\r
     # 收藏清华大学
     Mouse over  css=#content-box > div.rk-table-box > table > tbody > tr:nth-child(1) > td.align-left > div
     Sleep  1s
     Click Element  css=#content-box > div.rk-table-box > table > tbody > tr:nth-child(1) > td.align-left > div > div.univname > div:nth-child(1) > div > div > div > img 
     Sleep  1s

     KW_进入我的收藏（通过菜单）
     Wait Until Element Contains  css=#tab0 > div > div.univ-box > div.univ-nameCn > a > span  清华大学

#     # 2. 在院校列表中执行收藏操作

*** Keywords ***
KW_生成指定长度的数值列表
    [Arguments]     ${ROW_NUM}
    ${UnivColList}=     Create List
    FOR     ${i}        IN RANGE        0   ${ROW_NUM}+1
        ${s}=  Convert To String  ${i}
        Append To List      ${UnivColList}      ${s}
    END
    Return From Keyword  ${UnivColList}

KW_进入我的收藏（通过菜单）
   # 点出菜单
    Click Element  css=div.header-user > div.user-detail > span
    # 点击 - 我的收藏
    Click Element  css=div.user-dropdown > ul > li:nth-child(2)

KW_进入我的收藏（直接访问前端路由）
    go to  ${ROOT_URL}/account/favorites

KW_取消全部我的收藏
    ${uCount}=  Get Element Count  css=div.favorite-container > ul.favorite-list > li
    Log To Console  \n\r---------> 当前收藏学校数量:${uCount}所\n\r

    FOR  ${i}  IN RANGE  1   ${uCount}+1
        log to console  当前处理li的index:${i}
        Mouse Over  css=div.favorite-container > ul.favorite-list > li:nth-child(1)
        Click Element  css=div.favorite-container > ul.favorite-list > li:nth-child(1) > div.favorite-item > button.button
        Sleep  3s
    END

    # 取消收藏后，校验学校列表数量是否为0
    ${uCount}=  Get Element Count  css=div.favorite-container > ul.favorite-list > li
    Should Be Equal As Integers  ${uCount}  0
    # 验证没有收藏的提示信息
    Element Should Contain  css=div.tips > span  暂未收藏
