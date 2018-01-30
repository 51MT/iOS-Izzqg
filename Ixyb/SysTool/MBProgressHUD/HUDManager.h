//
//  HUDManager.h
//  SunnyFace
//
//  Created by 龚 俊慧 on 13-1-21.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface HUDManager : NSObject <MBProgressHUDDelegate, UIApplicationDelegate>

//+ (HUDManager *)shareHUDManager;

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo;
+ (void)hideHUD;

@end
