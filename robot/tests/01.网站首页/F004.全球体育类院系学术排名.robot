*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup       Start TestCase
Test Teardown    Finish TestCase

*** Test Cases ***

1.「全球体育类院系学术排名」榜单页面
    [Documentation]  打开「全球体育类院系学术排名」榜单页面
    [Tags]  Functional

    # 1. 打开首页
    Open Main Page Successful
    Wait Until Page Contains    REPORTS
    Wait Until Page Contains    关于软科

    # 1.1 检查「其他排名」子菜单的正确显示
    # 其他菜单
    Sleep       1s
    Click Element       css=#__layout > div > div:nth-child(1) > div.header.shadow > div > div.header-nav > ul > li:nth-child(2) > a
    Log To Console      点击首页排名菜单成功
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep   1s

    Click Element       css=#__layout > div > div.rank-container > div:nth-child(7) > a > div
    Wait Until Element Contains      xpath=//*[@id="content-box"]/ul/li[10]/div      跳至
    Page Should Contain        全球体育类院系学术排名
    Log To Console      成功进入排名页面！

    # 4. 校验排名数据
    # 4.1 选择年份
    Click Element       xpath=//*[@id="content"]/div[1]/h1   # 点击一下 h1 让鼠标动一动
    Sleep       1s
    Click Element       xpath=//*[@id="content"]/div[1]/div/div[1]/img       # 年份选择框
    Sleep       1s
    # 年份选择框

    Set Focus To Element        xpath=//*[@id="content"]/div[1]/div/div[2]/ul/li[1]     #2020
    Click Element               xpath=//*[@id="content"]/div[1]/div/div[2]/ul/li[1]

    Table Cell Should Contain       class=rk-table      2       1       1
    Table Cell Should Contain       class=rk-table      2       2       哥本哈根大学
    Table Cell Should Contain       class=rk-table      2       2       运动与营养系
    Table Cell Should Contain       class=rk-table      2       2       运动医学研究所
    Table Cell Should Contain       class=rk-table      2       3       丹麦
    Table Cell Should Contain       class=rk-table      2       4       100
    Table Cell Should Contain       class=rk-table      2       5       98.3

    Table Cell Should Contain       class=rk-table      3       1       2
    Table Cell Should Contain       class=rk-table      3       2       挪威体育学院
    Table Cell Should Contain       class=rk-table      3       2       挪威体育学院
    Table Cell Should Contain       class=rk-table      3       3       挪威
    Table Cell Should Contain       class=rk-table      3       4       98.7
    Table Cell Should Contain       class=rk-table      3       5       79.2
    Log To Console                  完成年份选择测试！

    # 4.2 选择国家
    Click Element               xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[1]/img           # 国家选择框
    Set Focus To Element        xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[2]/ul/li[text()='波兰']      # 波兰
    Click Element               xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[2]/ul/li[text()='波兰']      # 波兰

    Table Cell Should Contain       class=rk-table      2       1       201-300
    Table Cell Should Contain       class=rk-table      2       2       格但斯克体育大学
    Table Cell Should Contain       class=rk-table      2       2       格但斯克体育大学
    Table Cell Should Contain       class=rk-table      2       3       波兰
    Table Cell Should Contain       class=rk-table      2       5       18.3
    Log To Console                  完成国家选择测试！
