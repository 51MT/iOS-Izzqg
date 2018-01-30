//
//  BaseViewController.m
//  Ixyb
//
//  Created by dengjian on 9/2/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import "BaseViewController.h"
#import "HUD.h"
#import "MBProgressHUD.h"
#import "StrUtil.h"
#import "UIImage+GIF.h"

#import "WRNavigationBar.h"

@interface BaseViewController () {
    MBProgressHUD *hud;
}

@end

@implementation BaseViewController

#pragma mark - ViewController内置方法，自动执行
- (void)viewDidLoad {
    [super viewDidLoad];

    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;

    /*在iOS7中，苹果引入了一个新的属性，叫做 [UIViewController setEdgesForExtendedLayout:]，它的默认值为 UIRectEdgeAll。
     当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始。这就是为什么所有的UI元素都往上漂移了44pt。
     修复这个问题的快速方法就是在方法 - (void)viewDidLoad中添加如下一行代码：self.edgesForExtendedLayout = UIRectEdgeNone;
     只要设置了self.edgesForExtendedLayout＝UIRectEdgeAll的时候会让tableView从导航栏顶部开始，设置为UIRectEdgeNone的时候，刚刚在导航栏下面，也就是向下移动了44pt。 */
    self.edgesForExtendedLayout = UIRectEdgeNone;

    /*automaticallyAdjustsScrollViewInsets,它的默认值为YES,导航视图内Push进来TableView或ScrollView为主View的视图，本来我们的cell是放在（0,0）的位置上的，
     但是考虑到导航栏、状态栏会挡住后面的主视图，而自动把我们的内容（cell、滚动视图里的元素）向下偏移离Top64px,或者下方位置如果是tarbar向上偏移离49px、toolbar则是44px，
     也就是当我们把navigationBar给隐藏掉时，滚动视图会给我们的内容预留部分的空白Top（所有内容向下偏移20px，因为状态栏的存在）。那么，当我们不想自动为我们下移或上移可以设置*/
    self.automaticallyAdjustsScrollViewInsets = NO; //自动滚动调整，默认为YES

    //设置所有ViewController的self.view的背景颜色
    self.view.backgroundColor = COLOR_BG;

    // 设置自定义导航栏底部分割线是否隐藏
    [self wr_setNavBarShadowImageHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - MBProgressHUD页面加载进度，成功／错误提示
- (void)showLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.square = YES;
    [hud show:YES];
}

- (void)showLoadingWithLabelText:(NSString *)labelText {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"%@", labelText];
    hud.square = YES;
    [hud show:YES];
}

- (void)showLoadingWithLabelText:(NSString *)labelText andDetailsLabelText:(NSString *)detailsLabelText {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"%@", labelText];
    hud.detailsLabelText = [NSString stringWithFormat:@"%@", detailsLabelText];
    hud.square = YES;
    [hud show:YES];
}

- (void)showLoadingOnAlertView {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
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
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
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
 *  @brief 安全交易时的loading（显示在view上）
 */
- (void)showTradeLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
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
        hud = [[MBProgressHUD alloc] initWithView:self.view];
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
 *  @brief 数据加载时的loading(显示在view上)
 */
- (void)showDataLoading {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
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
        hud = [[MBProgressHUD alloc] initWithView:self.view];
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

/**
 *  @author xyb, 16-3-23 11:19:39
 *
 *  @brief 二维码识别loading
 */
- (void)showQrcodeLoadingOnAlertView {
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [delegate.window addSubview:hud];
    }
    UIImageView *imageView = [self createTheAnimateLoadingViewWithImageName:@"dataLoading" ImageCount:24 Width:50 Height:58];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = XYBString(@"str_common_sb", @"正在识别");
    hud.margin = 22.f;
    hud.square = YES;
    [hud show:YES];
}


#pragma mark - 设置下拉刷新MJRefreshCustomGifHeader

- (MJRefreshCustomGifHeader *)gifHeader1 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi", i]];
        [headerImages addObject:image];
    }
    _gifHeader1 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:1];
    [_gifHeader1 setImages:@[ headerImages[0] ] forState:MJRefreshStateIdle];
    [_gifHeader1 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    _gifHeader1.showLab.text = XYBString(@"str_common_BeijingLoanAssociationFounder", @"中国互联网金融协会会员");
    return _gifHeader1;
}

- (MJRefreshCustomGifHeader *)gifHeader2 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi", i]];
        [headerImages addObject:image];
    }
    _gifHeader2 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:2];
    [_gifHeader2 setImages:@[ headerImages[0] ] forState:MJRefreshStateIdle];
    [_gifHeader2 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    _gifHeader2.showLab.text = XYBString(@"str_common_BeijingLoanAssociationFounder", @"中国互联网金融协会会员");
    return _gifHeader2;
}

- (MJRefreshCustomGifHeader *)gifHeader3 {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zi", i]];
        [headerImages addObject:image];
    }
    _gifHeader3 = [MJRefreshCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) Type:3];
    [_gifHeader3 setImages:@[ headerImages[0] ] forState:MJRefreshStateIdle];
    [_gifHeader3 setImages:headerImages duration:1.4f forState:MJRefreshStateRefreshing];
    return _gifHeader3;
}


#pragma mark - 下拉刷新时 响应事件

#pragma mark 适用于当前控制器中只有一个scrollView或者只有一个tableView的下拉刷新
- (void)headerRereshing {
}


#pragma mark - 导航栏初始化 navigationItem init

@end
