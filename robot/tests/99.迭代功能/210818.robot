*** Settings ***
Library          String
Documentation    shanghairanking.cn - 院校详情页面中若干功能迭代
...

Resource         ../../resources/CommonFunctionality.robot

Test Setup      Start TestCase
Test Teardown   Finish TestCase

*** Test Cases ***
Test001
    [Documentation]   院校详情页中，学科排名模块，新增跳转至该学科排名页的功能
    [Tags]  Functional

    go to   ${ROOT_URL}/institution/shanghai-jiao-tong-university
    Wait Until Element Contains  css=#bk_reason > div.title   报考理由

    # 软科世界一流学科排名
    Click Subject Name  1
    Click Subject Name  2
    Click Subject Name  3

*** Keywords ***
Click Subject Name
    [Arguments]  ${idx}

    ${handles}=  Get Window Handles
    Switch Window  ${handles}[0]
    ${sbj_name}  Get Text  css=#gras > div.subj-container > div.all-subj > div.table-container > table > tbody > tr:nth-child(${idx}) > td:nth-child(1)
    Log To Console  学科名称：${sbj_name}
    Click Element  css=#gras > div.subj-container > div.all-subj > div.table-container > table > tbody > tr:nth-child(${idx})
    ${handles}=    Get Window Handles 
    Switch Window    ${handles}[1]
    Wait Until Element Contains  css=#content-box > ul > li.ant-pagination-options > div  跳至
    Element Should Contain  css=#content-box > div.tool-box > div.table-title > div:nth-child(3)  ${sbj_name}
    Close Window