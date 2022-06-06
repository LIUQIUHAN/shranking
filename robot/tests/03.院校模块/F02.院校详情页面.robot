*** Settings ***
Library          String
Documentation    shanghairanking.cn - 院校详情页面测试
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup      Start TestCase
Test Teardown   Finish TestCase

*** Test Cases ***
RuZhuYuanXiao

    [Documentation]     点击列表中的具体院校，进入已入住院校的详情页面
    [Tags]      Functional

    # Step 1: 打开院校列表页面
    Go To       ${ROOT_URL}/institution
    Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div       跳至

    # Step 2: 输入关键字：西安电子，点击搜索按钮
    Input Text       css=div.input-box > input    西安电子
    Click Button     css=div.input-box > button

    # Step 3: 提示信息应该为：共查询到 2 所院校
    # Sleep       2s
    Wait Until Element Contains  css=div.univ-container > div.univ-title     共查询到 2 所院校

#     Step 6: 点击西安电子科技大学，进入院校详情页面(查询结果列表中的第一个)
    Click Element  css=#__layout > div > div.out-container > div.school-container > div.univ-container > div:nth-child(2) > div
     Wait Until Element Contains  css=#rec_school > div.title > span  推荐院校

    Log To Console      -------> 进入排名页面

    Element Should Contain      css=#univ_name > span.name-cn    西安电子科技大学
    Element Should Contain      css=#univ_name > span.name-en    Xidian University
    Log To Console      -------> 院校中英文校名显示正常！

    Element Should Contain      css=#univ_addr > div.school-name > span      陕西省
    Element Should Contain      css=#univ_addr > div.school-phone > div > p     029-88204236
    Element Should Contain      css=#univ_addr > div.school-website > span     www.xidian.edu.cn

    # Element Should Be Visible       css=#viewerbox > img
    # Log To Console      -------> 入住院校精选照片显示正常！
