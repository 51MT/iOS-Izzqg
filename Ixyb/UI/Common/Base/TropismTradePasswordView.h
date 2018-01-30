//
//  TropismTradePasswordView.h
//  Ixyb
//
//  Created by qiushuitian on 6/1/2016.
//  Copyright © 2016 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "Utility.h"

typedef enum {
    TropismTradePasswordViewActionCancel,
    TropismTradePasswordViewActionForgetPassword,
    TropismTradePasswordViewActionOK
} TropismTradePasswordViewAction;

typedef void (^TropismTradePasswordViewCompletion)(TropismTradePasswordViewAction action, NSString *password);

@interface TropismTradePasswordView : BaseView

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, strong) ColorButton *sureBtn;

- (void)show:(TropismTradePasswordViewCompletion)completion;

@end
