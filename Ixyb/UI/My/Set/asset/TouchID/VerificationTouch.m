//
//  VerificationTouch.m
//  Ixyb
//
//  Created by wang on 16/6/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "Utility.h"
#import "VerificationTouch.h"

@implementation VerificationTouch

+ (VerificationTouch *)shared {

    static VerificationTouch *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[VerificationTouch alloc] init];
        }
    });
    return _instance;
}

- (void)isSupportTouch:(touchBlock)block {

    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    //判断设备是否支持touchID
    BOOL isSupport = [context canEvaluatePolicy:
                                  LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                          error:&error];

    if (isSupport) {

        block(YesSupportedTouID);

    } else {
        if (error.code == LAErrorTouchIDNotAvailable) {

            block(NotSupportedTouID);

        } else {
            if (error.code == LAErrorTouchIDNotEnrolled) {

                block(UserNotInputTouID);
            } else {
                block(YesSupportedTouID);
            }
        }
    }
}

- (void)SupportTouchID:(touchBlock)block {
    //指纹验证
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = XYBString(@"string_tradePassword", @"交易密码");
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹,用于交易" reply:^(BOOL success, NSError *error) {
        if (success) { //验证成功，主线程处理UI

            block(TouIDVerficationSuccess);

        } else {

            switch (error.code) {
                case LAErrorSystemCancel: { // 切换到其他APP，系统取消验证Touch ID

                    block(UserCancelTouID);
                    break;
                }
                case LAErrorUserCancel: { //用户取消验证Touch ID

                    block(UserCancelTouID);
                    break;
                }
                case LAErrorUserFallback: { //用户选择输入密码，切换主线程处理

                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 主线程处理UI
                        block(UserInputPassWord);
                    });
                    break;
                }
                case LAErrorPasscodeNotSet: //系统未设置密码
                {
                    block(SystemPassWord);
                    break;
                }
                case LAErrorTouchIDNotAvailable: //设备Touch ID不可用，例如未打开
                {
                    block(SystemTouIDNotOpen);
                    break;
                }
                case LAErrorTouchIDNotEnrolled: //设备Touch ID不可用，用户未录入
                {
                    block(UserNotInputTouID);
                    break;
                }
                default: {
                    block(TouIDVerficationFail);
                } break;
            }
        }
    }];
}

@end
