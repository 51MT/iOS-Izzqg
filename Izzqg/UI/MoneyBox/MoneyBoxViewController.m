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
    NSLog(@"-----SafeArea:%@",self.view.safeAreaInsets);
    [self setNav1];
}

#pragma mark - 创建UI

- (void)setNav1 {
    
    self.navigationItem.title = @"skjdflsjfal";
    
    //导航栏左侧消息按钮
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    messageBtn.frame = CGRectMake(0, 0, 22.0f, 22.0f);
    [messageBtn addTarget:self action:@selector(clickTheMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpace.width = 0;
    self.navigationItem.leftBarButtonItems = @[leftSpace,leftItem];
    
    UIImageView *redPoint = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 8, 8)];
    redPoint.image = [UIImage imageNamed:@"redPoint"];
    redPoint.hidden = YES;
    [messageBtn addSubview:redPoint];
    
    [redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(8));
        make.centerY.equalTo(messageBtn.mas_top).offset(4);
        make.centerX.equalTo(messageBtn.mas_right);
    }];
    
    //导航栏右侧借款须知入口
    UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noticeBtn setFrame:CGRectMake(0, 0, 80, 40)];
    noticeBtn.titleLabel.font = TEXT_FONT_16;
    [noticeBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [noticeBtn setTitleColor:COLOR_COMMON_RED forState:UIControlStateSelected];
    [noticeBtn setTitle:XYBString(@"str_borrow_notice", @"借款须知") forState:UIControlStateNormal];
    [noticeBtn addTarget:self action:@selector(clickTheRightItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:noticeBtn];
    
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpace.width = -5;
    self.navigationItem.rightBarButtonItems = @[rightSpace,rightItem];
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
