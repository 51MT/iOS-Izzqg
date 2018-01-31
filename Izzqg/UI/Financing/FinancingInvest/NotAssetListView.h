//
//  NotAssetListView.h
//  Ixyb
//
//  Created by dengjian on 2017/3/11.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"

typedef void(^completetionBlock)(NSDictionary *params);


/**
 待配置资产列表页面
 */
@interface NotAssetListView : BaseView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) completetionBlock complete;


/**
 待匹配资产页面初始化

 @param frame       大小
 @param state       状态 1: 发售中 2：发售完
 @param productType 产品类型：步步高：BBG；定期宝：ZZY CCNY
 @param projectId   产品ID
 @param amountStr   项目发售额度
 @return  NotAssetListView
 */
- (instancetype)initWithFrame:(CGRect)frame state:(int)state productType:(NSString *)productType projectId:(NSString *)projectId amountStr:(NSString *)amountStr;


@end
