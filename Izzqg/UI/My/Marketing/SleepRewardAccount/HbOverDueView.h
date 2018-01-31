//
//  HbOverDueView.h
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MoreProductViewController.h"
#import "SleepRewardAccountCell.h"
#import "SleepRewardAccountModel.h"
#import "SleepRewardAccountOverDueViewController.h"
#import "SleepRewordAmountModel.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYTableView.h"
#import "HomeCircleProgressView.h"

#define VIEW_TAG_TITLE_LABEL 50501
#define VIEW_TAG_PROGRES_VIEW 50502
#define VIEW_TAG_SLEEP_REWARD_AMOUNT_LABEL 50503
#define VIEW_TAG_END_TIME_LABEL 50504
#define VIEW_TAG_THAW_SLEEP_REWORD_AMOUNT_LABEL 50505
#define VIEW_TAG_ALL_THAW_SLEEP_CASH_AMOUNT_LABEL 50506
@interface HbOverDueView : BaseView<UITableViewDataSource, UITableViewDelegate>
{
     NSInteger currentPage;
}
@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, copy) void (^clickTheDueVC)(void);
@property(nonatomic,copy) void(^clickTheMoreProductVc)(void);

-(void)setTheRequest:(NSInteger)currentPage;

@end
