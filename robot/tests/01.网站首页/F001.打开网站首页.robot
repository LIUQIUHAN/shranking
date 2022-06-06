*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup       Start TestCase
Test Teardown    Finish TestCase

*** Test Cases ***

1.首页搜索有效的学校关键字
    [Documentation]  在网站首页搜索框搜索 - 「西安电子」，进入院校模糊搜索页面，查出包含「西安电子」的所有学校
    [Tags]  Functional

    Open Main Page Successful
    Wait Until Page Contains      世界大学学术排名

    # 定义查询关键字
    ${s_kw}  Set Variable  西安电子
    # 输入关键字，并按下回车，执行搜索
    Input Text  css=input.input  ${s_kw}
    Press Keys  css=input.input  RETURN
    # 检查查询学校数量
    Wait Until Element Contains  css=div.univ-title  共查询到
    # 检查查询结果
    Element Should Contain  css=div.univ-container > div:nth-child(2) > div > div.univ-container > div:nth-child(1) > span  ${s_kw}
    Element Should Contain  css=div.univ-container > div:nth-child(3) > div > div.univ-container > div:nth-child(1) > span  ${s_kw}

2.首页搜索无效的学校关键字
    [Documentation]  在网站首页搜索框搜索 - 「qwertuy」，进入院校模糊搜索页面，提示信息包含「抱歉，没有搜到您想找的大学」
    [Tags]  Functional

    # 定义查询关键字
    ${s_kw}  Set Variable  qwertuy
    # 输入关键字，并按下回车，执行搜索
    Input Text  css=input.input  ${s_kw}
    Press Keys  css=input.input  RETURN
    # 提示信息
    Wait Until Element Contains  css=div.univ-container > div:nth-child(3) > div  抱歉，没有搜到您想找的大学
