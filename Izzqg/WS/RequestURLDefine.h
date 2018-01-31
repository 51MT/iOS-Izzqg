//
//  RequestURLDefine.h
//  IXsd
//
//  Created by wangjianimac on 16/6/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#ifndef RequestURLDefine_h
#define RequestURLDefine_h

//用户模块：用户登录、注册、忘记密码
//用户登录
#define UserLoginRequestURL @"/user/login?sign="

#define ResetPasswordRequestURL @"/user/resetPassword?sign="

//手机快捷登录-登录
#define UserPhoneSMSRequestURL @"/user/smsLogin?sign="

//手机快捷登录-获取验证码
#define UserPhoneVerifyCodeRequestURL @"/user/getVerifyCode?sign="

//用户注册
#define UserRegisterRequestURL @"/user/register?sign="

//首页接口
#define HomePageRequestURL @"/index?sign="

//首页V2接口
#define FinancingRequestURL @"/v2/index?sign="

//首页签到
#define HomePageAttendenceRequestURL @"/user/signin?sign="

//首页签到做任务nodejs
#define HomePageGoSignRequestURL @"/signin/goSign"

//新手任务规则说明
#define VipRuleReqestURL @"/html/app-newUser-taskRule.html"

//出借产品—活期宝
#define InvestProduct_Hqb @"/invest/hqb?sign="

//出借产品—活期宝详情
#define InvestProduct_HqbDetailRequestURl @"/invest/hqb/my?sign="

//活期宝-万份收益列表接口
#define HqbTotalProfitURL @"/invest/hqb/totalProfit?sign="

//出借产品-活期宝-项目出借明细
#define Hqb_projectInvestDetailRequestURL @"/invest/hqb/matchDetail?sign="

//出借产品-活期宝-转入
#define Hqb_TransferIn @"/invest/hqb/transferIn?sign="

//出借产品-活期宝-转出
#define Hqb_TransferOut @"/invest/hqb/transferOut?sign="

//出借产品-活期宝转入记录
#define Hqb_TransferInRecord @"/invest/hqb/deposit?sign="

//出借产品-活期宝转出记录
#define Hqb_TransferOutRecord @"/invest/hqb/rebackApply?sign="

//出借产品-活期宝收益记录
#define Hqb_IncomeRecord @"/invest/hqb/userProfit?sign="

//出借产品-活期宝转入历史每日收益
#define Hqb_RealProfit @"/invest/hqb/realData?sign="

//出借产品-活期宝转入实时数据
#define Hqb_TransferInRealData @"/invest/hqb/realData?sign="

//出借产品-步步高
#define BbgProductData @"/bbg/product?sign="

//出借产品-步步高详情
#define BbgDetailData @"/bbg/product?sign="

//出借产品-步步高收益查询
#define BbgPreIncomeCheckURL @"/bbg/preIncome?sign="

//一键出借产品列表接口
#define OneKeyProductList_URL @"/dep/gather/list?sign="

//存管开户接口
#define CGAccountRegister_URL @"/dep/form/register"

//出借产品-定期宝列表
#define CcProductData @"/invest/cc/products?sign="

//出借产品-定期宝详情
#define CcDetailURL @"/invest/cc/product/info?sign="

//出借产品-定期宝出借记录
#define CcInvestRecordsURL @"/invest/cc/records?sign="

//一键出借产品 出借前接口
#define OneKeyProductPreInvest_URL @"/dep/gather/preInvest?sign="

//一键出借产品 出借接口
#define OneKeyProductDoInvest_URL @"/dep/gather/invest?sign="

//出借产品-定期宝/信投宝出借前接口
#define DqbAndXtbPreInvestURL @"/invest/preInvest?sign="

//出借产品-信投宝出借接口
#define XtbInvestURL @"/invest/doInvest?sign="

//出借产品-定期宝出借接口
#define DqbInvestURL @"/invest/cc/doInvest?sign="

//出借产品-信投宝列表
#define XtbProductData @"/invest/products?sign="

//出借产品-信投宝详情
#define XtbProductDetailData @"/invest/product/info?sign="

//出借产品-信投保匹配详情
#define XtbMatchingProductURL @"/asset/xtb/details?sign="

//出借产品-信闪贷匹配详情
#define XsdMatchingProductURL @"/asset/xsd/details?sign="

//一键出借产品 匹配后的借款详情
#define OneKeyProductLoanBidDet_URL @"/dep/loan/bidDetail?sign="

////出借产品-人人车匹配详情
//#define RrcMatchingProductURL @"/asset/rrc/details?sign="
//
////出借产品-租葛亮匹配详情
//#define ZglMatchingProductURL @"/asset/zgl/details?sign="

//出借产品-匹配详情 2.1.7 新增接口
#define AssetMatchingProductURL @"/asset/details?sign="

//出借产品-惠农宝匹配详情
#define HnbMatchingProductURL @"/asset/hnb/details?sign="

//出借产品-惠农宝详情
#define HnbProductDetailDate @"/hnb/info?sign="

//出借产品-信投宝出借记录
#define XtbInvestRecordURL @"/invest/bid?sign="

//出借产品-债权转让出借记录
#define ZqzrInvestRecordURL @"/invest/ca/invest-record?sign="

//出借产品-债权转让列表
#define ZqzrProductData @"/invest/ca/list?sign="

//出借产品-债权转让详情
#define ZqzrDetailURL @"/invest/ca/info?sign="

//出借产品-债权转让历史收益查询
#define ZqzrCheckIncomeURL @"/invest/ca/income?sign="

//出借产品-债权转让出借接口
#define ZqzrInvestURL @"/invest/ca/doInvest?sign="

//出借产品-步步高计算器
#define BbgCalculatorData @"/bbg/calculator?sign="

//出借产品-活期宝出借记录接口
#define HqbInvestRecordURL @"/invest/hqb/tradeRecords?sign="

//出借产品-步步高出借记录接口
#define BbgInvestRecordRequestURL @"/bbg/tradeRecords?sign="

//出借产品-步步高出借接口
#define BbgInvestURL @"/bbg/doInvest?sign="

//信闪贷详情接口
#define XsdDetailRequestURL @"/invest/xsd/info?sign="

//摇摇乐中奖记录
#define ShakePrideRecordRequestURL @"/shaker/prizes?sign="

//摇摇乐次数查询
#define ShakeTimesRequestURL @"/user/shake/data?sign="

//摇一摇时数据请求
#define ShakingRequestURL @"/user/shake?sign="

//保存实名认证接口
#define SaveRealNameAuthURL @"/user/saveAuthInfo?sign="

//检验手机验证码接口
#define checkPhoneCodeURL @"/user/code/verify?sign="

//我的联盟-报表
#define MyUnionTheReportURL @"/user/recommend/report?sign="

//我的联盟-我的排名
#define MyUnionRankURL @"/user/recommend/rank?sign="

//选择支付路由接口
#define ChargePayRouteURL @"/recharge/payRoute?sign="

//快钱确认支付接口
#define Bill99ChargeURL @"/recharge/kq/confirmPay?sign="

//快钱重新创建订单并发送验证码
#define BillCreatOrderURL @"/recharge/kq/createOrder?sign="

//根据银行卡前6位查询银行类型
#define CheckBankTypeURL @"/bank/prefix?sign="

//连连充值接口
#define RechargeURL @"/recharge/sign?sign="

//连连充值回调
#define LLChargeReturnURL @"/callback/lianlpayreturn?sign="

//通联支付
#define TNPayURL @"/recharge/tonglian/confirmPay?sign="

//通联支付发送验证码
#define TNPaySendCodeURL @"/recharge/tonglian/sendCode?sign="

//信闪贷查询授信接口
#define XsdGetBorrowURL @"ws/getBorrowAction.json"

//信闪贷获取通讯录接口
#define XsdContactsURL @"/xsd/contacts/push" //因为通讯录字符串太长，故未加签名验证

//出借使用的加息券
#define IncreaseCardInvestCanUseURL @"/user/increaseCard/use?sign="

//消息分类接口
#define NotificationCategoryURL @"/notification/category?sign="

//公告消息接口
#define NotificationURL @"/notification?sign="

//快钱独立鉴权发送验证码
#define KqdljqSendCode @"/recharge/kq/sendCode?sign="

//快钱独立鉴权验证验证码
#define KqdljqVerifyCode @"/recharge/kq/verifyCode?sign="

//信闪贷页面接口
#define XsdPageURL @"/ws/queryBorrowPage.json"

//信闪贷1000元快速借款接口
#define XsdQuickBorrowURL @"/ws/handleGpsInfo.json"

//信闪贷上传tokenKey接口
#define XsdTokenKeyURL @"/ws/setTokenKey.json"

//信闪贷身份证照片上传接口
#define XsdHandleIdPhotosURL @"/app-loan/portrait/upload"

//信闪贷人脸比对接口接口
#define XsdFaceCompareURL @"/app-loan/portrait/faceVerify"

//信闪贷活体检测接口
#define XsdLivingCheckURL @"/app-loan/portrait/livingCheck"

//信闪贷可借额度接口
#define XsdQueryAmountURL @"/ws/queryCanAmount.json"

//资产配置列表
#define FinanceAssetListURL @"/asset/list?sign="

//存管账户信息查询
#define CGAccountInfo_URL @"/dep/accountInfo?sign="

//存管换绑卡
#define CGAccountChangeCard_URL @"/dep/form/changeBankcard"

//存管修改密码
#define CGAccountResetPassword_URL @"/dep/form/resetPassword"

//一键出借产品详情
#define OneKeyProductDetail_URL @"/dep/gather/info?sign="

//一键出借产品 出借记录
#define OneKeyProductOrderList_URL @"/dep/gather/orderList?sign="

//一键出借产品 标的组成
#define OneKeyProductBidItems_URL @"/dep/gather/bidItems?sign="

#pragma mark-- 安全
#define SafeRequestURL @"/safe/statis?sign="

#pragma mark-- 账户
#define AccountRequestURL @"/user/account?sign="

#pragma mark-- App活动banner
#define DiscoverRequestURL @"/share/list?sign="

#pragma mark--  用户信息接口
#define UserMyRequestURL @"/user/my?sign="

#pragma mark-- 用户头像上传接口
#define UserMyHeadImageURL @"/user/portrait/upload?sign="

#pragma mark-- 修改用户信息接口
#define UserUpdateInfoURL @"/user/updateUserInfo?sign="

#pragma mark-- VIP 权益
#define VipMyURL @"/vip/my?sign="

#pragma mark-- 充值VIP套餐
#define VipComboURL @"/vip/combo?sign="

#pragma mark-- 购买VIP套餐
#define VipBuyURL @"/vip/buy?sign="

#pragma mark-- 修改用户地址接口
#define UserUpdateAddressURL @"/user/updateAddress?sign="

#pragma mark-- 实名认证接口
#define UserAuthRealNameURL @"/user/authRealName?sign="

#pragma mark-- 公告消息接口
#define NotificationURL @"/notification?sign="

#pragma mark-- 意见反馈接口
#define FeedbackURL @"/feedback/save?sign="

#pragma mark-- 修改登录密码
#define UpdateLoginPasswordURL @"/user/updateLoginPassword?sign="

#pragma mark-- 绑定邮箱
#define BindEmailURL @"/user/bindEmail?sign="

#pragma mark-- 修改手机号码接口
#define UpdateMobilePhoneURL @"/user/updateMobilePhone?sign="

#pragma mark-- 修改交易密码接口
#define UpdateTradePasswordURL @"/user/updateTradePassword?sign="

#pragma mark-- 设置交易密码接口
#define SetTradePasswordURL @"/user/setTradePassword?sign="

#pragma mark-- 检测银行卡绑定接口
#define BankURL @"/user/bank?sign="

#pragma mark-- 查询实名认证信息
#define AuthRealNameURL @"/user/auth/realName?sign="

#pragma mark-- 实名认证接口
#define RealNameAuthURL @"/user/authRealName?sign="

#pragma mark-- 欢迎页面启动图片
#define LaunchICONURL @"/launch/icon?sign="

#pragma mark-- 收支明细接口
#define UserTransDetailsURL @"/user/transDetails?sign="

#pragma mark--  充值记录接口
#define RechargeListURL @"/recharge/list?sign="

#pragma mark--  提现记录接口
#define AccountWithdrawalsURL @"/account/withdrawals?sign="

#pragma mark-- 撤销提现接口
#define AccountDrawMoneyCancelURL @"/account/drawMoney/cancel?sign="

#pragma mark-- 冻结记录
#define AccountFreezeDetailURL @"/account/freezeDetail?sign="

#pragma mark-- 已投列表
#define InvestMyInvestURL @"/invest/myInvest?sign="

#pragma mark-- BBG已投列表
#define BbgInvestOrderList @"/bbg/invest/orderList?sign="

#pragma mark-- DQB已投列表
#define DqbInvestOrderList @"/invest/cc/orderList?sign="

#pragma mark-- Xtb已投列表
#define XtbInvestOrderList @"/xtb/invest/orderList?sign="

#pragma mark-- 回款计划
#define UserCollectDetailsURL @"/user/collectDetails?sign="

#pragma mark-- 礼金账户接口
#define UserAccountGetRewardAccountURL @"/user/account/getRewardAccount?sign="

#pragma mark-- 一级好友出借记录
#define UserInvestDetailtURL @"/user/recommend/investDetail?sign="

#pragma mark--  会员积分详情
#define UserScoreURL @"/user/score?sign="

#pragma mark-- 红包详情接口
#define UserAccountGetSleepRewardAccountDetailURL @"/user/account/getSleepRewardAccountDetail?sign="

#pragma mark-- 红包账户接口
#define UserAccountGetSleepRewardAccountURL @"/user/account/getSleepRewardAccount?sign="

#pragma mark-- 收益卡列表接口
#define UserIncreaseCardURL @"/user/increaseCard?sign="

#pragma mark-- 查询省市信息接口
#define AreasURL @"/areas?sign="

#pragma mark-- 查询省市区信息接口
#define UserAreaURL @"/user/area?sign="

#pragma mark-- 查询支行信息接口
#define BankBranchURL @"/bank/branch?sign="

#pragma mark-- 已投详情
#define InvestDetailURL @"/invest/detail?sign="

#pragma mark--  步步高已投详情查询
#define BbgInvestDetailURL @"/bbg/invest/detail?sign="

#pragma mark--  定期宝已投详情查询
#define DqbInvestDetailURL @"/invest/cc/detail?sign="

#pragma mark--  信投宝已投详情查询
#define XtbInvestDetailURL @"/xtb/invest/detail?sign="

#pragma mark-- 步步高回款明细
#define BbgInvestPaymentDetailURL @"/bbg/invest/paymentDetail?sign="

#pragma mark-- 定期宝回款明细
#define DqbInvestPaymentDetailURL @"/invest/cc/paymentDetail?sign="

#pragma mark-- 信投保回款明细
#define XtbInvestPaymentDetailURL @"/xtb/invest/paymentDetail?sign="

#pragma mark-- 绑定邮箱
#define UserInvestSendContractURL @"/user/invest/sendContract?sign="

#pragma mark -- 存管发送合同
#define UserCgInvestSendContractURL @"/dep/order/sendContract?sign="

#pragma mark-- 已投项目出借明细
#define MyInvestAssetMatchDetailURL @"/myInvest/assetMatchDetail?sign="

#pragma mark-- 步步高赎回
#define BbgInvestRebackURL @"/bbg/invest/reback?sign="

#pragma mark-- 步步高取消赎回
#define BbgInvestCancelRebackURL @"/bbg/invest/cancelReback?sign="

#pragma mark-- 步步高赎回查询
#define BbgInvestRebackInfoURL @"/bbg/invest/rebackInfo?sign="

#pragma mark-- 信投宝 我要转让 手续费
#define XtbCaAssignRuleURL @"/ca/assignRule?sign="

#pragma mark-- 信投宝 我要转让
#define XtbCaAssignApplyURL @"/ca/assignApply?sign="

#pragma mark-- 定期宝赎回
#define DqbMyinvestDoRedemptionURL @"/myInvest/doRedemption?sign="

#pragma mark-- 查询定期宝赎回信息：赎回本金、应计利息、提前赎回手续费、预计到账金额、预计到账时间
#define DqbMyinvestRedemptionInfoURL @"/myInvest/redemptionInfo?sign="

#pragma mark-- 债权转让记录
#define CaAcceptRecordURL @"/ca/acceptRecord?sign="

#pragma mark-- 提现接口
#define AccountDrawMoneyURL @"/account/drawMoney?sign="

#pragma mark-- 提现手续费
#define AccountDrawMoneyFeeURL @"/account/drawMoney/fee?sign="

#pragma mark-- 保存实名认证信息接口
#define UserSaveAuthInfoURL @"/user/saveAuthInfo?sign="

#pragma mark-- 信用宝联盟推荐详情数据
#define UserRecommendDetailURL @"/user/recommend/detail?sign="

#pragma mark-- 	推荐收益数据
#define UserRecommendlStatURL @"/user/recommend/stat?sign="

#pragma mark-- 信用宝联盟申请
#define BonusApplyURL @"/bonus/apply?sign="

#pragma mark--  网银宝充值手续费
#define RechargeWangyinbaoPayFeeURL @"/recharge/wangyinbao/payFee?sign="

#pragma mark-- 网银宝查询订单状态接口
#define RechargeWangyinbaoOrderStatusURL @"/recharge/wangyinbao/order/status?sign="

#pragma mark-- 网银宝创建订单
#define RechargeWangyinbaoCreateOrderURL @"/recharge/wangyinbao/createOrder?sign="

#pragma mark--  网银宝绑定订单
#define RechargeWangyinbaoBindDeviceURL @"/recharge/wangyinbao/bindDevice?sign="

#pragma mark--  银联商通充值手续费
#define RechargeSTPayFeeURL @"/unionPayST/payFee?sign="

#pragma mark-- 银联商通创建订单
#define RechargeSTCreateOrderURL @"/unionPayST/createOrder?sign="

#pragma mark-- 银联商通订单完成
#define RechargeSTDoneURL @"/unionPayST/order/done?sign="

#pragma mark-- 当前版本接口
#define VersionUpdateURL @"/version/update?sign="

#pragma mark-- 非联盟用户分享接口
#define NonalliedShareURL @"/nonallied/share?sign="

#pragma mark--  校验交易密码接口
#define UserVerifyTradePasswordURL @"/user/verifyTradePassword?sign="

#pragma mark--  绑定银行卡接口
#define UserBankAddURL @"/user/bank/add?sign="

#pragma mark-- 校验手机号码接口
#define UserCodeVerifyURL @"/user/code/verify?sign="

#pragma mark-- 非信用宝联盟人员推荐收益查询
#define BonusEarnURL @"/bonus/earn?sign="

#pragma mark-- 充值限额查询
#define RechargeLimitURL @"/recharge/limit?sign="

#pragma mark-- 查询出借后获得奖励
#define InvestGetOrderRewordURL @"/invest/getOrderReword?sign="

#pragma mark-- 摇一摇刷卡器申领前接口
#define ShakerMposPreApplyURL @"/shaker/mpos/preApply?sign="

#pragma mark-- 摇一摇刷卡器申领接口
#define ShakerMposApplyURL @"/shaker/mpos/apply?sign="

#pragma mark-- 步步高出借接口
#define BbgDoinvestURL @"/bbg/doInvest?sign="

#pragma mark-- 渠道激活
#define ChannelActivationURL @"/channel/activation?sign="

#pragma mark --  实时交易数据
#define TradDataURL @"/tradeData/statis?sign="

#pragma mark --  用户心声
#define UserCommentsURL @"/user/comments?sign="

#pragma mark --   消息订阅查询
#define SubscribeInfoURL @"/subscribe/info?sign="

#pragma mark -- 消息订阅配置
#define SubscribeComfigURL @"/subscribe/config?sign="

#pragma mark -- 图片识别接口
#define ORC_URL @"https://netocr.com/api/recog.do"

#pragma mark --  获取身份证接口
#define FaceI_URL @"https://api.faceid.com/faceid/v1/ocridcard"

#pragma mark -- 二维码扫码
#define QrcodeScanURL @"/qrcode/scan?sign="

#pragma mark --  确认登录
#define QrcodeLoginURL @"/qrcode/login?sign="

#pragma mark -- 客户经理佣金记录
#define RecommendCommissionURL @"/user/recommend/commission?sign="

#pragma mark -- 我的预约记录
#define MyReserve_URL @"/user/myReserve?sign="

#pragma mark -- 我的预约失效记录
#define MyReserveInvalid_URL @"/user/myReserve/history?sign="

#pragma mark -- 存管充值接口
#define CgRechargeURL @"/dep/form/recharge"

#pragma mark -- 存管提现接口
#define CgWithdrawURL @"/dep/form/withdraw"

#pragma mark --  存管账户统计
#define AccountStatURL @"/dep/accountStat?sign="

#pragma mark --  存管已投列表
#define OrderListURL @"/dep/order/list?sign="

#pragma mark --  存管已投详情
#define OrderDetailURL @"/dep/order/detail?sign="

#pragma mark --  存管回款计划
#define RefundPlanURL @"/dep/refundPlan?sign="

#pragma mark --  存管回款明细
#define OrderRefundDetailURL @"/dep/order/refundDetail?sign="

#pragma mark --  存管转让记录
#define OrderAssignDetailURL @"/dep/order/assignDetail?sign="

#pragma mark --  存管已完成列表
#define OrderFinishURL @"/dep/order/finish?sign="

#pragma mark --  存管出借明细
#define OrderMathListURL @"/dep/order/matchList?sign="

#pragma mark -- 存管转让信息查询
#define OrderRebackInfoURL @"/dep/order/rebackInfo?sign="

#pragma mark -- 存管一键转让
#define OrderRebackURL @"/dep/order/reback?sign="

#pragma mark -- 收支明细
#define CgAccountFlowURL @"/dep/account/flow?sign="

#pragma mark -- 充值明细
#define CgRechargeHistoryURL @"/dep/recharge/history?sign="

#pragma mark -- 冻结明细
#define CgFreezeRecordURL @"/dep/account/freezeRecord?sign="

#pragma mark -- 提现明细
#define CgWithdrawHistoryURL @"/dep/withdraw/history?sign="

#endif /* RequestURLDefine_h */
