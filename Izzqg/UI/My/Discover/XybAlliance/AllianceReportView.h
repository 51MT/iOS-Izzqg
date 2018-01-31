//
//  AllianceReportView.h
//  Ixyb
//
//  Created by wang on 15/10/19.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
#import "Report.h"
#import "ReportView.h"
#import "Utility.h"

@interface AllianceReportView : BaseView {
    UIScrollView *mainScrollView;

    UILabel *selectLab;
    NSMutableArray *btnArray;
    UIView *buttonViewBack;
    MBProgressHUD *hud;

    ReportView *repoetView;
    UIButton * returnRecordBut;

    NSMutableArray *weekDetailArr;
    NSMutableArray *yesterdayDetailArr;
    NSMutableArray *allDetailArr;

    int currentSelectBtnTag;
}

@property (nonatomic, strong) void (^clicckRoleButton)();
@property (nonatomic, strong) void (^clicckTodayButton)();
@property (nonatomic, strong) void (^clicckCumulativeButton)();
@property (nonatomic, strong) void (^clicckReturnRecordButton)();

@end
