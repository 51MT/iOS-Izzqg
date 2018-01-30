//
//  BbgInvestRecordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "DqbInvestRecordTableViewCell.h"
#import "DqbInvestRecordsResponseModel.h"
#import "Utility.h"
#import "XYTableView.h"

//步步高出借记录
@interface BbgInvestRecordViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong)XYTableView *recordTable;
@property (nonatomic, copy) NSString *projectId;

@end
