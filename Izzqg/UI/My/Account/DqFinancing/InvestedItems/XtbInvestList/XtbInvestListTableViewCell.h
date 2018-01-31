//
//  XtbInvestListTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/9/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"

#define INVESTED_TABLEVEIW_CELL_HEIGHT 135

@class XtbOrderListModel;

@interface XtbInvestListTableViewCell : XYTableViewCell

@property (nonatomic, strong) XtbOrderListModel * xtbOrderList;

@end
