//
//  CardsModel.h
//  Ixyb
//
//  Created by 董镇华 on 16/9/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol SingleIncreaseCardModel;
@interface SingleIncreaseCardModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *ID;
@property (nonatomic, copy) NSString<Optional> *stime;
@property (nonatomic, copy) NSString<Optional> *etime;
@property (nonatomic, copy) NSString<Optional> *rate;
@property (nonatomic, assign) int state;          //状态，0有效，1过期
@property (nonatomic, assign) NSInteger cardType; //0 收益卡 1 加息券
@property (nonatomic, assign) BOOL isUsable;      //是否可用

@end

@interface CardsModel : ResponseModel

@property (nonatomic, retain) NSArray<SingleIncreaseCardModel, Optional> *cards;

@end

/*
 “cards”: [
 {
 “id”: 251, //卡ID
 “stime”: “2015-08-06 16:32:36”,//有效开始时间
 “etime”: “2015-08-13 16:32:36”,//有效结束时间
 “rate”: 1.2, //倍率
 “state”: 0//状态，0有效，1过期
 ”cardType”：0 收益卡 1 加息券
 "isUsable": true//是否可用
 }
 ]

 */