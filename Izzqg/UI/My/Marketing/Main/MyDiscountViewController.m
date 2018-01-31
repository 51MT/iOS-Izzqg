//
//  MyDiscountViewController.m
//  Ixyb
//
//  Created by wang on 2017/2/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "MyDiscountViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "RewardAmountView.h"
#import "RewardAmountOverDueViewController.h"

#import "MyCouponsView.h"
#import "IncreaseCardFailedViewController.h"

#import "MoreProductViewController.h"
#import "HbOverDueView.h"
#import "SleepRewardAccountOverDueViewController.h"
#import "MyScoreView.h"

@interface MyDiscountViewController ()
{
    XYScrollView *mainScrollView;
    UIView *headerView;
    UILabel *selectLab;
    NSArray *nameArr; //按钮上的title
    NSMutableArray *btnArray;
    
    int currentScrollPage;
    CGFloat fontWidth; //字体宽度，iOS10的字体宽度有变化
    
    RewardAmountView * rewardAmountView;
    MyCouponsView *     myCouponsView;
    HbOverDueView *  hbOverView;
    MyScoreView * jfScoreVIew;
}
@end

@implementation MyDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self initData];
    [self creatTheHeaderView];
    [self creatTheMainScrollView];
    
    [self creatTheLJView];
    [self creatTheYHJView];
    [self creatTheHBView];
    [self creatTheJFView];
    
    [self reloadTheDataForChangeView:currentScrollPage];
}

#pragma mark - 创建UI
- (void)setNav {
    self.navItem.title = XYBString(@"string_my_favourable", @"我的优惠");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"使用规则" forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
    
}

- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @brief 初始化数据 获取到外部传进来的值type（滚动到第几页）
 */
- (void)initData {
    currentScrollPage = 0;
    switch (self.type) {
        case ClickTheLJ:
            currentScrollPage = 0;
            break;
        case ClickTheYHJ:
            currentScrollPage = 1;
            break;
        case ClickTheHB:
            currentScrollPage = 2;
            break;
        case ClickTheJF:
            currentScrollPage = 3;
            break;
        default:
            break;
    }
    
    btnArray = [[NSMutableArray alloc] init];
}

#pragma mark -- 创建视图UI
#pragma mark -- 礼金
-(void)creatTheLJView
{
    
    __weak MyDiscountViewController *productVC = self;
    rewardAmountView = [[RewardAmountView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:rewardAmountView];
    [rewardAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 41));
    }];
    rewardAmountView.clickTheOverDueVC =^(void)
    {
        RewardAmountOverDueViewController * rewardOuerDue = [[RewardAmountOverDueViewController alloc]init];
        [productVC.navigationController pushViewController:rewardOuerDue animated:YES];
    };
    
}

#pragma mark -- 优惠劵
-(void)creatTheYHJView
{
    __weak MyDiscountViewController *productVC = self;
    myCouponsView = [[MyCouponsView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:myCouponsView];
    [myCouponsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardAmountView.mas_right);
        make.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 40));
    }];
    myCouponsView.clickTheFailedVC =^(void)
    {
        IncreaseCardFailedViewController *IncreaseCardFailed = [[IncreaseCardFailedViewController alloc] init];
        IncreaseCardFailed.hidesBottomBarWhenPushed = YES;
        [productVC.navigationController pushViewController:IncreaseCardFailed animated:YES];
    };
    
    myCouponsView.clickTheMoreProductVc =^(void)
    {
        MoreProductViewController * moreProduct = [[MoreProductViewController alloc]init];
        moreProduct.type = ClickTheDQB;
        [productVC.navigationController pushViewController:moreProduct animated:YES];
    };
    
}

#pragma mark -- 红包
-(void)creatTheHBView
{
    __weak MyDiscountViewController *productVC = self;
    hbOverView = [[HbOverDueView alloc] initWithFrame:CGRectMake(MainScreenWidth*2, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:hbOverView];
    [hbOverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myCouponsView.mas_right);
        make.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 40));
    }];
    hbOverView.clickTheDueVC =^(void)
    {
        SleepRewardAccountOverDueViewController * sleepReward = [[SleepRewardAccountOverDueViewController alloc] init];
        sleepReward.hidesBottomBarWhenPushed = YES;
        [productVC.navigationController pushViewController:sleepReward animated:YES];
    };
    
    hbOverView.clickTheMoreProductVc =^(void)
    {
        //王智要求改的
        productVC.tabBarController.selectedIndex = 0;
    };

}

#pragma mark -- 积分
-(void)creatTheJFView
{
    jfScoreVIew = [[MyScoreView alloc] initWithFrame:CGRectMake(MainScreenWidth*3, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:jfScoreVIew];
    [jfScoreVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hbOverView.mas_right);
        make.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 40));
    }];
}

/**
 *  @brief 创建导航栏下的切换按钮
 */
- (void)creatTheHeaderView {
    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    nameArr = @[
                XYBString(@"str_lj", @"礼金"),
                XYBString(@"str_yhj", @"优惠券"),
                XYBString(@"str_hb", @"红包"),
                XYBString(@"str_jf", @"积分")
                ];
    
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
        
        fontWidth = 18.4;
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
    
    mainScrollView = [[XYScrollView alloc] initWithFrame:CGRectMake(0, 105, MainScreenWidth, MainScreenHeight - 105)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.directionalLockEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(nameArr.count * MainScreenWidth, MainScreenHeight - 105);
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
}

//使用规则
-(void)clickRightBtn:(id)sender
{
    NSString *titleStr = XYBString(@"sy_gz", @"使用规则");
    switch (currentScrollPage) {
        case 0://礼金
        {
            NSString *urlStr = [RequestURL getNodeJsH5URL:App_CashUseRules_URL withIsSign:NO];
            WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
            [self.navigationController pushViewController:webView animated:YES];
        }
        break;
        case 1://优惠劵
        {
            NSString *requestURL = [RequestURL getNodeJsH5URL:App_CardUseRules_URL withIsSign:NO];
            WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:requestURL];
            [self.navigationController pushViewController:webView animated:YES];
        }
        break;
        case 2://红包
        {
            NSString *urlStr = [RequestURL getNodeJsH5URL:App_BonusRules_URL withIsSign:NO];
            WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
            [self.navigationController pushViewController:webView animated:YES];
        }
        break;
        case 3://积分
        {
            NSString *urlStr = [RequestURL getNodeJsH5URL:App_ScoreIntro_URL withIsSign:NO];
            WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
            [self.navigationController pushViewController:webView animated:YES];
        }
        break;
        default:
        break;
    }
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
    }
                     completion:^(BOOL finished){
                         
                     }];
    currentScrollPage = (int) button.tag - 50;
    [self reloadTheDataForChangeView:currentScrollPage];
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
    }
                     completion:^(BOOL finished){
                         
                     }];
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
    }
                     completion:^(BOOL finished){
                         
                     }];
}


- (void)reloadTheDataScrollTheView:(int)currentViewPage {
    
    switch (currentViewPage) {
        case 0: {
            if (rewardAmountView.dataArray.count == 0) {
                [rewardAmountView setTheRequest];
            }
        } break;
        case 1: {
            if (myCouponsView.dataArray.count == 0) {
                [myCouponsView setTheRequest:0];
            }
        } break;
        case 2: {
            if (hbOverView.dataArray.count == 0) {
                [hbOverView setTheRequest:0];
            }
        } break;
        case 3: {
            if (jfScoreVIew.dataArray.count == 0) {
                [jfScoreVIew setTheRequest:0];
            }
        } break;
        default:
            break;
    }
}

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
        }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
