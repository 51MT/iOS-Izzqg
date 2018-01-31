//
//  IncreaseCardModel.h
//  Ixyb
//
//  Created by wang on 15/8/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol cardsModel
@end

@interface cardsModel : JSONModel
/*
 "id": 251, //卡ID
 "stime": "2015-08-06 16:32:36",//有效开始时间
 "etime": "2015-08-13 16:32:36",//有效结束时间
 "rate": 1.2, //倍率
 "state": 0//状态，0有效，1过期
 “cardType”：0 收益卡 1 加息券
 */

@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, copy) NSString<Optional> *ID;
@property (nonatomic, copy) NSString<Optional> *stime;
@property (nonatomic, copy) NSString<Optional> *etime;
@property (nonatomic, copy) NSString<Optional> *rate;
@property (nonatomic, assign) int state;

@end

@interface IncreaseCardModel : ResponseModel

@property (nonatomic, retain) NSArray<cardsModel, Optional> *cards;
@property(nonatomic, copy) NSString<Optional> * overdueCards;
@end
