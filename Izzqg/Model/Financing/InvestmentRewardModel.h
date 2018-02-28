//
//  InvestmentRewardModel.h
//  Ixyb
//
//  Created by wang on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface InvestmentRewardModel : ResponseModel

@property(nonatomic,copy)NSString <Optional>* activeReward;
@property(nonatomic,copy)NSString <Optional>* score;
@property(nonatomic,copy)NSString <Optional>* firstReward;
@property(nonatomic,copy)NSString <Optional>* unfreezeReward;

@end
