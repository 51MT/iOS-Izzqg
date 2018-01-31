//
//  AllianceViewController.m
//  Ixyb
//
//  Created by wang on 15/10/19.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AllianceViewController.h"

#import "FriendRecommendViewController.h"
#import "RequestURL.h"
#import "Utility.h"

#import "CumulativeDataViewController.h"
#import "TodayDataViewController.h"

#import "AllianceRankView.h"
#import "AllianceReportView.h"
#import "AllianceToolView.h"
#import "ShareListModel.h"
#import "UIImageView+WebCache.h"
#import "WebviewViewController.h"
#import "ReturnRecordViewController.h"

@interface AllianceViewController () <AllianceToolViewDelegate> {

    AllianceReportView *reportView;

    NSMutableArray *btnArray;

    UIView *shareView;

    AllianceRankView *rankView;

    AllianceToolView *toolView;
}
@end

@implementation AllianceViewController



- (void)clickTheRightBtn {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_AllianceRules_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_xyblm", @"信用宝联盟");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    btnArray = [[NSMutableArray alloc] init];
    [self creatTheReportView];
    [self creatTheShareView];
    [self creatTheToolView];
    [self creatTheRankView];
    [self creatTheFooterView];
}

- (void)setNav {
    
    [self.view bringSubviewToFront:self.navBar];
    
    self.navItem.title = XYBString(@"str_my_union", @"我的联盟");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:XYBString(@"str_reward_explain", @"奖励说明") forState:UIControlStateNormal];
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 40.0f);
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)clickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTheReportView {

    reportView = [[AllianceReportView alloc] init];
    __weak AllianceViewController *weakSelf = self;
    reportView.clicckTodayButton = ^(void) {
        TodayDataViewController *today = [[TodayDataViewController alloc] init];
        today.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:today animated:YES];
    };

    reportView.clicckCumulativeButton = ^(void) {
        CumulativeDataViewController *cumulativeDat = [[CumulativeDataViewController alloc] init];
        cumulativeDat.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:cumulativeDat animated:YES];
    };
    
    reportView.clicckReturnRecordButton =^(void)
    {
        ReturnRecordViewController * returnRecord = [[ReturnRecordViewController alloc]init];
        returnRecord.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:returnRecord animated:YES];
    };
    
    [self.view addSubview:reportView];
    [reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
    }];
}

- (void)creatTheShareView {
    FriendRecommendViewController *friendRecommendViewController = [[FriendRecommendViewController alloc] init];
    shareView = friendRecommendViewController.view;
    shareView.hidden = YES;
    [self.view addSubview:shareView];
    [self addChildViewController:friendRecommendViewController];

    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
    }];
}

- (void)creatTheToolView {
    toolView = [[AllianceToolView alloc] init];
    toolView.delegate = self;
    toolView.hidden = YES;
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
    }];
}

- (void)creatTheRankView {

    rankView = [[AllianceRankView alloc] init];
    rankView.hidden = YES;
    [self.view addSubview:rankView];
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
    }];
}

- (void)creatTheFooterView {
    UIImageView *buttonViewBackImage = [[UIImageView alloc] init];
    buttonViewBackImage.image = [UIImage imageNamed:@"viewBackImage"];
    buttonViewBackImage.userInteractionEnabled = YES;
    [self.view addSubview:buttonViewBackImage];

    [buttonViewBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    NSArray *buttonArr = @[ XYBString(@"str_chat", @"报表"),
                            XYBString(@"str_get_income", @"赚佣金"),
                            XYBString(@"str_my_union_tool", @"工具包"),
                            XYBString(@"str_my_rank", @"我的排名") ];

    UIButton *customBtn = nil;
    for (int x = 0; x < [buttonArr count]; x++) {
        //        UIImage *imgArrow = [UIImage imageNamed:[[imageArr objectAtIndex:0] objectAtIndex:x]];
        //        UIImage *imgArrow1 = [UIImage imageNamed:[[imageArr objectAtIndex:1] objectAtIndex:x]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[buttonArr objectAtIndex:x] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateSelected];
        [button setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateHighlighted];
        [button setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
        [button setBackgroundImage:[ColorUtil imageWithColor:COLOR_MAIN] forState:UIControlStateSelected];
        //        [button setImage:imgArrow forState:UIControlStateNormal];
        //        [button setImage:imgArrow1 forState:UIControlStateSelected];
        //        [button setImage:imgArrow1 forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickTheSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = x + 100;
        button.titleLabel.font = TEXT_FONT_14;
        [buttonViewBackImage addSubview:button];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(buttonViewBackImage);
            make.width.equalTo(@(MainScreenWidth / [buttonArr count]));
            if (customBtn) {
                make.left.equalTo(customBtn.mas_right);
            } else {
                make.left.equalTo(@0);
            }
        }];
        if (x == 0) {
            button.selected = YES;
        }
        customBtn = button;
        [btnArray addObject:button];

        UIView *viewLine = [[UIView alloc] init];
        viewLine.backgroundColor = COLOR_LINE;
        [buttonViewBackImage addSubview:viewLine];
        [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(buttonViewBackImage);
            make.width.equalTo(@(Line_Height));
            if (customBtn) {
                make.left.equalTo(customBtn.mas_right);
            } else {
                make.left.equalTo(@(MainScreenWidth / [buttonArr count]));
            }
        }];
    }
}

- (void)clickTheSelectBtn:(UIButton *)btn {

    for (UIButton *selectBtn in btnArray) {
        selectBtn.selected = NO;
    }
    btn.selected = YES;
    if (btn.tag == 100) {
        reportView.hidden = NO;
        shareView.hidden = YES;
        toolView.hidden = YES;
        rankView.hidden = YES;
    } else if (btn.tag == 101) {
        reportView.hidden = YES;
        shareView.hidden = NO;
        toolView.hidden = YES;
        rankView.hidden = YES;
    } else if (btn.tag == 102) {
        reportView.hidden = YES;
        shareView.hidden = YES;
        toolView.hidden = NO;
        rankView.hidden = YES;
    } else if (btn.tag == 103) {
        reportView.hidden = YES;
        shareView.hidden = YES;
        toolView.hidden = YES;
        rankView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myUnionToolView:(AllianceToolView *)view didClick:(NSDictionary *)userData {
    ShareModel *item = [userData objectForKey:@"item"];
    UIImageView *imgView = [userData objectForKey:@"imageView"];
    UIImage *shareImage = [UIImage imageNamed:@"default_pic"];
    if (imgView.image) {
        shareImage = imgView.image;
    }
    
    NSString *titleStr = XYBString(@"string_pro_detail", @"活动详情");
    NSString *recommendUrl = [NSString stringWithFormat:@"%@?code=%@&v=%@",item.linkUrl, [UserDefaultsUtil getUser].recommendCode,[ToolUtil getAppVersion]];
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:recommendUrl];
    webView.shareImage = shareImage;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)myUnionToolView:(AllianceToolView *)view didClickShare:(NSDictionary *)userData {
    ShareModel *item = [userData objectForKey:@"item"];
    UIImageView *imgView = [userData objectForKey:@"imageView"];
    NSString *recommendUrl = [NSString stringWithFormat:@"%@?code=%@", item.shareUrl, [UserDefaultsUtil getUser].recommendCode];
    UIImage *shareImage = [UIImage imageNamed:@"default_pic"];
    if (imgView.image) {
        shareImage = imgView.image;
    }
    [UMShareUtil shareUrl:recommendUrl title:item.title content:item.content image:shareImage controller:self];
}

@end
