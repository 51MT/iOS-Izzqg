//
//  MyScoreView.h
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "Utility.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyScoreCell.h"
#import "NoDataView.h"
#import "ScoreDetail.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"
#import "XYCellLine.h"
#import "XYTableView.h"

@interface MyScoreView : BaseView<UITableViewDataSource, UITableViewDelegate> {
    XYTableView *mainTable;
    UILabel *scoreLab;
    
    MBProgressHUD *hud;
    
    NSInteger currentPage;
    NoDataView *noDataView;
    UIImageView *pointsImage;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)setTheRequest:(NSInteger)currentPage;

@end
