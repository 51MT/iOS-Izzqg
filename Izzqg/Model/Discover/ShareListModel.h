//
//  ShareListModel.h
//  Ixyb
//
//  Created by wang on 2017/10/19.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol ShareModel

@end

@interface ShareModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *imgPath; //图片URL
@property (nonatomic, copy) NSString<Optional> *linkUrl; //H5链接
@property (nonatomic, copy) NSString<Optional> * shareUrl; //分享链接
@property (nonatomic, copy) NSString<Optional> *title;   //标题
@property (nonatomic, copy) NSString<Optional> *content; //内容


@end

@interface ShareListModel : ResponseModel

@property (nonatomic, retain) NSArray<ShareModel, Optional> *shareList;

@end
