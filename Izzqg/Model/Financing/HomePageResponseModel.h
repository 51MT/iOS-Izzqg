//
//  HomePageResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/12/12.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BbgProductModel.h"
#import "CcProductModel.h"
#import "HqbProductModel.h"
#import "ResponseModel.h"

@protocol BannerHomePageModel;
@interface BannerHomePageModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *imgPath; //图片URL
@property (nonatomic, copy) NSString<Optional> *linkUrl; //H5链接
@property (nonatomic, copy) NSString<Optional> *title;   //标题
@property (nonatomic, assign) int eventType;             //1: 最新活动，2：最热活动
@property (nonatomic, copy) NSString<Optional> *content; //内容

@end


@interface DqFinanceHomePageModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *maxTerm; //最大期限
@property (nonatomic, copy) NSString<Optional> *minTerm; //最小期限
@property (nonatomic, copy) NSString<Optional> *maxRate; //最大利率
@property (nonatomic, copy) NSString<Optional> *minRate; //最小利率
@property (nonatomic, copy) NSString<Optional> *tips;

@end

@interface FinancingNotificationModel : JSONModel

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *detailUrl;

@end

@interface HomePageResponseModel : ResponseModel

@property (nonatomic, copy) NSString<Optional> *openDep;//0：未开通存管功能，1：已开通存管
@property (nonatomic, assign) NSInteger unread;
@property (nonatomic, strong) CcProductModel<Optional> *zzy;
@property (nonatomic, strong) CcProductModel<Optional> *recommendProduct;
@property (nonatomic, strong) BbgProductModel<Optional> *bbg;
@property (nonatomic, strong) HqbProductModel<Optional> *hqb;
@property (nonatomic, strong) NSArray<BannerHomePageModel, Optional> *banners;
@property (nonatomic, strong) DqFinanceHomePageModel<Optional> *dqFinance;
@property (nonatomic, strong) FinancingNotificationModel<Optional> *notification;
@property (nonatomic, copy) NSString<Optional> *recommendProductType; //推荐产品类型
@property (nonatomic, assign) int shakeNum;//摇摇乐次数

@end
