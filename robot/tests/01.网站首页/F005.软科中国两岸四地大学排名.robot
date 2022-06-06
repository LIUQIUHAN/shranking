*** Settings ***
Documentation    软科排名网(www.shanghairanking.cn) - UI测试.
...
Resource         ../../resources/CommonFunctionality.robot
Library          DataDriver      ../../Resources/TestData/中国两岸四地大学排名.xlsx          sheet_name=人才培养       encoding=UTF-8

Suite Setup          准备开始两岸四地大学排名数据检查
Suite Teardown       Finish TestCase
Test Template        两岸四地大学排名数据检查

*** Test Cases ***
Region Select
    [Documentation]  两岸四地大学排名数据检查
    [Tags]  Functional

    两岸四地大学排名数据检查

*** Keywords ***
两岸四地大学排名数据检查
    [Arguments]      ${ROW_NUM}   ${RANKING}     ${UNIV_NAME}	${REGION}	${SCORE}	${IND_01}

    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      1      ${RANKING}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      2      ${UNIV_NAME}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      3      ${REGION}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      4      ${SCORE}
    Table Cell Should Contain       class=rk-table        ${ROW_NUM}      5      ${IND_01}
