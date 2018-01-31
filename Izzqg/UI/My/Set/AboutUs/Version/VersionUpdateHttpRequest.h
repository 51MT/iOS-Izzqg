//
//  VersionUpdateHttpRequest.h
//  Ixyb
//
//  Created by wang on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateHttpRequest : NSObject

+ (VersionUpdateHttpRequest *)getRequest;
- (void)clearInstance;

@end
