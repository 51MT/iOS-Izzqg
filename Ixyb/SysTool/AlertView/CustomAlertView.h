//
//  CustomAlertView.h
//  Ixyb
//
//  Created by wang on 15/5/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {

    alertSuccess = 0, // 成功
    alertFailure = 1, // 失败
    alertWarning = 2  // 警告

} alertStatus;

@interface CustomAlertView : UIView

@property (nonatomic, assign) alertStatus status; // 类型
@property (nonatomic, copy) void (^clickButton)();

- (id)initWithStatus:(alertStatus)status;

@end
