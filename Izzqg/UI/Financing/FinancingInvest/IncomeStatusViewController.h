//
//  IncomeStatusViewController.h
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "FromTo.h"
#import "HiddenNavBarBaseViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    financingSuccess = 0, // 出借成功
    chargeSuccess = 1,    //充值成功
    tropismSuccess = 2    //提现成功
} IncomeStatus;

@interface IncomeStatusViewController : HiddenNavBarBaseViewController

@property (assign, nonatomic) IncomeStatus status; // 类型
@property (strong, nonatomic) NSString *moneyString;
@property (strong, nonatomic) NSString *fromTag;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSDictionary *returnDataDic;


@property (nonatomic, assign) BOOL isBookBid; //是否为预约标，若为Yes，表示预约标，默认为no，（预约标只能是定期宝+步步高）
@property (nonatomic, assign) ToNewUserFromType fromType;

@end
