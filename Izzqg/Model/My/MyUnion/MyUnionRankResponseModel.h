//
//  MyUnionRankResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol RankModel ;
@interface RankModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, assign) double totalAmount;
@property(nonatomic,copy)   NSString <Optional> * mobilePhone;
@property (nonatomic, copy) NSString <Optional>*incomeAmount;
@property (nonatomic, assign) NSInteger registerNum;
@property (nonatomic, copy) NSString * type;
@end

@interface MyUnionRankResponseModel : ResponseModel

@property (nonatomic, strong) NSArray <RankModel>*ranks;
@property (nonatomic, copy) NSString <Optional>*myRank;

@end
