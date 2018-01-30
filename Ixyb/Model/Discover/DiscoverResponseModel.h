//
//  DiscoverResponseModel.h
//  Ixyb
//
//  Created by wang on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol BannersModel

@end

@interface BannersModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *imgPath; //图片URL
@property (nonatomic, copy) NSString<Optional> *linkUrl; //H5链接
@property (nonatomic, copy) NSString<Optional> *title;   //标题
@property (nonatomic, assign) int eventType;             //1: 最新活动，2：最热活动
@property (nonatomic, copy) NSString<Optional> *content; //内容

- (NSString *)clickLinkUrl;
- (NSString *)shareLinkUrl;

@end

@protocol LatestNewsModel;
@interface LatestNewsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *title;       //新闻标题
@property (nonatomic, copy) NSString<Optional> *imgUrl;      //新闻图片RUL
@property (nonatomic, copy) NSString<Optional> *createdDate; //文章创建时间
@property (nonatomic, copy) NSString<Optional> *articleUrl;  //文章URL

@end

@interface DiscoverResponseModel : ResponseModel

@property (nonatomic, retain) NSArray<BannersModel, Optional> *banners;
@property (nonatomic, copy) LatestNewsModel<Optional> *latestNews;
@property (nonatomic, assign) NSInteger bonusState;               //信用宝联盟状态，显示邀请好友：0：未加入，1：审核中，显示信用宝联盟：2：已加入
@property (nonatomic, assign) NSInteger shakeNum;                 //摇一摇剩余次数
@property (nonatomic, assign) NSInteger score;                    //积分
@property (nonatomic, assign) NSInteger vipLevel;                 //vip等级
@property (nonatomic, copy) NSString<Optional> *evaluatingResult; //评测结果

@end
