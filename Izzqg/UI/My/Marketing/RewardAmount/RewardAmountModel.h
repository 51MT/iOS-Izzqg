//
//  RewardAmountModel.h
//  Ixyb
//
//  Created by wang on 15/8/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"

@protocol AccountActionListModel

@end
@interface AccountActionListModel : JSONModel

@property (strong, nonatomic) NSString <Optional>  *amount;
@property (strong, nonatomic) NSString <Optional>  *createDate;
@property (strong, nonatomic) NSString <Optional>  *type;
@property (strong, nonatomic) NSString <Optional>  *issueTypeStr;

@end

@protocol RewardAccountModel

@end
@interface RewardAccountModel : JSONModel

@property(nonatomic,copy)NSString <Optional> *  rewardAmount;
@property(nonatomic,copy)NSString <Optional> *  rewardRemainderDay;

@end

@interface RewardAmountModel :  ResponseModel

@property(nonatomic,strong)RewardAccountModel *  rewardAccount;
@property(nonatomic,retain)NSArray <AccountActionListModel,Optional> * accountActionList;

@end
