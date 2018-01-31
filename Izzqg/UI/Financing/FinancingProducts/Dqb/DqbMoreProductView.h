//
//  DqbMoreProductView.h
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
#import "CcProductModel.h"
#import "NoDataView.h"
#import "Utility.h"

@interface DqbMoreProductView : BaseView <UITableViewDataSource, UITableViewDelegate> {
    XYTableView *dqbTable;
    int currentPage;

    NoDataView *noDataView;

    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^clickTheDetailVC)(CcProductModel *product);

@property (nonatomic, copy) void (^clickTheInvestButton)(CcProductModel *product);

- (void)setTheRequest;

@end
