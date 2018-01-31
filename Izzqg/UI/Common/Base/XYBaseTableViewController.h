//
//  XYBaseTableViewController.h
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "Utility.h"

@interface XYBaseTableViewController : HiddenNavBarBaseViewController

@property (nonatomic,retain) NSMutableArray * dataResource;

@property (strong, nonatomic) XYTableView * baseTableView;

@property (nonatomic,assign) NSInteger currentPage;



- (void)refreshRequest;

@end
