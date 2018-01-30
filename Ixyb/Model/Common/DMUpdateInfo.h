//
//  DMUpdateInfo.h
//  Ixyb
//
//  Created by dengjian on 12/9/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResponseModel.h"

@protocol VersionModel

@end

@interface VersionModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *infoId;
@property (nonatomic, copy) NSString<Optional> *clientType;
@property (nonatomic, copy) NSString<Optional> *appVersion;
@property (nonatomic, copy) NSString<Optional> *isForceUpdate;
@property (nonatomic, copy) NSString<Optional> *appUrl;
@property (nonatomic, copy) NSString<Optional> *updateTips;
@property (nonatomic, copy) NSString<Optional> *size;
@property (nonatomic, copy) NSArray<Optional> *images;

@end

@interface DMUpdateInfo : ResponseModel

@property (nonatomic, strong) VersionModel<Optional> *version;

@end
