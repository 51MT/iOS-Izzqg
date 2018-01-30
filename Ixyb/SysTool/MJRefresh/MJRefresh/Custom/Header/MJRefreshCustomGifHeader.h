//
//  MJRefreshCustomGifHeader.h
//  Ixyb
//
//  Created by dengjian on 16/12/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface MJRefreshCustomGifHeader : MJRefreshGifHeader

/**
 *  @author Dzg
 *
 *  @brief 显示《中国互联网金融协会会员》
 */
@property (nonatomic, strong) UILabel *showLab;
@property (nonatomic,assign) int type;

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action Type:(int)type;

@end
