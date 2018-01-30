//
//  Utility.h
//  Ixyb
//
//  Created by wang on 15/4/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XYDefine.h" //XYB公共定义类
#import "XYModel.h"  //XYB数据模型
#import "XYUtil.h"   //XYB公共工具类

#import "CustomAlertView.h"
#import "XYButton.h"
#import "XYCellLine.h"

#import "ColorButton.h"

#import "Constant.h"
#import "HUD.h"
#import "HUDManager.h"
#import "Masonry.h"

#import "AFAppDotNetAPIClient.h"

#import "ChargeResultStatusViewController.h"
#import "OrderHaveSubmitViewController.h"

#import "User.h"
#import "UserAddress.h"

#import "IPhoneXNavHeight.h"

#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

typedef enum {
    jumpFrom0 = 0, //
    jumpFrom1 = 1, //
    jumpFrom2 = 2  //

} JumpStatus;

@interface Utility : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isGestureUnlock;    //是否有手势密码 默认NO 有
@property (nonatomic, assign) BOOL isAddScoreFromHome; //积分UI显示入口
@property (nonatomic, assign) JumpStatus status;       // 类型
@property (nonatomic, assign) double xsdScale;         // 大刻度位数

+ (Utility *)shareInstance;

// 是否为数字字母下划线组成
+ (BOOL)isValidateCharStr:(NSString *)str;

/*邮箱验证*/
+ (BOOL)isValidateEmail:(NSString *)email;
/*短信验证码验证*/
+ (BOOL)isValidateEmailCode:(NSString *)EmailCode;
/*手机号码验证*/
+ (BOOL)isValidateMobile:(NSString *)mobile;
//金额数字
+ (BOOL)isValidateNumber:(NSString *)number;
/*输入数值*/
+ (BOOL)isValidateinvestNum:(NSString *)money;
/*定投金额验证*/
+ (BOOL)isValidateMoney:(NSString *)money;
/*汉字 字母 数字*/
+ (BOOL)isValidateChinaStr:(NSString *)str;

/*网址*/
+ (BOOL)isValidateWebsiteStr:(NSString *)str;

//财务计数
+ (NSString *)replaceTheNumberForNSNumberFormatter:(NSString *)numStr;

//利率计数（必须传入带有两位小数的字符串）
+ (NSString *)rateReplaceTheNumberForNSNumberFormatter:(NSString *)numStr;

//四舍五入（解决数据传输途中问题：服务器给数据10.00，前端接收到却成了9.99）
+ (NSString *)notRounding:(float)price afterPoint:(int)position;

//计算高度
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

//银行卡
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber;

/*银行卡格式化*/
+ (NSString *)firendlyCardString:(NSString *)cardStr;

/*字符串前后加俩空格*/
 + (NSString *)frontAfterString:(NSString *)str;


// 银行卡号转正常号 － 去除4位间的空格
+ (NSString *)bankNumToNormalNum:(NSString *)bankStr;

+ (BOOL)isValidatePassword:(NSString *)password;

// 是否为6位数的验证码
+ (BOOL)isSixVerifyCode:(NSString *)varifyCode;

// 是否为4位数的验证码
+ (BOOL)isFourVerifyCode:(NSString *)varifyCode;

/*隐藏部分号码*/
+ (NSString *)thePhoneReplaceTheStr:(NSString *)phone;

//匹配小数位
+ (NSString *)stringrangeStr:(NSString *)str;



//SHA1加密方式
+ (NSString *)sha1:(NSString *)input;
+ (NSString *)withThesha:(NSDictionary *)inputDic;
+ (NSString *)setUserAgent;

/**********字符串中搜索空格**************/
+ (BOOL)checkThenullStringBystring:(NSString *)str;

//去除空格
+ (NSString *)removeTheBlank:(NSString *)blankStr;

+ (BOOL)isExistenceNetwork;

//+(NSString *)formatPrecent:(NSInteger)fmt precent:(CGFloat)precent;

//金额格式化
+ (NSString *)formatFinance:(id)number;

//利率格式化
+ (NSString *)formatInterest:(id)number;

//检测并去掉emoji
+ (NSString *)disable_emoji:(NSString *)text;

//校验用户名输入
+ (NSString *)checkUserName:(NSString *)userName;
//校验密码输入
+ (NSString *)checkPassword:(NSString *)password;
//校验验证码输入
+ (NSString *)checkVerifyCode:(NSString *)verifyCode;
//校验验Email
+ (NSString *)checkEmail:(NSString *)email;

+ (NSMutableAttributedString *)rateAttributedStr:(CGFloat)rate size:(CGFloat)sizeText sizeSymble:(CGFloat)sizeSymbel color:(UIColor *)color;

+ (void)modifyLabel:(UILabel *)label color:(UIColor *)color font:(UIFont *)font space:(CGFloat)space;

+ (NSMutableAttributedString *)processTheDecimalTheRate:(CGFloat)rate size:(CGFloat)sizeText sizeSymble:(CGFloat)sizeSymbel color:(UIColor *)color;

+ (NSMutableAttributedString *)getAttributedstring:(NSString *)haxStr tailStr:(NSString *)tailStr labColor:(id)value;

+ (NSURL *)emailWebAddress:(NSString *)email;
+ (NSString *)dateFormate:(NSDate *)date formate:(NSString *)fmt;
+ (NSMutableAttributedString *)multAttributedString:(NSArray *)attrArray;

+ (NSDictionary *)findBankInfoByType:(int)type;

+ (NSString *)getUserAgent;

@end
