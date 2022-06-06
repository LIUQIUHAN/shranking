*** Settings ***
Library           SeleniumLibrary
Library           String

*** Variables ***
${ROOT_URL}       https://www.shanghairanking.cn
# ${ROOT_URL}       http://srcn.srv.lan
#${ROOT_URL}       http://192.168.1.10:8000

*** Keywords ***
Start TestCase
    Open Browser    ${ROOT_URL}        chrome
#    Maximize Browser Window

Finish TestCase
    Close Browser

# 打开院校页面
#     Open Main Page Successful
#     # 点击首页「院校」菜单
#     Click Element                   xpath=//*[@id="__layout"]/div/div[1]/div[1]/div/div[2]/ul/li[3]/a
#     Wait Until Element Contains     class=univ-title       共查询

Open Main Page Successful
    Wait Until Element Contains     css=div.footer-link > ul > li:nth-child(1)    关于软科

Start ARWU Ranking Data Check
    # 打开首页
    Start TestCase
    Open Main Page Successful
    Wait Until Page Contains   REPORTS
    Wait Until Page Contains   关于软科

    # Click Element       css=div.close-icon    # 关闭影响力页面弹窗
    # 点击首页 ARWU 卡片标签，进入ARWU排名榜单页面
    Click Element  css=div.card-item.arwu-bg > div.card-name-box.border-right > a > div.card-title
    Wait Until Element Contains     xpath=//*[@id="content-box"]/ul/li[10]/div      跳至
    Page Should Contain Element         class=rk-table

    # 选择奥地利
    Click Element            xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[1]/img
    Sleep       50ms
    Set Focus To Element     xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[2]/ul/li[text()='奥地利']
    Click Element            xpath=//*[@id="content-box"]/div[2]/table/thead/tr/th[3]/div/div/div[2]/ul/li[text()='奥地利']
    Sleep       50ms

准备开始两岸四地大学排名数据检查
    # 打开首页
    Start TestCase
    打开两岸四地页面

打开两岸四地页面
    Open Main Page Successful
    Wait Until Page Contains   REPORTS
    Wait Until Page Contains   关于软科
    Log To Console      -------> 成功打开首页

    # 点击“查看排名”按钮，进入榜单详情页面
    # Click Element  css=#__layout > div > div.rank-container > div:nth-child(5) > a > div
    go to  ${ROOT_URL}/rankings/rtugc/2020
    Wait Until Element Contains   css=#content-box > div.table-tip  排名或排名区间相同的大学按英文校名字母顺序排列
    Log To Console      -------> 进入两岸四地排名页面

准备开始测试用户登录后可操作之功能
    Start TestCase
    Open Main Page Successful
    测试用户登录系统

测试用户登录系统
# Step 1: 确认首页有登录链接
    Element Should Contain  css=div.header-user > span  登录/注册

    # Step 2: 点击登录链接
    Click Element  css=div.header-user > span
    Wait Until Element Contains     css=div.user-modal-title        登录软科网，体验更多功能
    Log To Console     \n\r----------> 成功弹出登录窗\n\r

    # Step 3: 验证登录窗的样式
    Element Should Contain      css=div.user-modal-subtitle     未注册手机验证后自动登录
    # 验证码按钮
    Element Should Contain      css=#smsCodeBtn        发送验证码
    # 登录按钮
    Element Should Contain       css=#loginBtn     登录/注册
    # 输入手机号码，点击发送验证码
    Input Text      css=#phoneInput       13321838656
    Click Element       css=#smsCodeBtn
    Input Text      css=#smsCodeInput     123456
    Click Element       css=#loginBtn
#    Wait Until Element Contains       css=div.header-user > div.user-detail > span      001
    Wait Until Element Is Visible   css=div.user-detail

    Log To Console     \n\r----------> 用户成功登录\n\r
    Click Element       css=div.header-user > div.user-detail > span
    sleep  10ms

    # 验证用户菜单文字
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(1)  编辑资料
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(2)  我的收藏
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(3)  我的推荐
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(4)  我的评价
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(5)  账号设置
    Element Should Contain  css=div.user-dropdown > ul > li:nth-child(6)  退出登录

    Log To Console     \n\r----------> 用户菜单正常\n\r


完成测试用户登出系统
    sleep  10ms
   # 点出菜单
    Click Element  css=div.header-user > div.user-detail > span
    # 点击 - 退出登录
    Click Element  css=div.user-dropdown > ul > li:nth-child(6)

    # # 弹出确认窗口
    # Wait Until Element Contains  css=p.login-out-text  是否退出登录
    # # 点击退出确认按钮 
    # # todo: 需要更新为通过 id 定位
    # Click Element  xpath=/html/body/div[3]/div/div[2]/div/div[2]/div[1]/div/div[3]/div/button[1]

    # 退出登录后页面验证
    Wait Until Element Contains  css=div.header-user > span  登录/注册
    Log To Console  \n\r----------> 用户成功退出登录\n\r
    Close Browser

准备开始测试院校详情重构后页面
    Start TestCase
    Open Main Page Successful

Get CSS Property Value
    [Documentation]
    ...    Get the CSS property value of an Element.
    ...
    ...    This keyword retrieves the CSS property value of an element. The element
    ...    is retrieved using the locator.
    ...
    ...    Arguments:
    ...    - locator           (string)    any Selenium Library supported locator xpath/css/id etc.
    ...    - property_name     (string)    the name of the css property for which the value is returned.
    ...
    ...    Returns             (string)    returns the string value of the given css attribute or fails.
    ...
    [Arguments]    ${locator}    ${attribute name}
    ${css}=         Get WebElement    ${locator}
    ${prop_val}=    Call Method       ${css}    value_of_css_property    ${attribute name}
    [Return]     ${prop_val}