//
//  HUD.h
//  Ixyb
//
//  Created by wang on 15/5/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AppDelegate.h"
#import "PromptView.h"
#import <Foundation/Foundation.h>

@interface HUD : NSObject

+ (void)showPromptViewWithToShowStr:(NSString *)showStr autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo;

@end
