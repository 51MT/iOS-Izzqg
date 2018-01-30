//
//  MyCouponsView.h
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "IncreaseCardFailedViewController.h"
#import "IncreaseCardModel.h"
#import "IncreaseCardViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MoreProductViewController.h"
#import "NoDataView.h"
#import "IncreaseCardCell.h"
#import "ShakeGameViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "WordAlertView.h"
#import "XYTableView.h"

@interface MyCouponsView : BaseView<UITableViewDataSource, UITableViewDelegate,IncreaseCardCellDelegate> {
    
    UIView *bgView;
    int currentPage;
    MBProgressHUD *hud;
    
}

@property (nonatomic, strong) XYTableView *mainTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger invalidCardPageIndex;



@property (nonatomic, strong) UIButton *seeInvalidCardButton;
@property (nonatomic, strong) XYButton *bgViewSeeInvalidCardButton;

@property (nonatomic, copy) void (^clickTheFailedVC)(void);
@property (nonatomic, copy) void (^clickTheMoreProductVc)(void);

- (void)setTheRequest:(NSInteger)currentPage;

@end
