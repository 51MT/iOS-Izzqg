//
//  BaseView.m
//  Ixyb
//
//  Created by wangjianimac on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"

#import "HUD.h"
#import "MBProgressHUD.h"
#import "StrUtil.h"

@interface BaseView () {
    MBProgressHUD *hud;
}

@end

@implementation BaseView

- (void)showLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.square = YES;
    [hud show:YES];
}

- (void)showLoadingWithLabelText:(NSString *)labelText {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"%@", labelText];
    hud.square = YES;
    [hud show:YES];

    [hud hide:YES afterDelay:2.0f];
    hud = nil;
}

- (void)showLoadingWithLabelText:(NSString *)labelText andDetailsLabelText:(NSString *)detailsLabelText {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"%@", labelText];
    hud.detailsLabelText = [NSString stringWithFormat:@"%@", detailsLabelText];
    hud.square = YES;
    [hud show:YES];

    [hud hide:YES afterDelay:2.0f];
    hud = nil;
}

- (void)showLoadingOnAlertView {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.square = YES;
    [hud show:YES];
}

- (void)hideLoading {
    if (hud != nil) {
        [hud hide:NO afterDelay:0.0f];
        hud = nil;
    }
}

- (void)showDelayTip:(NSString *)msg {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.square = NO;
    [hud show:YES];

    [hud hide:YES afterDelay:1.5f];
    hud = nil;
}

- (void)showPromptTip:(NSString *)msg {
    
    if ([StrUtil isEmptyString:msg]) {
        return;
    }
    
    [HUD showPromptViewWithToShowStr:msg autoHide:YES afterDelay:1.5f userInteractionEnabled:YES];
}

/**
 *  @author xyb, 16-11-18 09:11:21
 *
 *  @brief 动画
 *
 *  @param imageName  动画图片的前缀名
 *  @param imageCount 动画中的图片的张数
 *  @param width      动画的宽度
 *  @param height     动画的高度
 *
 *  @return 带动画的imageView
 */
- (UIImageView *)createTheAnimateLoadingViewWithImageName:(NSString *)imageName ImageCount:(int)imageCount Width:(CGFloat)width Height:(CGFloat)height {
    //图片数组
    NSMutableArray *picArr = [[NSMutableArray alloc] init];

    //循环添加动画的每一张图片
    for (int i = 1; i <= imageCount; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@%zi", imageName, i];
        UIImage *image = [UIImage imageNamed:imgName];
        [picArr addObject:image];
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.contentMode = UIViewContentModeTop;
    imageView.animationImages = picArr;
    imageView.animationDuration = 0.8;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];

    return imageView;
}

/**
 *  @author dzg, 16-11-17 12:11:13
 *
 *  @brief 安全交易loading（显示在view上）
 */
- (void)showTradeLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }

    UIImageView *imageView = [self createTheAnimateLoadingViewWithImageName:@"tradeLoading" ImageCount:24 Width:50 Height:58];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = XYBString(@"str_common_safeTrade", @"安全交易中");
    hud.margin = 22.f;
    hud.square = YES;
    [hud show:YES];
}

- (void)showTradeLoadingOnAlertView {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:hud];
    }

    UIImageView *imageView = [self createTheAnimateLoadingViewWithImageName:@"tradeLoading" ImageCount:24 Width:50 Height:58];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = XYBString(@"str_common_safeTrade", @"安全交易中");
    hud.margin = 22.f;
    hud.square = YES;
    [hud show:YES];
}

/**
 *  @author dzg, 16-11-17 12:11:59
 *
 *  @brief 信用宝出借loading(显示在view上)
 */
- (void)showDataLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
    }

    UIImageView *imageView = [self createTheAnimateLoadingViewWithImageName:@"dataLoading" ImageCount:24 Width:50 Height:58];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = XYBString(@"str_common_dataLoad", @"正在加载");
    hud.margin = 22.f;
    hud.square = YES;
    [hud show:YES];
}

- (void)showDataLoadingOnAlertView {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:hud];
    }

    UIImageView *imageView = [self createTheAnimateLoadingViewWithImageName:@"dataLoading" ImageCount:24 Width:50 Height:58];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = XYBString(@"str_common_dataLoad", @"正在加载");
    hud.margin = 22.f;
    hud.square = YES;
    [hud show:YES];
}

#pragma mark - 设置刷新的方法

#pragma mark - 设置刷新MJRefreshCustomGifHeader

- (MJRefreshCustomGifHeader *)gifHeader1 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi",i]];
        [headerImages addObject:image];
    }
    _gifHeader1 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:1];
    [_gifHeader1 setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [_gifHeader1 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    _gifHeader1.showLab.text = XYBString(@"str_common_BeijingLoanAssociationFounder", @"中国互联网金融协会会员");
    return _gifHeader1;
}

-(MJRefreshCustomGifHeader *)gifHeader2 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi",i]];
        [headerImages addObject:image];
    }
    _gifHeader2 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:2];
    [_gifHeader2 setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [_gifHeader2 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    _gifHeader2.showLab.text = XYBString(@"str_common_BeijingLoanAssociationFounder", @"中国互联网金融协会会员");
    return _gifHeader2;
}

-(MJRefreshCustomGifHeader *)gifHeader3 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi",i]];
        [headerImages addObject:image];
    }
    _gifHeader3 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:3];
    [_gifHeader3 setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [_gifHeader3 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    return _gifHeader3;
}

- (void)headerRereshing {
    
}


@end
