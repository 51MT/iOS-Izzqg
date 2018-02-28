//
//  SleepRewordAmountModel.h
//  Ixyb
//
//  Created by wang on 16/8/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <JSONModel.h>

@protocol  SleepRewordAmountListModel

@end

@interface SleepRewordAmountListModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * allThawSleepCashAmount;
@property(nonatomic,copy)NSString <Optional> * freezeProgress;
@property(nonatomic,copy)NSString <Optional> * sleepCashOverdueAmount;
@property(nonatomic,copy)NSString <Optional> * sleepRewardDuetime;
@property(nonatomic,copy)NSString <Optional> * sleepRewordAmount;
@property(nonatomic,copy)NSString <Optional> * thawSleepRewordAmount;
@property(nonatomic,copy)NSString <Optional> * title;


@end

@interface SleepRewordAmountModel : ResponseModel
@property(nonatomic,strong)SleepRewordAmountListModel <Optional>* sleepRewordAmount;
@end
