*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Library          SeleniumLibrary
Resource         ../../resources/CommonFunctionality.robot
Library          DataDriver      ../../Resources/TestData/F002.xlsx          sheet_name=首页链接测试       encoding=UTF-8

Suite Setup       Start TestCase
Suite Teardown    Finish TestCase
Test Template     Click Main Page Links

*** variables ***
${DOC1}    数据驱动测试用例

*** Test Cases ***
F002.点击首页链接
    Click Main Page Links

*** Keywords ***
Click Main Page Links
    [Arguments]         ${CURRENT_ELEMENT}     ${TARGET_ELEMENT}      ${TARGET_TEXT}
    [Documentation]     ${DOC1}

    Go To   ${ROOT_URL}
    Wait Until Page Contains   REPORTS
    Wait Until Page Contains   关于软科

    Set Selenium Speed         50ms
    Set Focus To Element   ${CURRENT_ELEMENT}
    Click Element   ${CURRENT_ELEMENT}
    Wait Until Element Contains     ${TARGET_ELEMENT}   ${TARGET_TEXT}


