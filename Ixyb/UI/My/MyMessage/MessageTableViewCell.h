//
//  MessageTableViewCell.h
//  Ixyb
//
//  Created by 董镇华 on 16/10/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MessageResponseModel.h"
#import <UIKit/UIKit.h>

typedef void (^clickDetailBtn)();

@interface MessageTableViewCell : XYTableViewCell

@property (nonatomic, strong) NotificationsModel *notification;
@property (nonatomic, assign) BOOL isRead; //是否已读
@property (nonatomic, copy) clickDetailBtn block;

@end
