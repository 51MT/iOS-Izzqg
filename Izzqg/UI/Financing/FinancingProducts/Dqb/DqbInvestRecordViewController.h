//
//  TrendRecordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/6/30.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTableView.h"
#import "HiddenNavBarBaseViewController.h"

/**
 定期宝投资记录
 */
@interface DqbInvestRecordViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) XYTableView *recordTable;
@property (nonatomic, copy) NSString *bidRequestIdStr;

@end
