//
//  EarnBonusCodeModel.h
//  Ixyb
//
//  Created by wang on 16/9/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol ShareInfoModel
@end
@interface ShareInfoModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *imageUrl;
@property (nonatomic, copy) NSString<Optional> *linkUrl;
@end

@interface EarnBonusCodeModel : ResponseModel

@property (nonatomic, strong) ShareInfoModel <Optional> *shareInfo;
@end
