//
//  BbgInvestListTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INVESTED_TABLEVEIW_CELL_HEIGHT 135

@class BbgOrderListModel;

@interface BbgInvestListTableViewCell : XYTableViewCell

@property (nonatomic, strong) BbgOrderListModel * bbgOrderList;

@end
