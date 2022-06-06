*** Settings ***
Documentation    shanghairanking.cn - 用户登录功能
...
Resource         ../../resources/CommonFunctionality.robot

Test Setup      Start TestCase
Test Teardown   Finish TestCase

*** Test Cases ***

登录网页+登出网页
    [Documentation]     点击首页「登录/注册」链接，弹出登录页面，通过手机号码登录系统，验证用户菜单，并退出登录。
    [Tags]      Functional  用户中心

    测试用户登录系统
    完成测试用户登出系统