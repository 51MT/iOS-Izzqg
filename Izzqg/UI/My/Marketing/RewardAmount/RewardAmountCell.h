//
//  RewardAmountCell.h
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RewardAmountModel.h"

@interface RewardAmountCell : UITableViewCell

@property (nonatomic, strong) AccountActionListModel *rewardAmountModel;
@property (nonatomic, assign) BOOL isOverDue;

@end
