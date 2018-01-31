//
//  ProgressWebViewController.h
//  Ixyb
//
//  Created by wang on 15/8/31.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

typedef enum {
    HZWebBrowserModeNavigation,
    HZWebBrowserModeModal,
} HZWebBrowserMode;

@interface ProgressWebViewController : HiddenNavBarBaseViewController <UIWebViewDelegate> {
    NSString *urlStrs;
}

@property (strong, nonatomic) NSURL *URL;
@property (nonatomic, assign) HZWebBrowserMode mode;
@property (strong, nonatomic) UIWebView *webView;

- (void)reload;

@end
