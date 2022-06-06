*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - 访问软科中国两岸四地大学排名页面.
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup       Start TestCase
Test Teardown    Finish TestCase

*** Variables ***
${SEARCH_TEXT}      XPath=//*[@id="content-box"]/div[1]/input
*** Test Cases ***

打开排名页面
    [Documentation]  打开软科中国两岸四地大学排名页面
    [Tags]  Functional

    打开两岸四地页面

搜索学校名称
    [Documentation]  输入学校名称关键字执行模糊搜索，搜索结果应该包含该关键字
    [Tags]  Functional

    打开两岸四地页面
    log to console     搜索：西安电子
    Input Text      ${SEARCH_TEXT}      西安电子
    Press Keys      ${SEARCH_TEXT}      RETURN
    Table Cell Should Contain           class=rk-table       2       2       西安电子

    Sleep       10ms

    log to console     搜索：科技
    Input Text      ${SEARCH_TEXT}      科技
    Press Keys      ${SEARCH_TEXT}      RETURN
    FOR     ${i}    IN RANGE    2    11
        Table Cell Should Contain       class=rk-table       ${i}       2       科技
    END

切换排名年份，方法论也同步变更
    [Documentation]  切换排名年份，排名方法同时改变
    [Tags]  Functional

    打开两岸四地页面

    切换排名年份    2017
    切换排名年份    2019
    切换排名年份    2020

切换指标维度
    [Documentation]  切换指标维度，排名指标同时改变
    [Tags]  Functional

    打开两岸四地页面

    切换具体指标维度        留学生比例       XPath=//*[@id="content-box"]/div[2]/table/thead/tr/th[5]/div/div[1]/div[2]/div/ul/li[1]/div[2]/div[2]
    Table Cell Should Contain       class=rk-table     3       2       北京大学
    Table Cell Should Contain       class=rk-table     3       5       6.8

*** Keywords ***
切换排名年份
    [Arguments]     ${yr}

    ${methodology_txt}         Set Variable       排名方法-${yr}中国两岸四地大学排名 
    Click Element              XPath=//*[@id="content"]/div[1]/div/div[1]
    ${yr_xpath}                Set Variable    //*[@id="content"]/div[1]/div/div[2]/ul/li[text()=${yr}]
    Set Focus To Element       XPath=${yr_xpath}
    Sleep                      3s
    Click Element              XPath=${yr_xpath}
    Sleep                      3s
    # 方法论应该同步切换
    Element Text Should Be     XPath=//*[@id="rank-side"]/div/ul/li/div/div/a      ${methodology_txt} 

切换具体指标维度
    [Arguments]     ${ITEM_TEXT}       ${LOCATOR}

    Click Element                    XPath=//*[@id="content-box"]/div[2]/table/thead/tr/th[5]/div/div[1]
    Set Focus To Element             ${LOCATOR}
    Click Element                    ${LOCATOR}
    Log To Console                   成功切换 - ${ITEM_TEXT}
    Sleep                            2ms
