//
//  XtbMoreProductView.h
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYUIKit.h" //XYB公共控件

#import "BaseView.h"
#import "BidProduct.h"
#import "NoDataView.h"
#import "Utility.h"

@interface XtbMoreProductView : BaseView <UITableViewDataSource, UITableViewDelegate> {

    XYTableView *xtbTable;

    int currentPage;

    NoDataView *noDataView;

    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^clickTheDetailButton)(BidProduct *product);

@property (nonatomic, copy) void (^clickTheInvestButton)(BidProduct *product);

- (void)setTheRequest:(int)page;
- (void)setTheRequest;

- (void)headerRereshing;

@end
