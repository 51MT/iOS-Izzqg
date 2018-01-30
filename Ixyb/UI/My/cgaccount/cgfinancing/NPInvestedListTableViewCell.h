//
//  NPInvestedListTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "CgDepOrderModel.h"

#define CELL_LARGE_HEIGHT 300.f
#define CELL_HEIGHT 215.f

@interface NPInvestedListTableViewCell : XYTableViewCell

@property(nonatomic,strong)CGDepOrderListModel * cgorderList;

@end
