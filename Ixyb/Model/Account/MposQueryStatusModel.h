//
//  MposQueryStatusModel.h
//  Ixyb
//
//  Created by wang on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface MposQueryStatusModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, copy) NSString<Optional> *firstSleepReward;

@end
