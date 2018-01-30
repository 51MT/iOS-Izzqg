//
//  IncomeStatusViewController.m
//  Ixyb
//
//  Created by wang on 15/5/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "IncomeStatusViewController.h"
#import "InvestmentRewardModel.h"
#import "MBProgressHUD.h"
#import "MoreProductViewController.h"
#import "RewardAmountViewController.h"
#import "Utility.h"
#import "BbgInvestListViewController.h"
#import "XtbInvestListViewController.h"
#import "DqbInvestListViewController.h"
#import "WebService.h"

#define FINTAG 1001
#define LJTAG  1002

@interface IncomeStatusViewController () {
    UILabel *cashGift_FirstRewardLab;
    UILabel *cashGift_FirstRewardLab2;
    
    UILabel *totalCashGiftLab;
    UILabel *cashGiftLab1;
    UILabel *cashGiftLab2;
    UILabel *cashGiftLab3;
    UILabel *integrationLab4;
    MBProgressHUD *hud;
    UIScrollView *scrollView;
    UIView *ljImageView1; //礼金-积分视图1的背景图
    UIView *ljImageView2; //礼金-积分视图2的背景图
    UIView *cashGiftView3;     //积分视图3的背景图
    UIView *BottomView;        //拼命计算获得奖励视图的底图
}
@end

@implementation IncomeStatusViewController

- (void)setNav {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    button.tag = 1001;
    [button setTitle:XYBString(@"str_common_complete", @"完成") forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)backTherootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickCompleteBtn:(id)sender {

    self.tabBarController.selectedIndex = 0;
    MoreProductViewController *moreVC = [[MoreProductViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)clickBackBtn:(id)sender {
    
    NSString *titleStr = self.navItem.title;
    UIButton * but = (UIButton *)sender;
    switch (but.tag) {
        case 1001://完成
        {
            if ([titleStr isEqualToString:XYBString(@"str_common_investSuccess", @"出借结果")]) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[MoreProductViewController class]]) {
                        
                        //新手任务(返回需求)_出借成功
                        if (self.fromType == FromTypeTheHome) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            return;
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
                        [self.navigationController popToViewController:controller animated:YES];
                        return;
                    }
                }
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        case 1002://礼金
        {
            if (_isBookBid == YES) {
                
                self.tabBarController.selectedIndex = 0;
                MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
                moreProductVC.hidesBottomBarWhenPushed = YES;
                moreProductVC.type = ClickTheDQB;
                [self.navigationController pushViewController:moreProductVC animated:YES];
                
            }else
            {
                if ([titleStr isEqualToString:XYBString(@"str_common_investSuccess", @"出借结果")]) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[MoreProductViewController class]]) {
                            
                            //新手任务(返回需求)_出借成功
                            if (self.fromType == FromTypeTheHome) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                return;
                            }
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                }
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    NSString *titleStr = self.navItem.title;
    
    if ([titleStr isEqualToString:XYBString(@"str_common_investSuccess", @"出借结果")]) {
        
        [self creatTheIncomeSatusView];
        [self requestOrderRewordData];
        //此处数据为异步加载，存在一定延时，所以数据请求三次
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2.0f];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self requestOrderRewordData];
                });
            }
        });
    } else if ([titleStr isEqualToString:XYBString(@"str_financing_tropism_sucess", @"提现成功")]) {
        
        [self creatTheTropismSuccessView];
    }
}

#pragma mark-- 出借成功
- (void)creatTheIncomeSatusView {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = COLOR_COMMON_CLEAR;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    float navBarHeight = self.navBar.frame.size.height;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(MainScreenHeight - navBarHeight));
    }];
    
    UIView *incomeSatusView = [[UIView alloc] init];
    incomeSatusView.backgroundColor = COLOR_COMMON_WHITE;
    incomeSatusView.layer.cornerRadius = Corner_Radius;
    incomeSatusView.tag = 1000;
    [scrollView addSubview:incomeSatusView];
    
    [incomeSatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Top));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.width.equalTo(@(MainScreenWidth-30));
        make.height.equalTo(@372);
    }];
    
    
    UIImageView * iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"redeemsuccess"];
    [incomeSatusView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(incomeSatusView.mas_centerX);
        make.top.equalTo(incomeSatusView.mas_top).offset(32);
    }];
    
    UILabel * lendSuccessLab = [[UILabel alloc] init];
    lendSuccessLab.font      = TEXT_FONT_19;
    lendSuccessLab.textColor = COLOR_COMMON_BLACK;
    lendSuccessLab.text      = XYBString(@"str_lend_success", @"出借成功");
    [incomeSatusView addSubview:lendSuccessLab];
    [lendSuccessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(2);
        make.centerX.equalTo(iconImageView.mas_centerX);
    }];
    
    UIView *splitTopView = [[UIView alloc] init];
    [incomeSatusView addSubview:splitTopView];
    splitTopView.backgroundColor = COLOR_LINE;
    [splitTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.bottom.equalTo(incomeSatusView.mas_top).offset(175);
        make.height.equalTo(@(Line_Height));
    }];
    
    
    UIImageView *buysucessImg = [[UIImageView alloc] init];
    buysucessImg.image = [UIImage imageNamed:@"green_click"];
    [incomeSatusView addSubview:buysucessImg];
    
    [buysucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.top.equalTo(splitTopView.mas_bottom).offset(27);
    }];
    
    UILabel *buySucessLab = [[UILabel alloc] init];
     if ([self.type isEqualToString:@"ZZY"])
     {
            buySucessLab.text = XYBString(@"str_financing_investedZzySuccess", @"成功出借周周盈");
     }else
     {
        if ([self.fromTag isEqualToString:XYBString(@"str_common_cc", @"策诚")]) {
            buySucessLab.text = XYBString(@"str_financing_investedDqbSuccess", @"成功出借定期宝");
        } else {
            buySucessLab.text = [NSString stringWithFormat:XYBString(@"str_financing_investedProductSuccess", @"成功出借%@"), self.fromTag];
        }
     }
    
    buySucessLab.font = [UIFont systemFontOfSize:14.0f];
    buySucessLab.textColor = COLOR_COMMON_BLACK;
    [incomeSatusView addSubview:buySucessLab];
    
    [buySucessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buysucessImg.mas_right).offset(29);
        make.centerY.equalTo(buysucessImg.mas_centerY);
    }];
    
    UILabel *buySucessmoneyLab = [[UILabel alloc] init];
    buySucessmoneyLab.text = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), self.moneyString];
    buySucessmoneyLab.font = [UIFont systemFontOfSize:14.0f];
    buySucessmoneyLab.textColor = COLOR_COMMON_BLACK;
    [incomeSatusView addSubview:buySucessmoneyLab];
    
    [buySucessmoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buySucessLab.mas_right).offset(1);
        make.centerY.equalTo(buysucessImg.mas_centerY);
    }];
    
    UILabel *incomeSatusLab1 = [[UILabel alloc] init];
    incomeSatusLab1.text = XYBString(@"str_financing_today", @"今天");
    incomeSatusLab1.textColor = COLOR_AUXILIARY_GREY;
    incomeSatusLab1.font = [UIFont systemFontOfSize:13.0f];
    [incomeSatusView addSubview:incomeSatusLab1];
    
    [incomeSatusLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buysucessImg.mas_right).offset(29);
        make.top.equalTo(buySucessLab.mas_bottom).offset(6);
    }];
    
    if (self.returnDataDic) {
        NSString *str = [self.returnDataDic objectForKey:@"orderDate"];
        if (![StrUtil isEmptyString:str]) {
            incomeSatusLab1.text =  [NSString stringWithFormat:@"%@",[self.returnDataDic objectForKey:@"orderDate"]];
        }
    }
    
  
    if (([self.fromTag isEqualToString:XYBString(@"str_common_cc", @"策诚")]) || [self.fromTag isEqualToString:XYBString(@"str_common_bbg", @"步步高")] || [self.fromTag isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
        
        UIImageView *startIncomeImg = [[UIImageView alloc] init];
        if ([self.type isEqualToString:@"ZZY"] || [self.fromTag isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
            startIncomeImg.image = [UIImage imageNamed:@"income_start"];
        }else
        {
            startIncomeImg.image = [UIImage imageNamed:@"income_end"];
        }
        [incomeSatusView addSubview:startIncomeImg];
        
        [startIncomeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.top.equalTo(buysucessImg.mas_bottom).offset(35);
        }];
        
        UILabel *startIncomeLab = [[UILabel alloc] init];
        startIncomeLab.textColor = COLOR_MAIN_GREY;
        startIncomeLab.text = XYBString(@"str_lend_startjx", @"开始计息");
        startIncomeLab.font = [UIFont systemFontOfSize:14.0f];
        [incomeSatusView addSubview:startIncomeLab];
        
        [startIncomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(startIncomeImg.mas_right).offset(29);
            make.centerY.equalTo(startIncomeImg.mas_centerY);
        }];
        
        UILabel *incomeSatusLab2 = [[UILabel alloc] init];
        incomeSatusLab2.textColor = COLOR_AUXILIARY_GREY;
        incomeSatusLab2.font = [UIFont systemFontOfSize:13.0f];
        [incomeSatusView addSubview:incomeSatusLab2];
        
        [incomeSatusLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(startIncomeLab.mas_left);
            make.top.equalTo(startIncomeLab.mas_bottom).offset(2);
        }];
        
        if (self.returnDataDic[@"orderDate"]) {
            incomeSatusLab1.text =  [NSString stringWithFormat:@"%@",[self.returnDataDic objectForKey:@"orderDate"]];
        }
        
        if ([self.returnDataDic objectForKey:@"startDate"]) {
            if ([self.type isEqualToString:@"ZZY"] || [self.fromTag isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
                incomeSatusLab2.text = [NSString stringWithFormat:@"%@",[self.returnDataDic objectForKey:@"startDate"]];
            }else
            {
                incomeSatusLab2.text = [NSString stringWithFormat:@"预计 %@",[self.returnDataDic objectForKey:@"startDate"]];
            }
        }
        
        
        UILabel *lineLab1 = [[UILabel alloc] init];
        if ([self.type isEqualToString:@"ZZY"] || [self.fromTag isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
            lineLab1.backgroundColor = COLOR_LINE_GREEN;
        }else
        {
            lineLab1.backgroundColor = COLOR_LINE;
        }

        [incomeSatusView addSubview:lineLab1];
        
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(startIncomeImg.mas_centerX);
            make.top.equalTo(buysucessImg.mas_bottom);
            make.height.equalTo(@35);
            make.width.equalTo(@2);
        }];
        
        
    } else if([self.fromTag isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]){
        
        UILabel *lineLab1 = [[UILabel alloc] init];
        lineLab1.backgroundColor = COLOR_LINE;
        [incomeSatusView addSubview:lineLab1];
        
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(buysucessImg.mas_centerX);
            make.top.equalTo(buysucessImg.mas_bottom);
            make.height.equalTo(@35);
            make.width.equalTo(@2);
        }];
        
        UIImageView *endIncomeImg = [[UIImageView alloc] init];
        endIncomeImg.image = [UIImage imageNamed:@"income_end"];
        [incomeSatusView addSubview:endIncomeImg];
        
        [endIncomeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.top.equalTo(buysucessImg.mas_bottom).offset(35);
        }];
        
        UILabel *endIncomeLab = [[UILabel alloc] init];
        endIncomeLab.text = XYBString(@"str_financing_fullBid_calculateProfit", @"满标当日,开始计息");
        endIncomeLab.font = [UIFont systemFontOfSize:14.0f];
        [incomeSatusView addSubview:endIncomeLab];
        
        [endIncomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(endIncomeImg.mas_right).offset(29);
            make.centerY.equalTo(endIncomeImg.mas_centerY);
        }];

    }
    
    UIView *splitView = [[UIView alloc] init];
    [incomeSatusView addSubview:splitView];
    splitView.backgroundColor = COLOR_LINE;
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.bottom.equalTo(incomeSatusView.mas_bottom).offset(-45);
        make.height.equalTo(@(Line_Height));
    }];
    
    
    XYButton * checkButton = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_financing_checkInvestedProject", @"查看已出借项目") titleColor:COLOR_COMMON_BLACK isUserInteractionEnabled:YES];
    checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    checkButton.titleLabel.font = TEXT_FONT_14;
    checkButton.contentEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
    [checkButton addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [incomeSatusView addSubview:checkButton];
    
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@(0));
        make.top.equalTo(splitView.mas_bottom).offset(1);
        make.height.equalTo(@45);
    }];
    
    UIImageView *cellArrow5 = [[UIImageView alloc] init];
    cellArrow5.image = [UIImage imageNamed:@"cell_arrow"];
    [checkButton addSubview:cellArrow5];
    
    [cellArrow5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(checkButton.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(checkButton.mas_centerY);
    }];
}

/**
 *  第一次请求显示loadingView，第二次不显示
 */
- (void)requestOrderRewordData {
    static BOOL isFirstComing = NO;
    if (isFirstComing == NO) {
        [self showDataLoadingOnAlertView];
        isFirstComing = YES;
    }
    [self requestGetOrderRewordWebService];
}

/**
 *  请求出借成功后的奖励：积分、礼金
 */
- (void)requestGetOrderRewordWebService {
    
    NSDictionary *dict;
    
    if (![StrUtil isEmptyString: self.returnDataDic[@"orderId"]] && ![StrUtil isEmptyString:self.returnDataDic[@"productType"]]) {
        
        dict = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                  @"orderId" : self.returnDataDic[@"orderId"],
                  @"productType" : self.returnDataDic[@"productType"],
                  };
        
    } else {
        
        return; //1.4.1以后添加字段orderId、productType，之前版本均不能请求
    }
    
    NSString *requestURL = [RequestURL getRequestURL:InvestGetOrderRewordURL param:dict];
    [WebService postRequest:requestURL param:dict JSONModelClass:[InvestmentRewardModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        InvestmentRewardModel *investment = responseObject;
        [self hideLoading];
        if (investment.resultCode == 1) {
            
            double firstRewardValue = [investment.firstReward doubleValue];
            double activeRewardValue = [investment.activeReward doubleValue];
            double unfreezeRewardValue = [investment.unfreezeReward doubleValue];
            
            double scoreValue = [investment.score doubleValue];
            
            NSString *firstRewardStr = [NSString stringWithFormat:@"%.2f", firstRewardValue];//投资获得礼金
            NSString *activeRewardStr = [NSString stringWithFormat:@"%.2f", activeRewardValue];//活动获得礼金
            NSString *unfreezeRewardStr = [NSString stringWithFormat:@"%.2f", unfreezeRewardValue];//解冻红包
            NSString *scoreStr = [NSString stringWithFormat:@"%.2f", scoreValue];//投资获得积分
            
            //删除之前创建的视图
            if (ljImageView1) {
                [ljImageView1 removeFromSuperview];
            }
            
            if (ljImageView2) {
                [ljImageView2 removeFromSuperview];
            }
            
            if (cashGiftView3) {
                [cashGiftView3 removeFromSuperview];
            }
            
            if (BottomView) {
                [BottomView removeFromSuperview];
            }
        
            if (firstRewardValue != 0 || activeRewardValue != 0 || scoreValue != 0 || unfreezeRewardValue != 0) {
                
                    [self createCashGiftView1]; //创建礼金-积分视图1（多行的，至少两行）
                    double totalCashGift = firstRewardValue + activeRewardValue + unfreezeRewardValue;
                    
                    if (firstRewardValue == 0) {
                        cashGiftLab1.hidden = YES;
                        [cashGiftLab1 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@0);
                        }];
                    }
                    
                    if (activeRewardValue == 0) {
                        cashGiftLab2.hidden = YES;
                        [cashGiftLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cashGiftLab1.mas_bottom).offset(0);
                            make.height.equalTo(@0);
                        }];
                        [cashGiftLab3 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cashGiftLab2.mas_bottom).offset(5);
                        }];
                    }
                    
                    if (unfreezeRewardValue == 0) {
                        cashGiftLab3.hidden = YES;
                        [cashGiftLab3 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cashGiftLab2.mas_bottom).offset(0);
                            make.height.equalTo(@0);
                        }];
                        [integrationLab4 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cashGiftLab3.mas_bottom).offset(5);
                        }];
                    }
                    
                    if (scoreValue == 0) {
                        integrationLab4.hidden = YES;
                        [integrationLab4 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cashGiftLab3.mas_bottom).offset(0);
                            make.height.equalTo(@0);
                        }];
                    }
                
                    ColorButton * finacingButton =  [self.view viewWithTag:LJTAG];
                    if (totalCashGift > 0) {//礼金大于0 显示下面按钮
                        finacingButton.hidden = NO;
                        
                        [finacingButton mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(45));
                        }];
                    }
                
                    [ljImageView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(scrollView.mas_bottom).offset(-30);
                    }];
                
                    NSString *totalStr = [NSString stringWithFormat:@"%.2f", totalCashGift];
                    NSString * totalOrScore;
                    
                    if ([totalStr doubleValue] > 0 && [scoreStr doubleValue] > 0 ) {
                        
                        totalOrScore = [NSString stringWithFormat:@"%@%@%@",XYBString(@"str_financing_someCash", @"恭喜你，获得"),[NSString stringWithFormat:XYBString(@"str_financing_yuanlj", @"%@元礼金"),[Utility replaceTheNumberForNSNumberFormatter:totalStr]],[NSString stringWithFormat:XYBString(@"str_financing_someIntegral", @"+%@积分"), [Utility replaceTheNumberForNSNumberFormatter:scoreStr]]];
                
                    }else
                    {
                        if ([totalStr doubleValue] > 0) {
                            
                            totalOrScore = [NSString stringWithFormat:@"%@%@",XYBString(@"str_financing_someCash", @"恭喜你，获得"),[NSString stringWithFormat:XYBString(@"str_financing_yuanlj", @"%@元礼金"),[Utility replaceTheNumberForNSNumberFormatter:totalStr]]];
                            
                        }else if ([scoreStr doubleValue] > 0)
                            
                        {
                            totalOrScore = [NSString stringWithFormat:@"%@%@",XYBString(@"str_financing_someCash", @"恭喜你，获得"),[NSString stringWithFormat:XYBString(@"str_financing_someNoIntegral", @"%@积分"),[Utility replaceTheNumberForNSNumberFormatter:scoreStr]]];
                        }
                    }
                    
                    
                    totalCashGiftLab.text = totalOrScore;

                    NSString * cashGift1Str =  [NSString stringWithFormat:XYBString(@"str_financing_firstInvestGetSomeCash", @"• 首次出借得%@元礼金"), [Utility replaceTheNumberForNSNumberFormatter:firstRewardStr]];
                    
                    NSMutableAttributedString *attrabutedStr1 = [[NSMutableAttributedString alloc] initWithString:cashGift1Str];
                    [attrabutedStr1 addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
                    
                    cashGiftLab1.attributedText = attrabutedStr1;
                    
                    
                    NSString * cashGift2Str =  [NSString stringWithFormat:XYBString(@"str_financing_activityGetSomeCash", @"• 活动得%@元礼金"), [Utility replaceTheNumberForNSNumberFormatter:activeRewardStr]];
                    
                    NSMutableAttributedString *attrabutedStr2 = [[NSMutableAttributedString alloc] initWithString:cashGift2Str];
                    [attrabutedStr2 addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
                    
                    cashGiftLab2.attributedText = attrabutedStr2;
                    
                    
                    NSString * cashGift3Str = [NSString stringWithFormat:XYBString(@"str_financing_unfreezeGetSomeCash", @"• 解冻红包得%@元礼金"), [Utility replaceTheNumberForNSNumberFormatter:unfreezeRewardStr]];
                    
                    NSMutableAttributedString *attrabutedStr3 = [[NSMutableAttributedString alloc] initWithString:cashGift3Str];
                    [attrabutedStr3 addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
                    
                    cashGiftLab3.attributedText = attrabutedStr3;
                    

                    NSString * cashGift4Str = [NSString stringWithFormat:XYBString(@"str_financing_investGetSomeIntegral", @"• 出借得%@积分"), [Utility replaceTheNumberForNSNumberFormatter:scoreStr]];
                    
                    NSMutableAttributedString *attrabutedStr4 = [[NSMutableAttributedString alloc] initWithString:cashGift4Str];
                    [attrabutedStr4 addAttributes:@{NSForegroundColorAttributeName:COLOR_LINE_GREY} range:NSMakeRange(0, 1)];
                    integrationLab4.attributedText = attrabutedStr4;
                
            } else {
                
                [self createBottomView]; //加载底部视图显示“系统正在拼命计算您所获得的奖励”
            }
        }
    }
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }];
}

- (void)creatTheHud {
    
    if (!hud) {
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [delegate.window addSubview:hud];
    }
    hud.square = YES;
    [hud show:YES];
}

/*
 *创建礼金-积分视图1（多行的，至少两行）
 */

- (void)createCashGiftView1 {
    ljImageView1 = [[UIView alloc] init]; //礼金券的背景图
    ljImageView1.layer.cornerRadius = Corner_Radius;
    ljImageView1.backgroundColor = COLOR_COMMON_WHITE;
    ljImageView1.userInteractionEnabled = YES;
    [scrollView addSubview:ljImageView1];
    
    UIView *incomeSatusView = [self.view viewWithTag:1000];
    [ljImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.left.equalTo(scrollView.mas_left).offset(Margin_Length);
        make.top.equalTo(incomeSatusView.mas_bottom).offset(20);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-Margin_Bottom);
    }];

    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectZero]; //礼金券中间的虚线
    lineView.backgroundColor = COLOR_LINE;
    [ljImageView1 addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ljImageView1.mas_top).offset(45);
        make.height.equalTo(@(Line_Height));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
    }];
    
    
    totalCashGiftLab = [[UILabel alloc] initWithFrame:CGRectZero]; //礼金Label //积分Label
    totalCashGiftLab.text = XYBString(@"str_financing_zeroCash", @"0元礼金");
    totalCashGiftLab.font = NORMAL_TEXT_FONT_15;
    totalCashGiftLab.textColor = COLOR_COMMON_BLACK;
    [ljImageView1 addSubview:totalCashGiftLab];
    
    [totalCashGiftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(15));
    }];
    
    
    UIView *backGroundView2 = [[UIView alloc] initWithFrame:CGRectZero];
    backGroundView2.backgroundColor = COLOR_COMMON_CLEAR;
    [ljImageView1 addSubview:backGroundView2];
    
    [backGroundView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(13);
        make.left.right.equalTo(lineView);
        make.bottom.equalTo(ljImageView1.mas_bottom).offset(-65);
    }];
    
    cashGiftLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    cashGiftLab1.text = XYBString(@"str_financing_firstInvestGetZeroCash", @"• 首次出借获得0元礼金");
    cashGiftLab1.textColor = COLOR_AUXILIARY_GREY;
    cashGiftLab1.font = SMALL_TEXT_FONT_13;
    [backGroundView2 addSubview:cashGiftLab1];
    
    [cashGiftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backGroundView2);
    }];
    
    cashGiftLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    cashGiftLab2.text = XYBString(@"str_financing_activityGetZeroCash", @"• 活动得0元礼金");
    cashGiftLab2.font = SMALL_TEXT_FONT_13;
    cashGiftLab2.textColor = COLOR_AUXILIARY_GREY;
    [backGroundView2 addSubview:cashGiftLab2];
    
    [cashGiftLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView2.mas_left).offset(0);
        make.top.equalTo(cashGiftLab1.mas_bottom).offset(5);
    }];
    
    cashGiftLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    cashGiftLab3.text = XYBString(@"str_financing_unfreezeGetZeroCash", @"• 解冻红包得0元礼金");
    cashGiftLab3.font = SMALL_TEXT_FONT_13;
    cashGiftLab3.textColor = COLOR_AUXILIARY_GREY;
    [backGroundView2 addSubview:cashGiftLab3];
    
    [cashGiftLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView2.mas_left).offset(0);
        make.top.equalTo(cashGiftLab2.mas_bottom).offset(5);
    }];
    
    integrationLab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    integrationLab4.text = XYBString(@"str_financing_investGetZeroCash", @"• 出借得0积分");
    integrationLab4.font = SMALL_TEXT_FONT_13;
    integrationLab4.textColor = COLOR_AUXILIARY_GREY;
    [backGroundView2 addSubview:integrationLab4];
    
    [integrationLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView2.mas_left).offset(0);
        make.top.equalTo(cashGiftLab3.mas_bottom).offset(5);
        make.bottom.equalTo(backGroundView2.mas_bottom).offset(0);
    }];
    
    
    ColorButton *finacingButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_financing_useCash", @"使用礼金")  ByGradientType:leftToRight];
    finacingButton.tag = LJTAG;
    finacingButton.layer.cornerRadius = 3.f;
    finacingButton.hidden = YES;
    finacingButton.titleLabel.font = TEXT_FONT_16;
    [finacingButton addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ljImageView1 addSubview:finacingButton];
    
    [finacingButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.equalTo(@0);
        make.bottom.equalTo(ljImageView1.mas_bottom);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(0));
    }];
    
}

/*
 *创建礼金-积分视图2（单行的）
 */

- (void)createCashGiftView2 {
    ljImageView2 = [[UIView alloc] init]; //礼金券的背景图
    ljImageView2.userInteractionEnabled = YES;
    ljImageView2.backgroundColor = COLOR_COMMON_WHITE;
    ljImageView2.layer.cornerRadius = Corner_Radius;
    [scrollView addSubview:ljImageView2];
    
    UIView *incomeSatusView = [self.view viewWithTag:1000];
    [ljImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.left.equalTo(scrollView.mas_left).offset(Margin_Length);
        make.top.equalTo(incomeSatusView.mas_bottom).offset(20);
    }];
    
    UIImageView *lj_markView = [[UIImageView alloc] initWithFrame:CGRectZero]; //礼金券右上角的标记
    lj_markView.image = [UIImage imageNamed:@"lj_mark"];
    [ljImageView2 addSubview:lj_markView];
    [lj_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(ljImageView2);
    }];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectZero]; //礼金券中间的虚线
    lineView.backgroundColor = COLOR_LINE;
    [ljImageView2 addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ljImageView2.mas_centerX);
        make.top.equalTo(ljImageView2.mas_top).offset(Margin_Length);
        make.height.equalTo(@30);
        make.width.equalTo(@(Line_Height));
    }];
    
    cashGift_FirstRewardLab = [[UILabel alloc] initWithFrame:CGRectZero]; //礼金Label
    cashGift_FirstRewardLab.text = XYBString(@"str_financing_zeroCash", @"0元礼金") ;
    cashGift_FirstRewardLab.font = TEXT_FONT_18;
    cashGift_FirstRewardLab.textColor = COLOR_STRONG_RED;
    [ljImageView2 addSubview:cashGift_FirstRewardLab];
    
    [cashGift_FirstRewardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.right.equalTo(lineView.mas_left).offset(-19);
    }];
    
    cashGift_FirstRewardLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    cashGift_FirstRewardLab2.text = XYBString(@"str_financing_firstInvestGetTenCash", @"首次出借获得10元礼金");
    cashGift_FirstRewardLab2.textColor = COLOR_AUXILIARY_GREY;
    cashGift_FirstRewardLab2.font = TEXT_FONT_12;
    [ljImageView2 addSubview:cashGift_FirstRewardLab2];
    
    [cashGift_FirstRewardLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(19);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    
    UIButton *finacingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finacingButton setTitle:XYBString(@"str_financing_useCash", @"使用礼金") forState:UIControlStateNormal];
    [finacingButton addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [finacingButton setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [ljImageView2 addSubview:finacingButton];
    
    [finacingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(ljImageView2.mas_bottom);
        make.height.equalTo(@45);
        make.bottom.equalTo(scrollView.mas_bottom);
    }];
}

/**
 *  创建积分视图3（单行的）
 */
- (void)createCashGiftView3 {
    cashGiftView3 = [[UIView alloc] init];
    cashGiftView3.backgroundColor = COLOR_COMMON_WHITE;
    cashGiftView3.layer.cornerRadius = Corner_Radius;
    [scrollView addSubview:cashGiftView3];
    
    UIView *incomeSatusView = [self.view viewWithTag:1000];
    [cashGiftView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.left.equalTo(scrollView.mas_left).offset(Margin_Length);
        make.top.equalTo(incomeSatusView.mas_bottom).offset(20);
        make.width.equalTo(@(MainScreenWidth - 2 * Margin_Length));
        make.height.equalTo(@(94));
        make.bottom.equalTo(scrollView.mas_bottom).offset(-Margin_Bottom);
    }];
    
    cashGift_FirstRewardLab = [[UILabel alloc] initWithFrame:CGRectZero]; //礼金Label
    cashGift_FirstRewardLab.text = XYBString(@"str_financing_zeroIntegral", @"0积分");
    cashGift_FirstRewardLab.font = BIG_TEXT_FONT_17;
    cashGift_FirstRewardLab.textColor = COLOR_INTRODUCE_RED;
    [cashGiftView3 addSubview:cashGift_FirstRewardLab];
    
    [cashGift_FirstRewardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashGiftView3.mas_centerX);
        make.top.equalTo(cashGiftView3.mas_top).offset(27);
    }];
    
    cashGift_FirstRewardLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    cashGift_FirstRewardLab2.text = XYBString(@"str_financing_investGetZeroCash", @"出借获得0积分");
    cashGift_FirstRewardLab2.textColor = COLOR_AUXILIARY_GREY;
    cashGift_FirstRewardLab2.font = SMALL_TEXT_FONT_13;
    [cashGiftView3 addSubview:cashGift_FirstRewardLab2];
    
    [cashGift_FirstRewardLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashGiftView3.mas_centerX);
        make.top.equalTo(cashGift_FirstRewardLab.mas_bottom).offset(9);
    }];
}

/*
 *当礼品积分数据获取不到时，加载底部视图显示“系统正在拼命计算您获得的奖励”
 */
- (void)createBottomView {
    
    BottomView = [[UIView alloc] initWithFrame:CGRectZero];
    BottomView.backgroundColor = COLOR_COMMON_WHITE;
    BottomView.layer.cornerRadius = Corner_Radius;
    [scrollView addSubview:BottomView];
    
    UIView *incomeSatusView = [self.view viewWithTag:1000];
    [BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.width.equalTo(@(MainScreenWidth - 2 * Margin_Length));
        make.top.equalTo(incomeSatusView.mas_bottom).offset(20);
    }];
    
    UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    clockImage.image = [UIImage imageNamed:@"lend_Time"];
    [BottomView addSubview:clockImage];
    
    [clockImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(BottomView.mas_centerX);
        make.top.equalTo(BottomView.mas_top).offset(38);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = XYBString(@"str_financing_systemCalculatingTheReward", @"系统正在拼命计算您获得的奖励");
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    [BottomView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clockImage.mas_bottom).offset(19);
        make.centerX.equalTo(BottomView.mas_centerX);
    }];
    
    UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    subTitleLab.text = XYBString(@"str_financing_rewardSendToAccount", @"所得奖励，将稍后发放到你的账户中");
    subTitleLab.textColor = COLOR_LIGHT_GREY;
    subTitleLab.font = TEXT_FONT_12;
    [BottomView addSubview:subTitleLab];
    
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(9.5);
        make.centerX.equalTo(BottomView.mas_centerX);
        make.bottom.equalTo(BottomView.mas_bottom).offset(-26.5);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-15);
    }];
}

#pragma mark-- 提现成功
- (void)creatTheTropismSuccessView {
    
    UIView *incomeSatusView = [[UIView alloc] init];
    incomeSatusView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:incomeSatusView];
    
    [incomeSatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    UIImageView *buysucessImg = [[UIImageView alloc] init];
    buysucessImg.image = [UIImage imageNamed:@"green_click"];
    [incomeSatusView addSubview:buysucessImg];
    
    [buysucessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@(Margin_Top));
    }];
    
    UILabel *buySucessLab = [[UILabel alloc] init];
    NSString *moneyStr = [NSString stringWithFormat:XYBString(@"str_financing_some_yuan", @"%@元"), [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.moneyString doubleValue]]]];
    NSArray *attrArray = @[
                           @{
                               @"kStr" : XYBString(@"str_financing_txje", @"提现金额"),
                               @"kColor" : COLOR_MAIN_GREY,
                               @"kFont" : TEXT_FONT_16,
                               },
                           @{
                               @"kStr" : moneyStr,
                               @"kColor" : COLOR_STRONG_RED,
                               @"kFont" : TEXT_FONT_16,
                               }
                           
                           ];
    buySucessLab.attributedText = [Utility multAttributedString:attrArray];
    buySucessLab.font = TEXT_FONT_16;
    [incomeSatusView addSubview:buySucessLab];
    
    [buySucessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buysucessImg.mas_right).offset(10);
        make.centerY.equalTo(buysucessImg.mas_centerY);
    }];
    
    UILabel *incomeSatusLab1 = [[UILabel alloc] init];
    incomeSatusLab1.text = XYBString(@"str_financing_today", @"今天");
    incomeSatusLab1.textColor = COLOR_LIGHT_GREY;
    incomeSatusLab1.font = TEXT_FONT_12;
    [incomeSatusView addSubview:incomeSatusLab1];
    
    [incomeSatusLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buysucessImg.mas_right).offset(10);
        make.top.equalTo(buySucessLab.mas_bottom).offset(2);
    }];
    
    UIImageView *startIncomeImg = [[UIImageView alloc] init];
    startIncomeImg.image = [UIImage imageNamed:@"income_end"];
    [incomeSatusView addSubview:startIncomeImg];
    
    [startIncomeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(buysucessImg.mas_bottom).offset(35);
    }];
    
    UILabel *startIncomeLab = [[UILabel alloc] init];
    startIncomeLab.text = XYBString(@"str_financing_toAccountDate", @"预计到账日期");
    startIncomeLab.font = TEXT_FONT_16;
    [incomeSatusView addSubview:startIncomeLab];
    
    [startIncomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startIncomeImg.mas_right).offset(10);
        make.centerY.equalTo(startIncomeImg.mas_centerY);
    }];
    
    UILabel *incomeSatusLab2 = [[UILabel alloc] init];
    incomeSatusLab2.text = XYBString(@"str_financing_oneToThreeDaysToAccount", @"1-3个工作日到账");
    incomeSatusLab2.textColor = COLOR_LIGHT_GREY;
    incomeSatusLab2.font = TEXT_FONT_12;
    [incomeSatusView addSubview:incomeSatusLab2];
    
    [incomeSatusLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startIncomeImg.mas_right).offset(10);
        make.top.equalTo(startIncomeLab.mas_bottom).offset(2);
        make.bottom.equalTo(incomeSatusView.mas_bottom).offset(-Margin_Bottom);
    }];
    
    UILabel *lineLab1 = [[UILabel alloc] init];
    lineLab1.backgroundColor = COLOR_LINE_GREEN;
    [incomeSatusView addSubview:lineLab1];
    
    [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(startIncomeImg.mas_centerX);
        make.top.equalTo(buysucessImg.mas_bottom);
        make.height.equalTo(@17.5);
        make.width.equalTo(@2);
    }];
    
    UILabel *lineLab2 = [[UILabel alloc] init];
    lineLab2.backgroundColor = COLOR_LIGHT_GREY;
    [incomeSatusView addSubview:lineLab2];
    
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLab1);
        make.top.equalTo(lineLab1.mas_bottom).offset(0);
        make.height.equalTo(@17.5);
        make.width.equalTo(@2);
    }];
}

- (void)clickTheButton:(id)sender {

//    self.tabBarController.selectedIndex = 2;
    if ([self.fromTag isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")] || [self.fromTag isEqualToString:XYBString(@"str_common_xtb", @"信投宝")]) {
        XtbInvestListViewController * xtbInvestList = [[XtbInvestListViewController alloc] init];
        [self.tabBarController.selectedViewController pushViewController:xtbInvestList animated:YES];
        
    }else if ([self.fromTag isEqualToString:XYBString(@"str_common_bbg", @"步步高")])
    {
        BbgInvestListViewController * bbgInvestList = [[BbgInvestListViewController alloc] init];
        [self.tabBarController.selectedViewController pushViewController:bbgInvestList animated:YES];
    }else
    {
        DqbInvestListViewController * DqbInvestList = [[DqbInvestListViewController alloc] init];
        [self.tabBarController.selectedViewController pushViewController:DqbInvestList animated:YES];
    }
}

- (void)clickTheUseBtn {
    
    RewardAmountViewController *rewardVC = [[RewardAmountViewController alloc] init];
    [self.navigationController pushViewController:rewardVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
