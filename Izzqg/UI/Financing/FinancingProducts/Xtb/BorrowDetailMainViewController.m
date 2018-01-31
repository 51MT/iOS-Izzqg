//
//  BorrowDetailMainViewController.m
//  Ixyb
//
//  Created by wang on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "BorrowDetailMainViewController.h"
#import "ProjectIntroduceView.h"
#import "BorrowMessagegeView.h"
#import "Utility.h"

@interface BorrowDetailMainViewController ()<UIScrollViewDelegate>
{
    UIView       *   headerView;
    XYScrollView *   mainScrollView;
    NSArray *nameArr; //按钮上的title;
    UILabel *selectLab;
    int currentScrollPage;
    CGFloat fontWidth; //字体宽度，iOS10的字体宽度有变化
    NSMutableArray *btnArray;
    ProjectIntroduceView * introduceView;  //项目介绍
    BorrowMessagegeView  * messageView;    //借款人信息
    BorrowMessagegeView  * fkshView;       //风控审核
}

@end

@implementation BorrowDetailMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self creatTheHeaderView];
    [self creatTheMainScrollView];
    [self creatTheNpView];
    [self creatBorrowMessageView];
    [self creatfkshView];
}

#pragma mark - 创建UI

- (void)setNav {
    
    self.navItem.title = XYBString(@"str_financing_loanDetails", @"借款详情");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
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
    
    btnArray = [[NSMutableArray alloc] init];
    
    nameArr = @[XYBString(@"str_financing_projrctjs", @"项目介绍"),
                XYBString(@"str_financing_borrowerInformation", @"借款人信息"),
                XYBString(@"str_financing_fksh", @"风控审核")];
    
    
    
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

#pragma mark - 创建项目介绍

- (void)creatTheNpView {
    
    introduceView = [[ProjectIntroduceView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:introduceView];
    
    if (_xtbDetailModel) {
        introduceView.productInfo = _xtbDetailModel.product;
    }
    
    if (_bidDetailModel) {
        introduceView.productModel = _bidDetailModel.product;
    }
    
    [introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainScrollView);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 101.f));
    }];
}

#pragma mark - 创建借款人信息

- (void)creatBorrowMessageView {
    
    messageView = [[BorrowMessagegeView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - 41)];
    [mainScrollView addSubview:messageView];
    
    if (_xtbDetailModel) {
        messageView.dataSource = [[NSMutableArray alloc] initWithArray:_xtbDetailModel.borrowerInfo];
    }
    
    if (_bidDetailModel) {
        messageView.dataSource = [[NSMutableArray alloc] initWithArray:_bidDetailModel.borrowerInfo];
    }
    
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView);
        make.left.equalTo(introduceView.mas_right);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 101.f));
    }];
}

#pragma mark - 创建风控审核

- (void)creatfkshView {
    
    fkshView = [[BorrowMessagegeView alloc] initWithFrame:CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - 41)];
    
    [mainScrollView addSubview:fkshView];
    
    if (_xtbDetailModel) {
        fkshView.dataSource = [[NSMutableArray alloc] initWithArray:_xtbDetailModel.riskControlInfo];
    }
    
    if (_bidDetailModel) {
        fkshView.dataSource = [[NSMutableArray alloc] initWithArray:_bidDetailModel.riskControlInfo];
    }
    
    [fkshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView);
        make.left.equalTo(messageView.mas_right);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 101.f));
    }];
}

#pragma mark - 事件处理

//返回

-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

/**
 *  切换视图刷新显示数据
 *
 *  @param currentViewPage 当前页数
 */
- (void)reloadTheDataForChangeView:(int)currentViewPage {
    

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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:mainScrollView]) {
        
        CGFloat pageWidth = MainScreenWidth;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page >= nameArr.count) {
            return;
        }
        
        if (page != currentScrollPage) {
      
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
