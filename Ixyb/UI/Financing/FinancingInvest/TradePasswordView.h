//
//  TradePasswordView.h
//  Ixyb
//
//  Created by wang on 15/11/18.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TradePasswordViewActionCancel,
    TradePasswordViewActionForgetPassword,
    TradePasswordViewActionOK
} TradePasswordViewAction;

typedef void (^TradePasswordViewCompletion)(TradePasswordViewAction action, NSString *password);

@interface TradePasswordView : UIView <UITextFieldDelegate>

@property (nonatomic, copy) void (^clickForgetButton)();
@property (nonatomic, copy) void (^clickSureButton)(NSString *payStr);

@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *titleLabel;

+ (TradePasswordView *)shareInstancesaidView;

@end
