//
//  IPhoneXNavHeight.m
//  Ixyb
//
//  Created by wang on 2017/11/17.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "IPhoneXNavHeight.h"

@implementation IPhoneXNavHeight

+ (int)navBarBottom
{
    if ([IPhoneXNavHeight isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}

+ (BOOL)isIphoneX
{
    if (CGRectEqualToRect([UIScreen mainScreen].bounds,CGRectMake(0, 0, 375, 812))) {
        return YES;
    } else {
        return NO;
    }
}

@end
