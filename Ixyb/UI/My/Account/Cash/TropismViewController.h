//
//  TropismViewController.h
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AlertViewToSetShow.h"
#import "FromTo.h"
#import "HBRSAHandler.h"
#import "OpenUDID.h"
#import "SetNewPaywordViewController.h"
#import "VerificationTouch.h"
#import "HiddenNavBarBaseViewController.h"
#import <UIKit/UIKit.h>

/**
 *  提现
 */
@interface TropismViewController : HiddenNavBarBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *tropismNumString;

@property (nonatomic, assign) ToNewUserFromType fromType;

@end
