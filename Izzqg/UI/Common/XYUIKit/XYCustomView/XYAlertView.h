//
//  XYAlertView.h
//  Ixyb
//
//  Created by wang on 16/3/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTLabel.h"
#import "RechargeVipModel.h"
#import "RedemptionInfo.h"

typedef void(^rightBlock)(NSString *contentStr);
typedef void(^cancelBlock)(void);

typedef NS_ENUM(NSInteger,CustomedAlertStyle) {
    KQAlertStyleDefault = 0,//快钱弹窗
    TLAlertStyle,//通联弹窗
};

@interface XYAlertView : UIView <UITextFieldDelegate, RTLabelDelegate>

@property (nonatomic, copy) void (^clickHyperlinkButton)();
@property (nonatomic, copy) void (^clickUrlButton)();
@property (nonatomic, copy) rightBlock clickSureButton;
@property (nonatomic, copy) cancelBlock clickCancelButton;
@property (nonatomic, copy) void (^clickSureVipButton)(NSString *contentStr, NSInteger tag);
@property (nonatomic, copy) void (^clickStartLocationButton)(BOOL isOpen);
@property (nonatomic, copy) void (^clickCodeButton)(); //快钱弹窗中重新获取验证码时使用,回调是否发送验证码
@property (nonatomic, strong) UILabel *remaindLab;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UILabel *telephoneLab;

@property (nonatomic, strong) UIAlertView *alertView;

/**
 * 输入密码弹出框
 */
- (id)initWithTitle:(NSString *)title isShowHyperlinkButton:(BOOL)show IsEyes:(BOOL)eyes;

/**
 *  弹出框(参考首页签到弹出框)
 *
 *  @param image       图片
 *  @param title       图片下的title
 *  @param describeStr 内容
 *  @param isHave      是否有图片
 *
 *  @return UIview
 */
- (id)initWithRadioAlertViewClueImage:(UIImage *)image
                                title:(NSMutableAttributedString *)title
                             describe:(NSString *)describeStr
                          isHaveIamge:(BOOL)isHave;

/**
 *  弹出框（未使用过，底部为“确定”和“取消”按钮）
 *  @param title       标题
 *  @param describeStr 描述
 *  @return UIview
 */
- (id)initWithMoreSelectAlertViewTitle:(NSString *)title
                              describe:(NSString *)describeStr;

/**
 *  购买VIP 弹出框
 *  @param rechargeVip RechargeVipModel 模型
 *  @return UIview
 */
- (id)initWithRadioVipAlertView:(RechargeVipModel *)rechargeVip type:(NSInteger)type;

/**
 *   定期宝赎回弹出框(老版的，现在没用了，暂时不删)
 *
 *  @param title          标题
 *  @param show           是否显示“赎回规则”和“忘记密码”按钮
 *  @param eyes           是否在密码输入框中显示眼睛，(有：密文；没有：明文)
 *  @param redemptionInfo 模型
 *
 *  @return UIview
 */
- (id)initBackWithTitle:(NSString *)title
  isShowHyperlinkButton:(BOOL)show
                 IsEyes:(BOOL)eyes
     WithRedemptionInfo:(RedemptionInfo *)redemptionInfo;

/**
 *  确定弹出框(预付利息的弹窗)
 *  @param descripe 内容
 *  @return UIview
 */
- (id)initWithFrame:(CGRect)frame SureBorderDescription:(NSString *)descripe;

/**
 *  风险测评弹出框
 *
 *  @param frame       显示大小
 *  @param descripe    描述
 *  @param buttonTitle 底部按钮的title
 *
 *  @return UIview
 */
- (id)initWithFrame:(CGRect)frame presentTestWindowWithDescripe:(NSString *)descripe bottomButtonTitle:(NSString *)buttonTitle;

/**
 快钱支付确认弹出框 / 通联支付确认弹窗框

 @param frame          显示大小
 @param title          标题
 @param telephoneNo    银行预留手机号
 @param style          快钱弹窗/通联弹窗
 @return UIView
 */
- (id)initPaySureBorderWithFrame:(CGRect)frame title:(NSString *)title telephoneNo:(NSString *)telephoneNo alertStyle:(CustomedAlertStyle)style;

/**
  信闪贷 一键开启弹窗

 @param frame          大小
 @param title          标题
 @param describeStr    描述
 @param buttonTitle    底部按钮的title
 @return UIView
 */
- (id)initWithStartLocationAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr bottomButtonTitle:(NSString *)buttonTitle;


/**
 新功能上线通知

 @param frame    大小
 @param titleStr 标题
 @param describeStr 描述
 @param leftBtnTitleStr 左边按钮的title
 @param rightBtnTitleStr 右边标题的title
 @return UIView
 */
- (id)initWithNewFunctionAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr leftButtonTitle:(NSString *)leftBtnTitleStr rightButtonTitle:(NSString *)rightBtnTitleStr;

@end

@interface XYAlertViewComponent : NSObject

/*
 *  输入框样式
 *  title       标题
 *  show    是否显示超链接按钮 例如忘记密码
 *  eyes     密码是否明文显示
 *  addViewController 承载控制器
 */
+ (XYAlertView *)initWithTheTitle:(NSString *)title
            isShowHyperlinkButton:(BOOL)show
                           IsEyes:(BOOL)eyes
                addViewController:(UIViewController *)viewController;

/*
 *  image 单个选项 （带图片和不带）
 *  title       标题
 *  describe    描述内容
 *  isHave 显示样式
 *  addViewController 承载控制器
 */
+ (void)initWithRadioAlertViewClueImage:(UIImage *)image
                                  title:(NSMutableAttributedString *)title
                               describe:(NSString *)describe
                      addViewController:(UIViewController *)viewController
                            isHaveIamge:(BOOL)isHave;

/**
 *  购买VIP套餐 弹出框
 */
+ (void)initWithRadioVipAlertView:(RechargeVipModel *)RechargeVip type:(NSInteger)type addViewController:
(UIViewController *)viewController;

/*
 *  多个选项（两个按钮）
 *  title       标题
 *  describe    描述内容
 *  addViewController 承载控制器
 */
+ (XYAlertView *)initWithMoreSelectAlertViewTitle:(NSString *)title
                                         describe:(NSString *)describeStr
                                addViewController:(UIViewController *)viewController;

/*
 *  输入框样式
 *  title       标题
 *  show    是否显示超链接按钮 例如忘记密码
 *  eyes     密码是否明文显示
 *  addViewController 承载控制器
 */
+ (XYAlertView *)initBackWithTheTitle:(NSString *)title
                isShowHyperlinkButton:(BOOL)show
                               IsEyes:(BOOL)eyes
                   WithRedemptionInfo:(RedemptionInfo *)redemptionInfo
                    addViewController:(UIViewController *)viewController;

@end
