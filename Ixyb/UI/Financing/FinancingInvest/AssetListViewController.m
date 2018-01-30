//
//  BidConsistViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/3/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "AssetListViewController.h"
#import "Utility.h"
#import "NotAssetListView.h"
#import "AssetListView.h"
#import "ZqzrDetailViewController.h"
#import "XtbProductDetailViewController.h"
#import "XsdProductDetailViewController.h"
#import "HnbProductDetailViewController.h"
#import "RrcProductDetailViewController.h"
#import "ZglProductDetailViewController.h"

@interface AssetListViewController ()<UIScrollViewDelegate> {
    
    XYButton *leftBtn;          //待匹配资产
    XYButton *rightBtn;         //已匹配资产
    UILabel *blueBottom;        //蓝色的切换指示器
    XYScrollView *mainScroll;
    NotAssetListView *notAssetView;//待匹配资产视图
    AssetListView *assetView;   //已匹配资产视图
    
    int currentScrollPage;      //记录当前页
}

@end

@implementation AssetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createTheTopUI];
    [self createTheTableView];
}

#pragma mark - 创建UI

- (void)createNav {
    self.navItem.title = XYBString(@"str_financing_bidContains", @"标的组成");
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
}

- (void)createTheTopUI {
    self.view.backgroundColor = COLOR_BG;
    
    //未匹配资产
    leftBtn = [[XYButton alloc] initWithCustomerButtonTitle:XYBString(@"str_financing_willMatchAssets", @"待匹配资产")];
    leftBtn.titleLabel.font = TEXT_FONT_16;
    leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftBtn setBackgroundColor:COLOR_COMMON_WHITE];
    [leftBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    
    leftBtn.selected = YES;
    [leftBtn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth/2));
        make.height.equalTo(@(45));
    }];
    
    //已匹配资产
    rightBtn = [[XYButton alloc] initWithCustomerButtonTitle:XYBString(@"str_financing_MatchAssets", @"已匹配资产")];
    rightBtn.titleLabel.font = TEXT_FONT_16;
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn setBackgroundColor:COLOR_COMMON_WHITE];
    [rightBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(self.navBar.mas_bottom);
        make.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth/2));
        make.height.equalTo(@(45));
    }];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [rightBtn addSubview:verticalLine];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Line_Height * 2));
        make.centerY.equalTo(rightBtn);
        make.left.equalTo(rightBtn.mas_left).offset(Line_Height/2);
        make.height.equalTo(@25);
    }];
    
    //蓝色的切换指示器
    blueBottom = [[UILabel alloc] initWithFrame:CGRectZero];
    blueBottom.backgroundColor = COLOR_MAIN;
    [self.view addSubview:blueBottom];
    
    [blueBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftBtn);
        make.top.equalTo(leftBtn.mas_bottom);
        make.height.equalTo(@3);
        make.width.equalTo(@90);
    }];
}


/**
 创建待匹配资产列表 + 已匹配资产列表
 */
- (void)createTheTableView {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.contentSize = CGSizeMake(MainScreenWidth*2, MainScreenHeight - 48 - 64);
    mainScroll.pagingEnabled = YES;
    mainScroll.showsHorizontalScrollIndicator = NO;
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(leftBtn.mas_bottom).offset(3);
    }];
    
    AssetListViewController *weakSelf = self;
    
    notAssetView = [[NotAssetListView alloc] initWithFrame:CGRectZero state:self.state productType:self.productType projectId:self.projectId amountStr:self.amountStr];
    [mainScroll addSubview:notAssetView];
    
    [notAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 48 - 64));
    }];
    
    //cell点击后回调，统一跳转到信投保详情界面
    notAssetView.complete = ^(NSDictionary *params) {
        
        NSString *matchType = [params objectForKey:@"matchType"];
        int loanType = [[params objectForKey:@"loanType"] intValue];
        NSString *productId = [params objectForKey:@"projectId"];
        NSString * subType = [params objectForKey:@"subType"];
        
        // loanType   4 信农贷   5格莱珉 6信闪贷  7人人车  8租葛亮
   
        if (loanType == 6) {//信闪贷
            XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
            xsdProductDetail.productId = productId;
            [weakSelf.navigationController pushViewController:xsdProductDetail animated:YES];
            
        } else if (loanType == 4) {//惠农宝
            HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
            hnbProductDetail.productId = productId;
            [weakSelf.navigationController pushViewController:hnbProductDetail animated:YES];
            
        } else if (loanType == 7) {//人人车
            
            RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
            rrcProductDetail.productId = productId;
            rrcProductDetail.loanType =  [StrUtil isEmptyString:[params objectForKey:@"loanType"]] ? @"" : [params objectForKey:@"loanType"];
            rrcProductDetail.matchType = matchType;
            rrcProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            [weakSelf.navigationController pushViewController:rrcProductDetail animated:YES];
            
        }else if (loanType == 8) {//租葛亮
            
            ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
            zglProductDetail.productId = productId;
            zglProductDetail.loanType =   [StrUtil isEmptyString:[params objectForKey:@"loanType"]] ? @"" : [params objectForKey:@"loanType"];
            zglProductDetail.matchType = matchType;
            zglProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            [weakSelf.navigationController pushViewController:zglProductDetail animated:YES];
            
        }else if ([matchType isEqualToString:@"REBACK"]) {//债权转让
            ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
            zqzrDetailVC.productId = productId;
            zqzrDetailVC.matchType = matchType;
            zqzrDetailVC.isMatching = YES;
            [weakSelf.navigationController pushViewController:zqzrDetailVC animated:YES];
            
        }else{//信投宝
            XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
            xtbProductDetail.productId = productId;
            xtbProductDetail.matchType = matchType;
            xtbProductDetail.isMatching = 1;
            [weakSelf.navigationController pushViewController:xtbProductDetail animated:YES];
        }
    };
    
    assetView = [[AssetListView alloc] initWithFrame:CGRectZero state:self.state productType:self.productType projectId:self.projectId];
    [mainScroll addSubview:assetView];
    
    [assetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notAssetView.mas_right);
        make.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 48 - 64));
    }];
    
    //cell点击后回调，统一跳转到信投保详情界面
    assetView.complete = ^(NSDictionary *params) {
        
        NSString *matchType = [params objectForKey:@"matchType"];
        int loanType = [[params objectForKey:@"loanType"] intValue];
        NSString *productId = [params objectForKey:@"projectId"];
        NSString * subType = [params objectForKey:@"subType"];
        
        if (loanType == 6) {//信闪贷
            XsdProductDetailViewController *xsdProductDetail = [[XsdProductDetailViewController alloc] init];
            xsdProductDetail.productId = productId;
            [weakSelf.navigationController pushViewController:xsdProductDetail animated:YES];
            
        } else if (loanType == 4) {//惠农宝
            HnbProductDetailViewController *hnbProductDetail = [[HnbProductDetailViewController alloc] init];
            hnbProductDetail.productId = productId;
            [weakSelf.navigationController pushViewController:hnbProductDetail animated:YES];
            
        } else if (loanType == 7) {//人人车
            
            RrcProductDetailViewController *rrcProductDetail = [[RrcProductDetailViewController alloc] init];
            rrcProductDetail.productId = productId;
            rrcProductDetail.loanType =  [StrUtil isEmptyString:[params objectForKey:@"loanType"]] ? @"" : [params objectForKey:@"loanType"];
            rrcProductDetail.matchType = matchType;
            rrcProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            [weakSelf.navigationController pushViewController:rrcProductDetail animated:YES];
            
        }else if (loanType == 8) {//租葛亮
            
            ZglProductDetailViewController *zglProductDetail = [[ZglProductDetailViewController alloc] init];
            zglProductDetail.productId = productId;
            zglProductDetail.loanType =   [StrUtil isEmptyString:[params objectForKey:@"loanType"]] ? @"" : [params objectForKey:@"loanType"];
            zglProductDetail.matchType = matchType;
            zglProductDetail.subType = [StrUtil isEmptyString:subType] ? @"" : subType;
            [weakSelf.navigationController pushViewController:zglProductDetail animated:YES];
            
        }else if ([matchType isEqualToString:@"REBACK"]) {//债权转让
            
            ZqzrDetailViewController *zqzrDetailVC = [[ZqzrDetailViewController alloc] init];
            zqzrDetailVC.productId = productId;
            zqzrDetailVC.matchType = matchType;
            zqzrDetailVC.isMatching = YES;
            [weakSelf.navigationController pushViewController:zqzrDetailVC animated:YES];
            
        }else {//信投宝
            XtbProductDetailViewController *xtbProductDetail = [[XtbProductDetailViewController alloc] init];
            xtbProductDetail.productId = productId;
            xtbProductDetail.matchType = matchType;
            xtbProductDetail.isMatching = 1;
            [weakSelf.navigationController pushViewController:xtbProductDetail animated:YES];
        }
    };
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:mainScroll]) {
        
        CGFloat pageWidth = MainScreenWidth;
        int page = floor((mainScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page >= 2) {
            return;
        }
        
        if (page != currentScrollPage) {
            //数据请求
            [self reloadDataWithCurrentScrollPage:page];
        }
        
        currentScrollPage = page;
        
        if (currentScrollPage == 0) {
            leftBtn.selected = YES;
            rightBtn.selected = NO;
            
        }else if (currentScrollPage == 1) {
            rightBtn.selected = YES;
            leftBtn.selected = NO;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            if (currentScrollPage == 0) {
                [blueBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(leftBtn.mas_centerX);
                    make.top.equalTo(leftBtn.mas_bottom);
                    make.height.equalTo(@3);
                    make.width.equalTo(@90);
                }];
                
            }else if (currentScrollPage == 1) {
                [blueBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(rightBtn.mas_centerX);
                    make.top.equalTo(rightBtn.mas_bottom);
                    make.height.equalTo(@3);
                    make.width.equalTo(@90);
                }];
            }
        }];
    }
}


#pragma mark - 响应事件

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 待匹配按钮、已匹配按钮点击事件
 
 @param sender 待匹配按钮、已匹配按钮
 */
- (void)clickHeaderBtn:(id)sender {
    
    XYButton *button = (XYButton *)sender;
    //待匹配资产按钮
    if ([button isEqual:leftBtn]) {
        leftBtn.selected = YES;
        rightBtn.selected = NO;
        currentScrollPage = 0;
        mainScroll.contentOffset = CGPointMake(MainScreenWidth * currentScrollPage, 0);
    }
    
    //已匹配资产按钮
    if ([button isEqual:rightBtn]) {
        rightBtn.selected = YES;
        leftBtn.selected = NO;
        currentScrollPage = 1;
        mainScroll.contentOffset = CGPointMake(MainScreenWidth * currentScrollPage, 0);
    }
    
    [self reloadDataWithCurrentScrollPage:currentScrollPage];
    
    [UIView animateWithDuration:0.5 animations:^{
        if ([button isEqual:leftBtn]) {
            [blueBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(leftBtn.mas_centerX);
                make.top.equalTo(leftBtn.mas_bottom);
                make.height.equalTo(@3);
                make.width.equalTo(@90);
            }];
        }else if ([button isEqual:rightBtn]) {
            [blueBottom mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(rightBtn.mas_centerX);
                make.top.equalTo(rightBtn.mas_bottom);
                make.height.equalTo(@3);
                make.width.equalTo(@90);
            }];
        }
    }];
}


/**
 根据滚动页scrollPage判断当前页面，然后请求数据
 
 @param scrollPage 等于0：待匹配资产列表 1：已匹配资产列表
 */
- (void)reloadDataWithCurrentScrollPage:(int)scrollPage {
    if (scrollPage == 0) {
        [notAssetView headerRereshing];
        
    }else if (scrollPage == 1) {
        [assetView headerRereshing];
    }
}

@end
