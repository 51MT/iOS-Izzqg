//
//  BbgInvestViewController.h
//  Ixyb
//
//  Created by wang on 15/12/10.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HiddenNavBarBaseViewController.h"
#import "BbgProductModel.h"
#import "FromTo.h"
#import "HBRSAHandler.h"
#import "OpenUDID.h"
#import "SetNewPaywordViewController.h"
#import "TouchIdentityAuthViewController.h"
#import "VerificationTouch.h"

/**
 *  步步高 出借 页面
 */
@interface BbgInvestViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) BOOL isBookBid; //是否为预约标，若为Yes，表示预约标，默认为no，（预约标只能是定期宝+步步高）
@property (nonatomic, strong) BbgProductModel *info;
@property (nonatomic, assign) ToNewUserFromType fromType;

@end
