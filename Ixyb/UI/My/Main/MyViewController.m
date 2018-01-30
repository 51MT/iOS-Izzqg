//
//  MyViewController.m
//  Ixyb
//
//  Created by wang on 15/8/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SGAlertView.h"
#import <Photos/Photos.h>
#import "SGScanningQRCodeVC.h"

#import "AccountResponseModel.h"
#import "CGAccountOpenDialogView.h"
#import "CGAccountOpenViewController.h"
#import "AllAssetsViewController.h"
#import "AllianceApplyViewController.h"
#import "AllianceViewController.h"
#import "BackPlanViewController.h"
#import "ChargeViewController.h"
#import "DrawWebViewController.h"
#import "MyAlertView.h"
#import "EarnBonusCodeViewController.h"
#import "HandleUserInfo.h"
#import "IncreaseCardViewController.h"
#import "BbgInvestListViewController.h"
#import "DqbInvestListViewController.h"
#import "XtbInvestListViewController.h"
#import "LoginFlowViewController.h"
#import "MJRefresh.h"
#import "MessageCategoryViewController.h"
#import "MyBanksResponseModel.h"
#import "RecommendViewController.h"
#import "RewardAmountViewController.h"
#import "RiskEvaluatingViewController.h"
#import "ScoreStoreWebViewController.h"
#import "SetViewController.h"
#import "ShakeGameViewController.h"
#import "TradeDetailViewController.h"
#import "TropismViewController.h"
#import "CGAccountOpenViewController.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "UserDetailRealNamesViewController.h"
#import "AccountViewController.h"
#import "CGAccountViewController.h"
#import "UserInfoViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "XYUIKit.h" //XYB公共控件
#import "XsdQueryAmountResponseModel.h"

#import "MJRefreshCustomGifHeader.h"

#import "MyDiscountViewController.h"
#import "UICountingLabel.h"
#import "WaterView.h"

#define SPACING 10
#define LJTAG   1001
#define HBTAG   1002
#define SYKTAG  1003
#define JFTAG   1004
#define HKJH_TAG   2008
#define JKSQ_TAG    3000
#define YQHY_TAG    3001
#define JRLM_TAG    3002
#define CGAOT_TAG   3003
#define SCOAN_TAG     3004

@interface MyViewController () <UIAlertViewDelegate, UIScrollViewDelegate>
{
    UILabel         * bbgQuotaLabel; //步步高已投金额
    UILabel         * dqbQuotaLabel; //定期宝已投金额
    UILabel         * xtbQuotaLabel; //信投保已投金额
}

@property (nonatomic, strong) XYScrollView *mainScrollView;
@property (nonatomic, strong) UICountingLabel      *amountLabel;     //总金额
@property (nonatomic, strong) UICountingLabel      *remainLabel;    //可用余额
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
@property (nonatomic, assign) BOOL         isBonusState;            //是否是信用宝联盟账户
@property (nonatomic, strong) NSMutableDictionary  * accountDic;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UMengAnalyticsUtil event:EVENT_MY_IN];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
    
    if ([Utility shareInstance].isLogin) {
        
        dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t dispatchGroup = dispatch_group_create();
        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
            [self updateAccountInfo];
        });
        
        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
            //请求数据
            [self callCheckBankWebService:@{@"userId" : [UserDefaultsUtil getUser].userId}];;
        });

        //判断是否登录 隐藏相应的控件
        self.totalAssetsLabel.hidden = NO;
        self.mainScrollView.header.hidden = NO;
        
    } else {
        self.mainScrollView.header.hidden = YES;
        self.totalAssetsLabel.hidden = YES;
        [self signOutDataZero];//退出登录 数据清零
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UMengAnalyticsUtil event:EVENT_MY_OUT];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //充值成功后 通知提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];

    [self initUI];
    //设置刷新
    [self setupRefresh];
}

- (void)chargeSuccess {
    
    [HUD showPromptViewWithToShowStr:XYBString(@"str_recharge_success", @"充值成功") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
    [self performSelector:@selector(updateAccountInfo) withObject:nil afterDelay:0.6f];
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
                       (id) COLOR_LIGHT_BLUE.CGColor, nil];
    [headView.layer addSublayer:gradient];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MainScreenWidth));
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@226);
    }];
    
    WaterView * wterWave = [[WaterView alloc]initWithFrame:CGRectMake(0,147.f, MainScreenWidth, 79)];
    [headView addSubview:wterWave];
    
    
    UIButton *butMyAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [butMyAccount setTitle:XYBString(@"str_account", @"我的账户") forState:UIControlStateNormal];
    [headView addSubview:butMyAccount];
    
    [butMyAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(28));
        make.left.equalTo(@(Margin_Left));
    }];

    UIButton *butTransactionDetailed = [UIButton buttonWithType:UIButtonTypeCustom];
    [butTransactionDetailed setImage:[UIImage imageNamed:@"account_transactionload"] forState:UIControlStateNormal];
    [butTransactionDetailed setImage:[UIImage imageNamed:@"account_transactionselect"] forState:UIControlStateHighlighted];
    [butTransactionDetailed addTarget:self
                               action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    butTransactionDetailed.frame = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
    [headView addSubview:butTransactionDetailed];
    [butTransactionDetailed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(butMyAccount);
          make.right.equalTo(@(-Margin_Right));
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
        make.height.equalTo(@(134));
    }];
    
    UITapGestureRecognizer * tapAllAssetsGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allAssetsBtn:)];
    [backImageView addGestureRecognizer:tapAllAssetsGesturRecognizer];

    float width = (MainScreenWidth - 20 - 8) / 2;
    
    XYButton *ordinaryBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [ordinaryBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    ordinaryBtn.userInteractionEnabled = NO;
    [backImageView addSubview:ordinaryBtn];

    [ordinaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-52.5);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.width.equalTo(@(width));
    }];
    
    UILabel * ordinaryLab = [[UILabel alloc] init];
    ordinaryLab.text = XYBString(@"str_tip_all_asset", @"总资产(元)");
    ordinaryLab.font = TEXT_FONT_14;
    ordinaryLab.textColor = COLOR_MAIN_GREY;
    [backImageView addSubview:ordinaryLab];
    [ordinaryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ordinaryBtn.mas_centerX);
        make.top.equalTo(@(22));
    }];
    
    self.amountLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.font = FONT_BUTTON_NORMAL;
    self.amountLabel.textColor = COLOR_AUXILIARY_GREY;
    self.amountLabel.text = @"0.00";
    self.amountLabel.format = @"%.2f";
    [backImageView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ordinaryLab.mas_centerX);
        make.top.equalTo(ordinaryLab.mas_bottom).offset(4);
    }];
    
    //存管账户
    XYButton * ptAmountBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [ptAmountBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    ptAmountBtn.userInteractionEnabled = NO;
    [backImageView addSubview:ptAmountBtn];
    
    [ptAmountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(1);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-52.5);
        make.left.equalTo(ordinaryBtn.mas_right);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];
    
    UILabel * depositoryLab = [[UILabel alloc] init];
    depositoryLab.text = XYBString(@"str_tip_amount_asset", @"可用余额(元)");
    depositoryLab.font = TEXT_FONT_14;
    depositoryLab.textColor = COLOR_MAIN_GREY;
    [ptAmountBtn addSubview:depositoryLab];
    [depositoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ptAmountBtn.mas_centerX);
        make.top.equalTo(@(22));
    }];
    
    self.remainLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.remainLabel.textAlignment = NSTextAlignmentCenter;
    self.remainLabel.font = FONT_BUTTON_NORMAL;
    self.remainLabel.textColor = COLOR_AUXILIARY_GREY;
    self.remainLabel.text = @"0.00";
    self.remainLabel.format = @"%.2f";
    [backImageView addSubview:self.remainLabel];
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ptAmountBtn.mas_centerX);
        make.top.equalTo(depositoryLab.mas_bottom).offset(4);
    }];
    
    UIView * levelLine = [[UIView alloc] initWithFrame:CGRectZero];
    levelLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:levelLine];
    [levelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ordinaryBtn.mas_bottom);
        make.left.equalTo(@(4));
        make.right.equalTo(@(-4));
        make.height.equalTo(@(Line_Height));
    }];

    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [backImageView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLine.mas_bottom);
        make.centerX.equalTo(backImageView);
        make.bottom.equalTo(@(-7.f));
        make.width.equalTo(@(Line_Height));
    }];
    
    XYButton *withDrawBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_withdraw", @"提现") titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    withDrawBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    withDrawBtn.titleLabel.font = BIG_TEXT_FONT_17;
    [withDrawBtn addTarget:self action:@selector(clickWithDrawBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView  addSubview:withDrawBtn];
    [withDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLine.mas_bottom);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(backImageView.mas_left).offset(4);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    XYButton *chargeBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_charge", @"充值") titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    chargeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    chargeBtn.titleLabel.font = BIG_TEXT_FONT_17;
    [chargeBtn addTarget:self action:@selector(clickChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView  addSubview:chargeBtn];
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLine.mas_bottom);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-7);
        make.left.equalTo(verticalLine.mas_right);
        make.right.equalTo(backImageView.mas_right).offset(-4);
    }];
    
    
    //我的优惠
    float youhuiWidth = (MainScreenWidth - 28.5) / 2;

    UIImageView *youHuiContainerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    youHuiContainerView.image = [UIImage imageNamed:@"radioBackImg"];
    youHuiContainerView.userInteractionEnabled = YES;
    [self.mainScrollView addSubview:youHuiContainerView];
    
    [youHuiContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(97.f);
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
    tipHbAmountLabel.textColor = COLOR_AUXILIARY_GREY;
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
    tipJfAmountLabel.textColor = COLOR_AUXILIARY_GREY;
    [youHuiContainerView addSubview:tipJfAmountLabel];

    [tipJfAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tipHbAmountLabel.mas_right);
        make.centerY.equalTo(jfControlBtn.mas_centerY);
    }];
    
    
#pragma mark -- 步步高已投 定期宝已投 信用宝已投 回款计划
    
    UIView * bBgCastView = [[UIView alloc] initWithFrame:CGRectZero];
    bBgCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:bBgCastView];
    [bBgCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(youHuiContainerView.mas_bottom).offset(4);
        make.height.equalTo(@45.5);
    }];
    
    XYButton * bBgCastControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                                  titleColor:nil
                                                    isUserInteractionEnabled:YES];
    [bBgCastControlBtn addTarget:self
                          action:@selector(clickBBgCastControl:)
                forControlEvents:UIControlEventTouchUpInside];
    [bBgCastView addSubview:bBgCastControlBtn];
    [bBgCastControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bBgCastView.mas_top);
        make.left.equalTo(bBgCastView.mas_left);
        make.right.equalTo(bBgCastView.mas_right);
        make.height.equalTo(@(45));
    }];
    
    UIImageView * bBgCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bBgCastImageView.image = [UIImage imageNamed:@"bbg_Icon"];
    [bBgCastView addSubview:bBgCastImageView];
    [bBgCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];
    
    
    UILabel *tipbBgCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipbBgCastLabel.text =  XYBString(@"str_bbg_invested", @"步步高已投");
    tipbBgCastLabel.font = TEXT_FONT_16;
    tipbBgCastLabel.textColor = COLOR_MAIN_GREY;
    [bBgCastView addSubview:tipbBgCastLabel];
    [tipbBgCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bBgCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowBgCastImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [bBgCastView addSubview:arrowBgCastImageView];
    [arrowBgCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
        make.right.equalTo(bBgCastView.mas_right).offset(-Margin_Right);
    }];
    
    bbgQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    bbgQuotaLabel.font = TEXT_FONT_14;
    bbgQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    bbgQuotaLabel.textAlignment = NSTextAlignmentRight;
    bbgQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [bBgCastView addSubview:bbgQuotaLabel];
    [bbgQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowBgCastImageView.mas_left).offset(-3);
        make.centerY.equalTo(bBgCastControlBtn.mas_centerY);
    }];
    
    //定期宝 View
    UIView *dQbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    dQbCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:dQbCastView];
    [dQbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(bBgCastView.mas_bottom).offset(0);
        make.height.equalTo(@46);
    }];
    
    UIView *splitInviteDqbCastLineView = [[UIView alloc] initWithFrame:CGRectZero];
    splitInviteDqbCastLineView.backgroundColor = COLOR_LINE;
    [dQbCastView addSubview:splitInviteDqbCastLineView];
    
    [splitInviteDqbCastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.top.equalTo(dQbCastView.mas_top);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIView *splitCenterLineDqbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    splitCenterLineDqbCastView.backgroundColor = COLOR_LINE;
    [dQbCastView addSubview:splitCenterLineDqbCastView];
    
    [splitCenterLineDqbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(dQbCastView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(Line_Height));
    }];
    
    XYButton *dqbCastControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                                 titleColor:nil
                                                   isUserInteractionEnabled:YES];
    [dqbCastControlBtn addTarget:self
                          action:@selector(clickDqbCastControl:)
                forControlEvents:UIControlEventTouchUpInside];
    [dQbCastView addSubview:dqbCastControlBtn];
    [dqbCastControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dQbCastView.mas_top).offset(0.5f);
        make.left.equalTo(dQbCastView.mas_left);
        make.right.equalTo(dQbCastView.mas_right);
        make.height.equalTo(@(44.5f));
    }];
    
    UIImageView * dqbCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    dqbCastImageView.image = [UIImage imageNamed:@"dqb_Icon"];
    [dQbCastView addSubview:dqbCastImageView];
    [dqbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];
    
    UILabel *tipdqbCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipdqbCastLabel.text = XYBString(@"str_dqb_invested", @"定期宝已投");
    tipdqbCastLabel.font = TEXT_FONT_16;
    tipdqbCastLabel.textColor = COLOR_MAIN_GREY;
    [dQbCastView addSubview:tipdqbCastLabel];
    [tipdqbCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dqbCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowdqbCastImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [dQbCastView addSubview:arrowdqbCastImageView];
    [arrowdqbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
        make.right.equalTo(dQbCastView.mas_right).offset(-Margin_Right);
    }];
    
    dqbQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    dqbQuotaLabel.font = TEXT_FONT_14;
    dqbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    dqbQuotaLabel.textAlignment = NSTextAlignmentRight;
    dqbQuotaLabel.text =   XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [dQbCastView addSubview:dqbQuotaLabel];
    [dqbQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowdqbCastImageView.mas_left).offset(-3);
        make.centerY.equalTo(dqbCastControlBtn.mas_centerY);
    }];
    
    //信投保已投
    UIView * xtbCastView = [[UIView alloc] initWithFrame:CGRectZero];
    xtbCastView.backgroundColor = COLOR_COMMON_WHITE;
    [_mainScrollView addSubview:xtbCastView];
    [xtbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(dQbCastView.mas_bottom).offset(0);
        make.height.equalTo(@45.5);
    }];
    
    
    XYButton *xtbCastBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                          titleColor:nil
                                            isUserInteractionEnabled:YES];
    [xtbCastBtn addTarget:self
                   action:@selector(clickXtbCastViewControl:)
         forControlEvents:UIControlEventTouchUpInside];
    [xtbCastView addSubview:xtbCastBtn];
    [xtbCastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xtbCastView.mas_top);
        make.width.equalTo(xtbCastView.mas_width);
        make.bottom.equalTo(xtbCastView.mas_bottom).offset(-Line_Height);
    }];
    
    UIView *xtbCastLineView = [[UIView alloc] initWithFrame:CGRectZero];
    xtbCastLineView.backgroundColor = COLOR_LINE;
    [xtbCastView addSubview:xtbCastLineView];
    
    [xtbCastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@0);
        make.bottom.equalTo(xtbCastBtn.mas_bottom).offset(-0.5);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIImageView * xtbCastImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    xtbCastImageView.image = [UIImage imageNamed:@"xtb_Icon"];
    [xtbCastView addSubview:xtbCastImageView];
    [xtbCastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];
    
    UILabel *tipXtbCastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipXtbCastLabel.text = XYBString(@"str_xtb_invested", @"信投保已投");
    tipXtbCastLabel.font = TEXT_FONT_16;
    tipXtbCastLabel.textColor = COLOR_MAIN_GREY;
    [xtbCastView addSubview:tipXtbCastLabel];
    [tipXtbCastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xtbCastImageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];
    
    UIImageView *arrowXtbCastView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [xtbCastView addSubview:arrowXtbCastView];
    [arrowXtbCastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
        make.right.equalTo(xtbCastView.mas_right).offset(-Margin_Right);
    }];
    
    xtbQuotaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    xtbQuotaLabel.font = TEXT_FONT_14;
    xtbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    xtbQuotaLabel.textAlignment = NSTextAlignmentRight;
    xtbQuotaLabel.text =  XYBString(@"str_tip_amount_asset_zero", @"0.00");
    [xtbCastView addSubview:xtbQuotaLabel];
    [xtbQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowXtbCastView.mas_left).offset(-3);
        make.centerY.equalTo(xtbCastBtn.mas_centerY);
    }];
    
    
    //回款计划
    UIView * paymentPlanView = [[UIView alloc] initWithFrame:CGRectZero];
    paymentPlanView.backgroundColor = COLOR_COMMON_WHITE;
    paymentPlanView.tag  = HKJH_TAG;
    [_mainScrollView addSubview:paymentPlanView];
    [paymentPlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(xtbCastLineView.mas_bottom);
        make.height.equalTo(@(45.f));
    }];
    
    XYButton *paymentPlanControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                                     titleColor:nil
                                                       isUserInteractionEnabled:YES];
    [paymentPlanControlBtn addTarget:self
                              action:@selector(clickStayBackControl:)
                    forControlEvents:UIControlEventTouchUpInside];
    [paymentPlanView addSubview:paymentPlanControlBtn];
    [paymentPlanControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(paymentPlanView);
    }];
    
    UIImageView * paymentPlanmageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    paymentPlanmageView.image = [UIImage imageNamed:@"paymentplan_Icon"];
    [paymentPlanView addSubview:paymentPlanmageView];
    [paymentPlanmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
    }];
    
    UILabel *tipPaymentPlanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipPaymentPlanLabel.text = XYBString(@"str_payment_plan", @"回款计划");
    tipPaymentPlanLabel.font = TEXT_FONT_16;
    tipPaymentPlanLabel.textColor = COLOR_MAIN_GREY;
    [paymentPlanView addSubview:tipPaymentPlanLabel];
    [tipPaymentPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paymentPlanmageView.mas_right).offset(Margin_Left);
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
    }];
    
    UIImageView *arrowPaymentPlanImageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [paymentPlanView addSubview:arrowPaymentPlanImageView];
    [arrowPaymentPlanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(paymentPlanControlBtn.mas_centerY);
        make.right.equalTo(paymentPlanView.mas_right).offset(-Margin_Right);
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
        make.top.equalTo(paymentPlanView.mas_bottom).offset(SPACING);
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

    //设置
    XYButton *setControlBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_my_Set", @"设置") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    setControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    setControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);;
    [setControlBtn addTarget:self
                      action:@selector(clickSetControl:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:setControlBtn];
    [setControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.bottom.equalTo(setControlBtn.mas_bottom);
        make.height.equalTo(@(Line_Height));
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

    //扫码 Scan code
    XYButton *scanCodeBtn = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_san_code", @"扫一扫") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    scanCodeBtn.tag = SCOAN_TAG;
    scanCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    scanCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [scanCodeBtn addTarget:self
                    action:@selector(clickScanCodeControl:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:scanCodeBtn];
    [scanCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(setControlBtn.mas_bottom);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(Cell_Height));
        
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

  #pragma mark -- 借款人开户
    XYButton * borrowerControlBtn =  [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_account_borrowerkh", @"借款申请") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    borrowerControlBtn.tag = JKSQ_TAG;
    borrowerControlBtn.hidden = YES;
    [borrowerControlBtn addTarget:self
                           action:@selector(clickBorrowerControl:)
                 forControlEvents:UIControlEventTouchUpInside];
    borrowerControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    borrowerControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [self.mainScrollView addSubview:borrowerControlBtn];
    [borrowerControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanCodeBtn.mas_bottom);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(0));
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

#pragma mark -- 存管账户
    XYButton * cgAmountControlBtn =  [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_cga", @"存管账户") titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    cgAmountControlBtn.tag = CGAOT_TAG;
    cgAmountControlBtn.hidden = YES;
    [cgAmountControlBtn addTarget:self
                           action:@selector(clickDepositoryBtn:)
                 forControlEvents:UIControlEventTouchUpInside];
    cgAmountControlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cgAmountControlBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 51, 0, 0);
    [self.mainScrollView addSubview:cgAmountControlBtn];
    [cgAmountControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowerControlBtn.mas_bottom);
        make.left.right.equalTo(self.mainScrollView);
        make.height.equalTo(@(0));
        make.bottom.equalTo(self.mainScrollView.mas_bottom).offset(-SPACING);
    }];

    UIImageView *cgAmountImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [cgAmountImage setImage:[UIImage imageNamed:@"my_cgamount"]];
    cgAmountImage.userInteractionEnabled = NO;
    [cgAmountControlBtn addSubview:cgAmountImage];

    [cgAmountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cgAmountControlBtn.mas_left).offset(Margin_Length);
        make.centerY.equalTo(cgAmountControlBtn.mas_centerY);
    }];

    UIImageView *arrowCgAmountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    [cgAmountControlBtn addSubview:arrowCgAmountImageView];
    [arrowCgAmountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cgAmountControlBtn.mas_centerY);
        make.right.equalTo(cgAmountControlBtn.mas_right).offset(-Margin_Right);
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
    self.amountLabel.textColor = COLOR_LIGHT_GREY;
    self.amountLabel.text = @"--";
    
    //可用余额
    self.remainLabel.textColor = COLOR_LIGHT_GREY;
    self.remainLabel.text = @"--";
    
    //礼金
    UILabel *labLJ = (UILabel *) [self.view viewWithTag:LJTAG];
    labLJ.textColor = COLOR_LIGHT_GREY;
    labLJ.text = @"--";
    
    //优惠劵
    UILabel *labSYK = (UILabel *) [self.view viewWithTag:SYKTAG];
    labSYK.textColor = COLOR_LIGHT_GREY;
    labSYK.text = @"--";;
    
    //红包
    UILabel *labHB = (UILabel *) [self.view viewWithTag:HBTAG];
    labHB.textColor = COLOR_LIGHT_GREY;
    labHB.text = @"--";;
    
    //积分
    UILabel *labJF = (UILabel *) [self.view viewWithTag:JFTAG];
    labJF.textColor = COLOR_LIGHT_GREY;
    labJF.text = @"--";
    
    //步步高
    bbgQuotaLabel.textColor = COLOR_LIGHT_GREY;
    bbgQuotaLabel.text = @"--";
    
    //定期宝
    dqbQuotaLabel.textColor = COLOR_LIGHT_GREY;
    dqbQuotaLabel.text = @"--";
    
    //信投宝
    xtbQuotaLabel.textColor = COLOR_LIGHT_GREY;
    xtbQuotaLabel.text = @"--";
    
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
    
    UIView * hkJhView = (UIView *)[self.view viewWithTag:HKJH_TAG];
    XYButton * yqhyBut = (XYButton *)[self.view viewWithTag:YQHY_TAG];
    XYButton * xybLmBut = (XYButton *)[self.view viewWithTag:JRLM_TAG];
    XYButton * scoanBut  = (XYButton *)[self.view viewWithTag:SCOAN_TAG];
    XYButton * borrowSqBtn = (XYButton *)[self.view viewWithTag:JKSQ_TAG];
    XYButton * cgAmountBtn = (XYButton *)[self.view viewWithTag:CGAOT_TAG];

    yqhyBut.hidden = NO;
    [yqhyBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hkJhView.mas_bottom).offset(SPACING);
        make.height.equalTo(@(Cell_Height));
    }];
    
    [xybLmBut setTitle:XYBString(@"str_my_xybLM", @"加入信用宝联盟") forState:UIControlStateNormal];
    [xybLmBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yqhyBut.mas_bottom);
    }];
    
    borrowSqBtn.hidden = YES;
    [borrowSqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoanBut.mas_bottom).offset(0);
        make.height.equalTo(@(0));
    }];
    
    cgAmountBtn.hidden = YES;
    [cgAmountBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borrowSqBtn.mas_bottom).offset(0);
        make.height.equalTo(@(0));
    }];
    
    [self.mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)setXYBUI {
    
    //普通用户金额
    User *userInfo = [UserDefaultsUtil getUser];
    
    if ([userInfo.totalAmount doubleValue] == 0) {
        self.amountLabel.textColor = COLOR_AUXILIARY_GREY;
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
        [self.amountLabel countFrom:0 to:toAmonut  withDuration:1.0f];
        self.amountLabel.toAmount = toAmonut;
    }
    
    //可用金额
    if ([userInfo.usableAmount doubleValue] == 0) {
        
        self.remainLabel.textColor = COLOR_AUXILIARY_GREY;
        self.remainLabel.text = @"0.00";
        
    } else {
        
        self.remainLabel.textColor = COLOR_XTB_ORANGE;
        self.remainLabel.formatBlock = ^NSString* (double value){
            NSString* formatted =  [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",value]];
            return [NSString stringWithFormat:@"%@",formatted];
        };
        
        self.remainLabel.method = UILabelCountingMethodEaseOut;
        NSDecimalNumber * minBidAmounts = [NSDecimalNumber doubleToNSDecimalNumber:[userInfo.usableAmount  doubleValue]];
        double toAmonut = [minBidAmounts doubleValue];
        [self.remainLabel countFrom:0 to:toAmonut  withDuration:1.0f];
        self.remainLabel.toAmount = toAmonut;
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
        lab1.textColor = COLOR_MAIN_GREY;
        lab1.text = [NSString stringWithFormat:@"%@元", rewardAmount]; // userInfo.rewardAmount;
    } else {
        lab1.textColor = COLOR_AUXILIARY_GREY;
        lab1.text = [NSString stringWithFormat:@"%@元",XYBString(@"str_recommend_income_zero", @"0.00")];
    }
    
    UILabel *lab2 = (UILabel *) [self.view viewWithTag:HBTAG];
    if ([userInfo.sleepRewordAmount doubleValue] > 0) {
        NSString *sleepRewordAmount = [Utility replaceTheNumberForNSNumberFormatter:userInfo.sleepRewordAmount];
        lab2.textColor = COLOR_MAIN_GREY;
        lab2.text = [NSString stringWithFormat:@"%@元",sleepRewordAmount];
    } else {
        lab2.textColor = COLOR_AUXILIARY_GREY;
        lab2.text = [NSString stringWithFormat:@"%@元",XYBString(@"str_recommend_income_zero", @"0.00")];
    }

    UILabel *lab3 = (UILabel *) [self.view viewWithTag:SYKTAG];
    if ([userInfo.increaseCardCount doubleValue] > 0) {
        lab3.textColor = COLOR_MAIN_GREY;
        lab3.text = [NSString stringWithFormat:@"%@张", userInfo.increaseCardCount];
    } else {
        lab3.textColor = COLOR_AUXILIARY_GREY;
        lab3.text = @"0张";
    }

    UILabel *lab4 = (UILabel *) [self.view viewWithTag:JFTAG];
    if ([userInfo.score doubleValue] > 0) {
        lab4.textColor = COLOR_MAIN_GREY;
        lab4.text = [NSString stringWithFormat:@"%@分",[Utility replaceTheNumberForNSNumberFormatter:userInfo.score]];
    } else {
        lab4.textColor = COLOR_AUXILIARY_GREY;
        lab4.text = @"0分";
    }
    
    //步步高已投
    bbgQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    if ([userInfo.bbgPrincipal doubleValue] == 0) {
        bbgQuotaLabel.text = @"0.00元";
    } else {
        bbgQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.bbgPrincipal doubleValue]]] stringByAppendingString:@"元"];
    }
  
    //定期宝已投
    dqbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    if ([userInfo.dqbPrincipal doubleValue] == 0) {
        dqbQuotaLabel.text = @"0.00元";
    } else {
        dqbQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.dqbPrincipal doubleValue]]] stringByAppendingString:@"元"];
    }

    //信投保已投
    xtbQuotaLabel.textColor = COLOR_AUXILIARY_GREY;
    if ([userInfo.xtbPrincipal doubleValue] == 0) {
        xtbQuotaLabel.text = @"0.00元";
    } else {
        xtbQuotaLabel.text = [[Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[userInfo.xtbPrincipal doubleValue]]] stringByAppendingString:@"元"];
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
             
            }
        }];
        
    } else {
        
        [UMengAnalyticsUtil event:EVENT_MY_USER_MESSAGE];
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfo animated:YES];
    }
  
}

//存管账户
-(void)clickDepositoryBtn:(id)sender
{
    User *userInfo = [UserDefaultsUtil getUser];
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            
        }];
        
    } else {
        
        if ([StrUtil isEmptyString:userInfo.depAcctId]) {
            [self loadIskh];
            return ;
        }
        
        CGAccountViewController * cgacount = [[CGAccountViewController alloc] init];
        [self.navigationController pushViewController:cgacount animated:YES];
    }
    
}

-(void)loadIskh
{
    CGAccountOpenDialogView * cgAccountOpeView = [[CGAccountOpenDialogView alloc] initWithFrame:CGRectZero isLC:YES];
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.window addSubview:cgAccountOpeView];
    
    [cgAccountOpeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
    
    cgAccountOpeView.clickGokhBut =^(void) {
        CGAccountOpenViewController *openAccountVC = [[CGAccountOpenViewController alloc] initWithType:1];
        [self.navigationController pushViewController:openAccountVC animated:YES];
    };
    
}

//收支明细
-(void)clickRightBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                TradeDetailViewController * tradeDetailViewController = [[TradeDetailViewController alloc] init];
                [self.navigationController pushViewController:tradeDetailViewController animated:YES];
            }
        }];
        
    } else {
        TradeDetailViewController * tradeDetailViewController = [[TradeDetailViewController alloc] init];
        [self.navigationController pushViewController:tradeDetailViewController animated:YES];
    }
  
}

/**
 *
 * 普通账户
 */
-(void)clickOrdinaryBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    AccountViewController * account = [[AccountViewController alloc] init];
                    [self.navigationController pushViewController:account animated:YES];
                }
            }
        }];
        
    } else {
        AccountViewController * account = [[AccountViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    }
}

//总资产
-(void)allAssetsBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
  
        }];
        
    } else {
        
        [UMengAnalyticsUtil event:EVENT_MY_assets];
        AllAssetsViewController *allAssetsVC = [[AllAssetsViewController alloc] init];
        allAssetsVC.accountInfo = [UserDefaultsUtil getUser];
        allAssetsVC.accountDic = _accountDic;
        [self.navigationController pushViewController:allAssetsVC animated:YES];
        
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self clickChargeBtn:nil];
    }
}

//提现
-(void)clickWithDrawBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                [self loadTropismVC];
            }
        }];
        
    } else {
        
        [self loadTropismVC];
    }
  
}

-(void)loadTropismVC
{
    [UMengAnalyticsUtil event:EVENT_MY_GETCASH];
    
    if ([[UserDefaultsUtil getUser].isIdentityAuth boolValue]) {
        TropismViewController *tropismViewController =
        [[TropismViewController alloc] init];
        tropismViewController.tropismNumString =
        [UserDefaultsUtil getUser].usableAmount;
        [self.navigationController pushViewController:tropismViewController
                                             animated:YES];
    } else {
        NSString *contentStr;
        if ([[UserDefaultsUtil getUser].usableAmount doubleValue] > 0) {
            contentStr = [NSString
                          stringWithFormat:@"您还未进行实名认证,请先充值认证"];
        } else {
            contentStr = [NSString stringWithFormat:@"您的可提现金额为0元"];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:contentStr
                                  delegate:self
                                  cancelButtonTitle:XYBString(@"str_cancel", @"取消")
                                  otherButtonTitles:XYBString(@"str_go_charge", @"去充值"), nil];
        [alertView show];
    }
}

//充值
-(void)clickChargeBtn:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                [UMengAnalyticsUtil event:EVENT_MY_RECHARGE];
                ChargeViewController *chargeView = [[ChargeViewController alloc] initWithIdetifer:NO];
                [self.navigationController pushViewController:chargeView animated:YES];
            }
        }];
        
    } else {
        
        [UMengAnalyticsUtil event:EVENT_MY_RECHARGE];
        ChargeViewController *chargeView = [[ChargeViewController alloc] initWithIdetifer:NO];
        [self.navigationController pushViewController:chargeView animated:YES];
    }
   
}

//步步高
-(void)clickBBgCastControl:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                BbgInvestListViewController * bbgInvestList = [[BbgInvestListViewController alloc] init];
                [self.navigationController pushViewController:bbgInvestList animated:YES];
            }
        }];
        
    } else {
        
        BbgInvestListViewController * bbgInvestList = [[BbgInvestListViewController alloc] init];
        [self.navigationController pushViewController:bbgInvestList animated:YES];
    }
  
}

//定期保
-(void)clickDqbCastControl:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                DqbInvestListViewController * dqbInvestList = [[DqbInvestListViewController alloc] init];
                [self.navigationController pushViewController:dqbInvestList animated:YES];
            }
        }];
        
    } else {
        
        DqbInvestListViewController * dqbInvestList = [[DqbInvestListViewController alloc] init];
        [self.navigationController pushViewController:dqbInvestList animated:YES];
    }
  
}

//信投保
-(void)clickXtbCastViewControl:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                XtbInvestListViewController * xtbInvestList = [[XtbInvestListViewController alloc] init];
                [self.navigationController pushViewController:xtbInvestList animated:YES];
            }
        }];
        
    } else {
        
        XtbInvestListViewController * xtbInvestList = [[XtbInvestListViewController alloc] init];
        [self.navigationController pushViewController:xtbInvestList animated:YES];
    }

}

//回款计划
-(void)clickStayBackControl:(id)sender
{
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                
                [UMengAnalyticsUtil event:EVENT_MY_COLLECTION_PLAN];
                BackPlanViewController *backPlan = [[BackPlanViewController alloc] init];
                backPlan.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:backPlan animated:YES];
            }
        }];
        
    } else {
        
        [UMengAnalyticsUtil event:EVENT_MY_COLLECTION_PLAN];
        BackPlanViewController *backPlan = [[BackPlanViewController alloc] init];
        backPlan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:backPlan animated:YES];
        
    }
}

-(void)clickBorrowerControl:(id)sender {
    
    int i = random() % 100;
    NSString *requestURL =  [NSString stringWithFormat:@"%@&ts=%d",[RequestURL getNodeJsH5URL:APP_LOAN_URL withIsSign:YES],i];
    
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                
                    User *user = [UserDefaultsUtil getUser];
                    if ([user.openDep boolValue] && ![StrUtil isEmptyString:user.depBorrowAcctId]) {
                        XYWebViewController *attendenceVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_account_borrowerkh", @"借款申请") webUrlString:requestURL];
                        attendenceVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:attendenceVC animated:YES];
                    }
                }
            }
        }];
        
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_LJ];
                    //是否进入下一步
                    MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
                    myDiscount.hidesBottomBarWhenPushed = YES;
                    myDiscount.type = ClickTheLJ;
                    [self.navigationController pushViewController:myDiscount
                                                         animated:YES];
                }
            }
        }];

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_LJ];
        MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
        myDiscount.hidesBottomBarWhenPushed = YES;
        myDiscount.type = ClickTheLJ;
        [self.navigationController pushViewController:myDiscount
                                             animated:YES];
    }
}

/**
 *  红包
 *
 *  @param
 */
- (void)clickHBControl:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_HB];
                    //是否进入下一步
                    MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
                    myDiscount.hidesBottomBarWhenPushed = YES;
                    myDiscount.type = ClickTheHB;
                    [self.navigationController pushViewController:myDiscount
                                                         animated:YES];
                }
            }
        }];

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_HB];
        MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
        myDiscount.hidesBottomBarWhenPushed = YES;
        myDiscount.type = ClickTheHB;
        [self.navigationController pushViewController:myDiscount
                                             animated:YES];
    }
}

/**
 *  收益提升卡
 *
 *  @param sender
 */
- (void)clickSYKControl:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    
                    //是否进入下一步
                    [UMengAnalyticsUtil event:EVENT_MY_YHJ];
                    MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
                    myDiscount.hidesBottomBarWhenPushed = YES;
                    myDiscount.type = ClickTheYHJ;
                    [self.navigationController pushViewController:myDiscount
                                                         animated:YES];
                }
            }
        }];

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_YHJ];
        MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
        myDiscount.hidesBottomBarWhenPushed = YES;
        myDiscount.type = ClickTheYHJ;
        [self.navigationController pushViewController:myDiscount
                                             animated:YES];
    }
}

/**
 *  我的积分
 *
 *  @param sender
 */
- (void)clickJFControl:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_JF];
                    //是否进入下一步
                    MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
                    myDiscount.hidesBottomBarWhenPushed = YES;
                    myDiscount.type = ClickTheJF;
                    [self.navigationController pushViewController:myDiscount
                                                         animated:YES];
                }
            }
        }];

    } else {
        [UMengAnalyticsUtil event:EVENT_MY_JF];
        MyDiscountViewController *  myDiscount = [[MyDiscountViewController alloc] init];
        myDiscount.hidesBottomBarWhenPushed = YES;
        myDiscount.type = ClickTheJF;
        [self.navigationController pushViewController:myDiscount
                                             animated:YES];
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {

            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [self loadViewController];
                }
            }
        }];
    } else {
        [self loadViewController];
    }
}

- (void)loadViewController {
    if ([UserDefaultsUtil getUser].bonusState) {
        if ([[UserDefaultsUtil getUser].bonusState intValue] != 2) {
            [UMengAnalyticsUtil event:EVENT_MY_YQHY];
            EarnBonusCodeViewController *earnBonusCode = [[EarnBonusCodeViewController alloc] init];
            earnBonusCode.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:earnBonusCode animated:YES];
        } else {
            [UMengAnalyticsUtil event:EVENT_MY_XYB_UNION];
            AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
            allianceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:allianceVC animated:YES];
        }
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {

            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    if ([xybLmBut.titleLabel.text isEqualToString:XYBString(@"str_my_xybLM", @"加入信用宝联盟")]) {
                        self.isBonusState = YES;
                    }
                    [self loadJrViewController];
                }
            }
        }];
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
                AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
                [self.navigationController pushViewController:allianceVC animated:YES];
                self.isBonusState = NO;
                return;
            }
        }
    }
    if ([UserDefaultsUtil getUser].bonusState) {
        if ([[UserDefaultsUtil getUser].bonusState intValue] != 2) {
            [UMengAnalyticsUtil event:EVENT_MY_JRXYB_UNION];
            AllianceApplyViewController *allianceApply = [[AllianceApplyViewController alloc] init];
            [self.navigationController pushViewController:allianceApply animated:YES];
        } else {
            [UMengAnalyticsUtil event:EVENT_MY_XYB_UNION];
            AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
            [self.navigationController pushViewController:allianceVC animated:YES];
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    //是否进入下一步
                    [self LoadQrCode];
                }
            }
        }];
        
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
                SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                scanningQRCodeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
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
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        
    } else {
        [UMengAnalyticsUtil event:EVENT_MY_SET];
        SetViewController  *set = [[SetViewController alloc] init];
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];
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
            _accountDic = [[NSMutableDictionary alloc] initWithDictionary:account.accountInfo.toDictionary];
            if (account.resultCode == 1) {
                
                //保存user
                User *user = [HandleUserInfo hanedleTheUserInfo:account.toDictionary];
                [UserDefaultsUtil setUser:user];
                
                //是否开通存管账户  1 已开通 0 未开通
                XYButton * scoanBut  = (XYButton *)[self.view viewWithTag:SCOAN_TAG];
                XYButton * borrowSqBtn = (XYButton *)[self.view viewWithTag:JKSQ_TAG];
                XYButton * cgAmountBtn = (XYButton *)[self.view viewWithTag:CGAOT_TAG];
                
                //开通存管账户 切 借款存管账户ID不能为空显示借款申请
                if(![StrUtil isEmptyString:user.depBorrowAcctId]) {
                    
                    borrowSqBtn.hidden = NO;
                    [borrowSqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(scoanBut.mas_bottom).offset(SPACING);
                        make.height.equalTo(@(Cell_Height));
                    }];
                    
                }
                
                if ([user.openDep boolValue]) {
                    
                    cgAmountBtn.hidden = NO;
                    [cgAmountBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(borrowSqBtn.mas_bottom).offset(SPACING);
                        make.height.equalTo(@(Cell_Height));
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
