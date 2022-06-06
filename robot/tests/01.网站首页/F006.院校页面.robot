*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Resource         ../../resources/CommonFunctionality.robot

Suite Setup       Start TestCase
Suite Teardown    Finish TestCase

*** Variables ***
#${SEARCH_TEXT}      xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[1]/div/input
${SEARCH_TEXT}      css=div.input-box > input.input

*** Test Cases ***
从首页打开院校页面
    [Documentation]     首页点击「院校」链接，页面跳转到「院校」页面
    [Tags]  Functional

    打开院校页面

检查页面默认显示
    [Documentation]
    ...     1.筛选标签默认显示全部地区、全部类型、全部层次的学校
    ...
    ...     2.查询结果列表默认显示所有学校
    [Tags]  Functional

    Go To       ${ROOT_URL}/institution
    Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div       跳至
    # 地区默认选中全部
    ${class_str}=    Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[1]/div/div[2]/ul/li[1]      class
    Should Contain      ${class_str}             select-active

    # 学校类型默认选中全部
    ${class_str}=       Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[2]/div/div[2]/ul/li[1]      class
    Should Contain      ${class_str}                select-active

    # 学校层次默认选中全部
    ${class_str}=       Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[3]/div/div[2]/ul/li[1]      class
    Should Contain      ${class_str}                select-active

    Element Should Be Visible       class=univ-title
    Element Should Contain          class=univ-title        共查询到


学校模糊搜索 - 中文
    [Documentation]  在「学校名称」搜索框输入学校关键字执行模糊搜索，搜索结果记录都是包含关键字的学校
    [Tags]  Functional

    打开院校页面
    Input Text      ${SEARCH_TEXT}      上海交通
    Press Keys      ${SEARCH_TEXT}      RETURN
    Sleep       200ms
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[2]/div/div[2]/div[1]     上海交通大学

    Sleep       50ms

学校模糊搜索 - 拼音首字母
    [Documentation]  在「学校名称」搜索框输入学校拼音的首字母，搜索结果记录都是包含拼音首字母匹配的学校
    [Tags]  Functional

    打开院校页面
    Clear Element Text      ${SEARCH_TEXT}
    Input Text      ${SEARCH_TEXT}      bjhk
    Press Keys      ${SEARCH_TEXT}      RETURN
    Sleep       2s
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[2]       北京航空
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[3]       北京航空

    Sleep       1s

# 学校筛选(按院校属地)
test001
    [Documentation]  在「按院校所属省份」标签中选中"天津"，查询到的学校列表"省市"列都应该是"天津"
    [Tags]  Functional

    Go To       ${ROOT_URL}/institution
    Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div       跳至

    Click Element               xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[1]/div/div[1]/img
    Sleep  1s
    Click Element               xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[1]/div/div[2]/ul/li[28]
    Sleep  2s

    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[2]       天津
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[3]       天津
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[4]       天津
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[5]       天津

院校搜索逻辑校验
    [Documentation]  经由搜索结果进入院校详情页，回退搜索结果页，\n\r
    ...  需将搜索内容回显在搜索框，点击 Tab 栏上的“院校”，应展示所有院校列表\n\r
    [Tags]  Functional

    Go To  ${ROOT_URL}/institution
    Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div       跳至
    # 输入"上海"执行模糊搜索
    Input Text      ${SEARCH_TEXT}      上海
    Press Keys      ${SEARCH_TEXT}      RETURN
    Sleep  2s
    Element Should Contain  css=div.univ-container > div.univ-title  共查询到 34 所院校
    Element Should Contain  css=div.univ-container > div.univ-main:nth-child(2)  上海大学
    Element Should Contain  css=div.univ-container > div.univ-main:nth-child(3)  上海商学院
    Element Should Contain  css=div.univ-container > div.univ-main:nth-child(4)  上海交通大学
    Log To Console  -------> 成功完成搜索

    # 进入"搜索结果的第一所大学"详情页面
    Click Element  css=#__layout > div > div.out-container > div.school-container > div.univ-container > div:nth-child(2)
    Wait Until Element Contains  css=#rec_school > div.title > span  推荐院校
    Go Back

    # 点击浏览器返回按钮后，搜索关键字还应在搜索框内
    ${key_word}  Get Element Attribute  css=input.input  value
    # Sleep  5s
    Log To Console   -------> ${key_word}
    Should Be Equal  ${key_word}  上海

*** Keywords ***
打开院校页面
    Open Main Page Successful
    # 点击首页「院校」菜单
    Click Element                   xpath=//*[@id="__layout"]/div/div[1]/div[1]/div/div[2]/ul/li[3]/a
    Wait Until Element Contains     class=univ-title       共查