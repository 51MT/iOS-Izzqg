//
//  NotificationResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/10/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DiscoverResponseModel.h"
#import "ResponseModel.h"

@interface NotificationModel : JSONModel

@property (nonatomic, assign) NSInteger type;  //消息类型，0：公告，1：活动, 2: 出借, 3: 信闪贷
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *createdDate;

@end

@protocol NewsModel;
@interface NewsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *title;       //新闻标题
@property (nonatomic, copy) NSString<Optional> *imgUrl;      //新闻图片RUL
@property (nonatomic, copy) NSString<Optional> *createdDate; //文章创建时间
@property (nonatomic, copy) NSString<Optional> *articleUrl;  //文章URL

@end

@protocol NotificationModel
@end
@interface NotificationResponseModel : ResponseModel

@property (nonatomic, strong) NSArray<NotificationModel, Optional> *notifications;
@property (nonatomic, strong) NewsModel<Optional> *news;

@end
