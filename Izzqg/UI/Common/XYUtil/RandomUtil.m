//
//  RandomUtil.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/21.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "RandomUtil.h"

@implementation RandomUtil

//获取一个随机整数，范围在[from,to），包括from，不包括to
+ (NSInteger)getRandomFrom:(NSInteger)from To:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

@end
