//
//  BbgProduct.h
//  Ixyb
//
//  Created by wang on 15/12/11.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BbgProduct : NSObject

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, strong) NSString *sn; // 产品编号
@property (nonatomic, assign) double amount; // 总金额
@property (nonatomic, assign) double soldAmount; // 已售金额
@property (nonatomic, assign) double minBidAmount; //最低出借金额
@property (nonatomic, assign) int state; //状态
@property (nonatomic, assign) double baseRate; // 年化利率
@property (nonatomic, assign) double paddRate; // 每期增加年化
@property (nonatomic, assign) double maxRate; //最大年化
@property (nonatomic, assign) double restAmount; //剩余可投
@property (nonatomic, assign) double investProgress; // 已投百分比
@property (nonatomic,copy) NSString *productUrl;//步步高视图中图片的路径

@property (nonatomic,copy) NSString *minPeriods;//最低出借期限

@end
