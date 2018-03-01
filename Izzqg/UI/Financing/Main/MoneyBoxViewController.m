//
//  MoneyBoxViewController.m
//  Izzqg
//
//  Created by DzgMac on 2018/2/28.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "MoneyBoxViewController.h"
#import "IPhoneXNavHeight.h"
#import "Masonry.h"
#import "XYUtil.h"

#define ScreenHeight ([UIScreen mainScreen].bounds.size.height);

#define ViewSafeAreaInsets(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#define SafeAreaTopHeight (ScreenHeight == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (ScreenHeight == 812.0 ? 34 : 0)

@interface MoneyBoxViewController ()<UIScrollViewDelegate, UIWebViewDelegate>
{
    UIView *backview;
}

@property (nonatomic, strong) UIView *navBackView;  //自定义导航栏
@property (nonatomic, strong) UILabel *navTitleLab; //自定义导航栏上的title
@property (nonatomic, strong) UIImageView *leftNavRedPointImage;
@property (nonatomic, strong) XYScrollView *mainScroll;
@property (nonatomic, strong) UIImageView *shakeRedPoint;

@end

@implementation MoneyBoxViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [UMengAnalyticsUtil event:EVENT_FINANCE_IN];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil event:EVENT_FINANCE_OUT];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //自定义导航栏：必须将导航栏的创建放在mainscroll生成之后，否则自定义导航栏会在mainscroll的底部
    [self createCustomNavigationBar];
}

#pragma mark - 创建UI

/**
 *  @brief 自定义导航栏
 */
- (void)createCustomNavigationBar {
    
    self.navBar.hidden = YES;
    
    _navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [IPhoneXNavHeight navBarBottom])];
    _navBackView.backgroundColor = [COLOR_MAIN colorWithAlphaComponent:0.0f];
    [self.view addSubview:_navBackView];
    [self.view bringSubviewToFront:_navBackView];
    
    //消息按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"message_select"] forState:UIControlStateHighlighted];
    leftbutton.frame = CGRectMake(Margin_Length, 31.0f, 28.0f, 28.0f);
    [leftbutton addTarget:self action:@selector(clickTheLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_navBackView addSubview:leftbutton];
    
    [leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navBackView.mas_left).offset(Margin_Length);
        make.centerY.equalTo(_navBackView.mas_centerY).offset(10);
    }];
    
    _leftNavRedPointImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 8, 8)];
    _leftNavRedPointImage.image = [UIImage imageNamed:@"redPoint"];
    _leftNavRedPointImage.hidden = YES;
    [leftbutton addSubview:_leftNavRedPointImage];
    
    [_leftNavRedPointImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(8));
        make.centerY.equalTo(leftbutton.mas_top).offset(4);
        make.centerX.equalTo(leftbutton.mas_right);
    }];
    
    _navTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _navTitleLab.font = TEXT_FONT_18;
    _navTitleLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.0f];
    _navTitleLab.text = XYBString(@"str_common_xyb", @"信用宝");
    [_navBackView addSubview:_navTitleLab];
    
    [_navTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navBackView);
        make.centerY.equalTo(_navBackView.mas_centerY).offset(10);
    }];
    
    //签到按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"attendence"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"attendence_select"] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(Margin_Length, 31.0f, 28.0f, 28.0f);
    [rightBtn addTarget:self action:@selector(clickTheAttendenceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_navBackView addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navBackView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(_navTitleLab.mas_centerY);
    }];
}

- (void)clickTheLeftBtn:(id)sender {
    //调用分享方法
    [UMShareUtil shareUrl:@"www.baidu.com" title:@"ss" content:@"shdshjfhsfs" image:[UIImage imageWithContentsOfFile:@"www.baidu.com" ] controller:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
