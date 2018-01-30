//
//  HUD.m
//  Ixyb
//
//  Created by wang on 15/5/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "HUD.h"

static PromptView *promptView;

@implementation HUD

+ (void)showPromptViewWithToShowStr:(NSString *)showStr autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo {

    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (promptView) {
        [promptView removeFromSuperview];
    }
    promptView = [[PromptView alloc] initWithFrame:delegate.window.frame ShowStr:showStr];
    [delegate.window addSubview:promptView];
    [delegate.window bringSubviewToFront:promptView];

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(commitAnimation) userInfo:nil repeats:NO]; //提示弹窗出来后，计时器开始计时，1秒后（此处即为弹窗在页面停留时间）执行commitAnimation动画（消失）

    //    [UIView animateWithDuration:3 animations:^{
    //        promptView.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        [promptView removeFromSuperview];
    //    }];
}

+ (void)commitAnimation {
    promptView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0f, 1.0f));
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    promptView.alpha = 0.f;
    promptView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)hide {
    [promptView hideDelayed];
}
@end
