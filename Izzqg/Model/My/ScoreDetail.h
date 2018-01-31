//
//  ScoreDetail.h
//  Ixyb
//
//  Created by wangjianimac on 15/8/28.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import <Foundation/Foundation.h>
#import <JSONModel.h>
/**
 * 积分详情类
 *
 * @author wangjian
 *
 */
@protocol ScoreDetailList

@end

@interface ScoreDetailList : JSONModel
@property (nonatomic, assign) NSInteger score;                // 本次操作积分
@property (nonatomic, assign) NSInteger balance;              // 操作后剩余积分
@property (nonatomic, copy) NSString<Optional> *streamType;   // 操作类型，收入、支出
@property (nonatomic, copy) NSString<Optional> *createTime;   // 操作时间
@property (nonatomic, copy) NSString<Optional> *issueTypeStr; // 积分操作原因
@end

@interface ScoreDetail : ResponseModel

@property (nonatomic, retain) NSArray<ScoreDetailList, Optional> *scoreDetail;
@property (nonatomic, copy) NSString *totalScore;
- (id)init;

@end
