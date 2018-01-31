//
//  H5UrlDefine.h
//  Ixyb
//
//  Created by wangjianimac on 16/6/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#ifndef H5UrlDefine_h
#define H5UrlDefine_h

/**
 * NodeJs                                                                             V2.0静态H5
 1.出借模块：@董志刚                                                                          曹雪峰
 出借产品介绍 活期宝服务协议 步步高服务协议 周周盈服务协议                                                       定期宝服务协议、借款协议、债权转让协议、安全保障（优化一下文字样式）、风险警示书
 
 2.信闪贷模块 @董志刚                                                                         曹雪峰
 
 3.安全模块 @姜建军                                                                          曾中祥
 涂志云讲风控 平台运营月报                                                                        网贷逾期信息公示
 个人信用、信用评分、小额分散、风投注资、资金存管、高管团队、合同安全、信息安全、公司证书、行业协会
 
 4.我的 @姜建军                                                                            曾中祥
 网银宝充值协议                                                                              老版本删掉
 债权转让规则、定期宝赎回说明
 礼金、红包、优惠券、积分使用规则
 摇摇乐详细规则、积分抽奖活动规则、信用宝联盟奖励说明、查看联盟规则
 实名认证、VIP特权说明、VIP特权备注
 VIP权益、VIP服务条款、新手任务细则（老版本删掉                                                           NodeJs服务器没有）
 常用问题及产品介绍、关于信用宝、登录说明
 
 **/

/**
 *  NodeJs                                                                            V2.0.1开发模块(动态H5,需要开发接口）
 首页（原发现）页面的活动页（6个页面）                                                                  动态
 网贷逾期信息公示                                                                             动态
 充值说明、提现说明、银行限额说明                                                                     动态
 积分抽奖
 积分商城
 风险评测
 新闻动态(列表)
 新闻动态(详情)
 APP分享注册URL                                                                           2016元红包分享落地页
 消息公告活动H5
 摇摇乐/积分抽奖/积分商城/新闻动态分享炫耀落地页
 信闪贷借款
 */

/**
 * NodeJs                                                                             V2.0静态H5
 */

//1.出借模块：@董志刚 曹雪峰 // 出借产品介绍 步步高服务协议 周周盈服务协议 定期宝服务协议、借款协议、债权转让协议、安全保障（优化一下文字样式）、风险警示书

// 出借产品介绍
#define App_ProductIntro_URL    @"/html/appProductIntro.html"

// 活期宝服务协议
#define App_Hqb_Protocol_URL    @"/html/app_hqb_protocol.html"

// 步步高服务协议
#define App_Bbg_Protocol_URL    @"/html/app_bbg_protocol.html"

// 周周盈服务协议
#define App_Zzy_Protocol_URL    @"/html/app_zzy_protocol.html"

// 定期宝服务协议
#define App_CC_Protocol_URL     @"/html/app_cc_protocol.html"

// 借款协议
#define App_Borrow_Protocol_URL @"/html/app_borrow_protocol.html"

// 债权转让协议
#define App_Ca_Protocol_URL     @"/html/app_ca_protocol.html"

// 存管转让规则
#define App_Dep_Assign_Rule_URL @"/html/dep-assign-rule.html"

// 安全保障
#define App_Safe_URL            @"/html/app_safe.html"

// 风险警示书
#define App_Risk_Warn_URL       @"/html/app_risk_warn.html"

// 出借人服务协议
#define App_investorServiceProtocol_URL       @"/html/investor_service_protocol.html"

// 出借人授权书
#define App_InvestorAuthLetter_URL       @"/html/investor_auth_letter.html"

// 风险揭示
#define App_Risk_Show_URL       @"/html/app_risk_show.html"

// 信用宝服务协议
#define App_Protocol_URL        @"/html/app_protocol.html"

//2.信闪贷模块 @董志刚 曹雪峰

//3.安全模块 @姜建军 曾中祥
// 涂志云讲风控
#define App_Ceo_Video_URL       @"/html/safe/app-ceo-video.html"

// 平台运营月报
#define App_Safe_Monthly_URL    @"/html/safe/app-safe-monthly.html"

// 个人信用、信用评分、小额分散、风投注资、资金存管、高管团队、合同安全、信息安全、公司证书、行业协会
// 个人信用
#define App_Person_Credit_URL   @"/html/safe/app-person-credit.html"

// 组织架构
#define App_Safe_Organization_URL  @"/html/safe/organization-struct.html"

//小额分散
#define App_Per_Small_URL       @"/html/safe/app-per-small.html"

//团队介绍
#define App_Team_Intro_URL      @"/html/safe/team-intro.html"

// 运营数据
#define App_Operate_Data_URL    @"/html/safe/operate-data.html"

//高管团队
#define App_Safe_Specialist_URL @"/html/safe/app-safe-specialist.html"

// 合同安全
#define App_Safe_Contract_URL   @"/html/safe/app-safe-contract.html"

// 信息安全
#define App_Safe_Cfca_URL       @"/html/safe/app-safe-cfca.html"

// 收费标准
#define App_Borrow_Product_URL  @"/html/safe/borrow-product-fee.html"

// 公司概况
#define App_Safe_Company_URL     @"/html/safe/company-arch.html"

// 重大事项
#define App_Safe_ImportantThing_URL @"/html/safe/important-thing.html"

// 风控体系
#define App_Safe_Risk_URL @"/html/safe/risk-control-explain.html"

//重大事项披露说明
#define App_Safe_Important_URL @"/html/safe/important-thing-explain.html"

//4.我的 模块 @曾中祥

//网银宝充值协议 老版本删掉
#define App_Mpos_Protocol_URL      @"/html/mpos-protocol.html"

//定期产品
//债权转让规则
#define App_Assign_Rule_URL        @"/html/app-assign-rule.html"
//定期宝赎回说明
#define App_Redemption_Explain_URL @"/html/app-redemption-explain.html"

//礼金、红包、优惠券、积分使用规则
//礼金使用规则
#define App_CashUseRules_URL       @"/html/appCashUseRules.html"
//红包解冻规则说明
#define App_BonusRules_URL         @"/html/appBonusRules.html"
//优惠券使用规则
#define App_CardUseRules_URL       @"/html/appCardUseRules.html"
//如何获取积分
#define App_ScoreIntro_URL         @"/html/appScoreIntro.html"

//摇摇乐详细规则
#define App_MobileShake_Rule_URL   @"/html/app-mobileShake-rule.html"

//积分抽奖活动规则
#define App_Lottery_Explain_URL    @"/html/app-lottery-explain.html"

//信用宝联盟奖励说明、查看联盟规则
#define App_AllianceRules_URL      @"/html/appAllianceRules.html"

//设置模块
//实名认证
#define App_AuthName_Explain_URL   @"/html/app-authName-explain.html"

//VIP特权说明
#define App_Vip_Explain_URL       @"/html/vip-explain.html"

//VIP特权备注
#define App_Vip_Remark_URL        @"/html/app-vip-remark.html"

//VIP服务条款
#define App_Xyb_Servise_URL       @"/html/xyb-servise.html"

//新手任务细则
#define App_NewUser_Task_Rule_URL @"/html/app-newUser-task-rule.html"

//常用问题及产品介绍
#define App_Faq_Index_URL         @"/html/faq/index.html"

//关于信用宝
#define App_About_URL             @"/html/app_about.html"

//登录说明
#define App_Login_Explain_URL     @"/html/app-login-explain.html"

/**
 *  NodeJs                                                                            V2.0.1开发模块(动态H5,需要开发接口）
 */

// 首页（原发现）页面的活动页（6个页面） 动态

// 充值说明、提现说明、银行限额说明 动态
#define App_Bank_Limit_URL @"/bank/limit"  //动态 NodeJs服务器没有
#define App_Bank_Tab_Nav1_URL @"?tab=nav1"//充值说明
#define App_Bank_Tab_CGNav1_URL @"?tab=nav1&type=dep"
#define App_Bank_Tab_Nav2_URL @"?tab=nav2"//提现说明
#define App_Bank_Tab_CGNav2_URL @"?tab=nav2&type=dep"
#define App_Bank_Tab_Nav3_URL @"?tab=nav3"//银行限额说明

// 风险评测
#define App_Risk_Evaluating_URL @"/riskEvaluating/index"

// 网贷逾期信息公示 动态
#define App_Campaign_News_Type2_URL @"/newsList/news?type=2"//动态 NodeJs服务器没有

// 新闻动态(列表) 新闻动态(详情) 消息公告活动详情H5
#define APP_Campaing_news_List_URL @"/newsList/news"

//首页做任务，抢VIP
#define HomePageTaskRequestURL @"/new_task/new_task"

// 已出借明细合同 信投宝\债权转让\惠农宝合同链接：
#define App_Agreement_URL @"/agreement/asset"

// 出借合同
#define App_Investor_URL @"/agreement/investor"

// APP分享注册URL 2016元红包分享落地页
#define App_Share_Signup_URL @"/userRegister/inputRegister?code="

// 摇摇乐/积分抽奖/积分商城/新闻动态分享炫耀落地页
#define APP_Share_Shake @"/campaign/prize/share"

// 积分抽奖
#define App_Score_Lottery_URL @"/lottery"

// 积分商城
#define App_Score_Mall_URL @"/mall"

// 借款申请
#define APP_LOAN_URL @"/loan"

// 信闪贷借款

#endif /* H5UrlDefine_h */
