//
//  New.h
//  Ixyb
//
//  Created by wang on 15/10/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResponseModel.h"

@protocol NotificationsModel
@end

@interface NotificationsModel : JSONModel

@property (nonatomic, assign) NSInteger noticeId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *webContent;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, copy) NSString<Optional> *pictureUrl; //消息为活动时，才有该字段，活动配的图片的URL
@property (nonatomic, copy) NSString<Optional> *detailUrl;//详情URL（公告、活动才有）

@end

@interface MessageResponseModel : ResponseModel

@property (nonatomic, strong) NSArray<NotificationsModel, Optional> *notifications;

@end

/*  "id": 1,
 "type": 1,//消息类型，0：公告，1：活动
 "title": "测试公告",//标题
 "content": "是否是对方是否是发顺丰是对方的所发生的",//内容
 "createdDate": "2015-10-22 15:44:09"//时间
 webContent;//HTML内容
 */
