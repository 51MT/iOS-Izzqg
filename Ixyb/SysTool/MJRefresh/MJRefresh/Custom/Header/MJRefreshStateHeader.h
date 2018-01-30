//
//  MJRefreshStateHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshStateHeader : MJRefreshHeader
#pragma mark - 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic) NSString * (^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;
@property (assign, nonatomic) BOOL isUpdatedTimeLabel;
@property (weak, nonatomic) NSString *lastUpdatedTimeStr;
#pragma mark - 状态相关
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 显示刷新出借额的label */
@property (weak, nonatomic, readonly) UILabel *amountLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/** 设置TimeLabel;状态下的文字 */
- (void)setTimeLabel:(NSString *)timeLabelStr forState:(MJRefreshState)state;

@end
