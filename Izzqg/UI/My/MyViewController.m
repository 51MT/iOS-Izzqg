//
//  MyViewController.m
//  Ixyb
//
//  Created by wang on 15/8/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "XYWebViewController.h"

#import "AccountResponseModel.h"
#import "MyAlertView.h"
#import "HandleUserInfo.h"
#import "MJRefresh.h"
#import "MyBanksResponseModel.h"

#import "UIImageView+WebCache.h"
#import "User.h"
#import "Utility.h"
#import "WebService.h"
#import "XYUIKit.h" //XYB公共控件
#import "XsdQueryAmountResponseModel.h"

#import "MJRefreshCustomGifHeader.h"
#import "UICountingLabel.h"

#define SPACING 15
#define LJTAG   1001
#define HBTAG   1002
#define SYKTAG  1003
#define JFTAG   1004
#define YHTAG   2008
#define JKSQ_TAG    3000
#define YQHY_TAG    3001
#define JRLM_TAG    3002

@interface MyViewController () <UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) XYScrollView *mainScrollView;
@property (nonatomic, strong) UICountingLabel      *amountLabel;     //总金额
@property (nonatomic, strong) UICountingLabel      *cgamountLabel;     //存管金额
@property (nonatomic, strong) UILabel      *remainLabel;            //可用余额
@property (nonatomic, strong) UILabel      *rateLabel;              //年化收益率
@property (nonatomic, strong) UILabel      *hqIncomeLabel;          //收益
@property (nonatomic, strong) UILabel      *totalAssetsLabel;       //总资产(元)
@property (nonatomic, strong) UIView       *headVipVIew;            //Vip等级
@property (nonatomic, strong) UIImageView  *headVipImageVIew;       //Vip等级
@property (nonatomic, strong) UILabel      *nameLabel;              //用户名
@property (nonatomic, strong) UIImageView  *headerImageview;
@property (nonatomic, strong) UILabel      *unionLabel;
@property (nonatomic, strong) UILabel      *unionDetailLabel;
@property (nonatomic, strong) UIImageView  *redPointImage;
@property (nonatomic, strong) XYButton *depositoryBtn;              // 存管按钮
@property (nonatomic, assign) BOOL         isBonusState;            //是否是信用宝联盟账户

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UMengAnalyticsUtil event:EVENT_MY_IN];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];

//    if ([Utility shareInstance].isLogin) {
//
//        dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_group_t dispatchGroup = dispatch_group_create();
//        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
//            [self updateAccountInfo];
//        });
//
//        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
//            //请求数据
//            [self callCheckBankWebService:@{@"userId" : [UserDefaultsUtil getUser].userId}];;
//        });
//
//        //判断是否登录 隐藏相应的控件
//        self.totalAssetsLabel.hidden = NO;
//        self.mainScrollView.header.hidden = NO;
//
//    } else {
//        self.mainScrollView.header.hidden = YES;
//        self.totalAssetsLabel.hidden = YES;
//        [self signOutDataZero];//退出登录 数据清零
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UMengAnalyticsUtil event:EVENT_MY_OUT];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initUI];
//    设置刷新
//    [self setupRefresh];
}



- (void)initUI {
    
    self.navBar.hidden = YES;
    self.mainScrollView = [[XYScrollView alloc] init];
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    UIView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 226.f)];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = COLOR_MAIN;
    [self.mainScrollView addSubview:headView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id) COLOR_MAIN.CGColor,
                       (id) COLOR_BLUE.CGColor, nil];
    [headView.layer addSublayer:gradient];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MainScreenWidth));
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@226);
    }];
    
    UIButton *butMyAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [butMyAccount setTitle:XYBString(@"str_account", @"我的账户") forState:UIControlStateNormal];
    [butMyAccount addTarget:self action:@selector(clickMyAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:butMyAccount];
    
    [butMyAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(28));
        make.left.equalTo(@(Margin_Left));
    }];


    _headerImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]];
    [_headerImageview.layer setMasksToBounds:YES];
    [_headerImageview.layer setCornerRadius:30];
    _headerImageview.layer.borderWidth = Border_Width_2;
    _headerImageview.layer.borderColor = COLOR_COMMON_WHITE.CGColor;
    [headView addSubview:_headerImageview];
    [_headerImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(@(80.f));
        make.width.height.equalTo(@(60));
    }];

    NSString *btnTitleStr = [NSString stringWithFormat:@"%@/%@",
                                                       XYBString(@"str_immediately_login", @"立即登录"),
                                                       XYBString(@"str_register", @"注册")];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = TEXT_FONT_16;
    self.nameLabel.textColor = COLOR_COMMON_WHITE;
    self.nameLabel.text = btnTitleStr;
    [headView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageview.mas_right).offset(14);
        make.centerY.equalTo(_headerImageview.mas_centerY).offset(-15);
    }];
    
    self.headVipVIew = [[UIView alloc] init];
    self.headVipVIew.backgroundColor = COLOR_COMMON_WHITE;
    self.headVipVIew.layer.cornerRadius = 10.f;
    [headView addSubview:self.headVipVIew];
    [self.headVipVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(68));
        make.height.equalTo(@(20));
        make.centerY.equalTo(_headerImageview.mas_centerY).offset(15);
    }];

    self.headVipImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_vip0"]];
    [self.headVipVIew  addSubview:self.headVipImageVIew];
    [self.headVipImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headVipVIew.mas_left).offset(4);
        make.centerY.equalTo(self.headVipVIew.mas_centerY);
    }];
    
    UILabel * vipLab = [[UILabel alloc] init];
    vipLab.textColor = COLOR_AUXILIARY_GREY;
    vipLab.font = WEAK_TEXT_FONT_11;
    vipLab.text = XYBString(@"string_vip_class", @"VIP等级");
    [self.headVipVIew addSubview:vipLab];
    [vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headVipImageVIew.mas_right).offset(4);
        make.centerY.equalTo(self.headVipVIew.mas_centerY);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImgView.image = [UIImage imageNamed:@"right_arrow"];
    [headView addSubview:arrowImgView];
    
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(_headerImageview.mas_centerY);
    }];
    
    //添加点击手势
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickleftBtn:)];
    [headView addGestureRecognizer:tapGesturRecognizer];

   //普通账户 存管账户
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"radioBackImg"];
    backImageView.userInteractionEnabled = YES;
    [self.mainScrollView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImageview.mas_bottom).offset(47);
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.width.equalTo(@(MainScreenWidth - 20));
        make.height.equalTo(@(88));
    }];

    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(backImageView);
        make.height.equalTo(@(40));
        make.width.equalTo(@(Line_Height));
    }];
    
    //普通账户
    XYButton *ordinaryBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [ordinaryBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [ordinaryBtn addTarget:self action:@selector(clickOrdinaryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:ordinaryBtn];

    [ordinaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    UILabel * ordinaryLab = [[UILabel alloc] init];
    ordinaryLab.text = XYBString(@"str_account_ordinary", @"普通账户");
    ordinaryLab.font = TEXT_FONT_14;
    ordinaryLab.textColor = COLOR_MAIN_GREY;
    [backImageView addSubview:ordinaryLab];
    [ordinaryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.top.equalTo(@(22));
    }];
    
    self.amountLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.font = TEXT_FONT_19;
    self.amountLabel.textColor = COLOR_AUXILIARY_GREY;
    self.amountLabel.text = @"0.00";
    self.amountLabel.format = @"%.2f";
    [backImageView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ordinaryLab.mas_left);
        make.top.equalTo(ordinaryLab.mas_bottom).offset(3);
    }];
    
    UIButton * ordinaryLendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [ordinaryLendBut addTarget:self action:@selector(clickOrdinaryLendButState:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:ordinaryLendBut];
    [ordinaryLendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ordinaryLab.mas_centerY);
        make.width.height.equalTo(@(14.5));
        make.right.equalTo(verticalLine.mas_left).offset(-Margin_Right);;
    }];
    
    UIImageView *infoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lendstate"]];
    [ordinaryLendBut addSubview:infoIconView];
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ordinaryLendBut);
    }];

    
    //存管账户
    _depositoryBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [_depositoryBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [_depositoryBtn addTarget:self action:@selector(clickDepositoryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:_depositoryBtn];
    
    [_depositoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(verticalLine.mas_right);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];
    
    UILabel * depositoryLab = [[UILabel alloc] init];
    depositoryLab.text = XYBString(@"str_account_depository", @"存管账户");
    depositoryLab.font = TEXT_FONT_14;
    depositoryLab.textColor = COLOR_MAIN_GREY;
    [backImageView addSubview:depositoryLab];
    [depositoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(Margin_Left);
        make.top.equalTo(@(22));
    }];
    
    self.cgamountLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.cgamountLabel.textAlignment = NSTextAlignmentCenter;
    self.cgamountLabel.font = TEXT_FONT_19;
    self.cgamountLabel.textColor = COLOR_AUXILIARY_GREY;
    self.cgamountLabel.text = @"0.00";
    self.cgamountLabel.format = @"%.2f";
    [backImageView addSubview:self.cgamountLabel];
    [self.cgamountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(depositoryLab.mas_left);
        make.top.equalTo(depositoryLab.mas_bottom).offset(3);
    }];
    
    UIButton * depositoryLendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [depositoryLendBut addTarget:self action:@selector(clickDepositoryLendButState:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:depositoryLendBut];
    [depositoryLendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(depositoryLab.mas_centerY);
        make.width.height.equalTo(@(14.5));
        make.right.equalTo(backImageView.mas_right).offset(-Margin_Right);;
    }];
    
    UIImageView *infoDepositoryIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lendstate"]];
    [depositoryLendBut addSubview:infoDepositoryIconView];
    [infoDepositoryIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(depositoryLendBut);
    }];

    //我的优惠
    float youhuiWidth = (MainScreenWidth - 28.5) / 2;

    UIImageView *youHuiContainerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    youHuiContainerView.image = [UIImage imageNamed:@"radioBackImg"];
    youHuiContainerView.tag  = YHTAG;
    youHuiContainerView.userInteractionEnabled = YES;
    [self.mainScrollView addSubview:youHuiContainerView];
    
    [youHuiContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(55.f);
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.width.equalTo(@(MainScreenWidth - 20));
        make.height.equalTo(@97);
    }];
    
    UIView *splitHLineView = [[UIView alloc] initWithFrame:CGRectZero];
    [youHuiContainerView addSubview:splitHLineView];
    splitHLineView.backgroundColor = COLOR_LINE;
    [splitHLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(youHuiContainerView).offset(-4);
    }];
    //礼金
    XYButton *ljControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                            titleColor:nil
                                              isUserInteractionEnabled:YES];
    [ljControlBtn addTarget:self
                     action:@selector(clickLJControl:)
           forControlEvents:UIControlEventTouchUpInside];
    [youHuiContainerView addSubview:ljControlBtn];
    [ljControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youHuiContainerView.mas_top).offset(1);
        make.bottom.equalTo(splitHLineView.mas_top);
        make.left.equalTo(youHuiContainerView.mas_left).offset(4);
        make.width.equalTo(@(youhuiWidth));
    }];

    UILabel *tipLJLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLJLabel.text = XYBString(@"str_invested_project_lj", @"礼金");
    tipLJLabel.textColor = COLOR_MAIN_GREY;
    tipLJLabel.font = NORMAL_TEXT_FONT_15;
    [youHuiContainerView addSubview:tipLJLabel];
    [tipLJLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youHuiContainerView.mas_top).offset(15);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel *tipLjAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLjAmountLabel.text = @"0.00元";
    tipLjAmountLabel.tag = LJTAG;
    tipLjAmountLabel.textColor = COLOR_AUXILIARY_GREY;
    tipLjAmountLabel.font = TEXT_FONT_14;
    [youHuiContainerView addSubview:tipLjAmountLabel];
    
    [tipLjAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ljControlBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(ljControlBtn.mas_centerY);
    }];

    UIView *splitYouhuiShuLineView = [[UIView alloc] initWithFrame:CGRectZero];
    [youHuiContainerView addSubview:splitYouhuiShuLineView];
    splitYouhuiShuLineView.backgroundColor = COLOR_LINE;
    [splitYouhuiShuLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(45/2));
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(ljControlBtn);
        make.right.equalTo(ljControlBtn.mas_right);
    }];

    //优惠劵
    XYButton *sykControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                             titleColor:nil
                                               isUserInteractionEnabled:YES];
    [sykControlBtn addTarget:self
                      action:@selector(clickSYKControl:)
            forControlEvents:UIControlEventTouchUpInside];
    [youHuiContainerView addSubview:sykControlBtn];
    [sykControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitHLineView.mas_bottom);
        make.left.equalTo(youHuiContainerView.mas_left).offset(4);
        make.width.equalTo(@(youhuiWidth));
        make.bottom.equalTo(youHuiContainerView.mas_bottom).offset(-7);

    }];
    
    UILabel *tipSYKLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipSYKLabel.text = XYBString(@"str_invested_project_syk", @"优惠券");
    tipSYKLabel.font = NORMAL_TEXT_FONT_15;
    tipSYKLabel.textColor = COLOR_MAIN_GREY;
    [youHuiContainerView addSubview:tipSYKLabel];
    [tipSYKLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sykControlBtn.mas_centerY);
        make.left.equalTo(@(Margin_Left));
    }];


    UILabel *tipSykAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipSykAmountLabel.text = @"0张";
    tipSykAmountLabel.tag = SYKTAG;
    tipSykAmountLabel.font = TEXT_FONT_14;
    tipSykAmountLabel.textColor = COLOR_AUXILIARY_GREY;
    [youHuiContainerView addSubview:tipSykAmountLabel];

    [tipSykAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sykControlBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(sykControlBtn.mas_centerY);
    }];

    UIView *splitYouhuiShuLine2View = [[UIView alloc] initWithFrame:CGRectZero];
    splitYouhuiShuLine2View.backgroundColor = COLOR_LINE;
    [youHuiContainerView addSubview:splitYouhuiShuLine2View];
    
    [splitYouhuiShuLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(45/2));
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(sykControlBtn);
        make.right.equalTo(sykControlBtn.mas_right);
    }];

    //红包
    XYButton *hbControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [hbControlBtn addTarget:self action:@selector(clickHBControl:) forControlEvents:UIControlEventTouchUpInside];
    [youHuiContainerView addSubview:hbControlBtn];
    
    [hbControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youHuiContainerView.mas_top).offset(1);
        make.bottom.equalTo(splitHLineView.mas_top);
        make.left.equalTo(splitYouhuiShuLineView.mas_right);
        make.right.equalTo(youHuiContainerView.mas_right).offset(-4);
    }];
    
    UILabel *tipHBLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipHBLabel.text = XYBString(@"str_invested_project_hb", @"红包");
    tipHBLabel.font = NORMAL_TEXT_FONT_15;
    tipHBLabel.textColor = COLOR_MAIN_GREY;
    [youHuiContainerView addSubview:tipHBLabel];
    
    [tipHBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hbControlBtn.mas_centerY);
        make.left.equalTo(hbControlBtn.mas_left).offset(Margin_Left);
    }];

    UILabel *tipHbAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipHbAmountLabel.text = @"0.00元";
    tipHbAmountLabel.tag = HBTAG;
    tipHbAmountLabel.font = TEXT_FONT_14;
    tipHbAmountLabel.textColor = COLOR_XTB_ORANGE;
    [youHuiContainerView addSubview:tipHbAmountLabel];

    [tipHbAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hbControlBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(hbControlBtn.mas_centerY);
    }];


    //积分
    XYButton *jfControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [jfControlBtn addTarget:self action:@selector(clickJFControl:) forControlEvents:UIControlEventTouchUpInside];
    [youHuiContainerView addSubview:jfControlBtn];

    [jfControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitHLineView.mas_bottom);
        make.left.equalTo(splitYouhuiShuLine2View.mas_right);
        make.right.equalTo(youHuiContainerView.mas_right).offset(-4);
        make.bottom.equalTo(youHuiContainerView.mas_bottom).offset(-7);
    }];
    
    UILabel *tipJFLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipJFLabel.text = XYBString(@"str_invested_project_jf", @"积分");
    tipJFLabel.font = NORMAL_TEXT_FONT_15;
    tipJFLabel.textColor = COLOR_MAIN_GREY;
    [youHuiContainerView addSubview:tipJFLabel];
    [tipJFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jfControlBtn.mas_centerY);
        make.left.equalTo(jfControlBtn.mas_left).offset(Margin_Left);
    }];


    UILabel *tipJfAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipJfAmountLabel.text = @"0分";
    tipJfAmountLabel.tag = JFTAG;
    tipJfAmountLabel.font = TEXT_FONT_14;
    tipJfAmountLabel.textColor = COLOR_XTB_ORANGE;
    [youHuiContainerView addSubview:tipJfAmountLabel];

    [tipJfAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tipHbAmountLabel.mas_right);
        make.centerY.equalTo(jfControlBtn.mas_centerY);
    }];

#pragma mark -- 借款人开户
    XYButton * borrowerControlBtn =  [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_account_borrowerkh", @"借款申请") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    borrowerControlBtn.tag = JKSQ_TAG;
    [borrowerControlBtn addTarget:self
                          action:@selector(clickBorrowerControl:)
                forControlEvents:UIControlEventTouchUpInside];
    borrowerControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    borrowerControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [self.mainScrollView addSubview:borrowerControlBtn];
    [borrowerControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youHuiContainerView.mas_bottom).offset(8.f);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(Cell_Height));
    }];
    
    UIImageView *borrowerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [borrowerImage setImage:[UIImage imageNamed:@"my_jksq"]];
    borrowerImage.userInteractionEnabled = NO;
    [borrowerControlBtn addSubview:borrowerImage];
    
    [borrowerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(borrowerControlBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(borrowerControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowMyAppointmentImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [borrowerControlBtn addSubview:arrowMyAppointmentImageView];
    [arrowMyAppointmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(borrowerControlBtn.mas_centerY);
        make.right.equalTo(borrowerControlBtn.mas_right).offset(-Margin_Right);
    }];
    
#pragma mark --  邀请好友 加入信用宝联盟 扫一扫 设置
    
    XYButton *inviteFriendsControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_yqhy", @"邀请好友") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    inviteFriendsControlBtn.tag = YQHY_TAG;
    inviteFriendsControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    inviteFriendsControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [inviteFriendsControlBtn addTarget:self
                        action:@selector(clickyqhyControl:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView  addSubview:inviteFriendsControlBtn];
    [inviteFriendsControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowerControlBtn.mas_bottom).offset(SPACING);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(45));
    }];
    
    UIView *splitInviteFriendsLineView = [[UIView alloc] initWithFrame:CGRectZero];
    splitInviteFriendsLineView.backgroundColor = COLOR_LINE;
    [inviteFriendsControlBtn addSubview:splitInviteFriendsLineView];
    
    [splitInviteFriendsLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(inviteFriendsControlBtn.mas_bottom);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIImageView *inviteFriendsImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [inviteFriendsImage setImage:[UIImage imageNamed:@"my_yqhy"]];
    inviteFriendsImage.userInteractionEnabled = NO;
    [inviteFriendsControlBtn addSubview:inviteFriendsImage];
    
    [inviteFriendsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteFriendsControlBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(inviteFriendsControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowYqhyImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [inviteFriendsControlBtn addSubview:arrowYqhyImageView];
    [arrowYqhyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inviteFriendsControlBtn.mas_centerY);
        make.right.equalTo(inviteFriendsControlBtn.mas_right).offset(-Margin_Right);
    }];

    XYButton *xybLMControlBtn =  [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_my_xybLM", @"加入信用宝联盟") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    xybLMControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    xybLMControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    xybLMControlBtn.tag = JRLM_TAG;
    [xybLMControlBtn addTarget:self
                        action:@selector(clickxybLMControl:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:xybLMControlBtn];
    [xybLMControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteFriendsControlBtn.mas_bottom);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(Cell_Height));
    }];

    UIView *splitCenterLineView = [[UIView alloc] initWithFrame:CGRectZero];
    splitCenterLineView.backgroundColor = COLOR_LINE;
    [xybLMControlBtn addSubview:splitCenterLineView];

    [splitCenterLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(xybLMControlBtn.mas_bottom);
        make.height.equalTo(@(Line_Height));
    }];

    UIImageView *xybLMImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [xybLMImage setImage:[UIImage imageNamed:@"my_jrxybLm"]];
    xybLMImage.userInteractionEnabled = NO;
    [xybLMControlBtn addSubview:xybLMImage];
    
    [xybLMImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xybLMControlBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(xybLMControlBtn.mas_centerY);
    }];

    UIImageView *arrowxybLMImageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [xybLMControlBtn addSubview:arrowxybLMImageView];
    [arrowxybLMImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(xybLMControlBtn.mas_centerY);
        make.right.equalTo(xybLMControlBtn.mas_right).offset(-Margin_Right);
    }];

    //扫码 Scan code
    XYButton *scanCodeBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_san_code", @"扫一扫") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    scanCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    scanCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [scanCodeBtn addTarget:self
                    action:@selector(clickScanCodeControl:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:scanCodeBtn];
    [scanCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xybLMControlBtn.mas_bottom);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(Cell_Height));
      
    }];
    
    UIView *scanCodeViewLineView = [[UIView alloc] initWithFrame:CGRectZero];
    scanCodeViewLineView.backgroundColor = COLOR_LINE;
    [self.mainScrollView addSubview:scanCodeViewLineView];
    
    [scanCodeViewLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(scanCodeBtn.mas_bottom);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIImageView *scanCodeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [scanCodeImage setImage:[UIImage imageNamed:@"my_scre"]];
    scanCodeImage.userInteractionEnabled = NO;
    [scanCodeBtn addSubview:scanCodeImage];
    
    [scanCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanCodeBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(scanCodeBtn.mas_centerY);
    }];

    UIImageView *arrowScanCodeView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [scanCodeBtn addSubview:arrowScanCodeView];
    [arrowScanCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scanCodeBtn.mas_centerY);
        make.right.equalTo(scanCodeBtn.mas_right).offset(-Margin_Right);
    }];


    //设置
    XYButton *setControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_my_Set", @"设置") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    setControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);;
    [setControlBtn addTarget:self
                      action:@selector(clickSetControl:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:setControlBtn];
    [setControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanCodeBtn.mas_bottom);
        make.height.equalTo(@(Cell_Height));
         make.left.right.equalTo(self.mainScrollView);
        make.bottom.equalTo(self.mainScrollView.mas_bottom).offset(-Margin_Length);
    }];

    UIImageView *setImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [setImage setImage:[UIImage imageNamed:@"my_set"]];
    setImage.userInteractionEnabled = NO;
    [setControlBtn addSubview:setImage];
    
    [setImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setControlBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(setControlBtn.mas_centerY);
    }];

    UIImageView *arrowSetImageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [setControlBtn addSubview:arrowSetImageView];
    [arrowSetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(setControlBtn.mas_centerY);
        make.right.equalTo(setControlBtn.mas_right).offset(-Margin_Right);
    }];
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _mainScrollView.header = self.gifHeader1;
}

- (void)headerRereshing {
    [self updateAccountInfo];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainScrollView.header endRefreshing];
}
/*!
 *  @author JiangJJ, 16-12-14 11:12:31
 *
 *  退出登录 后 页面数据0.00
 */
- (void)signOutDataZero {
    
    //普通账户
    self.amountLabel.text = @"--";
    
    //存管账户
    self.cgamountLabel.textColor = COLOR_XTB_ORANGE;
    self.cgamountLabel.text = @"--";
    
    //礼金
    UILabel *labLJ = (UILabel *) [self.view viewWithTag:LJTAG];
    labLJ.text = @"--";
    
    //优惠劵
    UILabel *labSYK = (UILabel *) [self.view viewWithTag:SYKTAG];
    labSYK.text = @"--";;
    
    //红包
    UILabel *labHB = (UILabel *) [self.view viewWithTag:HBTAG];
    labHB.text = @"--";;
    
    //积分
    UILabel *labJF = (UILabel *) [self.view viewWithTag:JFTAG];
    labJF.text = @"--";
    
    //改变 Label文字
    UILabel *labelYqhy = (UILabel *) [self.view viewWithTag:2009];
    labelYqhy.text = XYBString(@"str_yqhy", @"邀请好友");
    
    //隐藏vip等级
    self.headVipVIew.hidden = YES;
    
    NSString *TitleStr = [NSString stringWithFormat:@"%@/%@",
                             XYBString(@"str_immediately_login", @"立即登录"),
                             XYBString(@"str_register", @"注册")];
    self.nameLabel.text = TitleStr;
    
     _headerImageview.image = [UIImage imageNamed:@"header_logo"];
    
    //居中
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerImageview.mas_centerY);
    }];
    
    XYButton * borrowSqBth = (XYButton *)[self.view viewWithTag:JKSQ_TAG];
    UIView * youHuiContainerView = (UIView *)[self.view viewWithTag:YHTAG];
    XYButton * yqhyBut = (XYButton *)[self.view viewWithTag:YQHY_TAG];
    XYButton * xybLmBut = (XYButton *)[self.view viewWithTag:JRLM_TAG];

    borrowSqBth.hidden = NO;
    [borrowSqBth mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youHuiContainerView.mas_bottom).offset(8.f);
        make.height.equalTo(@(Cell_Height));
    }];
    
    yqhyBut.hidden = NO;
    [yqhyBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowSqBth.mas_bottom).offset(SPACING);
        make.height.equalTo(@(Cell_Height));
    }];
    
    [xybLmBut setTitle:XYBString(@"str_my_xybLM", @"加入信用宝联盟") forState:UIControlStateNormal];
    [xybLmBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yqhyBut.mas_bottom);
    }];


    [self.mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)setXYBUI {
    
    //普通用户金额
    User *userInfo = [UserDefaultsUtil getUser];
    
    if ([userInfo.totalAmount doubleValue] == 0) {
        self.amountLabel.text = @"0.00";
    } else {
        self.amountLabel.textColor = COLOR_XTB_ORANGE;
        self.amountLabel.formatBlock = ^NSString* (double value){
            NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",value]];
            return [NSString stringWithFormat:@"%@",formatted];
        };
        
        self.amountLabel.method = UILabelCountingMethodEaseOut;
        NSDecimalNumber * minBidAmounts = [NSDecimalNumber doubleToNSDecimalNumber:[userInfo.totalAmount  doubleValue]];
        double toAmonut = [minBidAmounts doubleValue];
        self.amountLabel.toAmount = toAmonut;
        [self.amountLabel countFrom:0 to:toAmonut  withDuration:1.0f];
    }
    
    //存管用户金额
    if (![userInfo.openDep boolValue]) {
        
            _depositoryBtn.userInteractionEnabled = NO;
            self.cgamountLabel.textColor = COLOR_AUXILIARY_GREY;
            self.cgamountLabel.text = @"敬请期待";
    }else
    {
        if ([StrUtil isEmptyString:userInfo.depAcctId]) {
            
             self.cgamountLabel.text = @"立即开通";
             self.cgamountLabel.textColor = COLOR_XTB_ORANGE;
            _depositoryBtn.userInteractionEnabled = YES;
            
        }else
        {
            if ([userInfo.depTotalAmount doubleValue] == 0) {
                
                _depositoryBtn.userInteractionEnabled = YES;
                self.cgamountLabel.textColor = COLOR_AUXILIARY_GREY;
                self.cgamountLabel.text = @"0.00";
                
            } else {
                
                self.cgamountLabel.textColor = COLOR_XTB_ORANGE;
                self.cgamountLabel.formatBlock = ^NSString* (double value){
                    NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",value]];
                    return [NSString stringWithFormat:@"%@",formatted];
                };
                
                self.cgamountLabel.method = UILabelCountingMethodEaseOut;
                NSDecimalNumber * minBidAmounts = [NSDecimalNumber doubleToNSDecimalNumber:[userInfo.depTotalAmount  doubleValue]];
                double toAmonut = [minBidAmounts doubleValue];
                self.cgamountLabel.toAmount = toAmonut;
                [self.cgamountLabel countFrom:0 to:toAmonut  withDuration:1.0f];
            }
        }
    }
    //信用宝联盟
    if ([[UserDefaultsUtil getUser].bonusState intValue] == 2) {
        
        NSString *amountStr = @"0.00";
        if ([UserDefaultsUtil getUser]) {
            amountStr = [NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].recommendIncome doubleValue]]; //同一个字段
        }
        
        NSString *text = XYBString(@"str_recommend_income_zero", @"0.00"); //推荐收益
        if ([amountStr doubleValue] > 0) {
            text = [Utility replaceTheNumberForNSNumberFormatter:amountStr];
        }
        
        self.unionLabel.text = XYBString(@"str_invested_project_union", @"信用宝联盟");
        self.unionDetailLabel.text = [NSString stringWithFormat:@"%@元", text];

    } else {
        NSString *amountStr = @"0.00";
        if ([UserDefaultsUtil getUser]) {
            amountStr = [NSString stringWithFormat:@"%.2f", [[UserDefaultsUtil getUser].recommendIncome doubleValue]];
        }
        
        NSString *text = XYBString(@"str_recommend_income_zero", @"0.00"); //已获礼金
        if ([amountStr doubleValue] > 0) {
            text = [Utility replaceTheNumberForNSNumberFormatter:amountStr];
        }
        
        self.unionLabel.text = XYBString(@"str_invested_project_adv_firend",@"推荐好友拿奖励");
        self.unionDetailLabel.text = [NSString stringWithFormat:@"%@元", text];
    }

    UILabel *lab1 = (UILabel *) [self.view viewWithTag:LJTAG];
    if ([userInfo.rewardAmount doubleValue] > 0) {
        NSString *rewardAmount = [Utility replaceTheNumberForNSNumberFormatter:userInfo.rewardAmount];
        lab1.text = [NSString stringWithFormat:@"%@元", rewardAmount]; // userInfo.rewardAmount;
    } else {
        lab1.text = [NSString stringWithFormat:@"%@元",XYBString(@"str_recommend_income_zero", @"0.00")];
    }
    
    UILabel *lab2 = (UILabel *) [self.view viewWithTag:HBTAG];
    if ([userInfo.sleepRewordAmount doubleValue] > 0) {
        NSString *sleepRewordAmount = [Utility replaceTheNumberForNSNumberFormatter:userInfo.sleepRewordAmount];
        lab2.text = [NSString stringWithFormat:@"%@元",sleepRewordAmount];
    } else {
        lab2.text = [NSString stringWithFormat:@"%@元",XYBString(@"str_recommend_income_zero", @"0.00")];
    }

    UILabel *lab3 = (UILabel *) [self.view viewWithTag:SYKTAG];
    if ([userInfo.increaseCardCount doubleValue] > 0) {
        lab3.text = [NSString stringWithFormat:@"%@张", userInfo.increaseCardCount];
    } else {
        lab3.text = @"0张";
    }

    UILabel *lab4 = (UILabel *) [self.view viewWithTag:JFTAG];
    if ([userInfo.score doubleValue] > 0) {
        lab4.text = [NSString stringWithFormat:@"%@分",[Utility replaceTheNumberForNSNumberFormatter:userInfo.score]];
    } else {
        lab4.text = @"0分";
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //将scrollView滚动的距离传给userInfoView让顶部的View自动计算反向力的距离
}

//判断日期是今天，昨天还是明天
- (BOOL)compareDate:(NSDate *)date {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;

    tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
    yesterday = [today dateByAddingTimeInterval:-secondsPerDay];

    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *tomorrowString = [[tomorrow description] substringToIndex:10];

    NSString *dateString = [[date description] substringToIndex:10];

    if ([dateString isEqualToString:todayString]) {
        return YES;
    } else if ([dateString isEqualToString:yesterdayString]) {
        return YES;
    } else if ([dateString isEqualToString:tomorrowString]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark--
#pragma mark--  按钮点击事件

/*!
 *  @author JiangJJ, 16-12-12 14:12:52
 *
 *
 *  @param sender 左侧用户头像点击事件
 */
- (void)clickleftBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        
    } else {
        
        [UMengAnalyticsUtil event:EVENT_MY_USER_MESSAGE];

    }
  
}


/**
 *
 * 普通账户
 */
-(void)clickOrdinaryBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        
        
    } else {

    }
}

-(void)clickOrdinaryLendButState:(id)sender
{
    [MyAlertView showKonwMessage:XYBString(@"str_ga", @"普通账户") Message:XYBString(@"str_ptAlertview_tips", @"包含持有的步步高，定期宝，信投宝和债权转让资产")];
}

/**
 *
 * 存管账户
 */
-(void)clickDepositoryBtn:(id)sender
{
    User *userInfo = [UserDefaultsUtil getUser];
    if (![Utility shareInstance].isLogin) {
        
    } else {
        
        if ([StrUtil isEmptyString:userInfo.depAcctId]) {

            return ;
        }
        
//        CGAccountViewController * cgacount = [[CGAccountViewController alloc] init];
//        [self.navigationController pushViewController:cgacount animated:YES];
    }

}


-(void)clickDepositoryLendButState:(id)sendr
{
    [MyAlertView showKonwMessage:XYBString(@"str_cga", @"存管账户") Message:XYBString(@"str_cgAlertview_tips", @"包含持有一键出借产品的资产")];
}

/**
 *
 * 我的账户
 */
-(void)clickMyAccountBtn:(id)sender
{
    
}


-(void)clickBorrowerControl:(id)sender {
    
    int i = random() % 100;
    NSString *requestURL =  [NSString stringWithFormat:@"%@&ts=%d",[RequestURL getNodeJsH5URL:APP_LOAN_URL withIsSign:YES],i];
    
    if (![Utility shareInstance].isLogin) {
       
    } else {
        
        XYWebViewController *attendenceVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_account_borrowerkh", @"借款申请") webUrlString:requestURL];
        attendenceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:attendenceVC animated:YES];
    }
}

/**
 *  礼金
 *
 *  @param sender
 */
- (void)clickLJControl:(id)sender {
    if (![Utility shareInstance].isLogin) {
       

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_LJ];

    }
}

/**
 *  红包
 *
 *  @param
 */
- (void)clickHBControl:(id)sender {
    if (![Utility shareInstance].isLogin) {

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_HB];
    }
}

/**
 *  收益提升卡
 *
 *  @param sender
 */
- (void)clickSYKControl:(id)sender {
    if (![Utility shareInstance].isLogin) {

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_YHJ];
    }
}

/**
 *  我的积分
 *
 *  @param sender
 */
- (void)clickJFControl:(id)sender {
    if (![Utility shareInstance].isLogin) {

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_JF];
    }
}


/*!
 *  @author JiangJJ, 16-12-12 19:12:43
 *
 *
 *  @param sender 邀请好友  与 信用宝 联盟  点击事件
 */
- (void)clickyqhyControl:(id)sender {
    if (![Utility shareInstance].isLogin) {
    
    } else {
        [self loadViewController];
    }
}

- (void)loadViewController {
    if ([UserDefaultsUtil getUser].bonusState) {
    }
}

/*!
 *  @author JiangJJ, 16-12-12 19:12:46
 *
 *
 *  @param sender 加入信用宝联盟点击事件
 */
- (void)clickxybLMControl:(id)sender {
    XYButton * xybLmBut = (XYButton *)[self.view viewWithTag:JRLM_TAG];
    if (![Utility shareInstance].isLogin) {

    } else {
        [self loadJrViewController];
    }
}

- (void)loadJrViewController {
    if ([UserDefaultsUtil getUser].bonusState) {
        if ([[UserDefaultsUtil getUser].bonusState intValue] == 2) {
            //点击加入信用宝联盟 如果是信用宝联盟账户 第一次进入联盟页面
            if (self.isBonusState == YES) {
                [UMengAnalyticsUtil event:EVENT_MY_XYB_UNION];

                self.isBonusState = NO;
                return;
            }
        }
    }
    if ([UserDefaultsUtil getUser].bonusState) {
        if ([[UserDefaultsUtil getUser].bonusState intValue] != 2) {
            [UMengAnalyticsUtil event:EVENT_MY_JRXYB_UNION];

        } else {
            [UMengAnalyticsUtil event:EVENT_MY_XYB_UNION];
        }
    }
}

/*!
 *  @author JiangJJ, 16-12-12 19:12:01
 *
 *
 *  @param sender 扫码点击事件
 */
-(void)clickScanCodeControl:(id)sender
{
    if (![Utility shareInstance].isLogin) {

        
    } else {
        [self LoadQrCode];
    }
}

-(void)LoadQrCode
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)//用户相机未打开
    {
                //无权限 做一个友好的提示
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:XYBString(@"str_notifi_alert", @"提示") message:XYBString(@"str_alert_camera", @"请您设置允许APP访问您的相机\n设置>隐私>相机")  delegate:self cancelButtonTitle:XYBString(@"str_ok", @"确定") otherButtonTitles:nil, nil];
                [alart show];
                return ;
            } else {
                [UMengAnalyticsUtil event:EVENT_MY_SCAN];
            }
}

/*!
 *  @author JiangJJ, 16-12-12 19:12:01
 *
 *
 *  @param sender 设置点击事件
 */
- (void)clickSetControl:(id)sender {
    
    if (![Utility shareInstance].isLogin) {

        
    } else {
        [UMengAnalyticsUtil event:EVENT_MY_SET];

    }
}


/*!
 *  @author JiangJJ, 16-12-13 16:12:19
 *
 *  通知
 */
- (void)updateAccountInfo {
    static BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }

    NSString *noticeLastReadDateStr = nil;
    NSString *eventLastReadDateStr = nil;
    NSString *financeLastReadDateStr = nil;
    NSString *borrowLastReadDateStr = nil;

    NSDictionary *userDic = [UserDefaultsUtil getLastReadDateDic];
    NSDictionary *lastReadDateDic = [userDic objectForKey:[UserDefaultsUtil getUser].userId];
    if (lastReadDateDic) {

        if ([lastReadDateDic objectForKey:@"NoticeDate"]) { //公告最后阅读时间
            noticeLastReadDateStr = [lastReadDateDic objectForKey:@"NoticeDate"];
        } else {
            noticeLastReadDateStr = @"";
        }

        if ([lastReadDateDic objectForKey:@"EventDate"]) { //活动最后阅读时间
            eventLastReadDateStr = [lastReadDateDic objectForKey:@"EventDate"];
        } else {
            eventLastReadDateStr = @"";
        }

        if ([lastReadDateDic objectForKey:@"FinanceDate"]) { //出借最后阅读时间
            financeLastReadDateStr = [lastReadDateDic objectForKey:@"FinanceDate"];
        } else {
            financeLastReadDateStr = @"";
        }

        if ([lastReadDateDic objectForKey:@"BorrowDate"]) { //借款最后阅读时间
            borrowLastReadDateStr = [lastReadDateDic objectForKey:@"BorrowDate"];
        } else {
            borrowLastReadDateStr = @"";
        }

    } else {
        noticeLastReadDateStr = @"";
        eventLastReadDateStr = @"";
        financeLastReadDateStr = @"";
        borrowLastReadDateStr = @"";
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([UserDefaultsUtil getUser].userId) {
        [param setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }

    [param setObject:noticeLastReadDateStr forKey:@"noticeDate"];
    [param setObject:eventLastReadDateStr forKey:@"eventDate"];
    [param setObject:financeLastReadDateStr forKey:@"financeDate"];
    [param setObject:borrowLastReadDateStr forKey:@"borrowDate"];

    [self updateAccountInfoRequestWithparam:param];
}

/*!
 *  @author JiangJJ, 16-12-13 16:12:15
 *
 *
 *  @param params 我的账户接口
 */
- (void)updateAccountInfoRequestWithparam:(NSMutableDictionary *)params {
    NSString *urlPath = [RequestURL getRequestURL:AccountRequestURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[AccountResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self hideLoading];
            AccountResponseModel *account = responseObject;
            if (account.resultCode == 1) {
                
                //保存user
                User *user = [HandleUserInfo hanedleTheUserInfo:account.toDictionary];
                [UserDefaultsUtil setUser:user];
                
                //是否开通存管账户  1 已开通 0 未开通
                UIView * youHuiContainerView = (UIView *)[self.view viewWithTag:YHTAG];
                XYButton * borrowSqBth = (XYButton *)[self.view viewWithTag:JKSQ_TAG];
                
                //开通存管账户 切 借款存管账户ID不能为空显示借款申请
                if ([user.openDep boolValue] && ![StrUtil isEmptyString:user.depBorrowAcctId]) {
                    borrowSqBth.hidden = NO;
                    _depositoryBtn.userInteractionEnabled = YES;
                    [borrowSqBth mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(youHuiContainerView.mas_bottom).offset(SPACING);
                        make.height.equalTo(@(Cell_Height));
                    }];
                }else
                {
                    borrowSqBth.hidden = YES;
                    [borrowSqBth mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(youHuiContainerView.mas_bottom).offset(0);
                        make.height.equalTo(@(0.f));
                    }];
                }
                
                //设置名字
                if ([user.isIdentityAuth boolValue]) {
                      
                    NSRange range = NSMakeRange(0, 1);
                    NSString *  strName = [user.realName substringWithRange:range];
                    if ([user.sex intValue] == 0) { // 0 男 1 女
                        self.nameLabel.text = [strName stringByAppendingString:@"先生"];
                    }else
                    {
                        self.nameLabel.text = [strName stringByAppendingString:@"女士"];
                    }
                    
                }else
                {
                    if (![StrUtil isEmptyString:user.tel])
                    {
                        self.nameLabel.text = [Utility thePhoneReplaceTheStr:user.tel];
                    }
                }
                
                [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) { 
                    make.centerY.equalTo(_headerImageview.mas_centerY).offset(-15);
                }];
                
                self.headVipVIew.hidden = NO;
                [self.headVipVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_headerImageview.mas_centerY).offset(15);
                }];
                
                if (![account.accountInfo.vipExpired boolValue]) {//设置VIP等级
                    self.headVipImageVIew.image = [UIImage imageNamed:[NSString stringWithFormat:@"account_vip%@", account.accountInfo.vipLevel]];
                    
                }else{//设置过期VIP等级
                    self.headVipImageVIew.image = [UIImage imageNamed:[NSString stringWithFormat:@"account_gray_vip%@", account.accountInfo.vipLevel]];
                }
                
                //设置头像
                if ([UserDefaultsUtil getUser].url) {
                    [self.headerImageview sd_setImageWithURL:[NSURL URLWithString:[UserDefaultsUtil getUser].url] placeholderImage:[UIImage imageNamed:@"header_logo"]];
                } else {
                    [self.headerImageview sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"header_logo"]];
                }
                
                //信用宝联盟账户
                XYButton * yqhyBut = (XYButton *)[self.view viewWithTag:YQHY_TAG];
                XYButton * xybLmBut = (XYButton *)[self.view viewWithTag:JRLM_TAG];

                if ([UserDefaultsUtil getUser].bonusState) {

                    if ([[UserDefaultsUtil getUser].bonusState intValue] == 2) {

                        yqhyBut.hidden = YES;
                        [yqhyBut mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(0));
                        }];

                        [xybLmBut setTitle:XYBString(@"str_xyblm", @"信用宝联盟") forState:UIControlStateNormal];
                        [xybLmBut mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(yqhyBut.mas_bottom).offset(0);
                        }];
                        
                    }else
                    {
                        yqhyBut.hidden = NO;
                        [yqhyBut mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(Cell_Height));
                        }];
                        
                        [xybLmBut setTitle:XYBString(@"str_my_xybLM", @"加入信用宝联盟") forState:UIControlStateNormal];
                        [xybLmBut mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(yqhyBut.mas_bottom).offset(0);
                        }];
                    }
                }
            }
 
            [self setNeedsStatusBarAppearanceUpdate];
            [self setXYBUI];
        }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }
    ];
}

/*****************************检测银行卡绑定接口**********************************/
- (void)callCheckBankWebService:(NSDictionary *)dictionary {

    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSString *urlPath = [RequestURL getRequestURL:BankURL param:params];

    [WebService postRequest:urlPath param:params JSONModelClass:[MyBanksResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            MyBanksResponseModel *myBankResponse = responseObject;
            User *user = [UserDefaultsUtil getUser];
            user.accountNumber = myBankResponse.bank.accountNumber;
            user.bankName = myBankResponse.bank.bankName;
            user.bankType = myBankResponse.bank.bankType;
            user.bankmobilePhone = myBankResponse.bank.mobilePhone;
            user.bankId = myBankResponse.bank.bankId;
            BOOL isBank = [myBankResponse.isBankSaved boolValue];
            if (isBank == YES) {
                user.isBankSaved = @"1";
            }

            BOOL isIdentityAuth = [myBankResponse.isIdentityAuth boolValue];
            if (isIdentityAuth) {
                user.isIdentityAuth = @"1";
            }
            user.realName = myBankResponse.user.realName;
            user.idNumber = myBankResponse.user.idNumber;
            BOOL isWithdrawMoney = [myBankResponse.isWithdrawMoney boolValue];
            if (isWithdrawMoney) {
                user.isWithdrawMoney = @"1";
            }
            [UserDefaultsUtil setUser:user];

        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self showPromptTip:errorMessage];
        }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
