//
//  IQKeyboardManagerUtil.m
//  Ixyb
//
//  Created by wangjianimac on 2017/5/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "IQKeyboardManager.h"

#import "IQKeyboardManagerUtil.h"

@implementation IQKeyboardManagerUtil

+ (void)initIQKeyboardManager {
    
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    [keyManager setKeyboardDistanceFromTextField:0];
    keyManager.enable = YES;
    keyManager.preventShowingBottomBlankSpace = NO;
    keyManager.shouldResignOnTouchOutside = YES;
    keyManager.shouldToolbarUsesTextFieldTintColor = NO;
    keyManager.enableAutoToolbar = YES;
}

@end
