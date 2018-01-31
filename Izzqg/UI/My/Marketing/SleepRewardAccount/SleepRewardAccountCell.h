//
//  SleepRewardAccountCell.h
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SleepRewardAccountModel.h"

@interface SleepRewardAccountCell : UITableViewCell

@property (nonatomic, strong) SleepRewardAccountDetailListModel *model;

@property (nonatomic, assign) BOOL isBeoverdue; //yes 未过期 no 已过期
@end
