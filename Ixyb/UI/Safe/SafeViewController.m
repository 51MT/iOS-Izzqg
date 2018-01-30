//
//  SafeViewController.m
//  Ixyb
//
//  Created by dengjian on 2/18/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "SafeRealTimeDataViewController.h"
#import "SafeUserVoiceViewController.h"
#import "SafeViewController.h"
#import "MJRefreshCustomGifHeader.h"
#import "SafeResponseModel.h"
#import "SafeWebViewController.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "VideoSafeViewController.h"
#import "WebService.h"
#import "XYUIKit.h" //XYB公共控件

@import SafariServices;
@interface SafeViewController ()<SFSafariViewControllerDelegate>

@property (nonatomic, strong) XYScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong) UILabel *riskMoneLab;

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    self.navigationController.navigationBarHidden = NO;
    [UMengAnalyticsUtil event:EVENT_SAFE_IN];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil event:EVENT_MY_OUT];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)initUI {
    self.navItem.title = XYBString(@"str_safe", @"安全");
    self.view.backgroundColor = COLOR_BG;

    self.mainScrollView = [[XYScrollView alloc] init];
    self.mainScrollView.backgroundColor = COLOR_COMMON_CLEAR;
    [self.view addSubview:self.mainScrollView];

    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    self.headImageView = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"safe_header"];
    self.headImageView.image = img;
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.masksToBounds  = YES;
    self.headImageView.layer.cornerRadius = 3.f;
    [self.headImageView setContentMode:UIViewContentModeScaleToFill];
    [self.headImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.headImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.mainScrollView addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.width.equalTo(@(MainScreenWidth-20));
        make.height.equalTo(self.headImageView.mas_width).multipliedBy(img.size.height / img.size.width);
    }];
    
    UIButton *playerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playerBtn setImage:[UIImage imageNamed:@"player_load"] forState:UIControlStateNormal];
    [playerBtn setImage:[UIImage imageNamed:@"player_select"] forState:UIControlStateHighlighted];
    [playerBtn addTarget:self action:@selector(clickPlayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.headImageView addSubview:playerBtn];
    [playerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView.mas_centerX);
        if (IS_IPHONE_6P) {
            make.top.equalTo(self.headImageView.mas_top).offset((250 - 70) / 2 / 2);
        } else if (IS_IPHONE_6) {
            make.top.equalTo(self.headImageView.mas_top).offset((226.5 - 63.5) / 2 / 2);
        } else {
            make.top.equalTo(self.headImageView.mas_top).offset(30);
        }
    }];
    
    //宽度
    float Width = (MainScreenWidth - 21) / 3;
    UIView *viewTop =  [[UIView alloc] initWithFrame:CGRectMake(10, 0, MainScreenWidth - 20, 90.f)];;
    viewTop.backgroundColor = COLOR_COMMON_WHITE;
    viewTop.layer.masksToBounds  = YES;
    viewTop.layer.cornerRadius = 3.f;
    [self.mainScrollView addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(10));
        make.width.equalTo(@(MainScreenWidth - 20.f));
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.height.equalTo(@(90.f));
        
    }];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:viewTop.bounds];
    viewTop.layer.masksToBounds = NO;
    viewTop.layer.shadowColor = [UIColor blackColor].CGColor;
    viewTop.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    viewTop.layer.shadowOpacity = 0.05f;
    viewTop.layer.shadowPath = shadowPath.CGPath;
    
#pragma mark-- 运营月报
    XYButton *butMonthReport = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    butMonthReport.backgroundColor = COLOR_COMMON_WHITE;
    [butMonthReport addTarget:self action:@selector(clickMonthReport:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:butMonthReport];

    [butMonthReport mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTop.mas_left);
        make.top.equalTo(viewTop.mas_top).offset(Line_Height);
        make.bottom.equalTo(viewTop.mas_bottom).offset(-Line_Height);
        make.width.equalTo(@(Width));
    }];

    UIImageView *imageViewMonthReport = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safe_monthlyOperation"]];
    imageViewMonthReport.layer.masksToBounds = YES;
    [viewTop addSubview:imageViewMonthReport];
    [imageViewMonthReport mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butMonthReport.mas_centerX);
        make.top.equalTo(butMonthReport.mas_top).offset(20);
    }];

    UILabel *monthReportLab = [[UILabel alloc] init];
    monthReportLab.font = TEXT_FONT_12;
    monthReportLab.text = XYBString(@"str_security_monthly_report", @"运营月报");
    monthReportLab.textColor = COLOR_MAIN_GREY;
    monthReportLab.userInteractionEnabled = YES;
    [viewTop addSubview:monthReportLab];
    [monthReportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butMonthReport.mas_centerX);
        make.top.equalTo(imageViewMonthReport.mas_bottom).offset(8);
    }];

    UIView *splitYouhuiShuLine1View = [[UIView alloc] initWithFrame:CGRectZero];
    [viewTop addSubview:splitYouhuiShuLine1View];
    splitYouhuiShuLine1View.backgroundColor = COLOR_LINE;
    [splitYouhuiShuLine1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(29));
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(viewTop.mas_centerY);
        make.left.equalTo(butMonthReport.mas_right);
    }];
#pragma mark-- 逾期信息
    XYButton *butBeoverdue = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    butBeoverdue.backgroundColor = COLOR_COMMON_WHITE;
    [butBeoverdue addTarget:self action:@selector(clickBeoverdue:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:butBeoverdue];

    [butBeoverdue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(splitYouhuiShuLine1View.mas_right);
        make.top.equalTo(viewTop.mas_top).offset(Line_Height);
        make.bottom.equalTo(viewTop.mas_bottom).offset(-Line_Height);
        make.width.equalTo(@(Width));
    }];

    UIImageView *imageBeoverdue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safe_overdueInformation"]];
    imageBeoverdue.layer.masksToBounds = YES;
    [viewTop addSubview:imageBeoverdue];
    [imageBeoverdue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butBeoverdue.mas_centerX);
        make.top.equalTo(butBeoverdue.mas_top).offset(20);
    }];

    UILabel *BeoverdueLab = [[UILabel alloc] init];
    BeoverdueLab.font = TEXT_FONT_12;
    BeoverdueLab.text = XYBString(@"str_security_overdue", @"逾期信息");
    BeoverdueLab.textColor = COLOR_MAIN_GREY;
    BeoverdueLab.userInteractionEnabled = YES;
    [viewTop addSubview:BeoverdueLab];
    [BeoverdueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butBeoverdue.mas_centerX);
        make.top.equalTo(imageBeoverdue.mas_bottom).offset(8);
    }];

    UIView *splitYouhuiShuLine2View = [[UIView alloc] initWithFrame:CGRectZero];
    [viewTop addSubview:splitYouhuiShuLine2View];
    splitYouhuiShuLine2View.backgroundColor = COLOR_LINE;
    [splitYouhuiShuLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(29));
        make.width.equalTo(@(Line_Height));
        make.centerY.equalTo(viewTop.mas_centerY);
        make.left.equalTo(butBeoverdue.mas_right);
    }];

#pragma mark-- 用户心声
    XYButton *butUsersVoice = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    butUsersVoice.backgroundColor = COLOR_COMMON_WHITE;
    [butUsersVoice addTarget:self action:@selector(clickUsersVoice:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:butUsersVoice];

    [butUsersVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(splitYouhuiShuLine2View.mas_right);
        make.top.equalTo(viewTop.mas_top).offset(Line_Height);
        make.bottom.equalTo(viewTop.mas_bottom).offset(-Line_Height);
        make.width.equalTo(@(Width));
    }];

    UIImageView *imageUsersVoice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"safe_userCenter"]];
    imageUsersVoice.layer.masksToBounds = YES;
    [viewTop addSubview:imageUsersVoice];
    [imageUsersVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butUsersVoice.mas_centerX);
        make.top.equalTo(butUsersVoice.mas_top).offset(20);
    }];

    UILabel *usersVoiceLab = [[UILabel alloc] init];
    usersVoiceLab.font = TEXT_FONT_12;
    usersVoiceLab.text = XYBString(@"str_security_user_voice", @"用户心声");
    usersVoiceLab.textColor = COLOR_MAIN_GREY;
    usersVoiceLab.userInteractionEnabled = YES;
    [viewTop addSubview:usersVoiceLab];
    [usersVoiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(butUsersVoice.mas_centerX);
        make.top.equalTo(imageUsersVoice.mas_bottom).offset(8);
    }];
    
#pragma mark--公司概况、组织架构、高管团队、团队介绍、运营数据、收费标准、风控体系、重大事项 的底图
    
    UIView *middleBackView = [[UIView alloc] init];
    middleBackView.backgroundColor = COLOR_COMMON_WHITE;
    middleBackView.layer.cornerRadius = 3.f;
    [self.mainScrollView addSubview:middleBackView];

    float middleHeight = 240.f;
    
    [middleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(viewTop.mas_bottom).offset(10);
        make.width.equalTo(@(MainScreenWidth - 20.f));
        make.height.equalTo(@(middleHeight));
        make.bottom.equalTo(self.mainScrollView.mas_bottom).offset(-Margin_Length);
    }];

    float btnHeight = (middleHeight - 2 * 0.4) / 3;

    //中间横线 1
    UIView *horizonLine = [[UIView alloc] init];
    horizonLine.backgroundColor = COLOR_LINE;
    [middleBackView addSubview:horizonLine];

    [horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(middleBackView);
        make.height.equalTo(@(0.4));
        make.top.equalTo(middleBackView.mas_top).offset(btnHeight);
    }];

    //中间横线 2
    UIView *horizonLine2 = [[UIView alloc] init];
    horizonLine2.backgroundColor = COLOR_LINE;
    [middleBackView addSubview:horizonLine2];

    [horizonLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(middleBackView);
        make.height.equalTo(@(0.4));
        make.top.equalTo(horizonLine.mas_bottom).offset(btnHeight);
    }];

    //竖线1
    UIView *VerticalLine = [[UIView alloc] init];
    VerticalLine.backgroundColor = COLOR_LINE;
    [middleBackView addSubview:VerticalLine];

    [VerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(middleBackView);
        make.left.equalTo(middleBackView.mas_left).offset(((MainScreenWidth - 2 * 0.4) - 20) / 3);
        make.width.equalTo(@(0.4));
    }];
    
    //竖线2
    UIView *VerticalLine2 = [[UIView alloc] init];
    VerticalLine2.backgroundColor = COLOR_LINE;
    [middleBackView addSubview:VerticalLine2];

    [VerticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(middleBackView);
        make.left.equalTo(VerticalLine.mas_right).offset(((MainScreenWidth - 2 * 0.4) - 20) / 3);
        make.width.equalTo(VerticalLine.mas_width);
    }];
    
    float width = ((MainScreenWidth - 2 * 0.4) - 20) / 3;
    
    #pragma mark - 公司概况

    XYButton *gsgkBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    gsgkBtn.backgroundColor = COLOR_COMMON_WHITE;
    [gsgkBtn addTarget:self action:@selector(clickGsgkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:gsgkBtn];

    [gsgkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleBackView.mas_left).offset(0);
        make.top.equalTo(middleBackView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
    }];

    UIImageView *personalCreditImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"document"]];
    [gsgkBtn addSubview:personalCreditImg]; //个人信用button上的图片

    [personalCreditImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(gsgkBtn.mas_centerX);
        make.top.equalTo(gsgkBtn.mas_top).offset(14);
    }];

    UILabel *personalCreditLab = [[UILabel alloc] init];
    personalCreditLab.font = TEXT_FONT_12;
    personalCreditLab.textColor = COLOR_MAIN_GREY;
    personalCreditLab.text =  XYBString(@"str_security_gsgk", @"公司概况");
    [gsgkBtn addSubview:personalCreditLab];

    [personalCreditLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personalCreditImg.mas_bottom).offset(6);
        make.centerX.equalTo(gsgkBtn.mas_centerX);
    }];

#pragma mark - 组织架构

    XYButton *zzjgBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    zzjgBtn.backgroundColor = COLOR_COMMON_WHITE;
    [zzjgBtn addTarget:self action:@selector(clickzjgBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:zzjgBtn];

    [zzjgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gsgkBtn.mas_right).offset(0.4);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
        make.centerY.equalTo(gsgkBtn.mas_centerY);
    }];

    UIImageView *creditScoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parallel_tasks"]];
    [zzjgBtn addSubview:creditScoreImage];
    ;

    [creditScoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zzjgBtn.mas_centerX);
        make.top.equalTo(zzjgBtn.mas_top).offset(14);
    }];

    UILabel *creditScoreLab = [[UILabel alloc] init];
    creditScoreLab.font = TEXT_FONT_12;
    creditScoreLab.textColor = COLOR_MAIN_GREY;
    creditScoreLab.text = XYBString(@"str_security_zzjg", @"组织架构");
    [zzjgBtn addSubview:creditScoreLab];

    [creditScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(creditScoreImage.mas_bottom).offset(6);
        make.centerX.equalTo(zzjgBtn.mas_centerX);
    }];

#pragma mark - 高管团队

    XYButton *ggtdBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    ggtdBtn.backgroundColor = COLOR_COMMON_WHITE;
    [ggtdBtn addTarget:self action:@selector(clickGgtdBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:ggtdBtn];

    [ggtdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zzjgBtn.mas_right).offset(Line_Height);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
        make.centerY.equalTo(zzjgBtn.mas_centerY);
    }];

    UIImageView *smallAmountImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"training"]];
    [ggtdBtn addSubview:smallAmountImage];
    [smallAmountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ggtdBtn.mas_centerX);
        make.top.equalTo(ggtdBtn.mas_top).offset(14);
    }];

    UILabel *smallAmountLab = [[UILabel alloc] init];
    smallAmountLab.font = TEXT_FONT_12;
    smallAmountLab.textColor = COLOR_MAIN_GREY;
    smallAmountLab.text = XYBString(@"str_security_management", @"高管团队");
    [ggtdBtn addSubview:smallAmountLab];

    [smallAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallAmountImage.mas_bottom).offset(6);
        make.centerX.equalTo(ggtdBtn.mas_centerX);
    }];

#pragma mark - 团队介绍
    XYButton *tdjsBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    tdjsBtn.backgroundColor = COLOR_COMMON_WHITE;
    [tdjsBtn addTarget:self action:@selector(clickdjsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:tdjsBtn];

    [tdjsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleBackView.mas_left).offset(0);
        make.top.equalTo(gsgkBtn.mas_bottom).offset(Line_Height);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
    }];

    UIImageView *addMoneyImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting"]];
    [tdjsBtn addSubview:addMoneyImg]; //风投注资button上的图片

    [addMoneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tdjsBtn.mas_centerX);
        make.top.equalTo(tdjsBtn.mas_top).offset(14);
    }];

    UILabel *addMoneyLab = [[UILabel alloc] init];
    addMoneyLab.font = TEXT_FONT_12;
    addMoneyLab.textColor = COLOR_MAIN_GREY;
    addMoneyLab.text = XYBString(@"str_security_tdjs", @"团队介绍");
    [tdjsBtn addSubview:addMoneyLab];

    [addMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addMoneyImg.mas_bottom).offset(6);
        make.centerX.equalTo(tdjsBtn.mas_centerX);
    }];

#pragma mark - 运营数据

    XYButton *yyshBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    yyshBtn.backgroundColor = COLOR_COMMON_WHITE;
    [yyshBtn addTarget:self action:@selector(clickYyshBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:yyshBtn];

    [yyshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tdjsBtn.mas_right).offset(0.4);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
        make.centerY.equalTo(tdjsBtn.mas_centerY);

    }];

    UIImageView *moneyManageImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullish"]];
    [yyshBtn addSubview:moneyManageImg]; //资金存管button上的图片

    [moneyManageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(yyshBtn.mas_centerX);
        make.top.equalTo(yyshBtn.mas_top).offset(14);
    }];

    UILabel *moneyManageLab = [[UILabel alloc] init];
    moneyManageLab.font = TEXT_FONT_12;
    moneyManageLab.textColor = COLOR_MAIN_GREY;
    moneyManageLab.text = XYBString(@"str_security_yysh", @"运营数据");
    [yyshBtn addSubview:moneyManageLab];

    [moneyManageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyManageImg.mas_bottom).offset(6);
        make.centerX.equalTo(yyshBtn.mas_centerX);
    }];

#pragma mark - 收费标准
//
//    XYButton *sfbzBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
//    sfbzBtn.backgroundColor = COLOR_COMMON_WHITE;
//    [sfbzBtn addTarget:self action:@selector(clickSfbzBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [middleBackView addSubview:sfbzBtn];
//
//    [sfbzBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(yyshBtn.mas_right).offset(Line_Height);
//        make.width.equalTo(@(width));
//        make.height.equalTo(@(btnHeight));
//        make.centerY.equalTo(yyshBtn.mas_centerY);
//    }];
//
//    UIImageView *leadingTeamImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banknotes"]];
//    [sfbzBtn addSubview:leadingTeamImage];
//
//
//    [leadingTeamImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(sfbzBtn.mas_centerX);
//        make.top.equalTo(sfbzBtn.mas_top).offset(14);
//    }];
//
//    UILabel *leadingTeamLab = [[UILabel alloc] init];
//    leadingTeamLab.font = TEXT_FONT_12;
//    leadingTeamLab.textColor = COLOR_MAIN_GREY;
//    leadingTeamLab.text = XYBString(@"str_security_sfbz", @"收费标准");
//    [sfbzBtn addSubview:leadingTeamLab];
//
//    [leadingTeamLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(leadingTeamImage.mas_bottom).offset(6);
//        make.centerX.equalTo(sfbzBtn.mas_centerX);
//    }];

#pragma mark - 风控体系

    XYButton *fktxBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    fktxBtn.backgroundColor = COLOR_COMMON_WHITE;
    [fktxBtn addTarget:self action:@selector(clickFktxBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:fktxBtn];
   
    [fktxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yyshBtn.mas_right).offset(Line_Height);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
        make.centerY.equalTo(yyshBtn.mas_centerY);
    }];

    UIImageView *accountSecurityImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crowdfunding"]];
    [fktxBtn addSubview:accountSecurityImage];

    [accountSecurityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fktxBtn.mas_centerX);
        make.top.equalTo(fktxBtn.mas_top).offset(14);
    }];

    UILabel *accountSecurityLab = [[UILabel alloc] init];
    accountSecurityLab.font = TEXT_FONT_12;
    accountSecurityLab.textColor = COLOR_MAIN_GREY;
    accountSecurityLab.text = XYBString(@"str_security_fktx", @"风控体系");
    [fktxBtn addSubview:accountSecurityLab];

    [accountSecurityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountSecurityImage.mas_bottom).offset(6);
        make.centerX.equalTo(fktxBtn.mas_centerX);
    }];

#pragma mark - 重大事项
    XYButton *zdsxBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    zdsxBtn.backgroundColor = COLOR_COMMON_WHITE;
    [zdsxBtn addTarget:self action:@selector(clickZdsxBtn:) forControlEvents:UIControlEventTouchUpInside];
    [middleBackView addSubview:zdsxBtn];

    [zdsxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleBackView.mas_left).offset(0);
        make.top.equalTo(tdjsBtn.mas_bottom).offset(Line_Height);
        make.width.equalTo(@(width));
        make.height.equalTo(@(btnHeight));
    }];

    UIImageView *cfcaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volume_up"]];
    [zdsxBtn addSubview:cfcaImage];

    [cfcaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zdsxBtn.mas_centerX);
        make.top.equalTo(zdsxBtn.mas_top).offset(14);
    }];

    UILabel *cfcaLab = [[UILabel alloc] init];
    cfcaLab.font = TEXT_FONT_12;
    cfcaLab.textColor = COLOR_MAIN_GREY;
    cfcaLab.text = XYBString(@"str_security_zdsx", @"重大事项");
    [zdsxBtn addSubview:cfcaLab];

    [cfcaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cfcaImage.mas_bottom).offset(6);
        make.centerX.equalTo(zdsxBtn.mas_centerX);
    }];
    
//#pragma mark - 公司证书
//    XYButton *patentBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
//    patentBtn.backgroundColor = COLOR_COMMON_WHITE;
//    [patentBtn addTarget:self action:@selector(clickPatentBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [middleBackView addSubview:patentBtn];
//
//    [patentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(cfcaBtn.mas_right).offset(0.5);
//        make.top.equalTo(addMoneyBtn.mas_bottom).offset(Line_Height);
//        make.width.equalTo(@(width));
//        make.height.equalTo(@(82));
//    }];
//
//    UIImageView *patenImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patent"]];
//    [patentBtn addSubview:patenImage];
//
//    [patenImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(patentBtn.mas_centerX);
//        make.top.equalTo(patentBtn.mas_top).offset(20);
//    }];
//
//    UILabel *patenLab = [[UILabel alloc] init];
//    patenLab.font = TEXT_FONT_12;
//    patenLab.textColor = COLOR_MAIN_GREY;
//    patenLab.text = XYBString(@"str_security_patent_introduction", @"公司证书");
//    [patentBtn addSubview:patenLab];
//
//    [patenLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(patenImage.mas_bottom).offset(6);
//        make.centerX.equalTo(patentBtn.mas_centerX);
//    }];
    
}

/*!
 *  @author JiangJJ, 16-12-16 10:12:43
 *
 *
 *  @return 实时数据
 */
- (void)clickRealTimerDate:(id)sender {
    SafeRealTimeDataViewController *safeRealTime = [[SafeRealTimeDataViewController alloc] init];
    //safeRealTime.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeRealTime animated:YES];
}

/*!
 *  @author JiangJJ, 16-12-16 11:12:20
 *
 *
 *  @return 用户心声
 */
- (void)clickUsersVoice:(id)sender {
    [UMengAnalyticsUtil event:EVENT_SAFE_USER_VOICE];
    SafeUserVoiceViewController *safeUserVoice = [[SafeUserVoiceViewController alloc] init];
    //safeUserVoice.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeUserVoice animated:YES];
}

/**
 *  网贷逾期信息公示
 *
 *  @return
 */
- (void)clickBeoverdue:(XYButton *)button {
    [UMengAnalyticsUtil event:EVENT_SAFE_BEOVERDUE_MESSAGE];
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Campaign_News_Type2_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:XYBString(@"str_H5_beoverdue_publicity", @"网贷逾期信息公示") webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

/**
 *  涂志云讲风控
 */
- (void)clickPlayer:(UIButton *)button {
    [UMengAnalyticsUtil event:EVENT_SAFE_TUZHIYUN];
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Ceo_Video_URL withIsSign:NO];
    if (!IS_iOS9) {
        VideoSafeViewController *safeWebViewController = [[VideoSafeViewController alloc] initWithTitle:@"" webUrlString:urlStr];
        safeWebViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:safeWebViewController animated:YES];
    }else
    {
    SFSafariViewController *sfViewControllr = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
    sfViewControllr.delegate = self;
    [self presentViewController:sfViewControllr animated:YES completion:^{
        
    }];
    }
}

/**
 *  重大事项
 *
 *  @param button
 */
- (void)clickZdsxBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_ImportantThing_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"重大事项" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

/**
 *   风控体系
 *
 *  @param button
 */
- (void)clickFktxBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Risk_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"风控体系" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickMonthReport:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Monthly_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:XYBString(@"str_H5_monthly_report", @"平台运营月度报告") webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}


/**
 *  公司证书
 *
 *  @param button
 */
- (void)clickPatentBtn:(XYButton *)button {
//    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Patent_URL withIsSign:NO];
//    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"公司证书" webUrlString:urlStr];
//    safeWebViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

/**
 *  公司概况
 *
 *  @param button
 */
- (void)clickGsgkBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Company_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"公司概况" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickzjgBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Organization_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"组织架构" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickGgtdBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Specialist_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"高管团队" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickdjsBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Team_Intro_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"团队介绍" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickYyshBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Operate_Data_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"运营数据" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

- (void)clickSfbzBtn:(XYButton *)button {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Borrow_Product_URL withIsSign:NO];
    SafeWebViewController *safeWebViewController = [[SafeWebViewController alloc] initWithTitle:@"收费标准" webUrlString:urlStr];
    safeWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:safeWebViewController animated:YES];
}

@end
