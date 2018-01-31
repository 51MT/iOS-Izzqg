//
//  ConfigureAssetListView.h
//  Ixyb
//
//  Created by dengjian on 2017/3/11.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"

typedef void(^completetionBlock)(NSDictionary *params);

/**
 已配置资产列表
 */
@interface AssetListView : BaseView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) completetionBlock complete;



/**
  已配置资产列表 初始化

 @param frame       位置 宽高
 @param state       状态 1: 发售中 2：发售完
 @param productType 产品类型：步步高：BBG；定期宝：ZZY CCNY
 @param projectId   产品ID
 @return AssetListView
 */
- (instancetype)initWithFrame:(CGRect)frame state:(int)state productType:(NSString *)productType projectId:(NSString *)projectId;

@end
