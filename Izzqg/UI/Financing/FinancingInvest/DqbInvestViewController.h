//
//  DqbInvestViewController.h
//  Ixyb
//
//  Created by dengjian on 2017/9/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "CcProductModel.h"

/**
 定期宝出借页面
 */
@interface DqbInvestViewController : HiddenNavBarBaseViewController

@property (nonatomic, assign) BOOL isBookBid; //是否为预约标，若为Yes，表示预约标，默认为no，（预约标只能是定期宝+步步高）
@property (nonatomic, strong) CcProductModel *ccInfo;

@end
