*** Settings ***
Library          String
Documentation    shanghairanking.cn - 院校列表页面测试
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup      Start TestCase
Test Teardown   Finish TestCase

*** Test Cases ***

Test01
   [Documentation]     打开软科网，点击网站首页顶部「院校」菜单，成功打开院校列表页
   [Tags]      Functional

   Open Main Page Successful
   Click Element   xpath=//*[@id="__layout"]/div/div[1]/div[1]/div/div[2]/ul/li[3]/a
   Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div    跳至

Test02
    [Documentation]     1. 搜索框placeholder显示："院校搜索"\n\r
    ...                 2. 搜索按钮应该显示："搜索"\n\r
    ...                 3. 检查省市选择框 - 默认显示："全部省市"\n\r
    ...                 4. 检查学校类型选择框 - 默认显示："全部类型"\n\r
    ...                 5. 检查学校层次选择框 - 默认显示："全部层次"\n\r
    ...                 6. 院校列表页默认显示查询结果：共查询到 xxx 所院校
    [Tags]      UI

    Go To       ${ROOT_URL}/institution
    Wait Until Element Contains     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div       跳至
    # 1. 检查收缩框中的placeholder
    ${content}     Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[1]/div/input     placeholder
    Should Be Equal     ${content}     院校搜索

    # 2. 搜索按钮
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[1]/div/button       搜索

    # 3. 检查省市选择框 - 默认显示："全部省市"
    ${content}     Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[1]/div/div[1]/input    value
    Should Be Equal     ${content}    全部省市

    # 4. 检查学校类型选择框 - 默认显示："全部类型"
    ${content}     Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[2]/div/div[1]/input    value
    Should Be Equal     ${content}    全部类型

    # 5. 检查学校层次选择框 - 默认显示："全部层次"
    ${content}     Get Element Attribute       xpath=//*[@id="__layout"]/div/div[2]/div[1]/div/div[2]/div[3]/div/div[1]/input    value
    Should Be Equal     ${content}    全部层次

    # 6. 默认显示查询结果：共查询到 1307 所院校
    Sleep   2s
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[1]       共查询到
    Element Should Contain      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[1]       所院校

Test03
   [Documentation]     输入不存在的院校名称（vvvv），显示“抱歉……”提示信息
   [Tags]      Functional

  # 打开院校列表页面
  Open Main Page Successful
  Click Element        xpath=//*[@id="__layout"]/div/div[1]/div[1]/div/div[2]/ul/li[3]/a
  Wait Until Element Contains      xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/ul/li[10]/div    跳至

Test04
    [Documentation]     0. 输入不存在的学校，显示没有结果的提示\n\r
    ...                 1. 输入“西安电子”，显示包含关键字的2所院校\n\r
    ...                 2. 显示搜索结果提示信息\n\r
    ...                 3. 显示学校(西电)中英文名称、省市、类型、层次信息\n\r
    ...                 4. 显示学校(西电) - 校徽\n\r
    ...                 5. 显示学校(西电) - 入住院校标志\n\r
    [Tags]      Functional

    # Step 1: 打开院校列表页面
    Open Main Page Successful
    Click Element       css=div.header-nav > ul > li:nth-child(3) > a
    Wait Until Element Contains      css=div.ant-pagination-options-quick-jumper    跳至

    # 输入搜索内容：vvvv
    Input Text       css=div.input-box > input    vvvv
    Click Button     css=div.input-box > button
    Sleep    1s
    ${txt}   Get Text     xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[3]/div
    Log To Console       -------> ${txt}
    Should Contain   ${txt}      抱歉，没有搜到您想找的大学

    # Step 2: 输入关键字：西安电子，点击搜索按钮
    Input Text       css=div.input-box > input    西安电子
    Click Button     css=div.input-box > button

    # Step 3: 提示信息应该为：共查询到 2 所院校
    Wait Until Element Contains  css=div.univ-container > div.univ-title     共查询到 2 所院校

    # Step 4: 学校列表应该包括：西安电子科技大学、西安电子科技大学长安学院

    Element Should Contain      css=div.univ-container > div:nth-child(2) > div > div.univ-container > div:nth-child(1) > span       西安电子科技大学
    Element Should Contain      css=div.univ-container > div:nth-child(2) > div > div.univ-container > div:nth-child(2)       Xidian University

    # 校徽
    Element Should Be Visible       css=div.univ-container > div:nth-child(2) > div > div.logo-container > img
    # 入住院校图标
    Element Should Be Visible       css=div.univ-container > div:nth-child(2) > div > img

Test05
    [Documentation]     1. 进入学校列表页面，正常显示院校列表；\n\r
    ...                 2. 点击进入第五页，分页按钮"第5页"高亮显示；\n\r
    ...                 3. 点击第5页的校园进入详情页面，正常显示院校详情页面\n\r
    ...                 4. 模拟用户点击浏览器"返回"按钮；\n\r
    ...                 5. 显示页面应该与上述第2步的页面一致(第5页按钮高亮显示)。\n\r
    [Tags]      Functional

    go to  ${ROOT_URL}/institution
    # 1.
    Wait Until Page Contains  版权声明
    Sleep  2s

    # 2.
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep  2s
    ${Selector}=  Set Variable  css=#__layout > div > div.out-container > div.school-container > div.univ-container > ul > li.ant-pagination-item.ant-pagination-item-5.ant-pagination-item-before-jump-next > a
    Click Element  ${Selector}
    Sleep  2s
    ${bg_color}=    Get CSS Property Value  css=#__layout > div > div.out-container > div.school-container > div.univ-container > ul > li.ant-pagination-item.ant-pagination-item-5.ant-pagination-item-active  background-color
    Should Be Equal As Strings    ${bg_color}    rgba(214, 11, 10, 1)

    #3.
    Click Element   css=#__layout > div > div.out-container > div.school-container > div.univ-container > div:nth-child(30) > div > div.univ-container > div:nth-child(1)
    Wait Until Page Contains    推荐院校
    Sleep   1s

    #4.
    Go Back

    #5.
    ${bg_color}=    Get CSS Property Value  css=#__layout > div > div.out-container > div.school-container > div.univ-container > ul > li.ant-pagination-item.ant-pagination-item-5.ant-pagination-item-active  background-color
    Should Be Equal As Strings    ${bg_color}    rgba(214, 11, 10, 1)

Test06
    [Documentation]  从其他页面进入「院校列表」页面时，应该与首次进入「院校列表」一致：空的搜索关键字，筛选条件都是“全部”
    [Tags]  Functional

    院校列表搜索内蒙古
    # 点击「关于我们」
    Click Element   css=div.header-nav > ul > li:nth-child(4) > a
    # 点击「院校」
    Click Element   css=div.header-nav > ul > li:nth-child(3) > a
    Sleep  3s
    # 检查搜索框
    ${txt}   get element attribute  css=div.search-container > div > div:nth-child(1) > div > input  value
    Log To Console  ${txt}
    Should Be Equal  ${txt}  ${EMPTY}

    Element Should Contain  css=div.univ-container > div:nth-child(2) > div > div.univ-container > div:nth-child(1) > span  清华大学

*** Keywords ***    
院校列表搜索内蒙古
    # 进入院校列表页
    Go To       ${ROOT_URL}/institution
    Wait Until Element Contains      css=div.ant-pagination-options-quick-jumper    跳至
    # 搜索「内蒙古」
    ${kw}=  Set Variable    内蒙古
    Input Text       css=div.input-box > input    ${kw}
    Click Button     css=div.input-box > button    
    Element Should Contain  css=div.univ-container > div:nth-child(2) > div > div.univ-container > div:nth-child(1) > span  ${kw}
    Element Should Contain  css=div.univ-container > div:nth-child(3) > div > div.univ-container > div:nth-child(1) > span  ${kw}    
