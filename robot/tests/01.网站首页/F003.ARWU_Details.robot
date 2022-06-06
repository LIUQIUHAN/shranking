*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Resource         ../../resources/CommonFunctionality.robot
Library         DataDriver      ../../Resources/TestData/F002.xlsx          sheet_name=榜单数据检查-奥地利       encoding=UTF-8

Suite Setup          Start ARWU Ranking Data Check
Suite Teardown       Finish TestCase
Test Template        Verify Ranking Data

*** Variables ***
${ENTRY_ELMT}       xpath=//*[@id="__layout"]/div/div[2]/div[2]/div[1]/div[3]/div[1]/div/div/div[1]/a
${REGION_SEL}       xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[1]

${LOG_PRE}      -----→ 成功完成区域切换：

${REGION_SEL_AUSTRIA}      xpath=//*[@id="content-box"]/div[1]/div[2]/div[2]/ul/li[7]
${REGION_SEL_KOREA}        xpath=//*[@id="content-box"]/div[1]/div[2]/div[2]/ul/li[21]
${REGION_SEL_NORWAY}       xpath=//*[@id="content-box"]/div[1]/div[2]/div[2]/ul/li[35]
${REGION_SEL_JAPAN}        xpath=//*[@id="content-box"]/div[1]/div[2]/div[2]/ul/li[37]

*** Test Cases ***

Region Select
    [Documentation]  ARWU - 切换国家/区域选择框
    [Tags]  Functional

    Verify Ranking Data

*** Keywords ***
Verify Ranking Data
    [Arguments]     ${ROW_NUM}      ${RK_W}      ${UNIV_NAME}       ${COUNTRY_NAME}     ${RK_C}     ${XYHJ_VAL}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      1      ${RK_W}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      2      ${UNIV_NAME}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      3      ${COUNTRY_NAME}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      4      ${RK_C}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      6      ${XYHJ_VAL}