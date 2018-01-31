//
//  ReturnRecordViewController.h
//  Ixyb
//
//  Created by wang on 2017/3/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "NoDataView.h"
//返佣记录
@interface ReturnRecordViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
