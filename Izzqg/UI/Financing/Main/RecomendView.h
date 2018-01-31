//
//  RecomendView.h
//  Ixyb
//
//  Created by dengjian on 16/12/12.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HomePageResponseModel.h"
#import <UIKit/UIKit.h>

typedef void(^RecommendBlock)(CcProductModel *model);
/**
 *  @author Dzg, 16-12-12 16:12:31
 *
 *  @brief 首页_推荐出借产品UI
 */
@interface RecomendView : UIView

@property (nonatomic, strong) CcProductModel *model;
@property (nonatomic, copy) RecommendBlock block;

@property (nonatomic, strong) UILabel *activityLab;  //活动Lab
@property (nonatomic, strong) UILabel *addProfitLab; //加息Lab

@end
