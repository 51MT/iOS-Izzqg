//
//  CaPossessionRecordModel.h
//  Ixyb
//
//  Created by wang on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <JSONModel.h>

@protocol  AcceptListModel
@end
@interface AcceptListModel : JSONModel

@property(nonatomic,copy)NSString <Optional> * createdDate;
@property(nonatomic,copy)NSString <Optional> * mobilePhone;
@property(nonatomic,copy)NSString <Optional> * acceptAmount;
@property(nonatomic,copy)NSString <Optional> * prepayInterest;
@property(nonatomic,copy)NSString <Optional> * assignFee;
@property(nonatomic,copy)NSString <Optional> * disScoreFee;
@property(nonatomic,copy)NSString <Optional> * addInterest; //应计奖励

@end

@interface CaPossessionRecordModel : ResponseModel

@property(nonatomic,retain)NSArray  <AcceptListModel,Optional>* acceptList;

@end
