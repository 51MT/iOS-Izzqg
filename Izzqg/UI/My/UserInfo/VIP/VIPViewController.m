//
//  VIPViewController.m
//  Ixyb
//
//  Created by dengjian on 16/8/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DMVip.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "VIPInterestsViewController.h"
#import "VIPViewController.h"
#import "VipPrivilegeNoteWebViewController.h"
#import "VipPurchaseViewController.h"
#import "WebService.h"

#define REMAINDIMAGETAG 100
#define REMAINDLAB2TAG 101

/**
 *  @author xyb, 16-11-16 16:11:02
 *
 *  @brief vip特权
 */
@interface VIPViewController () {
    UIView *backView;    //会员有效期的背景
    UILabel *vipTimeLab; //显示会员有效期
}

@property (nonatomic, strong) XYScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UIImageView *headerImgView; //头像
@property (nonatomic, strong) UILabel *accountLab;        //账户
@property (nonatomic, strong) UILabel *growLab;           //成长值

@property (nonatomic, strong) UIImageView *firstBottomImg; //第一个等级图的底图
@property (nonatomic, strong) UIImageView *firstStateImg;  //第一个等级图
@property (nonatomic, strong) UILabel *firstScoreLab;      //第一个等级图的的积分label

@property (nonatomic, strong) UIImageView *secondBottomImg; //第二个等级图的底图
@property (nonatomic, strong) UIImageView *secondStateImg;  //第二个等级图
@property (nonatomic, strong) UILabel *secondScoreLab;      //第二个等级图的的积分label

@property (nonatomic, strong) UIImageView *thirdBottomImg; //第三个等级图的底图
@property (nonatomic, strong) UIImageView *thirdStateImg;  //第三个等级图
@property (nonatomic, strong) UILabel *thirdScoreLab;      //第三个等级图的的积分label

@property (nonatomic, strong) UIImageView *triangleImgView; //三角进度标示
@property (nonatomic, strong) UIProgressView *progresss1;   //进度条
@property (nonatomic, strong) UIProgressView *progresss2;
@property (nonatomic, strong) UILabel *signLab; //进度条上显示imageview

@property (nonatomic, strong) UILabel *vipRightLab;    //vip特权
@property (nonatomic, strong) UILabel *scoreRateLab;   //积分累计速度
@property (nonatomic, strong) UILabel *couponsLab;     //加息券
@property (nonatomic, strong) UILabel *zzyChancesLab;  //周周盈出借机会
@property (nonatomic, strong) UILabel *birthRewardLab; //生日送礼金
@property (nonatomic, strong) UILabel *monthBeginLab;  //每月1日送红包
@property (nonatomic, strong) UILabel *dayLimitLab;    //积分抽奖（每日上限）
@property (nonatomic, strong) UILabel *serviceFeeLab;  //服务费（折扣）

@property (nonatomic, assign) NSInteger vipLevel; //vip等级
@property (nonatomic, strong) DMVip *model;
@property (nonatomic, strong) ColorButton *buyButton; //购买vip按钮

@end

@implementation VIPViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //购买vip后回到页面，页面数据更新
    [self requestVipDataWebService];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self createTheTopUI];
    [self createTheBottomUI];
    [self createTheBuyVipUI];
    [self requestVipDataWebService];
}

- (void)setNav {
    self.navItem.title = XYBString(@"string_vip", @"VIP权益");

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button setTitle:XYBString(@"str_integral_specialRightDescription", @"特权说明") forState:UIControlStateNormal];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

#pragma mark 1.创建顶部视图

- (void)createTheTopUI {
    _scrollView = [[XYScrollView alloc] init];
    _scrollView.backgroundColor = COLOR_COMMON_WHITE;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-Cell_Height - 30);
    }];

    UIImage *bigImg = [UIImage imageNamed:@"vip_BigImg"];
    _bigImgView = [[UIImageView alloc] initWithImage:bigImg];
    [_scrollView addSubview:_bigImgView];

    [_bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_scrollView);
        make.width.equalTo(@(MainScreenWidth));
        if (IS_IPHONE_5_OR_LESS) {
            make.height.equalTo(@(MainScreenWidth * (bigImg.size.height / bigImg.size.width) + 20));
        } else {
            make.height.equalTo(@(MainScreenWidth * (bigImg.size.height / bigImg.size.width)));
        }

    }];

    User *user = [UserDefaultsUtil getUser];
    _headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]];
    _headerImgView.layer.cornerRadius = 37;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.layer.borderWidth = Corner_Radius_2;
    _headerImgView.layer.borderColor = COLOR_COMMON_WHITE.CGColor;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:user.url] placeholderImage:[UIImage imageNamed:@"header_logo"]];
    [_bigImgView addSubview:_headerImgView];

    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
            make.top.equalTo(_bigImgView.mas_top).offset(20);
        } else {
            make.top.equalTo(_bigImgView.mas_top).offset(28);
        }
        make.centerX.equalTo(_bigImgView.mas_centerX);
        make.width.height.equalTo(@(74));
    }];

    _accountLab = [[UILabel alloc] init];
    _accountLab.backgroundColor = COLOR_COMMON_CLEAR;
    _accountLab.textColor = COLOR_COMMON_WHITE;
    _accountLab.font = TEXT_FONT_18;
    _accountLab.text = @"000****0000";
    if (user.nickName) {
        _accountLab.text = user.nickName;
    } else if (user.tel) {
        _accountLab.text = [Utility thePhoneReplaceTheStr:user.tel];
    }

    [_bigImgView addSubview:_accountLab];

    [_accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5_OR_LESS) {
            make.top.equalTo(_headerImgView.mas_bottom).offset(10);
        } else {
            make.top.equalTo(_headerImgView.mas_bottom).offset(Margin_Length);
        }
        make.centerX.equalTo(_headerImgView.mas_centerX);
    }];

    _growLab = [[UILabel alloc] init];
    _growLab.backgroundColor = COLOR_COMMON_CLEAR;
    _growLab.font = TEXT_FONT_12;
    _growLab.textColor = COLOR_COMMON_WHITE_TRANS;
    _growLab.text = @"成长值0分";
    [_bigImgView addSubview:_growLab];

    [_growLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountLab.mas_bottom).offset(6);
        make.centerX.equalTo(_bigImgView.mas_centerX);
    }];

#pragma mark 第一个等级的创建
    _firstBottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_NotNowState"]];
    [_bigImgView addSubview:_firstBottomImg];

    [_firstBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bigImgView.mas_left).offset(30);
        if (IS_IPHONE_5_OR_LESS) {
            make.top.equalTo(_bigImgView.mas_top).offset(156);
        } else {
            make.top.equalTo(_bigImgView.mas_top).offset(181);
        }
    }];

    _firstStateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip0_normal"]];
    [_firstBottomImg addSubview:_firstStateImg];

    [_firstStateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_firstBottomImg.mas_centerX).offset(0);
        make.centerY.equalTo(_firstBottomImg.mas_centerY).offset(-2);
    }];

    _firstScoreLab = [[UILabel alloc] init];
    _firstScoreLab.font = TEXT_FONT_12;
    _firstScoreLab.textColor = COLOR_COMMON_WHITE;
    _firstScoreLab.text = @"0分";
    [_bigImgView addSubview:_firstScoreLab];

    [_firstScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_firstBottomImg.mas_centerX);
        make.top.equalTo(_firstBottomImg.mas_bottom).offset(9);
    }];

#pragma mark 第二个等级的创建
    _secondBottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_NotNowState"]];
    [_bigImgView addSubview:_secondBottomImg];

    [_secondBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bigImgView.mas_centerX);
        make.centerY.equalTo(_firstBottomImg.mas_centerY).offset(0);
    }];

    _secondStateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip0_normal"]];
    [_secondBottomImg addSubview:_secondStateImg];

    [_secondStateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_secondBottomImg.mas_centerX).offset(0);
        make.centerY.equalTo(_secondBottomImg.mas_centerY).offset(-2);
    }];

    _secondScoreLab = [[UILabel alloc] init];
    _secondScoreLab.font = TEXT_FONT_12;
    _secondScoreLab.textColor = COLOR_COMMON_WHITE;
    _secondScoreLab.text = @"0分";
    [_bigImgView addSubview:_secondScoreLab];

    [_secondScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_secondBottomImg.mas_centerX);
        make.top.equalTo(_secondBottomImg.mas_bottom).offset(9);
    }];

    //已过期图片
    UIImageView *overDueImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_overDue"]];
    overDueImage.hidden = YES;
    overDueImage.tag = REMAINDIMAGETAG;
    [_secondBottomImg addSubview:overDueImage];

    [overDueImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondBottomImg.mas_top);
        make.left.equalTo(_secondBottomImg.mas_right).offset(-8);
    }];

#pragma mark 第三个等级的创建
    _thirdBottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_NotNowState"]];
    [_bigImgView addSubview:_thirdBottomImg];

    [_thirdBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bigImgView.mas_right).offset(-30);
        make.centerY.equalTo(_firstBottomImg.mas_centerY).offset(0);
    }];

    _thirdStateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip0_normal"]];
    [_thirdBottomImg addSubview:_thirdStateImg];

    [_thirdStateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thirdBottomImg.mas_centerX).offset(0);
        make.centerY.equalTo(_thirdBottomImg.mas_centerY).offset(-2);
    }];

    _thirdScoreLab = [[UILabel alloc] init];
    _thirdScoreLab.font = TEXT_FONT_12;
    _thirdScoreLab.textColor = COLOR_COMMON_WHITE;
    _thirdScoreLab.text = @"0分";
    [_bigImgView addSubview:_thirdScoreLab];

    [_thirdScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thirdBottomImg.mas_centerX);
        make.top.equalTo(_thirdBottomImg.mas_bottom).offset(9);
    }];

#pragma mark 第一等级与第二等级之间的进度条
    _progresss1 = [[UIProgressView alloc] init];
    _progresss1.progressTintColor = COLOR_COMMON_WHITE;
    _progresss1.trackTintColor = COLOR_COMMON_WHITE_TRANS;
    [_bigImgView addSubview:_progresss1];

    [_progresss1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstBottomImg.mas_right).offset(0);
        make.centerY.equalTo(_firstBottomImg.mas_centerY);
        make.right.equalTo(_secondBottomImg.mas_left).offset(0);
        make.height.equalTo(@(2));
    }];

#pragma mark 第一等级与第二等级之间的进度条

    _progresss2 = [[UIProgressView alloc] init];
    _progresss2.progressTintColor = COLOR_COMMON_WHITE;
    _progresss2.trackTintColor = COLOR_COMMON_WHITE_TRANS;
    _progresss2.progress = 0.5;
    [_bigImgView addSubview:_progresss2];

    [_progresss2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_secondBottomImg.mas_right).offset(0);
        make.centerY.equalTo(_secondBottomImg.mas_centerY);
        make.right.equalTo(_thirdBottomImg.mas_left).offset(0);
        make.height.equalTo(@(2));
    }];

    _signLab = [[UILabel alloc] init];
    _signLab.backgroundColor = COLOR_MAIN;
    _signLab.layer.cornerRadius = Corner_Radius;
    _signLab.layer.masksToBounds = YES;
    _signLab.layer.borderWidth = Border_Width_2;
    _signLab.layer.borderColor = COLOR_COMMON_WHITE.CGColor;
    [_bigImgView addSubview:_signLab];

    [_signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progresss2.mas_centerX);
        make.centerY.equalTo(_progresss2.mas_centerY);
        make.width.height.equalTo(@(6));
    }];

    _triangleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    [_bigImgView addSubview:_triangleImgView];

    [_triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bigImgView.mas_bottom).offset(0);
        make.centerX.equalTo(_thirdScoreLab.mas_centerX);
    }];
}

#pragma mark 2.创建底部视图

- (void)createTheBottomUI {
    _vipRightLab = [[UILabel alloc] init];
    _vipRightLab.backgroundColor = COLOR_COMMON_CLEAR;
    _vipRightLab.font = TEXT_FONT_14;
    _vipRightLab.textColor = COLOR_MAIN_GREY;
    _vipRightLab.textAlignment = NSTextAlignmentLeft;
    _vipRightLab.text = @"VIP0特权";
    [_scrollView addSubview:_vipRightLab];

    [_vipRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(30);
        make.top.equalTo(_bigImgView.mas_bottom).offset(Margin_Left);
    }];

    UILabel *remaindLab2 = [[UILabel alloc] init];
    remaindLab2.backgroundColor = COLOR_COMMON_CLEAR;
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_LIGHT_GREY;
    remaindLab2.text = @"已过期，权益不再享有";
    remaindLab2.tag = REMAINDLAB2TAG;
    remaindLab2.hidden = YES;
    [_scrollView addSubview:remaindLab2];

    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left);
        make.top.equalTo(_vipRightLab.mas_bottom).offset(5);
        make.height.equalTo(@(0));
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [_scrollView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(remaindLab2.mas_bottom).offset(Margin_Length);
    }];

    UILabel *title1 = [[UILabel alloc] init];
    title1.backgroundColor = COLOR_COMMON_CLEAR;
    title1.font = TEXT_FONT_14;
    title1.textColor = COLOR_AUXILIARY_GREY;
    title1.text = @"积分累计速度";
    title1.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title1];

    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(lineView.mas_bottom).offset(Margin_Length);
    }];

    _scoreRateLab = [[UILabel alloc] init];
    _scoreRateLab.backgroundColor = COLOR_COMMON_CLEAR;
    _scoreRateLab.font = TEXT_FONT_14;
    _scoreRateLab.textColor = COLOR_MAIN_GREY;
    _scoreRateLab.text = @"0倍";
    _scoreRateLab.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_scoreRateLab];

    [_scoreRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right).offset(0);
        make.centerY.equalTo(title1.mas_centerY).offset(0);
    }];

    UILabel *title2 = [[UILabel alloc] init];
    title2.backgroundColor = COLOR_COMMON_CLEAR;
    title2.font = TEXT_FONT_14;
    title2.textColor = COLOR_AUXILIARY_GREY;
    title2.text = @"加息券";
    title2.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title2];

    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title1.mas_bottom).offset(Margin_Length);
    }];

    _couponsLab = [[UILabel alloc] init];
    _couponsLab.backgroundColor = COLOR_COMMON_CLEAR;
    _couponsLab.font = TEXT_FONT_14;
    _couponsLab.textColor = COLOR_MAIN_GREY;
    _couponsLab.textAlignment = NSTextAlignmentRight;
    _couponsLab.text = @"0";
    [_scrollView addSubview:_couponsLab];

    [_couponsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scoreRateLab.mas_right).offset(0);
        make.centerY.equalTo(title2.mas_centerY).offset(0);
    }];

    UILabel *title3 = [[UILabel alloc] init];
    title3.backgroundColor = COLOR_COMMON_CLEAR;
    title3.font = TEXT_FONT_14;
    title3.textColor = COLOR_AUXILIARY_GREY;
    title3.text = @"周周盈出借机会";
    title3.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title3];

    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title2.mas_bottom).offset(Margin_Length);
    }];

    _zzyChancesLab = [[UILabel alloc] init];
    _zzyChancesLab.backgroundColor = COLOR_COMMON_CLEAR;
    _zzyChancesLab.font = TEXT_FONT_14;
    _zzyChancesLab.textColor = COLOR_MAIN_GREY;
    _zzyChancesLab.textAlignment = NSTextAlignmentRight;
    _zzyChancesLab.text = @"0次";
    [_scrollView addSubview:_zzyChancesLab];

    [_zzyChancesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scoreRateLab.mas_right).offset(0);
        make.centerY.equalTo(title3.mas_centerY).offset(0);
    }];

    UILabel *title4 = [[UILabel alloc] init];
    title4.backgroundColor = COLOR_COMMON_CLEAR;
    title4.font = TEXT_FONT_14;
    title4.textColor = COLOR_AUXILIARY_GREY;
    title4.text = @"生日送礼金";
    title4.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title4];

    [title4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title3.mas_bottom).offset(Margin_Length);
    }];

    _birthRewardLab = [[UILabel alloc] init];
    _birthRewardLab.backgroundColor = COLOR_COMMON_CLEAR;
    _birthRewardLab.font = TEXT_FONT_14;
    _birthRewardLab.textColor = COLOR_MAIN_GREY;
    _birthRewardLab.textAlignment = NSTextAlignmentRight;
    _birthRewardLab.text = @"0元";
    [_scrollView addSubview:_birthRewardLab];

    [_birthRewardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scoreRateLab.mas_right).offset(0);
        make.centerY.equalTo(title4.mas_centerY).offset(0);
    }];

    UILabel *title5 = [[UILabel alloc] init];
    title5.backgroundColor = COLOR_COMMON_CLEAR;
    title5.font = TEXT_FONT_14;
    title5.textColor = COLOR_AUXILIARY_GREY;
    title5.text = @"每月1日送红包";
    title5.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title5];

    [title5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title4.mas_bottom).offset(Margin_Length);
    }];

    _monthBeginLab = [[UILabel alloc] init];
    _monthBeginLab.backgroundColor = COLOR_COMMON_CLEAR;
    _monthBeginLab.font = TEXT_FONT_14;
    _monthBeginLab.textColor = COLOR_MAIN_GREY;
    _monthBeginLab.textAlignment = NSTextAlignmentRight;
    _monthBeginLab.text = @"0.00元";
    [_scrollView addSubview:_monthBeginLab];

    [_monthBeginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scoreRateLab.mas_right).offset(0);
        make.centerY.equalTo(title5.mas_centerY).offset(0);
    }];

    UILabel *title6 = [[UILabel alloc] init];
    title6.backgroundColor = COLOR_COMMON_CLEAR;
    title6.font = TEXT_FONT_14;
    title6.textColor = COLOR_AUXILIARY_GREY;
    title6.text = @"积分抽奖(每日上限)";
    title6.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title6];

    [title6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title5.mas_bottom).offset(Margin_Length);
    }];

    _dayLimitLab = [[UILabel alloc] init];
    _dayLimitLab.backgroundColor = COLOR_COMMON_CLEAR;
    _dayLimitLab.font = TEXT_FONT_14;
    _dayLimitLab.textColor = COLOR_MAIN_GREY;
    _dayLimitLab.textAlignment = NSTextAlignmentRight;
    _dayLimitLab.text = @"0次";
    [_scrollView addSubview:_dayLimitLab];

    [_dayLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_monthBeginLab.mas_right).offset(0);
        make.centerY.equalTo(title6.mas_centerY).offset(0);
    }];

    UILabel *title7 = [[UILabel alloc] init];
    title7.backgroundColor = COLOR_COMMON_CLEAR;
    title7.font = TEXT_FONT_14;
    title7.textColor = COLOR_AUXILIARY_GREY;
    title7.text = @"服务费(折扣)";
    title7.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:title7];

    [title7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipRightLab.mas_left).offset(0);
        make.top.equalTo(title6.mas_bottom).offset(Margin_Length);
    }];

    _serviceFeeLab = [[UILabel alloc] init];
    _serviceFeeLab.backgroundColor = COLOR_COMMON_CLEAR;
    _serviceFeeLab.font = TEXT_FONT_14;
    _serviceFeeLab.textColor = COLOR_MAIN_GREY;
    _serviceFeeLab.textAlignment = NSTextAlignmentRight;
    _serviceFeeLab.text = @"0.00%";
    [_scrollView addSubview:_serviceFeeLab];

    [_serviceFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dayLimitLab.mas_right).offset(0);
        make.centerY.equalTo(title7.mas_centerY).offset(0);
        make.bottom.equalTo(_scrollView.mas_bottom).offset(-30);
    }];
}

#pragma mark 3.创建购买 VIP 的Btn

- (void)createTheBuyVipUI {
    _buyButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, Cell_Height) Title:XYBString(@"str_integral_buyVIP", @"购买VIP") ByGradientType:leftToRight];
    _buyButton.layer.cornerRadius = 0.f;
    [_buyButton addTarget:self action:@selector(buyVip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyButton];

    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(Cell_Height));
    }];

    backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_BG_1;
    [self.view addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_buyButton.mas_top);
        make.height.equalTo(@(30));
    }];

    vipTimeLab = [[UILabel alloc] init];
    vipTimeLab.textColor = COLOR_COMMON_WHITE;
    vipTimeLab.font = TEXT_FONT_12;
    vipTimeLab.text = XYBString(@"str_integral_VIPValidDateDefault", @"VIP会员有效期至:0000-00-00");
    [backView addSubview:vipTimeLab];

    [vipTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
    }];
}

#pragma mark - 4.vip权益数据请求

- (void)requestVipDataWebService {
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId };
    NSString *urlPath = [RequestURL getRequestURL:VipMyURL param:param];

    [self showDataLoading];
    [WebService postRequest:urlPath param:param JSONModelClass:[DMVip class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self hideLoading];
        DMVip *responseModel = responseObject;
        self.model = responseModel;

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

#pragma mark - set方法对UI赋值

- (void)setModel:(DMVip *)model {
    _model = model;
    _growLab.text = [NSString stringWithFormat:@"成长值%zi分", model.vip.currGrow];
    self.vipLevel = model.vip.vipLevel;

    if (self.vipLevel == 0) {
        _progresss1.progress = 0;
        _progresss2.progress = 0;
        [_signLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progresss1.mas_left).offset(0);
            make.centerY.equalTo(_progresss1.mas_centerY).offset(0);
            make.width.height.equalTo(@(6));
        }];

        //更新三角标示的位置
        [_triangleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_firstScoreLab.mas_centerX);
            make.bottom.equalTo(_bigImgView.mas_bottom);
        }];

    } else if (self.vipLevel == 8) {
        _progresss1.progress = 1;
        _progresss2.progress = 1;
        _signLab.hidden = YES;

        //更新三角标示的位置
        [_triangleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_thirdScoreLab.mas_centerX);
            make.bottom.equalTo(_bigImgView.mas_bottom);
        }];

    } else {

        //更新三角标示的位置
        [_triangleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_secondScoreLab.mas_centerX);
            make.bottom.equalTo(_bigImgView.mas_bottom);
        }];
        _progresss1.progress = 1;
        NSInteger preGrow; //前一个等级的积分值
        switch (model.vip.vipLevel) {
            case 1:
                preGrow = 0;
                break;
            case 2:
                preGrow = model.vip.vipGrows.vip2;
                break;
            case 3:
                preGrow = model.vip.vipGrows.vip3;
                break;
            case 4:
                preGrow = model.vip.vipGrows.vip4;
                break;
            case 5:
                preGrow = model.vip.vipGrows.vip5;
                break;
            case 6:
                preGrow = model.vip.vipGrows.vip6;
                break;
            case 7:
                preGrow = model.vip.vipGrows.vip7;
                break;
            default:
                break;
        }

        _progresss2.progress = (float) (model.vip.currGrow - preGrow) / (float) (model.vip.nextGrow - preGrow);

        [_signLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_progresss2.mas_left).offset(_progresss2.progress * _progresss2.frame.size.width);
            make.centerY.equalTo(_progresss2.mas_centerY).offset(0);
            make.width.height.equalTo(@(6));
        }];
    }

    //根据当前vip等级赋值
    switch (self.vipLevel) {
        case 0:
            self.firstScoreLab.text = @"0分";
            self.secondScoreLab.text = @"0分";
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip2 / 10000];
            break;
        case 1:
            self.firstScoreLab.text = @"0分";
            self.secondScoreLab.text = @"0分";
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip2 / 10000];
            break;
        case 2:
            self.firstScoreLab.text = @"0分";
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip2 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip3 / 10000];
            break;
        case 3:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip2 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip3 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip4 / 10000];
            break;
        case 4:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip3 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip4 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip5 / 10000];
            break;
        case 5:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip4 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip5 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip6 / 10000];
            break;
        case 6:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip5 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip6 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip7 / 10000];
            break;
        case 7:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip6 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip7 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip8 / 10000];
            break;
        case 8:
            self.firstScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip6 / 10000];
            self.secondScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip7 / 10000];
            self.thirdScoreLab.text = [NSString stringWithFormat:@"%zi万分", model.vip.vipGrows.vip8 / 10000];
            break;

        default:
            break;
    }

    UIImageView *overDueImage = (UIImageView *) [self.view viewWithTag:REMAINDIMAGETAG];
    UILabel *remaindLab = (UILabel *) [self.view viewWithTag:REMAINDLAB2TAG];
    if ([model.vip.isExpired boolValue] == 1) {
        overDueImage.hidden = NO;
        remaindLab.hidden = NO;
        [remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(13));
        }];
    } else {
        overDueImage.hidden = YES;
        remaindLab.hidden = YES;
        [remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }

    self.vipRightLab.text = [NSString stringWithFormat:@"VIP%zi特权", self.vipLevel];
    self.scoreRateLab.text = [NSString stringWithFormat:@"%@倍", model.vip.scoreRate];
    self.couponsLab.text = [NSString stringWithFormat:@"%@%%", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.vip.increaseCard * 100]]];
    self.zzyChancesLab.text = [NSString stringWithFormat:@"%zi次", model.vip.zzy];
    self.birthRewardLab.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.vip.birthReward]]];
    self.monthBeginLab.text = [NSString stringWithFormat:@"%zi元", model.vip.firstDaySleepReward];
    self.dayLimitLab.text = [NSString stringWithFormat:@"%zi次", model.vip.maxLuckyDraw];
    self.serviceFeeLab.text = [NSString stringWithFormat:@"%@%%", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.vip.serviceFeeDiscount * 100]]];

    //判断购买vip按钮如何显示
    if (self.vipLevel == 0) {
        //改变购买button的title
        [_buyButton setTitle:XYBString(@"str_integral_buyVIP", @"购买VIP") forState:UIControlStateNormal];

        //影藏vip有效期提现视图
        backView.hidden = YES;
        [backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];

        //改变scrollView的约束
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-Cell_Height);
        }];

    } else {

        //显示vip有效期提现视图
        backView.hidden = NO;
        [backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(30));
        }];

        //通过vip是否过期，来改变button的title文案和vip有效期文案
        if ([model.vip.isExpired boolValue] == 1) { //已经过期

            //改变购买button的title
            [_buyButton setTitle:XYBString(@"str_integral_buyVipAgain", @"再次购买") forState:UIControlStateNormal];
            vipTimeLab.text = [NSString stringWithFormat:XYBString(@"str_integral_VIPValidDate_overdue", @"VIP会员有效期至:%@(已过期)"), model.vip.vipDuetime];

        } else { //没有过期
            [_buyButton setTitle:XYBString(@"str_integral_VIPRenew", @"立即续费") forState:UIControlStateNormal];
            vipTimeLab.text = [NSString stringWithFormat:XYBString(@"str_integral_VIPValidDate", @"VIP会员有效期至:%@"), model.vip.vipDuetime];
        }

        //改变scrollView的约束
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-Cell_Height - 30);
        }];
    }
}

- (void)setVipLevel:(NSInteger)vipLevel {
    _vipLevel = vipLevel;
    if (_vipLevel == 0) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip0_select"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip1_normal"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip2_normal"];

    } else if (_vipLevel == 1) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip0_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip1_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip2_normal"];

    } else if (_vipLevel == 2) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip1_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip2_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip3_normal"];

    } else if (_vipLevel == 3) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip2_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip3_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip4_normal"];

    } else if (_vipLevel == 4) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip3_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip4_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip5_normal"];

    } else if (_vipLevel == 5) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip4_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip5_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip6_normal"];

    } else if (_vipLevel == 6) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip5_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip6_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip7_normal"];

    } else if (_vipLevel == 7) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip6_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip7_select"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip8_normal"];

    } else if (_vipLevel == 8) {
        _firstBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _firstStateImg.image = [UIImage imageNamed:@"vip6_normal"];
        _secondBottomImg.image = [UIImage imageNamed:@"vip_NotNowState"];
        _secondStateImg.image = [UIImage imageNamed:@"vip7_normal"];
        _thirdBottomImg.image = [UIImage imageNamed:@"vip_NowState"];
        _thirdStateImg.image = [UIImage imageNamed:@"vip8_select"];
    }

    if (_vipLevel == 0) {
        [_progresss1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_firstBottomImg.mas_right).offset(-6);
        }];

    } else if (_vipLevel == 8) {
        [_progresss2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_thirdBottomImg.mas_left).offset(6);
        }];

    } else {
        [_progresss1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_secondBottomImg.mas_left).offset(6);
        }];
        [_progresss2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_secondBottomImg.mas_right).offset(-6);
        }];
    }
}

#pragma mark - 响应事件
- (void)buyVip:(id)sender {
    VipPurchaseViewController *vipPurchase = [[VipPurchaseViewController alloc] init];
    [self.navigationController pushViewController:vipPurchase animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Vip_Explain_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_xyb_service_protocol", @"VIP特权说明");
    VipPrivilegeNoteWebViewController *webView = [[VipPrivilegeNoteWebViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
