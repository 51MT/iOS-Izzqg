//
//  NewHomeViewController.m
//  Ixyb
//
//  Created by dengjian on 16/12/12.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ActivityWebViewController.h"
#import "BannerScrollView.h"
#import "BbgDetailViewController.h"
#import "DqFinanceView.h"
#import "DqbProductDetailViewController.h"
#import "DrawWebViewController.h"
#import "FinancingViewController.h"
#import "FlexibleView.h"
#import "HomePageResponseModel.h"
#import "LoginFlowViewController.h"
#import "MJRefresh.h"
#import "MJRefreshCustomGifHeader.h"
#import "MessageCategoryViewController.h"
#import "MoreProductViewController.h"
#import "NTalkerChatViewController.h"
#import "RecomendView.h"
#import "RequestURL.h"
#import "RiskEvaluatingViewController.h"
#import "ScoreStoreWebViewController.h"
#import "SelectionView.h"
#import "ShakeGameViewController.h"
#import "VipWebViewController.h"
#import "WebService.h"
#import "XYAlertView.h"
#import "NewProGuideView.h"

@interface FinancingViewController () <UIScrollViewDelegate, UIWebViewDelegate>
{
    UIView *backview;
}
@property (nonatomic, strong) UIView *navBackView;  //自定义导航栏
@property (nonatomic, strong) UILabel *navTitleLab; //自定义导航栏上的title
@property (nonatomic, strong) UIImageView *leftNavRedPointImage;
@property (nonatomic, strong) XYScrollView *mainScroll;
@property (nonatomic, strong) BannerScrollView *bannerScroll; //广告banner
@property (nonatomic, strong) NSMutableArray *bannerArray;    //用于存放banner的图片
@property (nonatomic, strong) XYButton *radioBtn;             //公告button
@property (nonatomic, strong) UILabel *remaindLab;            //测评显示文字的label
@property (nonatomic, strong) UIView *backView;               //测评remaindLab的父视图
@property (nonatomic, strong) NSMutableArray *dataSource;     //tableView的数据源
@property (nonatomic, strong) SelectionView *selectionView;   //精选视图
@property (nonatomic, strong) RecomendView *recommendView;    //推荐视图
@property (nonatomic, strong) FlexibleView *flexibleView;     //灵活产品视图
@property (nonatomic, strong) DqFinanceView *dqFinanceView;   //定期产品视图
@property (nonatomic, strong) UIImageView *shakeRedPoint;

@property (nonatomic, strong) HomePageResponseModel *homeModel;
@property (nonatomic, strong) FinancingNotificationModel *notificationModel;

@end

@implementation FinancingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self presentNewFunctionAlert];
    [self callHomePageWebService];
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
    
    [self createMainScrollView];
    
    //自定义导航栏：必须将导航栏的创建放在mainscroll生成之后，否则自定义导航栏会在mainscroll的底部
    [self createCustomNavigationBar];
    
    [self createTheRadioUI];
    [self createTheMiddleView];
    [self createSelectionView];
    [self createTheRecommendView];
    [self createTheFlexibleView];
    [self createTheDqFinanceView];
    [self setupRefresh];
    [self callRequestChannelService]; //上传 idfa
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

/**
 *  创建mainScroll 和 bannerScroll
 */
- (void)createMainScrollView {
    
    _mainScroll = [[XYScrollView alloc] init];
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.delegate = self;
    [self.view addSubview:_mainScroll];
    
    [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.bottom.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth)); //UIScrollView没加width，在有些系统上可能会不显示其上面的子视图
    }];
    
    UIImage *image = [UIImage imageNamed:@"bannerDefaultImage"];
    _bannerScroll = [[BannerScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth / image.size.width * image.size.height)];
    FinancingViewController *weakVC = self;
    [_mainScroll addSubview:_bannerScroll];
    
    _bannerScroll.block = ^(NSInteger pageIndex) {
        //        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%zi", pageIndex], @"click_index", nil];
        BannerHomePageModel *banner = [weakVC.bannerArray objectAtIndex:pageIndex];
        
        if (banner.linkUrl) {
            NSArray *strArray = [banner.linkUrl componentsSeparatedByString:@"?"];
            if (strArray.count > 1) {
                //通过view=mall来标示此活动链接会跳转到--积分商城，跳转前判断是否登录（积分商城需要在登录状态下才能进入）
                BOOL isEqual = [[strArray objectAtIndex:1] isEqualToString:@"view=mall"];
                if (isEqual == YES) {
                    [weakVC isLoginWithTitleStr:banner.title WebUrlString:banner.linkUrl];
                    return;
                }
                
                //通过view=lottery来标示此活动链接会跳转到--积分抽奖，跳转前判断是否登录（积分抽奖需要在登录状态下才能进入）
                BOOL isEqual2 = [[strArray objectAtIndex:1] isEqualToString:@"view=lottery"];
                if (isEqual2 == YES) {
                    [weakVC isLoginWithTitleStr:banner.title WebUrlString:banner.linkUrl];
                    return;
                }
            }
            
            [weakVC addVersionAndRecommendCodeWithTitleStr:banner.title LinkUrl:banner.linkUrl];
        }
    };
    
    [_bannerScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenWidth / image.size.width * image.size.height));
    }];
}

/**
 *  @brief 创建广播的UI
 */
- (void)createTheRadioUI {
    _radioBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [_radioBtn setBackgroundImage:[UIImage imageNamed:@"radioBackImg"] forState:UIControlStateNormal];
    [_radioBtn addTarget:self action:@selector(clickTheRadioButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:_radioBtn];
    
    [_radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll.mas_left).offset(11);
        make.top.equalTo(_bannerScroll.mas_bottom).offset(15);
        make.width.equalTo(@(MainScreenWidth - 22));
        make.height.equalTo(@(Cell_Height));
    }];
    
    //喇叭图标
    UIImageView *notiImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio"]];
    notiImgView.userInteractionEnabled = NO;
    [_radioBtn addSubview:notiImgView];
    
    [notiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_radioBtn.mas_left).offset(8 + 4);
        make.centerY.equalTo(_radioBtn.mas_centerY).offset(-3);
    }];
    
    //箭头图标
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    arrowImage.userInteractionEnabled = NO;
    [_radioBtn addSubview:arrowImage];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_radioBtn.mas_right).offset(-Margin_Length - 4);
        make.centerY.equalTo(_radioBtn.mas_centerY).offset(-3);
    }];
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = COLOR_COMMON_CLEAR;
    _backView.clipsToBounds = YES;
    _backView.userInteractionEnabled = NO;
    [_radioBtn addSubview:_backView];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notiImgView.mas_right).offset(6);
        make.top.bottom.equalTo(_radioBtn);
        make.width.equalTo(@(MainScreenWidth - 12 - 16 - 15 * 3 - 8 - 6));
        make.centerY.equalTo(_radioBtn.mas_centerY);
    }];
    
    NSString *remaindStr = XYBString(@"str_message_latestNoticeMessage", @"最新公告消息");
    _remaindLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 3, 90, 33)];
    _remaindLab.backgroundColor = COLOR_COMMON_CLEAR;
    _remaindLab.font = TEXT_FONT_14;
    _remaindLab.textColor = COLOR_MAIN_GREY;
    _remaindLab.textAlignment = NSTextAlignmentLeft;
    _remaindLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _remaindLab.text = remaindStr;
    _remaindLab.userInteractionEnabled = NO;
    [_backView addSubview:_remaindLab];
    
    [_remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backView).offset(0);
        make.centerY.equalTo(_backView.mas_centerY).offset(-3);
        make.height.equalTo(@(33));
    }];
}

/**
 创建摇摇乐、积分抽奖、积分商城、在线客服视图
 */
- (void)createTheMiddleView {
    
    UIImage *backImage = [UIImage imageNamed:@"radioBackImg"];
    UIImage *newImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 7, 20, 5) resizingMode:UIImageResizingModeStretch];
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:newImage];
    backImgView.backgroundColor = COLOR_COMMON_CLEAR;
    backImgView.userInteractionEnabled = YES;
    backImgView.tag = 1000;
    [_mainScroll addSubview:backImgView];
    
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@11);
        make.top.equalTo(_radioBtn.mas_bottom).offset(8);
        make.height.equalTo(@100);
        make.width.equalTo(@(MainScreenWidth - 2 * 11));
    }];
    
    //摇摇乐
    XYButton *shakeBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [shakeBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [shakeBtn addTarget:self action:@selector(clickTheShakBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:shakeBtn];
    
    [shakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView.mas_top);
        make.left.equalTo(backImgView.mas_left).offset(4);
        make.width.equalTo(@((MainScreenWidth - 30 - 3 * 0.5) / 4));
        make.bottom.equalTo(backImgView.mas_bottom).mas_offset(-7);
    }];
    
    UIImageView *shakeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_yyl"]];
    [backImgView addSubview:shakeImgView];
    
    [shakeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shakeBtn.mas_centerX);
        make.top.equalTo(shakeBtn.mas_top).offset(15);
    }];
    
    self.shakeRedPoint = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.shakeRedPoint.image = [UIImage imageNamed:@"redPoint"];
    self.shakeRedPoint.hidden = YES;
    [shakeBtn addSubview:self.shakeRedPoint];
    
    [self.shakeRedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shakeImgView.mas_right).offset(-3);
        make.top.equalTo(shakeBtn.mas_top).offset(15);
    }];
    
    UILabel *shakeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shakeLab.text = XYBString(@"str_yyl", @"摇摇乐");
    shakeLab.textColor = COLOR_MAIN_GREY;
    shakeLab.font = SMALL_TEXT_FONT_13;
    [backImgView addSubview:shakeLab];
    
    [shakeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shakeImgView.mas_bottom);
        make.centerX.equalTo(shakeBtn.mas_centerX);
    }];
    
    //竖线
    UIView *verticalLine1 = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine1.backgroundColor = COLOR_LINE;
    [backImgView addSubview:verticalLine1];
    
    [verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@27);
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(shakeBtn.mas_right);
        make.centerY.equalTo(shakeBtn.mas_centerY);
    }];
    
    //积分抽奖
    XYButton *lotteryBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [lotteryBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [lotteryBtn addTarget:self action:@selector(clickTheLotteryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:lotteryBtn];
    
    [lotteryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView.mas_top);
        make.left.equalTo(verticalLine1.mas_right);
        make.width.equalTo(@((MainScreenWidth - 30 - 5 * 0.5) / 4));
        make.bottom.equalTo(shakeBtn.mas_bottom);
    }];
    
    UIImageView *lotteryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_jfcj"]];
    [backImgView addSubview:lotteryImgView];
    
    [lotteryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lotteryBtn.mas_centerX);
        make.top.equalTo(lotteryBtn.mas_top).offset(15);
    }];
    
    UILabel *lotteryLab = [[UILabel alloc] initWithFrame:CGRectZero];
    lotteryLab.text = XYBString(@"str_jfcj", @"积分抽奖");
    lotteryLab.font = SMALL_TEXT_FONT_13;
    lotteryLab.textColor = COLOR_MAIN_GREY;
    [lotteryBtn addSubview:lotteryLab];
    
    [lotteryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lotteryImgView.mas_bottom);
        make.centerX.equalTo(lotteryBtn.mas_centerX);
    }];
    
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine2.backgroundColor = COLOR_LINE;
    [backImgView addSubview:verticalLine2];
    
    [verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(27));
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(lotteryBtn.mas_right);
        make.centerY.equalTo(lotteryBtn.mas_centerY);
    }];
    
    //积分商城
    XYButton *shopBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [shopBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(clickTheShopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:shopBtn];
    
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView.mas_top);
        make.left.equalTo(verticalLine2.mas_right);
        make.width.equalTo(@((MainScreenWidth - 30 - 5 * 0.5) / 4));
        make.bottom.equalTo(shakeBtn.mas_bottom);
    }];
    
    UIImageView *shopImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_jfsc"]];
    [shopBtn addSubview:shopImgView];
    
    [shopImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopBtn.mas_centerX);
        make.top.equalTo(shopBtn.mas_top).offset(15);
    }];
    
    UILabel *shopLab = [[UILabel alloc] initWithFrame:CGRectZero];
    shopLab.text = XYBString(@"str_jfsc", @"积分商城");
    shopLab.font = SMALL_TEXT_FONT_13;
    shopLab.textColor = COLOR_MAIN_GREY;
    [shopBtn addSubview:shopLab];
    
    [shopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopImgView.mas_bottom);
        make.centerX.equalTo(shopBtn.mas_centerX);
    }];
    
    UIView *verticalLine3 = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine3.backgroundColor = COLOR_LINE;
    [backImgView addSubview:verticalLine3];
    
    [verticalLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(27));
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(shopBtn.mas_right);
        make.centerY.equalTo(shopBtn.mas_centerY);
    }];
    
    //在线客服 小能客服
    XYButton *lineServiceBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [lineServiceBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [lineServiceBtn addTarget:self action:@selector(clickLineServiceWithQQ:) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:lineServiceBtn];
    
    [lineServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImgView.mas_top);
        make.left.equalTo(verticalLine3.mas_right);
        make.width.equalTo(@((MainScreenWidth - 30 - 5 * 0.5) / 4));
        make.bottom.equalTo(shakeBtn.mas_bottom);
    }];
    
    UIImageView *friendImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LineService"]];
    [lineServiceBtn addSubview:friendImgView];
    
    [friendImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lineServiceBtn.mas_centerX);
        make.top.equalTo(lineServiceBtn.mas_top).offset(15);
    }];
    
    UILabel *friendLab = [[UILabel alloc] initWithFrame:CGRectZero];
    friendLab.text = XYBString(@"str_loan_kf_zx", @"在线客服");
    friendLab.font = SMALL_TEXT_FONT_13;
    friendLab.tag = 2009;
    friendLab.textColor = COLOR_MAIN_GREY;
    [lineServiceBtn addSubview:friendLab];
    
    [friendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(friendImgView.mas_bottom);
        make.centerX.equalTo(lineServiceBtn.mas_centerX);
    }];
}

/**
 *  @brief 精选UI
 */
- (void)createSelectionView {
    _selectionView = [[SelectionView alloc] initWithFrame:CGRectZero];
    [_mainScroll addSubview:_selectionView];
    
    UIView *backView = [self.view viewWithTag:1000];
    [_selectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll).offset(0);
        make.top.equalTo(backView.mas_bottom).offset(0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(181));
    }];
    
    FinancingViewController *weakVC = self;
    _selectionView.block = ^(CcProductModel *model) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:weakVC animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) {
                    [UMengAnalyticsUtil event:EVENT_FINANCE_ZZYINVEST];
                    [weakVC pushToDqbDetailViewControllerWithCcProductModel:model];
                }
            }];
        } else {
            [UMengAnalyticsUtil event:EVENT_FINANCE_ZZYINVEST];
            [weakVC pushToDqbDetailViewControllerWithCcProductModel:model];
        }
    };
}

/**
 *  @brief 推荐UI
 */
- (void)createTheRecommendView {
    _recommendView = [[RecomendView alloc] initWithFrame:CGRectZero];
    [_mainScroll addSubview:_recommendView];
    
    [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll).offset(0);
        make.top.equalTo(_selectionView.mas_bottom).offset(0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(181));
    }];
    
    FinancingViewController *weakVC = self;
    _recommendView.block = ^(CcProductModel *model) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:weakVC animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) {
                    [weakVC pushToDqbDetailViewControllerWithCcProductModel:model];
                }
            }];
        } else {
            [weakVC pushToDqbDetailViewControllerWithCcProductModel:model];
        }
    };
}

/**
 *  @brief 灵活产品UI
 */
- (void)createTheFlexibleView {
    _flexibleView = [[FlexibleView alloc] initWithFrame:CGRectZero];
    [_mainScroll addSubview:_flexibleView];
    
    [_flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll).offset(0);
        make.top.equalTo(_recommendView.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(193));
    }];
    
    FinancingViewController *weakVC = self;
    //步步高出借时回调进入步步高出借页面
    _flexibleView.bbgInvestBlock = ^(BbgProductModel *bbgModel) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:weakVC animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) {
                    [UMengAnalyticsUtil event:EVENT_FINANCE_BBGINVEST];
                    [weakVC pushToBbgDetailViewControllerWithBbgModel:bbgModel];
                }
            }];
        } else {
            [UMengAnalyticsUtil event:EVENT_FINANCE_BBGINVEST];
            [weakVC pushToBbgDetailViewControllerWithBbgModel:bbgModel];
        }
    };
}

/**
 *  @brief 定期产品UI
 */
- (void)createTheDqFinanceView {
    
    _dqFinanceView = [[DqFinanceView alloc] initWithFrame:CGRectZero];
    [_mainScroll addSubview:_dqFinanceView];
    
    [_dqFinanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll).offset(0);
        make.top.equalTo(_flexibleView.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(141));
    }];
    
    FinancingViewController *weakVC = self;
    _dqFinanceView.block = ^{
        
        MoreProductViewController *moreProductVC;
        BOOL isOpen = [weakVC.homeModel.openDep boolValue];//0：未开通存管功能，1：已开通存管
        
        if (isOpen == NO) {
            moreProductVC = [[MoreProductViewController alloc] initWithCGValue:NO];
        }else{
            moreProductVC = [[MoreProductViewController alloc] initWithCGValue:YES];
        }
        
        moreProductVC.type = ClickTheNP;
        [weakVC.navigationController pushViewController:moreProductVC animated:YES];
        [UMengAnalyticsUtil event:EVENT_FINANCE_DQPORDUCTINVEST];
    };
    
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_10;
    remaindLab.textColor = COLOR_LIGHT_GREY;
    remaindLab.text = XYBString(@"str_financing_hasRiskAndInvestShouldBePrudent", @"市场有风险，出借需谨慎");
    [_mainScroll addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dqFinanceView.mas_centerX);
        make.top.equalTo(_dqFinanceView.mas_bottom).offset(17.5);
        make.bottom.equalTo(_mainScroll.mas_bottom).offset(-17.5);
    }];
}

/**
 新产品介绍第一页
 */
- (void)createIntroduceFirstUI {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    backview = [[UIView alloc] initWithFrame:self.view.bounds];
    backview.backgroundColor = COLOR_COMMON_BLACK_TRANS_75;
    [window addSubview:backview];
    
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    UIImage *btn_iKnowImage = [UIImage imageNamed:@"btn_iKnow"];
    CGSize iKnowImage_size = btn_iKnowImage.size;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:btn_iKnowImage forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickIntroduceFirstButton:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.width.equalTo(@(iKnowImage_size.width));
        make.height.equalTo(@(iKnowImage_size.height));
        make.bottom.equalTo(backview.mas_bottom).offset(-20 - 49);
    }];
    
    NSString *imageName = @"newProGuide1";
    UIImage *guide_1 = [UIImage imageNamed:imageName];
    CGSize image_size = guide_1.size;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.image = guide_1;
    [backview addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backview.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(nextBtn.mas_top).offset(-13);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@((MainScreenWidth - 30) * image_size.height / image_size.width));
    }];
}

#pragma mark - 新功能上线通知

/**
 新功能上线通知 弹窗
 */
- (void)presentNewFunctionAlert {
    
    //未登录时，不显示弹窗
    if (![Utility shareInstance].isLogin) {
        return;
    }
    
    //沙盒中查看之前是否已弹过窗
    BOOL isNewFunc = [UserDefaultsUtil getNewFunction];

    //1.弹窗过，则不再弹窗提示
    if (isNewFunc == YES) {
        return;
    }
    
    //2.未弹窗过（用户已登录，且用户在白名单中）就弹窗提示
    User *user = [UserDefaultsUtil getUser];
    if ([Utility shareInstance].isLogin && [user.openDep intValue] == 1) {
        
        //遍历Window上的子view，发现XYAlertView(升级弹窗)，不弹出“新功能上线通知”弹窗
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        for (UIView *subview in window.subviews) {
            if ([subview isKindOfClass:[XYAlertView class]]) {
                return;
            }
        }
        
        XYAlertView *newFuncAlert = [[XYAlertView alloc] initWithNewFunctionAlertViewWithFrame:CGRectZero title:XYBString(@"str_xsdborrow_newFunctionNotice", @"新功能上线通知") describe:XYBString(@"str_xsdborrow_newProductOnline", @"信用宝新产品“一键出借”隆重上线。\n是否阅读产品介绍。") leftButtonTitle:XYBString(@"str_xsdborrow_noIntroduce", @"无需介绍") rightButtonTitle:XYBString(@"str_xsdborrow_beginRead", @"开始阅读")];
        [window addSubview:newFuncAlert];
        
        [newFuncAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
        
        __weak XYAlertView *weakAlert = newFuncAlert;
        newFuncAlert.clickSureButton = ^(NSString *contentStr) {
            
            [weakAlert removeFromSuperview];
            
            //进入新产品引导页面
            [self createIntroduceFirstUI];
        };
        
        newFuncAlert.clickCancelButton = ^{
            [UserDefaultsUtil setNewFunction];
        };
    }
}

#pragma mark - 接收到数据后页面刷新

- (void)reloadDataWithHomePageResponseModel:(HomePageResponseModel *)model {
    
    //导航栏上的消息的红点的显示/隐藏
    if (model.unread > 0) {
        _leftNavRedPointImage.hidden = NO;
    } else {
        _leftNavRedPointImage.hidden = YES;
    }
    
    //banner赋值
    if (model && model.banners != nil) {
        self.bannerScroll.dataSourse = [NSMutableArray arrayWithArray:model.banners];
        self.bannerArray = [self.bannerScroll.dataSourse mutableCopy];
    }
    
    //公告消息赋值
    if (model.notification != nil) {
        self.notificationModel = model.notification;
        [self setRadioTitle:self.notificationModel];
    }
    
    //设置摇摇乐小红点
    if (model.shakeNum > 0) {
        self.shakeRedPoint.hidden = NO;
    } else {
        self.shakeRedPoint.hidden = YES;
    }
    
    //精选赋值
    if (model.zzy != nil) {
        self.selectionView.model = model.zzy;
        self.selectionView.hidden = NO;
        [self.selectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(181));
        }];
        
    } else {
        self.selectionView.hidden = YES;
        [self.selectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    
    //推荐赋值 根据model.recommendProduct对象是否为空控制显示/隐藏
    if (model && model.recommendProduct != nil) {
        self.recommendView.model = model.recommendProduct;
        self.recommendView.hidden = NO;
        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(181));
        }];
    } else {
        self.recommendView.hidden = YES;
        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    
    //灵活产品 步步高赋值
    if (model && model.bbg != nil) {
        self.flexibleView.bbgModel = model.bbg;
    }
    
    //价值产品
    if (model && model.dqFinance != nil) {
        self.dqFinanceView.dqModel = model.dqFinance;
    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    _mainScroll.header = self.gifHeader1;
}

- (void)headerRereshing {
    [self callHomePageWebService];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [_mainScroll.header endRefreshing];
}

#pragma mark - 简化代码 页面跳转

/**
 *  @brief 判断是否登录，若登录直接跳转；未登录，则先登录(积分商城+积分抽奖)
 */

- (void)isLoginWithTitleStr:(NSString *)title WebUrlString:(NSString *)webUrl {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    //登录成功后进入到下一页面
                    [self addVersionAndRecommendCodeWithTitleStr:title LinkUrl:webUrl];
                }
            }
        }];
        
    } else {
        [self addVersionAndRecommendCodeWithTitleStr:title LinkUrl:webUrl];
    }
}

/**
 *  @brief 在链接之后签名sign、带上用户ID和version和recommendCode
 *
 *  @param titleStr 标题
 *  @param linkUrl  链接路径
 */
- (void)addVersionAndRecommendCodeWithTitleStr:(NSString *)titleStr LinkUrl:(NSString *)linkUrl {
    //带userId和签名sign
    NSString *urlStr = [RequestURL getH5LinkURL:linkUrl];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
    
    //v2.0.2将推荐码加入到链接中（有就加，没有则不加）
    NSString *code = [UserDefaultsUtil getUser].recommendCode;
    if (code && code != nil) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&code=%@", code]]; //增加推荐码
    }
    
    ActivityWebViewController *webView = [[ActivityWebViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

/**
 *  @brief 精选 和 推荐 跳入定期宝详情页面
 *
 *  @param model 定期宝产品模型
 */
- (void)pushToDqbDetailViewControllerWithCcProductModel:(CcProductModel *)model {
    
    DqbProductDetailViewController *detailVC = [[DqbProductDetailViewController alloc] init];
    detailVC.productId = model.ccId;
    detailVC.ccProduct = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 跳入步步高详情页面
 
 @param model 步步高产品模型
 */
- (void)pushToBbgDetailViewControllerWithBbgModel:(BbgProductModel *)model {
    
    BbgDetailViewController *bbgDetailVC = [[BbgDetailViewController alloc] init];
    bbgDetailVC.bbgProduct = model;
    bbgDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bbgDetailVC animated:YES];
}

/**
 *  @brief 设定公告内容
 *
 *  @param model 模型
 */
- (void)setRadioTitle:(FinancingNotificationModel *)model {
    NSString *radioStr = [NSString stringWithFormat:@"%@", model.content];
    //    CGFloat width = [radioStr boundingRectWithSize:CGSizeMake(MainScreenWidth *4, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
    //                        NSForegroundColorAttributeName : COLOR_COMMON_CLEAR,
    //                        NSFontAttributeName : TEXT_FONT_14
    //                    }
    //                                           context:nil]
    //                        .size.width;
    _remaindLab.text = radioStr;
    
    /*  可显示title的区域的宽度和文字的宽度作比较
     *  1.小；显示不下，开始跑动
     *  2.大||等于；显示的下，直接显示，不跑动
     */
    //    if (width > MainScreenWidth - 12 - 16 - 15 * 3 - 8 - 6) {
    //        _remaindLab.frame = CGRectMake(width, 3, width, 33);
    //        [_remaindLab mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(_backView.mas_right).offset(0);
    //            make.centerY.equalTo(_backView.mas_centerY).offset(-3);
    //            make.height.equalTo(@(33));
    //        }];
    //        [AnimationUtil labelRun:_remaindLab WithText:radioStr]; //开始文字滚动效果
    //    } else {
    //        [_remaindLab mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(_backView.mas_left).offset(0);
    //            make.centerY.equalTo(_backView.mas_centerY).offset(-3);
    //            make.height.equalTo(@(33));
    //        }];
    //    }
}

#pragma mark - 点击事件

/**
 *  点击消息按钮：进入到消息列表页面
 */
- (void)clickTheLeftBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                [UMengAnalyticsUtil event:EVENT_FINANCE_MESSAGE];
                MessageCategoryViewController *myMessageVC = [[MessageCategoryViewController alloc] init];
                myMessageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myMessageVC animated:YES];
            }
        }];
    } else {
        [UMengAnalyticsUtil event:EVENT_FINANCE_MESSAGE];
        MessageCategoryViewController *myMessageVC = [[MessageCategoryViewController alloc] init];
        myMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myMessageVC animated:YES];
    }
}

/**
 *  点击签到按钮：进行签到
 */
- (void)clickTheAttendenceBtnBtn:(id)sender {
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) {
                [UMengAnalyticsUtil event:EVENT_FINANCE_SIGNIN];
                NSString *requestURL = [RequestURL getNodeJsH5URL:HomePageGoSignRequestURL withIsSign:YES];
                XYWebViewController *attendenceVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_home_sign", @"签到") webUrlString:requestURL];
                attendenceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:attendenceVC animated:YES];
            }
        }];
        
    } else {
        [UMengAnalyticsUtil event:EVENT_FINANCE_SIGNIN];
        NSString *requestURL = [RequestURL getNodeJsH5URL:HomePageGoSignRequestURL withIsSign:YES];
        XYWebViewController *attendenceVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_home_sign", @"签到") webUrlString:requestURL];
        attendenceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:attendenceVC animated:YES];
    }
}


/**
 *  @brief 点击广播按钮：进入最新广播页面
 *
 *  @param sender
 */
- (void)clickTheRadioButton:(id)sender {
    
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                XYWebViewController *radioVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_financing_details", @"详情") webUrlString:self.notificationModel.detailUrl];
                radioVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:radioVC animated:YES];
            }
        }];
        
    } else {
        XYWebViewController *radioVC = [[XYWebViewController alloc] initWithTitle:XYBString(@"str_financing_details", @"详情") webUrlString:self.notificationModel.detailUrl];
        radioVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:radioVC animated:YES];
    }
}

/**
 摇摇乐点击事件
 
 @param sender 摇摇乐button
 */
- (void)clickTheShakBtn:(id)sender {
    
    __weak FinancingViewController *homeVC = self;
    if (![Utility shareInstance].isLogin) {
        
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_YYL];
                    //是否进入下一步
                    ShakeGameViewController *shakeGameViewController = [[ShakeGameViewController alloc] init];
                    shakeGameViewController.hidesBottomBarWhenPushed = YES;
                    [homeVC.navigationController pushViewController:shakeGameViewController animated:YES];
                }
            }
        }];
        
    } else {
        [UMengAnalyticsUtil event:EVENT_MY_YYL];
        ShakeGameViewController *shakeGameViewController = [[ShakeGameViewController alloc] init];
        shakeGameViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shakeGameViewController animated:YES];
    }
}

/**
 积分抽奖点击事件
 
 @param sender 积分抽奖button
 */
- (void)clickTheLotteryBtn:(id)sender {
    
    if (![Utility shareInstance].isLogin) {
        
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_JFCJ];
                    //是否进入下一步
                    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Lottery_URL withIsSign:YES];
                    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
                    DrawWebViewController *drawWebVC = [[DrawWebViewController alloc] initWithTitle:@"积分抽奖" webUrlString:urlStr];
                    drawWebVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:drawWebVC animated:YES];
                }
            }
        }];
        
    } else {
        [UMengAnalyticsUtil event:EVENT_MY_JFCJ];
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Lottery_URL withIsSign:YES];
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
        DrawWebViewController *drawWebVC = [[DrawWebViewController alloc] initWithTitle:@"积分抽奖" webUrlString:urlStr];
        drawWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:drawWebVC animated:YES];
    }
}

/**
 积分商城点击事件
 
 @param sender 积分商城button
 */
- (void)clickTheShopBtn:(id)sender {
    
    if (![Utility shareInstance].isLogin) {
        
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
            
            if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                if (state == LoginFlowStateDoneAndRechare) {
                    //首页侧边栏登录成功
                    self.tabBarController.selectedIndex = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                } else {
                    [UMengAnalyticsUtil event:EVENT_MY_JFSC];
                    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Mall_URL withIsSign:YES];
                    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
                    ScoreStoreWebViewController *scoreStoreWebVC = [[ScoreStoreWebViewController alloc] initWithTitle:@"积分商城" webUrlString:urlStr];
                    scoreStoreWebVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scoreStoreWebVC animated:YES];
                }
            }
        }];
        
    } else {
        [UMengAnalyticsUtil event:EVENT_MY_JFSC];
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Mall_URL withIsSign:YES];
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
        ScoreStoreWebViewController *scoreStoreWebVC = [[ScoreStoreWebViewController alloc] initWithTitle:@"积分商城" webUrlString:urlStr];
        scoreStoreWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scoreStoreWebVC animated:YES];
    }
}

/**
 在线客服点击事件
 
 @param sender 在线客服button
 */
- (void)clickLineServiceWithQQ:(id)sender {
    
    if (![Utility shareInstance].isLogin) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentWith:self animated:NO completion:nil];
        return;
    }
    
    [UMengAnalyticsUtil event:EVENT_MY_CUSTOMER];
    [self loadXiaoNengPage:@"kf_9482_1482133740350"];
}

- (void)clickIntroduceFirstButton:(id)sender {
    
    NSArray *viewArr = backview.subviews;
    for (UIView *subview in viewArr) {
        [subview removeFromSuperview];
    }
    
    [backview removeFromSuperview];
    
    MoreProductViewController *productVC = [[MoreProductViewController alloc] initWithCGValue:YES];
    productVC.showSecondView = YES;
    [self.navigationController pushViewController:productVC animated:YES];
}

/**
 调用小能客服，QQ在线
 
 @param settingIdStr 配置参数
 */
- (void)loadXiaoNengPage:(NSString *)settingIdStr {
    
    NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
    ctrl.settingid = settingIdStr;                  //【必填】客服组ID 一定要传入自己的
    ctrl.erpParams = @"www.xyb100.com";             //传值示例
    ctrl.pageTitle = @"iPhone";                     //传值示例
    ctrl.kefuId = @"";                              //传值示例
    ctrl.isSingle = @"-1";                          //传值示例
    ctrl.pageURLString = @"https://www.xyb100.com"; //传值示例
    ctrl.pushOrPresent = YES;
    ctrl.titleColor = [UIColor whiteColor];
    if (ctrl.pushOrPresent == YES) {
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        ctrl.pushOrPresent = NO;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示") message:XYBString(@"str_notqq_alert", @"未安装QQ客户端") delegate:nil cancelButtonTitle:nil otherButtonTitles:XYBString(@"str_ok", @"确定"), nil];
    
    [alertview show];
}

#pragma mark - WebService接口

#pragma mark 1.首页数据请求接口

/**
 *  @brief 调用首页数据请求接口
 */
- (void)callHomePageWebService {
    
    //第一次请求数据时显示loading
    static BOOL s_isUpdate = NO;
    if (s_isUpdate == NO) {
        [self showDataLoading];
        s_isUpdate = YES;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //userId
    if ([UserDefaultsUtil getUser].userId) {
        [params setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    } else {
        [params setValue:@"0" forKey:@"userId"];
    }
    
    //deviceToken
    NSUserDefaults *dateDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = nil;
    if ([dateDefaults objectForKey:@"deviceToken"]) {
        deviceToken = [NSString stringWithFormat:@"%@", [dateDefaults objectForKey:@"deviceToken"]];
    }
    [params setValue:deviceToken forKey:@"deviceToken"];
    
    NSString *noticeLastReadDateStr = nil;
    NSString *eventLastReadDateStr = nil;
    NSString *financeLastReadDateStr = nil;
    NSString *borrowLastReadDateStr = nil;
    NSString *newsLastReadDateStr = nil;
    
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
        
        if ([lastReadDateDic objectForKey:@"newsDate"]) { //新闻最后阅读时间
            newsLastReadDateStr = [lastReadDateDic objectForKey:@"newsDate"];
        } else {
            newsLastReadDateStr = @"";
        }
        
    } else {
        noticeLastReadDateStr = @"";
        eventLastReadDateStr = @"";
        financeLastReadDateStr = @"";
        borrowLastReadDateStr = @"";
        newsLastReadDateStr = @"";
    }
    
    [params setValue:noticeLastReadDateStr forKey:@"noticeDate"];
    [params setValue:eventLastReadDateStr forKey:@"eventDate"];
    [params setValue:financeLastReadDateStr forKey:@"financeDate"];
    [params setValue:borrowLastReadDateStr forKey:@"borrowDate"];
    [params setValue:borrowLastReadDateStr forKey:@"newsDate"];
    
    [self requestHomePageWebService:params];
}

/**
 *  @brief 首页数据请求接口
 *
 */
- (void)requestHomePageWebService:(NSDictionary *)params {
    NSString *requestURL = [RequestURL getRequestURL:FinancingRequestURL param:params];
    [WebService postRequest:requestURL param:params JSONModelClass:[HomePageResponseModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self hideLoading];
                        HomePageResponseModel *model = responseObject;
                        self.homeModel = model;
                        
                        User *user = [UserDefaultsUtil getUser];
                        user.openDep = model.openDep;
                        [UserDefaultsUtil setUser:user];
                        
                        [self reloadDataWithHomePageResponseModel:self.homeModel];
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - 上传idfa接口

- (void)callRequestChannelService {
    NSString *adIFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    if ([Utility shareInstance].isLogin) {
        [paramsDic setValue:[UserDefaultsUtil getUser].userId forKey:@"userId"];
    }
    [paramsDic setValue:adIFA forKey:@"idfa"];
    [self requestChannelWebService:paramsDic];
}

/**
 *  @brief WebService接口：渠道激活  IDFA
 *
 *  @param param 接口参数
 */
- (void)requestChannelWebService:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:ChannelActivationURL param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class]
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        ResponseModel *response = responseObject;
                        if (response.resultCode == 1) {
                            NSLog(@"上传成功");
                        }
                    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self showPromptTip:errorMessage];
                       }];
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //banner默认底图，根据底图算出banner的高度
    UIImage *image = [UIImage imageNamed:@"bannerDefaultImage"];
    CGFloat maxAlphaOffset = MainScreenWidth / image.size.width * image.size.height - [IPhoneXNavHeight navBarBottom];
    
    //Y轴位移距离
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = offsetY / maxAlphaOffset;
    
    if (alpha > 0) { //上拉
        _navBackView.hidden = NO;
        _navBackView.backgroundColor = [COLOR_MAIN colorWithAlphaComponent:alpha];
        _navTitleLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:alpha];
    } else if (alpha == 0) {
        _navBackView.hidden = NO;
        _navBackView.backgroundColor = [COLOR_MAIN colorWithAlphaComponent:alpha];
        _navTitleLab.textColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:alpha];
    } else if (alpha < 0) { //下拉
        _navBackView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
