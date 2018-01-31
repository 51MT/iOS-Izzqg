//
//  RewardAmountView.h
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "RewardAmountCell.h"
#import "RewardAmountOverDueViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYTableView.h"

@interface RewardAmountView : BaseView<UITableViewDataSource, UITableViewDelegate> {
  
    int currentPage;
    NoDataView *noDataView;
    MBProgressHUD *hud;
}

@property(nonatomic,strong)  XYTableView *mainTable;
@property(nonatomic,strong)  UILabel * scoreLab;
@property(nonatomic,strong)  UILabel * overdueLabel;
@property(nonatomic,strong)  UILabel * tip4Label;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^clickTheOverDueVC)(void);
-(void)setTheRequest;

@end
