//
//  ActivityTableViewCell.h
//  Ixyb
//
//  Created by dengjian on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageResponseModel.h"

typedef void (^clickDetailBtn)();


/**
 *  @author Dzg
 *
 *  @brief 活动消息点击后进入活动页面时，页面显示的cell（带有图片）
 */
@interface ActivityTableViewCell : XYTableViewCell

@property (nonatomic, strong) NotificationsModel *notification;
@property (nonatomic, assign) BOOL isRead; //是否已读
@property (nonatomic, copy) clickDetailBtn block;

@end
