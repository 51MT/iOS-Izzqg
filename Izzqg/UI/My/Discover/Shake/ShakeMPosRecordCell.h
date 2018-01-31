//
//  ShakePrizeRecordCell2.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ShakePrizeRecordResponseModel.h"
#import "Utility.h"
#import <UIKit/UIKit.h>

typedef void (^GetBlock)(NSString *prizeLogId);           //进入领取
typedef void (^GetStatueBlock)(SingleRewardModel *model); //进入领取状态

@interface ShakeMPosRecordCell : UITableViewCell

@property (nonatomic, strong) SingleRewardModel *model;

@property (nonatomic, strong) XYButton *button;

@property (nonatomic, copy) GetBlock getBlock;
@property (nonatomic, copy) GetStatueBlock statueBlock;

@end
