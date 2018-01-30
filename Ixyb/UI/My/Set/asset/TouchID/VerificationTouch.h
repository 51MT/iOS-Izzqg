//
//  VerificationTouch.h
//  Ixyb
//
//  Created by wang on 16/6/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef enum {
    TouIDVerficationSuccess, //验证成功
    TouIDVerficationFail,    //验证失败
    NotSupportedTouID,       //不支持TouID
    YesSupportedTouID,       //支持TouID
    UserCancelTouID,         //用户取消验证TouID
    UserInputPassWord,       //用户选择请输入密码
    SystemPassWord,          //系统未设置密码
    SystemTouIDNotOpen,      //系统TouID未打开
    UserNotInputTouID        //用户未录入TouID
} XybTouIDVerification;
typedef void (^touchBlock)(XybTouIDVerification touchType);

/**
 *   指纹验证
 */
@interface VerificationTouch : NSObject

+ (VerificationTouch *)shared;
/**
 *  判断是否支持Touch ID
 *
 *  @param block
 */
- (void)isSupportTouch:(touchBlock)block;

/**
 *  支持Touch ID
 *
 *  @param block
 */
- (void)SupportTouchID:(touchBlock)block;
@end
