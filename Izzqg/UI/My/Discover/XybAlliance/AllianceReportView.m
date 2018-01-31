//
//  AllianceReportView.m
//  Ixyb
//
//  Created by wang on 15/10/19.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AllianceReportView.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyUnionResponseModel.h"
#import "RecommendDataModel.h"
#import "WebService.h"

@implementation AllianceReportView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self initData];
        [self setUI];
        [self setupRefresh];
        [self requestTheReportWebServiceWithParam:@{
            @"userId" : [UserDefaultsUtil getUser].userId
        }];
        //        [self requestTheRecommendStatWebServiceWithParam:@{@"type":[NSNumber numberWithInt:1],@"userId" : [UserDefaultsUtil getUser].userId}];
    }
    return self;
}

- (void)initData {
    currentSelectBtnTag = 0;
    btnArray = [[NSMutableArray alloc] init];
    yesterdayDetailArr = [[NSMutableArray alloc] init];
    allDetailArr = [[NSMutableArray alloc] init];
    weekDetailArr = [[NSMutableArray alloc] init];
}

- (void)setUI {

    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@1);
        //        make.width.equalTo(@(MainScreenWidth));
    }];

    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:mainScrollView];

    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_MAIN;
    [mainScrollView addSubview:headerView];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScrollView);
        make.height.equalTo(@100);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UILabel *incomeTitleLab = [[UILabel alloc] init];
    incomeTitleLab.text = XYBString(@"str_my_union_income", @"我的联盟收益(元)");
    incomeTitleLab.font = TEXT_FONT_12;
    incomeTitleLab.textColor = COLOR_COMMON_WHITE;
    [headerView addSubview:incomeTitleLab];

    [incomeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(Margin_Left);
        make.top.equalTo(@20);
    }];
    
    returnRecordBut = [UIButton buttonWithType:UIButtonTypeCustom];
    returnRecordBut.hidden = YES;
    [returnRecordBut setTitle:XYBString(@"return_record", @"返佣记录") forState:UIControlStateNormal];
   [returnRecordBut setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [returnRecordBut setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
    [returnRecordBut setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateHighlighted];
//    [returnRecordBut setTitleColor:COLOR_LIGHT_GREY forState:UIControlStateHighlighted];
    returnRecordBut.titleLabel.font = TEXT_FONT_12;
    returnRecordBut.imageEdgeInsets = UIEdgeInsetsMake(0,25,0,0);
    returnRecordBut.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    [returnRecordBut addTarget:self action:@selector(returnRecordClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:returnRecordBut];
    [returnRecordBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-Margin_Right);
        make.top.equalTo(incomeTitleLab.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(@15);
    }];

    UILabel *incomeLab = [[UILabel alloc] init];
    incomeLab.text = @"0.00";
    incomeLab.tag = 1001;
    incomeLab.font = BORROW_TEXT_FONT_40;
    incomeLab.adjustsFontSizeToFitWidth = YES;
    incomeLab.textAlignment = NSTextAlignmentCenter;
    incomeLab.textColor = COLOR_COMMON_WHITE;
    [headerView addSubview:incomeLab];

    [incomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(incomeTitleLab.mas_bottom).offset(6);
        make.width.equalTo(@(MainScreenWidth - 40));
    }];

    UIView *dataView = [[UIView alloc] init];
    dataView.backgroundColor = COLOR_COMMON_WHITE;
    dataView.layer.cornerRadius = Corner_Radius;
    dataView.layer.masksToBounds = YES;
    [mainScrollView addSubview:dataView];

    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScrollView).offset(Margin_Length);
        make.right.equalTo(mainScrollView).offset(-Margin_Length);
        make.top.equalTo(headerView.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@200);
    }];

    UILabel *todayDataLab = [[UILabel alloc] init];
    todayDataLab.text = XYBString(@"str_data_today", @"今日数据");
    todayDataLab.font = TEXT_FONT_12;
    todayDataLab.textColor = COLOR_AUXILIARY_GREY;
    [dataView addSubview:todayDataLab];

    [todayDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(@Margin_Length);
    }];

    UIButton *todayDataBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayDataBut setTitle:XYBString(@"str_see_details", @"查看详情") forState:UIControlStateNormal];
    [todayDataBut setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [todayDataBut setTitleColor:COLOR_HIGHTBULE_BUTTON forState:UIControlStateHighlighted];
    todayDataBut.titleLabel.font = TEXT_FONT_12;
    [todayDataBut addTarget:self action:@selector(todayDataClick:) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:todayDataBut];
    
    [todayDataBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
        make.top.equalTo(todayDataLab.mas_top);
        make.height.equalTo(@15);
    }];

    UILabel *todayRegisterLab = [[UILabel alloc] init];
    todayRegisterLab.text = @"0";
    todayRegisterLab.adjustsFontSizeToFitWidth = YES;
    todayRegisterLab.font = TEXT_FONT_18;
    todayRegisterLab.textColor = COLOR_MAIN_GREY;
    todayRegisterLab.tag = 1003;
    [dataView addSubview:todayRegisterLab];

    [todayRegisterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(todayDataLab.mas_bottom).offset(17);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];

    [dataView addSubview:verlineImage];
    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.centerY.equalTo(dataView.mas_centerY);
        make.height.equalTo(@1);
    }];

    UILabel *todayRegisterTitleLab = [[UILabel alloc] init];
    todayRegisterTitleLab.text = XYBString(@"str_register_number", @"注册好友(人)");
    todayRegisterTitleLab.font = TEXT_FONT_12;
    todayRegisterTitleLab.textColor = COLOR_LIGHT_GREY;
    [dataView addSubview:todayRegisterTitleLab];

    [todayRegisterTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.bottom.equalTo(verlineImage.mas_top).offset(-Margin_Bottom);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
    }];

    UILabel *todayAmountLab = [[UILabel alloc] init];
    todayAmountLab.text = @"0.00";
    todayAmountLab.tag = 1004;
    todayAmountLab.adjustsFontSizeToFitWidth = YES;
    todayAmountLab.font = TEXT_FONT_18;
    todayAmountLab.textColor = COLOR_ORANGE;
    todayAmountLab.textAlignment = NSTextAlignmentRight;
    [dataView addSubview:todayAmountLab];

    [todayAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(todayDataLab.mas_bottom).offset(17);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
    }];

    UILabel *todayAmountTitleLab = [[UILabel alloc] init];
    todayAmountTitleLab.text = XYBString(@"str_amount_money", @"出借金额(元)");
    todayAmountTitleLab.font = TEXT_FONT_12;
    todayAmountTitleLab.textColor = COLOR_LIGHT_GREY;
    todayAmountTitleLab.textAlignment = NSTextAlignmentRight;
    [dataView addSubview:todayAmountTitleLab];

    [todayAmountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dataView.mas_centerX);
        make.bottom.equalTo(verlineImage.mas_top).offset(-Margin_Bottom);
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
    }];

    UILabel *totalDataLab = [[UILabel alloc] init];
    totalDataLab.text = XYBString(@"str_cumulative", @"累计数据");
    totalDataLab.font = TEXT_FONT_12;
    totalDataLab.textColor = COLOR_AUXILIARY_GREY;
    [dataView addSubview:totalDataLab];

    [totalDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(verlineImage.mas_bottom).offset(Margin_Top);
    }];

    UIButton *totalDataBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [totalDataBut setTitle:XYBString(@"str_see_details", @"查看详情") forState:UIControlStateNormal];
    [totalDataBut setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [totalDataBut setTitleColor:COLOR_HIGHTBULE_BUTTON forState:UIControlStateHighlighted];
    totalDataBut.titleLabel.font = TEXT_FONT_12;
    [totalDataBut addTarget:self action:@selector(totalDataClick:) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:totalDataBut];
    [totalDataBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
        make.top.equalTo(totalDataLab.mas_top);
        make.height.equalTo(@15);
    }];

    UILabel *totalRegisterLab = [[UILabel alloc] init];
    totalRegisterLab.text = @"0";
    totalRegisterLab.tag = 1006;
    totalRegisterLab.adjustsFontSizeToFitWidth = YES;
    totalRegisterLab.font = TEXT_FONT_18;
    totalRegisterLab.textColor = COLOR_MAIN_GREY;
    [dataView addSubview:totalRegisterLab];

    [totalRegisterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(totalDataLab.mas_bottom).offset(17);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
    }];
    
    UILabel *totalRegisterTitleLab = [[UILabel alloc] init];
    totalRegisterTitleLab.text = XYBString(@"str_register_number", @"注册好友(人)");
    totalRegisterTitleLab.font = TEXT_FONT_12;
    totalRegisterTitleLab.textColor = COLOR_LIGHT_GREY;
    [dataView addSubview:totalRegisterTitleLab];

    [totalRegisterTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.bottom.equalTo(dataView.mas_bottom).offset(-Margin_Bottom);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
    }];

    UILabel *totalAmountLab = [[UILabel alloc] init];
    totalAmountLab.text = @"0.00";
    totalAmountLab.adjustsFontSizeToFitWidth = YES;
    totalAmountLab.tag = 1007;
    totalAmountLab.font = TEXT_FONT_18;
    totalAmountLab.textColor = COLOR_ORANGE;
    totalAmountLab.textAlignment = NSTextAlignmentRight;
    [dataView addSubview:totalAmountLab];

    [totalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalDataLab.mas_bottom).offset(17);
        make.width.equalTo(@((MainScreenWidth - 30) / 3));
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
    }];

    UILabel *totalAmountTitleLab = [[UILabel alloc] init];
    totalAmountTitleLab.text = XYBString(@"str_amount_money", @"出借金额(元)");
    totalAmountTitleLab.font = TEXT_FONT_12;
    totalAmountTitleLab.textColor = COLOR_LIGHT_GREY;
    totalAmountTitleLab.textAlignment = NSTextAlignmentRight;
    [dataView addSubview:totalAmountTitleLab];

    [totalAmountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dataView.mas_centerX);
        make.bottom.equalTo(dataView.mas_bottom).offset(-Margin_Bottom);
        make.right.equalTo(dataView.mas_right).offset(-Margin_Right);
    }];
    //
    //    UIImageView *verlineImage1 = [[UIImageView alloc] init];
    //    verlineImage1.image = [UIImage imageNamed:@"onePoint"];
    //
    //    [dataView addSubview:verlineImage1];
    //    [verlineImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(dataView);
    //        make.bottom.equalTo(dataView.mas_bottom).offset(1);
    //        make.height.equalTo(@1);
    //    }];

    UIView *amountView = [[UIView alloc] init];
    amountView.layer.masksToBounds = YES;
    amountView.layer.cornerRadius = Corner_Radius;
    [mainScrollView addSubview:amountView];

    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.top.equalTo(dataView.mas_bottom).offset(15);
        make.height.equalTo(@165);
        make.bottom.equalTo(mainScrollView.mas_bottom).offset(-Margin_Bottom);
    }];

    buttonViewBack = [[UIView alloc] init];
    buttonViewBack.backgroundColor = COLOR_COMMON_WHITE;
    [amountView addSubview:buttonViewBack];

    [buttonViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(amountView);
        make.height.equalTo(@48);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [buttonViewBack addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonViewBack.mas_bottom);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@2);
    }];

    NSArray *buttonArr = @[ XYBString(@"str_yestoday", @"昨日"), XYBString(@"str_last_7_days", @"7天"), XYBString(@"str_last_30_days", @"30天"), XYBString(@"str_total", @"总计") ];
    UIButton *customBtn = nil;
    for (int x = 0; x < 4; x++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[buttonArr objectAtIndex:x] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        [button setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickTheDataBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = x + 300;
        [amountView addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(buttonViewBack);
            make.width.equalTo(@((MainScreenWidth - 60) / 4));
            if (customBtn) {
                make.left.equalTo(customBtn.mas_right);
            } else {
                make.left.equalTo(@15);
            }
        }];
        if (x == 0) {
            button.selected = YES;
            selectLab = [[UILabel alloc] init];
            selectLab.backgroundColor = COLOR_MAIN;
            [buttonViewBack addSubview:selectLab];
            [buttonViewBack bringSubviewToFront:selectLab];
            [selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonViewBack).offset(Margin_Left);
                make.top.equalTo(buttonViewBack.mas_bottom).offset(-2);
                make.height.equalTo(@2);
                make.width.equalTo(@((MainScreenWidth - 60) / 4));
            }];
        }
        customBtn = button;
        [btnArray addObject:customBtn];
    }

    repoetView = [[ReportView alloc] init];
    [amountView addSubview:repoetView];
    [repoetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(amountView);
        make.top.equalTo(buttonViewBack.mas_bottom);
        make.height.equalTo(@(155));
    }];
}

- (void)roleButtonClickHandler:(id)sender {
    if (self.clicckRoleButton) {
        self.clicckRoleButton();
    }
}

- (void)clickTheDataBtn:(UIButton *)btn {

    for (UIButton *button in btnArray) {
        button.selected = NO;
    }
    btn.selected = YES;

    [UIView animateWithDuration:0.5 animations:^{
        [selectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_left);
            make.top.equalTo(buttonViewBack.mas_bottom).offset(-2);
            make.height.equalTo(@2);
            make.width.equalTo(@((MainScreenWidth - 60) / 4));
        }];
    }
        completion:^(BOOL finished){

        }];

    currentSelectBtnTag = (int) btn.tag - 300;
    [self setDataForRepoetView:currentSelectBtnTag];
}

- (void)setDataForRepoetView:(int)selectBtnTag {
    int type;
    switch (selectBtnTag) {
        case 0: {
            type = 1;
        } break;
        case 1: {
            type = 2;
        } break;
        case 2: {
            type = 4;
        } break;
        case 3: {
            type = 3;
        } break;
        default:
            break;
    }

    [self requestTheRecommendStatWebServiceWithParam:@{ @"type" : [NSNumber numberWithInt:type],
                                                        @"userId" : [UserDefaultsUtil getUser].userId }];
    //    if (selectBtnTag == 0) {
    //        if (yesterdayDetailArr.count > 0) {
    //            if (yesterdayDetailArr.count > 1) {
    //                repoetView.report1 = [yesterdayDetailArr objectAtIndex:0];
    //                repoetView.report2 = [yesterdayDetailArr objectAtIndex:1];
    //            } else {
    //                repoetView.report1 = [yesterdayDetailArr objectAtIndex:0];
    //                repoetView.report2 = nil;
    //            }
    //        } else {
    //            repoetView.report1 = nil;
    //            repoetView.report2 = nil;
    //        }
    //
    //    } else if (selectBtnTag == 1) {
    //        if (weekDetailArr.count > 0) {
    //            if (weekDetailArr.count > 1) {
    //                repoetView.report1 = [weekDetailArr objectAtIndex:0];
    //                repoetView.report2 = [weekDetailArr objectAtIndex:1];
    //            } else {
    //                repoetView.report1 = [weekDetailArr objectAtIndex:0];
    //                repoetView.report2 = nil;
    //            }
    //        } else {
    //            repoetView.report1 = nil;
    //            repoetView.report2 = nil;
    //        }
    //
    //    } else if (selectBtnTag == 2) {
    //        if (allDetailArr.count > 0) {
    //            if (allDetailArr.count > 1) {
    //                repoetView.report1 = [allDetailArr objectAtIndex:0];
    //                repoetView.report2 = [allDetailArr objectAtIndex:1];
    //            } else {
    //                repoetView.report1 = [allDetailArr objectAtIndex:0];
    //            }
    //        } else {
    //            repoetView.report1 = nil;
    //            repoetView.report2 = nil;
    //        }
    //    }
}

- (void)reloadTheDataForLab:(MyUnionResponseModel *)model {

    UILabel *lab1 = (UILabel *) [self viewWithTag:1001];
    UILabel *lab2 = (UILabel *) [self viewWithTag:1002];
    UILabel *lab3 = (UILabel *) [self viewWithTag:1003];
    UILabel *lab4 = (UILabel *) [self viewWithTag:1004];
    UILabel *lab5 = (UILabel *) [self viewWithTag:1005];
    UILabel *lab6 = (UILabel *) [self viewWithTag:1006];
    UILabel *lab7 = (UILabel *) [self viewWithTag:1007];

    lab1.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.recommendIncome]];
    if ([lab1.text doubleValue] == 0) {
        lab1.text = @"0.00";
    }
    
    if (model.userType == 2) {//客户经理
        returnRecordBut.hidden = NO;
    } else {
        returnRecordBut.hidden = YES;
    }

    //    NSDictionary *todayStatDic = [dic objectForKey:@"todayStat"];
    lab2.text = [NSString stringWithFormat:@"%d", model.todayStat.hits];
    lab3.text = [NSString stringWithFormat:@"%d", model.todayStat.registerNum];
    lab4.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.todayStat.totalAmount]];
    if ([lab4.text doubleValue] == 0) {
        lab4.text = @"0.00";
    }
    //    NSDictionary *allStatDic = [dic objectForKey:@"allStat"];
    lab5.text = [NSString stringWithFormat:@"%d", model.allStat.hits];
    lab6.text = [NSString stringWithFormat:@"%d", model.allStat.registerNum];
    lab7.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", model.allStat.totalAmount]];
    if ([lab7.text doubleValue] == 0) {
        lab7.text = @"0.00";
    }
}

#pragma mark - 设置刷新的方法

- (void)setupRefresh {
    mainScrollView.header = self.gifHeader3;
}

- (void)headerRereshing {
    [yesterdayDetailArr removeAllObjects];
    [allDetailArr removeAllObjects];
    [weekDetailArr removeAllObjects];
    [self requestTheReportWebServiceWithParam:@{
                                                @"userId" : [UserDefaultsUtil getUser].userId
                                                }];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.0f];
}

- (void)endRefresh {
    [mainScrollView.header endRefreshing];
}

/****************************10.1	信用宝联盟申请******************************/

- (void)requestTheRecommendStatWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:UserRecommendlStatURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[RecommendDataModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weekDetailArr removeAllObjects];
        [self hideLoading];
        RecommendDataModel *responseModel = responseObject;
        [weekDetailArr addObjectsFromArray:responseModel.recommendData];
        repoetView.report1 = [weekDetailArr objectAtIndex:0];
        repoetView.report2 = [weekDetailArr objectAtIndex:1];

        for (UIButton *button in btnArray) {
            if (button.selected) {
                currentSelectBtnTag = (int) button.tag - 300;
                break;
            }
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)requestTheReportWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:MyUnionTheReportURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[MyUnionResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideLoading];
        MyUnionResponseModel *responseModel = responseObject;
        [self reloadTheDataForLab:responseModel];

        [allDetailArr addObjectsFromArray:responseModel.allDetail];
        [yesterdayDetailArr addObjectsFromArray:responseModel.yesterdayDetail];
        //        [weekDetailArr addObjectsFromArray:responseModel.weekDetail];

        for (UIButton *button in btnArray) {
            if (button.selected) {
                currentSelectBtnTag = (int) button.tag - 300;
                break;
            }
        }

        [self setDataForRepoetView:currentSelectBtnTag];

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

/**
 *  今日 查看详情
 */
- (void)todayDataClick:(UIButton *)but {
    if (self.clicckTodayButton) {
        self.clicckTodayButton();
    }
}

/**
 *
 */
-(void)returnRecordClick:(id)sender
{
    if (self.clicckReturnRecordButton) {
        self.clicckReturnRecordButton();
    }
}

/**
 *  累计 查看详情
 */
- (void)totalDataClick:(UIButton *)but {
    if (self.clicckCumulativeButton) {
        self.clicckCumulativeButton();
    }
}

@end
