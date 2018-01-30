//
//  FromTo.h
//  Ixyb
//
//  Created by wangjianimac on 16/4/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FromTypeNone = 0,
    FromTypeTheMy = 1,  //侧边栏我的_新手任务
    FromTypeTheHome = 2 //首页_新手任务
} ToNewUserFromType;

@interface FromTo : NSObject

@end
