//
//  MoreProductViewController.m
//  Ixyb
//
//  Created by wang on 15/8/27.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "MoreProductViewController.h"
#import "Utility.h"

#import "NPListView.h"
#import "DqbMoreProductView.h"
#import "XtbMoreProductView.h"
#import "ZqzrMoreProductView.h"

#import "LoginFlowViewController.h"

#import "NPDetailViewController.h"
#import "DqbProductDetailViewController.h"
#import "XtbProductDetailViewController.h"
#import "ZqzrDetailViewController.h"

#import "BbgInvestViewController.h"
#import "ZqzrInvestViewController.h"

#import "LoginFlowViewController.h"
#import "RequestURL.h"
#import "RiskEvaluatingViewController.h"
#import "UMengAnalyticsUtil.h"
#import "WebviewViewController.h"
#import "XYAlertView.h"
#import "XtbInvestViewController.h"
#import "NProductListResModel.h"

@interface MoreProductViewController () {

    NPListView *npView;
    DqbMoreProductView *dqbView;
    XtbMoreProductView *xtbView;
    ZqzrMoreProductView *zqzrView;

    CcProductModel *ccproduct;
    BidProduct *bidproduct;
    NProductModel *newProduct;

    XYScrollView *mainScrollView;
    UIView *headerView;
    UILabel *selectLab;
    NSArray *nameArr; //按钮上的title
    NSMutableArray *btnArray;

    int currentScrollPage;
    CGFloat fontWidth; //字体宽度，iOS10的字体宽度有变化
    UIView *backview;
}

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,copy) NSString *productID;

@end

@implementation MoreProductViewController

- (instancetype)initWithCGValue:(BOOL)isOpen {
    self = [super init];
    if (self) {
        _isOpen = isOpen;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotyfication:) name:@"FirstID" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (currentScrollPage == 0) {
        [npView setTheRequest];
        
    } else if (currentScrollPage == 1) {
        [dqbView.dataArray removeAllObjects];
        [dqbView setTheRequest];
        
    } else if (currentScrollPage == 2) {
        [xtbView.dataArray removeAllObjects];
        [xtbView setTheRequest:0];
        
    } else if (currentScrollPage == 3) {
        [zqzrView.dataArray removeAllObjects];
        [zqzrView setTheRequest:0];
    }

    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self initData];
    [self creatTheHeaderView];
    [self creatTheMainScrollView];
    [self creatTheNpView];
    [self creatTheDqbView];
    [self creatTheXtbView];
    [self creatTheZqzrView];

    [self reloadTheDataForChangeView:currentScrollPage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadData" object:nil];
}

#pragma mark - 创建UI

- (void)setNav {

    self.navItem.title = XYBString(@"str_dq_product", @"价值产品");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

/**
 *  @brief 初始化数据 获取到外部传进来的值type（滚动到第几页）
 */
- (void)initData {
    
    currentScrollPage = 0;
    switch (self.type) {
        case ClickTheNP:
            currentScrollPage = 0;
            break;
            
        case ClickTheDQB:
            currentScrollPage = 1;
            break;
            
        case ClickTheXTB:
            currentScrollPage = 2;
            break;
            
        case ClickTheZQZR:
            currentScrollPage = 3;
            break;
            
        default:
            break;
    }
    
    btnArray = [[NSMutableArray alloc] init];
}

/**
 *  @brief 创建导航栏下的切换按钮
 */
- (void)creatTheHeaderView {

    headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.equalTo(@40);
    }];

    if (self.isOpen == YES) {
        nameArr = @[XYBString(@"str_common_yjcj", @"一键出借"),
                    XYBString(@"str_common_dqb", @"定期宝"),
                    XYBString(@"str_common_xtb", @"信投宝"),
                    XYBString(@"str_common_zqzr", @"债权转让")];
    }else{
        nameArr = @[XYBString(@"str_common_dqb", @"定期宝"),
                    XYBString(@"str_common_xtb", @"信投宝"),
                    XYBString(@"str_common_zqzr", @"债权转让")];
    }


    //计算出所有title的总长度
    NSInteger nameLength = 0;
    for (int i = 0; i < nameArr.count; i++) {
        nameLength = nameLength + [[nameArr objectAtIndex:i] length];
    }

    UIButton *customBtn = nil;

    for (int i = 0; i < nameArr.count; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 50 + i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(clickheaderButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [button setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        button.titleLabel.font = TEXT_FONT_16;

        fontWidth = 16.4;
        CGFloat spaceWidth = (MainScreenWidth - nameLength * fontWidth) / ((nameArr.count - 1) * 2 + 2);
        [headerView addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(5);
            make.width.equalTo(@([[nameArr objectAtIndex:i] length] * fontWidth));
            if (customBtn) {
                make.left.equalTo(customBtn.mas_right).offset(2 * spaceWidth);
            } else {
                make.left.equalTo(headerView.mas_left).offset(spaceWidth);
            }
        }];

        if (i == currentScrollPage) {
            button.selected = YES;
            selectLab = [[UILabel alloc] init];
            selectLab.backgroundColor = COLOR_MAIN;
            [headerView addSubview:selectLab];
            [headerView bringSubviewToFront:selectLab];

            [selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button).offset(1);
                make.top.equalTo(headerView.mas_bottom).offset(-0.5);
                make.height.equalTo(@1.5);
                make.width.equalTo(button.mas_width);
            }];
        }
        
        [btnArray addObject:button];
        customBtn = button;
    }

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];

    [headerView addSubview:verlineImage];
    [headerView insertSubview:verlineImage belowSubview:selectLab];
    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(headerView.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
}

- (void)creatTheMainScrollView {

    mainScrollView = [[XYScrollView alloc] init];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.directionalLockEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(nameArr.count * MainScreenWidth, MainScreenHeight - 105);
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - 创建新产品

- (void)creatTheNpView {
    
    if (self.isOpen == NO) {
        return;
    }
    
    npView = [[NPListView alloc] initWithFrame:CGRectMake(0, 1, MainScreenWidth, MainScreenHeight - 41) navigationController:self.navigationController];
    [mainScrollView addSubview:npView];
    
    [npView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView.mas_top).offset(1);
        make.left.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 41));
    }];
    
    __weak MoreProductViewController *productVC = self;
    npView.clickTheInvestButton = ^(NProductModel *product) {
        
        if (![Utility shareInstance].isLogin) {
            newProduct = product;
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:productVC animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        //首页侧边栏登录成功
                        productVC.tabBarController.selectedIndex = 3;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                    } else {
                        [productVC npCheckTheUserDefaultWithParam:product];
                    }
                }
            }];
            
        } else {
            [productVC npCheckTheUserDefaultWithParam:product];
        }
    };
    
    npView.clickTheDetailVC = ^(NProductModel *product) {
        if (![Utility isExistenceNetwork]) {
            ALERT(XYBString(@"str_common_network_error", @"网络连接不可用，请检查"));
            return;
        }
        
        NPDetailViewController *npVC = [[NPDetailViewController alloc] initWithNProductID:product.nproductId];
        [productVC.navigationController pushViewController:npVC animated:YES];
    };
}

- (void)npCheckTheUserDefaultWithParam:(NProductModel *)model {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isEvaluation = [userDefault boolForKey:@"isEvaluation"];
    BOOL forceEvaluation = [userDefault boolForKey:@"forceEvaluation"];

    if (isEvaluation == NO && forceEvaluation == YES) {
        [self presentTheTestAlerView];
        
    } else {
        NPDetailViewController *detailVC = [[NPDetailViewController alloc] initWithNProductID:model.nproductId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 创建定期宝

- (void)creatTheDqbView {

    dqbView = [[DqbMoreProductView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:dqbView];

    [dqbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView);
        if (_isOpen == YES) {
            make.left.equalTo(npView.mas_right);
        }else{
            make.left.equalTo(mainScrollView.mas_left);
        }
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 41));
    }];

    __weak MoreProductViewController *productVC = self;
    dqbView.clickTheInvestButton = ^(CcProductModel *product) {
        
        if (![Utility shareInstance].isLogin) {
            ccproduct = product;
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:productVC animated:NO completion:^(LoginFlowState state) {
                
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        //首页侧边栏登录成功
                        productVC.tabBarController.selectedIndex = 3;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                    } else {
                        [productVC dqbCheckTheUserDefaultWithParam:product];
                    }
                }
            }];

        } else {
            [productVC dqbCheckTheUserDefaultWithParam:product];
        }
    };

    dqbView.clickTheDetailVC = ^(CcProductModel *product) {
        if (![Utility isExistenceNetwork]) {
            ALERT(XYBString(@"str_common_network_error", @"网络连接不可用，请检查"));
            return;
        }

        DqbProductDetailViewController *dqbVC = [[DqbProductDetailViewController alloc] init];
        dqbVC.productId = product.ccId;
        dqbVC.ccProduct = product;
        dqbVC.fromType = productVC.fromType;
        [productVC.navigationController pushViewController:dqbVC animated:YES];
    };
}

- (void)dqbCheckTheUserDefaultWithParam:(CcProductModel *)model {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isEvaluation = [userDefault boolForKey:@"isEvaluation"];
    BOOL forceEvaluation = [userDefault boolForKey:@"forceEvaluation"];

    if (isEvaluation == NO && forceEvaluation == YES) {
        [self presentTheTestAlerView];
        
    } else {
        DqbProductDetailViewController *detailVC = [[DqbProductDetailViewController alloc] init];
        detailVC.productId = model.ccId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 创建信投宝

- (void)creatTheXtbView {

    xtbView = [[XtbMoreProductView alloc] initWithFrame:CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:xtbView];

    [xtbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dqbView.mas_right);
        make.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 40));
    }];

    __weak MoreProductViewController *productVC = self;
    xtbView.clickTheInvestButton = ^(BidProduct *product) {
        
        if (![Utility shareInstance].isLogin) {
            bidproduct = product;
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:productVC animated:NO completion:^(LoginFlowState state) {
                
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        //首页侧边栏登录成功
                        productVC.tabBarController.selectedIndex = 3;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                    } else {
                        [productVC xtbCheckTheUserDefaultWithParam:product];
                    }
                }
            }];

        } else {
            [productVC xtbCheckTheUserDefaultWithParam:product];
        }
    };

    xtbView.clickTheDetailButton = ^(BidProduct *product) {
        if (![Utility isExistenceNetwork]) {
            ALERT(XYBString(@"str_common_network_error", @"网络连接不可用，请检查"));
            return;
        }
        XtbProductDetailViewController *xtbProductDetailViewController = [[XtbProductDetailViewController alloc] init];
        xtbProductDetailViewController.productId = product.productId;
        xtbProductDetailViewController.productInfo = product;
        [productVC.navigationController pushViewController:xtbProductDetailViewController animated:YES];

    };
}

- (void)xtbCheckTheUserDefaultWithParam:(BidProduct *)model {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isEvaluation = [userDefault boolForKey:@"isEvaluation"];
    BOOL forceEvaluation = [userDefault boolForKey:@"forceEvaluation"];

    if (isEvaluation == NO && forceEvaluation == YES) {
        [self presentTheTestAlerView];
    } else {
        
        XtbProductDetailViewController *xtbProductDetailViewController = [[XtbProductDetailViewController alloc] init];
        xtbProductDetailViewController.productId = model.productId;
        xtbProductDetailViewController.productInfo = model;
        [self.navigationController pushViewController:xtbProductDetailViewController animated:YES];
        
//        InvestViewController *investViewController = [[InvestViewController alloc] init];
//        investViewController.info = model;
//        investViewController.fromTag = XYBString(@"str_common_xtb", @"信投宝");
//        investViewController.fromType = self.fromType;
//        [self.navigationController pushViewController:investViewController animated:YES];
    }
}

#pragma mark - 创建债权转让

- (void)creatTheZqzrView {
    
    zqzrView = [[ZqzrMoreProductView alloc] initWithFrame:CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:zqzrView];

    [zqzrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xtbView.mas_right);
        make.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 40));
    }];

    __weak MoreProductViewController *productVC = self;
    zqzrView.clickTheInvestButton = ^(BidProduct *product) {
        
        if (![Utility shareInstance].isLogin) {
            bidproduct = product;
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:productVC animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        //首页侧边栏登录成功
                        productVC.tabBarController.selectedIndex = 3;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickChargeButton" object:nil]; //注册成功后去充值
                    } else {
                        [productVC zqzrCheckTheUserDefaultWithParam:product];
                    }
                }
            }];

        } else {
            [productVC zqzrCheckTheUserDefaultWithParam:product];
        }

    };
}

-(void)setShowSecondView:(BOOL)showSecondView {
    _showSecondView = showSecondView;
    [self createIntroduceSecondView];
}

/**
 是否显示新产品介绍2页面
 */
- (void)createIntroduceSecondView {
    
    backview = [[UIView alloc] initWithFrame:self.view.bounds];
    backview.backgroundColor = COLOR_COMMON_BLACK_TRANS_75;
    [self.view addSubview:backview];
    
    NSString *imageName = @"newProGuide2";
    UIImage *guide_2 = [UIImage imageNamed:imageName];
    CGSize image_size = guide_2.size;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.image = guide_2;
    [backview addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backview.mas_top).offset(120);
        make.left.equalTo(backview.mas_left).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@((MainScreenWidth - 30) * image_size.height / image_size.width));
    }];
    
    
    UIImage *btn_iKnowImage = [UIImage imageNamed:@"btn_iKnow"];
    CGSize iKnowImage_size = btn_iKnowImage.size;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:btn_iKnowImage forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickIntroduceSecondButton:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(imageview.mas_bottom).offset(0);
        make.width.equalTo(@(iKnowImage_size.width));
        make.height.equalTo(@(iKnowImage_size.height));
    }];
}

#pragma mark - 接收通知

- (void)getNotyfication:(NSNotification *)noty {
    _productID = noty.object;
}

#pragma mark - 响应事件

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTheRightBtn {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_ProductIntro_URL withIsSign:NO];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:nil webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

/**
 *  点击头部按钮
 *
 *  @param button headerButton
 */
- (void)clickheaderButton:(UIButton *)button {
    
    [UIView animateWithDuration:0.5 animations:^{
        [selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_left);
            make.top.equalTo(headerView.mas_bottom).offset(-0.5);
            make.height.equalTo(@1.5);
            make.width.equalTo(@([[nameArr objectAtIndex:(int) button.tag - 50] length] * fontWidth));
        }];
    } completion:nil];
    
    currentScrollPage = (int) button.tag - 50;
    if (currentScrollPage == 0) {
        //[UMengAnalyticsUtil event:EVNET_FINANCE_XTB];
    } else if (currentScrollPage == 1) {
        //[UMengAnalyticsUtil event:EVENT_FINANCE_ZQZR];
    } else if (currentScrollPage == 2) {
        //[UMengAnalyticsUtil event:EVENT_FINANCE_ZQZR];
    } else if (currentScrollPage == 2) {
        //[UMengAnalyticsUtil event:EVENT_FINANCE_ZQZR];
    }
    
    [self reloadTheDataForChangeView:currentScrollPage];
}

- (void)clickIntroduceSecondButton:(id)sender {
    
    NSArray *viewArr = backview.subviews;
    for (UIView *subview in viewArr) {
        [subview removeFromSuperview];
    }
    
    [backview removeFromSuperview];
    
    NPDetailViewController *npVC = [[NPDetailViewController alloc] initWithNProductID:self.productID];
    npVC.showThirdView = YES;
    [self.navigationController pushViewController:npVC animated:YES];
}

//弹出测评弹窗
- (void)presentTheTestAlerView {
    
    UIAlertController *riskTestAlert = [UIAlertController alertControllerWithTitle:XYBString(@"str_common_riskTest", @"风险测评") message:XYBString(@"str_common_remaindRiskTest", @"应监管合规要求，您需要在出借相关产品前完成风险承受能力测评") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:XYBString(@"str_common_cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [riskTestAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [riskTestAlert addAction:cancelBtn];
    
    UIAlertAction *testBtn = [UIAlertAction actionWithTitle:XYBString(@"str_common_toFinishRiskTest", @"去测评") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [riskTestAlert dismissViewControllerAnimated:YES completion:nil];
        //跳转到测评h5界面
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Risk_Evaluating_URL withIsSign:YES];
        RiskEvaluatingViewController *riskEvaluatingVC = [[RiskEvaluatingViewController alloc] initWithTitle:XYBString(@"str_common_riskTest", @"风险测评") webUrlString:urlStr];
        [self.navigationController pushViewController:riskEvaluatingVC animated:YES];
    }];
    
    [riskTestAlert addAction:testBtn];
    
    [self presentViewController:riskTestAlert animated:YES completion:nil];
    
//    XYAlertView *alertView = [[XYAlertView alloc] initWithFrame:CGRectZero presentTestWindowWithDescripe:XYBString(@"str_common_remaindRiskTest", @"根据监管政策要求，请在出借前完成投风险评测。") bottomButtonTitle:XYBString(@"str_common_toFinishRiskTest", @"去测评")];
//    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    [app.window addSubview:alertView];
//
//    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(app.window);
//    }];
//
//    __weak XYAlertView *weakVC = alertView;
//    alertView.clickUrlButton = ^() {
//        //直接跳转到测评h5界面
//        [weakVC removeFromSuperview];
//        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Risk_Evaluating_URL withIsSign:YES];
//        RiskEvaluatingViewController *riskEvaluatingVC = [[RiskEvaluatingViewController alloc] initWithTitle:XYBString(@"str_common_riskTest", @"风险测评") webUrlString:urlStr];
//        riskEvaluatingVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:riskEvaluatingVC animated:YES];
//    };
}

/**
 收到刷新通知后，刷新数据

 @param noty 通知
 */
- (void)reloadData:(NSNotification *)noty {
    
    if (self.isOpen == YES) {
        
        switch (currentScrollPage) {
            case 0:
                [npView setTheRequest];
                break;
            case 1:
                [dqbView setTheRequest];
                break;
            case 2:
                [xtbView setTheRequest:0];
                break;
            case 3:
                [zqzrView setTheRequest:0];
                break;
            default:
                break;
        }
        
    }else{
        switch (currentScrollPage) {
            case 0:
                [dqbView setTheRequest];
                break;
            case 1:
                [xtbView setTheRequest:0];
                break;
            case 2:
                [zqzrView setTheRequest:0];
                break;
            default:
                break;
        }
    }
}


/**
 *  切换视图刷新显示数据
 *
 *  @param currentViewPage 当前页数
 */
- (void)reloadTheDataForChangeView:(int)currentViewPage {

    [self reloadTheDataScrollTheView:currentScrollPage];
    [UIView animateWithDuration:0.1 animations:^{
        mainScrollView.contentOffset = CGPointMake((MainScreenWidth) *currentScrollPage, 0);
    } completion:nil];
    
    for (UIButton *btn in btnArray) {
        btn.selected = NO;
    }
    UIButton *selectBtn = (UIButton *) [self.view viewWithTag:50 + currentScrollPage];
    selectBtn.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectBtn.mas_left);
            make.top.equalTo(headerView.mas_bottom).offset(-0.5);
            make.height.equalTo(@1.5);
            make.width.equalTo(@([[nameArr objectAtIndex:currentViewPage] length] * fontWidth));
        }];
    } completion:nil];
}

- (void)zqzrCheckTheUserDefaultWithParam:(BidProduct *)model {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isEvaluation = [userDefault boolForKey:@"isEvaluation"];
    BOOL forceEvaluation = [userDefault boolForKey:@"forceEvaluation"];
    
    if (isEvaluation == NO && forceEvaluation == YES) {
        [self presentTheTestAlerView];
    } else {
        
        ZqzrDetailViewController *detailVC = [[ZqzrDetailViewController alloc] init];
        detailVC.productId = model.productId;
        detailVC.productInfo = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)reloadTheDataScrollTheView:(int)currentViewPage {

    if (self.isOpen == YES) {
        switch (currentViewPage) {
            case 0: {
                if (npView.dataArray.count == 0) {
                    [npView setTheRequest];
                }
            }
                break;
                
            case 1: {
                if (dqbView.dataArray.count == 0) {
                    [dqbView setTheRequest];
                }
            }
                break;
                
            case 2: {
                if (xtbView.dataArray.count == 0) {
                    [xtbView setTheRequest:0];
                }
            }
                break;
                
            case 3: {
                if (zqzrView.dataArray.count == 0) {
                    [zqzrView setTheRequest:0];
                }
            }
                break;
                
            default:
                break;
        }
        
    }else{

        switch (currentViewPage) {
            case 0: {
                if (dqbView.dataArray.count == 0) {
                    [dqbView setTheRequest];
                }
            }
                break;
                
            case 1: {
                if (xtbView.dataArray.count == 0) {
                    [xtbView setTheRequest:0];
                }
            }
                break;
                
            case 2: {
                if (zqzrView.dataArray.count == 0) {
                    [zqzrView setTheRequest:0];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:mainScrollView]) {
        
        CGFloat pageWidth = MainScreenWidth;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page >= nameArr.count) {
            return;
        }
        
        if (page != currentScrollPage) {
            [self reloadTheDataScrollTheView:page];
        }
        currentScrollPage = page;
        
        for (UIButton *btn in btnArray) {
            btn.selected = NO;
        }
        UIButton *selectBtn = (UIButton *) [self.view viewWithTag:50 + currentScrollPage];
        selectBtn.selected = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            [selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(selectBtn.mas_left);
                make.top.equalTo(headerView.mas_bottom).offset(-0.5);
                make.height.equalTo(@1.5);
                make.width.equalTo(@([[nameArr objectAtIndex:currentScrollPage] length] * fontWidth));
            }];
        } completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
