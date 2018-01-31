//
//  HUDManager.m
//  SunnyFace
//
//  Created by 龚 俊慧 on 13-1-21.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "AppDelegate.h"
#import "HUDManager.h"

//static HUDManager *staticHUDManager;
static MBProgressHUD *HUD;

@implementation HUDManager

//+ (HUDManager *)shareHUDManager
//{
//
//}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo {
    if (!HUD) {
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;

        HUD = [[MBProgressHUD alloc] initWithFrame:delegate.window.frame];
        HUD.backgroundColor = [UIColor whiteColor];
        [delegate.window addSubview:HUD];
    }

    HUD.userInteractionEnabled = !yesOrNo; //加上这个属性才能在HUD还没隐藏的时候点击到别的view
                                           //    HUD.delegate = self;
    HUD.mode = mode;
    HUD.labelText = showStr;

    [HUD show:YES];

    //    [HUD showAnimated:YES whileExecutingBlock:^{
    //        sleep(2);//这个是2秒后隐藏
    //    } completionBlock:^{
    //        [HUD removeFromSuperview];
    //        [HUD release];
    //        HUD = nil;
    //    }];

    if (autoHide) {
        [HUD hide:YES afterDelay:afterDelay];
    }
}

+ (void)hideHUD {
    if (!HUD.hidden)
        [HUD hide:YES afterDelay:0.0];
}

//- (void)hudWasHidden:(MBProgressHUD *)hud
//{
//    [hud release];
//
//}

@end
