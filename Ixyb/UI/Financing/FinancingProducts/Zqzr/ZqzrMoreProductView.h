//
//  ZqzrMorProductView.h
//  Ixyb
//
//  Created by dengjian on 16/6/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "BidProduct.h"
#import "NoDataView.h"
#import "Utility.h"
#import <UIKit/UIKit.h>

@interface ZqzrMoreProductView : BaseView <UITableViewDataSource, UITableViewDelegate> {

    XYTableView *ZQZRTable;
    int currentPage;
    NoDataView *noDataView;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void (^clickTheInvestButton)(BidProduct *product);

- (void)setTheRequest:(int)page;

@end
