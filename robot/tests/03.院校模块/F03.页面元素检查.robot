*** Settings ***
Library    Collections

Documentation       shanghairanking.cn - 院校详情重构
...
Resource         ../../resources/CommonFunctionality.robot

Suite Setup     准备开始测试院校详情重构后页面
Suite Teardown  Finish TestCase

*** Variables ***


*** Test Cases ***
校验页面 ContainerID(未入住院校)
    [Documentation]  检查「未入住院校」页面元素≤
    [Tags]     元素检查   院校详情

    # 直接访问院校模块链接，顺便验证前端路由的有效性
    Go to  ${ROOT_URL}/institution
    Wait Until Element Contains  css=div.univ-container > div.univ-title  共查询到
    Element Should Be Visible  css=div.input-box > input.input
    Page Should Contain Button  css=div.input-box > Button

    # 进入清华大学详情页面
    Click Element  css=div.univ-container > div:nth-child(2)
    Wait Until Page Contains  推荐院校

    院校详情页面公共元素检查
    换一换推荐院校

校验页面 ContainerID(已入住院校)
    [Documentation]  检查「已入住院校」页面元素
    [Tags]     元素检查   院校详情

    Go to  ${ROOT_URL}/institution/xidian-university
    Wait Until Page Contains  推荐院校

    院校详情页面公共元素检查
    换一换推荐院校

    ## 以下信息只有"入住院校"才有
    # 报考理由
    Page Should Contain Element  css=#apply_rsns
    # 宿舍条件
    Page Should Contain Element  css=#dorm_conds
    # 园区环境
    Page Should Contain Element  css=#campus_env
    # 校园满意度 - 暂未显示
    # Page Should Contain Element  css=#campus_stsfctn
    # 精选评论 - 暂未显示
    # Page Should Contain Element  css=#featured_comments


*** Keywords ***
院校详情页面公共元素检查
    # 开始校验 ContainerID
    # 学校名称
    Page Should Contain Element  css=#univ_info
    # 校徽
    Page Should Contain Element  css=#univ_logo
    # 学校标签
    Page Should Contain Element  css=#univ_tags
    # 软科点评
    Page Should Contain Element  css=#rk_comments
    # 学校地址
    Page Should Contain Element  css=#univ_addr
    # 学校简介
    Page Should Contain Element  css=#univ_intro
    # 大学排名
    Page Should Contain Element  css=#univ_rankings

    # BCUR
    # BCUR 排名信息
    Page Should Contain Element  css=#bcur_latest
    # BCUR 历史排名信息
    Page Should Contain Element  css=#bcur_hist
    # ARWU
    Page Should Contain Element  css=#arwu_latest
    # ARWU 历史排名信息
    Page Should Contain Element  css=#arwu_hist
    # 在校生
    Page Should Contain Element  css=#crt_students
    # 毕业生
    Page Should Contain Element  css=#graduates

    # BCSR
    Page Should Contain Element  css=#bcsr
    ${txt}  Get Text  css=#bcsr > div.title > span 
    Should Be Equal  ${txt}  软科中国最好学科排名  
    # 优势学科旁边的小红旗
    Element Should Be Visible       css=#bcsr > div.subj-container > div.advantage-subj > div.table-title > img

    # GRAS
    Page Should Contain Element  css=#gras


换一换推荐院校
    # 推荐院校
    Page Should Contain Element  css=#rec_inst
    # 点击换一批
    # 推荐院校，一次从后台抓取31条院校数据，默认显示3所，点击换一批，会显示下3所，支持点击7次来显示不同7批院校
    # 此处测试点击6次「换一批」，每次显示第一位的院校名称都不一样
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)

    Click Element  css=#rec_inst > div.change-loop > img
    Sleep  1s
    ${uname1}  Get Text  css=#rec_inst > div:nth-child(2) > div > div.swiper-slide.my-slide-active > a > div.side-item > div.univ > div.school-text > span.cn-name
    Log To Console  ${uname1}

    Click Element  css=#rec_inst > div.change-loop > img
    Sleep  1s
    ${uname2}  Get Text  css=#rec_inst > div:nth-child(2) > div > div.swiper-slide.my-slide-active > a > div.side-item > div.univ > div.school-text > span.cn-name
    Log To Console  ${uname2}
    #  两次刷新后显示不同的学校名称
    Should Not Be Equal  ${uname1}  ${uname2}
