*** Settings ***
Library          String
Documentation    shanghairanking.cn - 院校详情页面中若干功能迭代
...

Resource         ../../resources/CommonFunctionality.robot

Test Setup      Start TestCase
Test Teardown   Finish TestCase

*** Test Cases ***
Test001 
    [Documentation]   院校详情页面中，ARWU&BCUR 排名，点击年份跳转至对应年份的排名列表页面
    [Tags]  Functional

    go to   ${ROOT_URL}/institution/shanghai-jiao-tong-university
    Wait Until Element Contains  css=#bk_reason > div.title   报考理由

    # 获取大学排名栏目中 BCUR Timeline 年份信息 
    # Element Should Contain  css=#bcur_hist > div:nth-child(1) > div.year  2017
    # Element Should Contain  css=#bcur_hist > div:nth-child(2) > div.year  2018
    # Element Should Contain  css=#bcur_hist > div:nth-child(3) > div.year  2019
    # Element Should Contain  css=#bcur_hist > div:nth-child(4) > div.year  2020
    # Element Should Contain  css=#bcur_hist > div:nth-child(5) > div.year  2021

    # 获取大学排名栏目中 ARWU Timeline 年份信息 
    # Element Should Contain  css=#arwu_hist > div > div:nth-child(1) > div.year   2017
    # Element Should Contain  css=#arwu_hist > div > div:nth-child(2) > div.year   2018
    # Element Should Contain  css=#arwu_hist > div > div:nth-child(3) > div.year   2019
    # Element Should Contain  css=#arwu_hist > div > div:nth-child(4) > div.year   2020
    # Element Should Contain  css=#arwu_hist > div > div:nth-child(5) > div.year   2021

    # 点击 BCUR Timeline 跳转到榜单页面
    
    Click BCUR Ranking Year  1  2017
    Click BCUR Ranking Year  2  2018
    Click BCUR Ranking Year  3  2019
    Click BCUR Ranking Year  4  2020
    Click BCUR Ranking Year  5  2021

    Click ARWU Ranking Year  1  2017
    Click ARWU Ranking Year  2  2018
    Click ARWU Ranking Year  3  2019
    Click ARWU Ranking Year  4  2020
    Click ARWU Ranking Year  5  2021

*** Keywords ***
Click BCUR Ranking Year
    [Arguments]  ${IDX}  ${YR}

    ${handles}=    Get Window Handles 
    Switch Window    ${handles}[0]
    Click Element  css=#bcur_hist > div:nth-child(${IDX})
    ${handles}=    Get Window Handles 
    Switch Window    ${handles}[1]
    Wait Until Element Contains  css=#content-box > ul > li.ant-pagination-options > div  跳至
    Element Should Contain  css=#content > div.content-title > h1  ${YR}
    Close Window

Click ARWU Ranking Year
    [Arguments]  ${IDX}  ${YR}

    ${handles}=    Get Window Handles 
    Switch Window    ${handles}[0]
    Click Element  css=#arwu_hist > div > div:nth-child(${IDX})
    ${handles}=    Get Window Handles 
    Switch Window    ${handles}[1]
    Wait Until Element Contains  css=#content-box > ul > li.ant-pagination-options > div  跳至
    Element Should Contain  css=#content > div.content-title > h1  ${YR}
    Close Window