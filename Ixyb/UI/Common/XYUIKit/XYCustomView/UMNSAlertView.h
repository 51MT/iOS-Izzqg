//
//  NotificationAlertView.h
//  Ixyb
//
//  Created by 董镇华 on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Block)();

/**
 *  @author wangjian, 16-12-01 16:12:51
 *
 *  @brief 友盟消息推送弹窗
 */
@interface UMNSAlertView : UIView

/**
 *  用来保存接收到的推送消息的字典
 */
@property (nonatomic, strong) NSDictionary *userInfoDic;

/**
 *  保存推送来的消息中的title和content，然后给友盟弹窗赋值
 */
@property (nonatomic, strong) NSDictionary *dataSource;

/**
 *  点击"查看"按钮时，回调进入消息分类页面
 */
@property (nonatomic, copy) Block block;

/**
 *  将友盟推送消息弹窗弹出
 */
- (void)show;

@end
