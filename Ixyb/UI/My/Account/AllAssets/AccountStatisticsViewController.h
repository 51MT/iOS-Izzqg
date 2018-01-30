//
//  AccountStatisticsViewController.h
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//
#import "XYTableView.h"
#import "HiddenNavBarBaseViewController.h"
#import "User.h"


@interface AccountStatisticsViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSDictionary *accountDic;
@property (nonatomic, strong) User *accountInfoStatistics;
@property (nonatomic, strong) XYTableView *tableView;

@end
