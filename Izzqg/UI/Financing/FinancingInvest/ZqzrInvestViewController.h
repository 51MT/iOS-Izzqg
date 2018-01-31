//
//  ZqzrInvestViewController.h
//  Ixyb
//
//  Created by wang on 15/10/19.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BidProduct.h"
#import "FromTo.h"
#import "HBRSAHandler.h"
#import "OpenUDID.h"
#import "SetNewPaywordViewController.h"
#import "HiddenNavBarBaseViewController.h"
#import "TouchIdentityAuthViewController.h"
#import "VerificationTouch.h"

@interface ZqzrInvestViewController : HiddenNavBarBaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) BidProduct *info;
@property (nonatomic, assign) ToNewUserFromType fromType;

@end
