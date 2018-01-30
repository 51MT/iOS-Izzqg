//
//  DqbRebackSuccessViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/4/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DqbRebackSuccessViewController.h"
#import "InvestedDetailDqbViewController.h"
#import "ColorButton.h"
#import "Utility.h"

@interface DqbRebackSuccessViewController ()

@end

@implementation DqbRebackSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    
    self.navigationItem.title = XYBString(@"str_apply_sh", @"申请赎回");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    self.view.backgroundColor = COLOR_BG;
    
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(265));
        make.top.equalTo(@(10));
        
    }];
    
    UIImageView * iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"redeemsuccess"];
    [contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(contentView.mas_top).offset(29);
    }];
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.font = FONT_TEXT_20;
    titleLab.textColor = COLOR_CHU_ORANGE;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:XYBString(@"str_apply_date_money", @"申请赎回%@元"),self.moneyStr]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TITLE_GREY range:NSMakeRange(0, 4)];
    titleLab.attributedText = attributedStr;
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(21.f);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    UIImageView * applyImageView = [[UIImageView alloc] init];
    applyImageView.image = [UIImage imageNamed:@"applyredeem"];
    [contentView addSubview:applyImageView];
    [applyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(35);
        make.left.equalTo(@(Margin_Left));
    }];
    
    NSString *title1 = [NSString stringWithFormat:XYBString(@"str_apply_sh_money", @"%@申请赎回%@元"),self.applyDate,self.moneyStr];
    
    UILabel * applyLab = [[UILabel alloc] init];
    applyLab.font = NORMAL_TEXT_FONT_15;
    applyLab.textColor = COLOR_TITLE_GREY;
    applyLab.text =  title1;
    [contentView addSubview:applyLab];
    [applyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyImageView.mas_centerY);
        make.left.equalTo(applyImageView.mas_right).offset(10);
    }];
    
    
    UIView * applyView = [[UIView alloc] init];
    applyView.backgroundColor = COLOR_HAVECAST_GREEN;
    [contentView addSubview:applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(2));
        make.height.equalTo(@(12));
        make.top.equalTo(applyImageView.mas_bottom);
        make.centerX.equalTo(applyImageView.mas_centerX);
    }];
    
    UIImageView * estimateImageView = [[UIImageView alloc] init];
    estimateImageView.image = [UIImage imageNamed:@"estimatemoney"];
    [contentView addSubview:estimateImageView];
    [estimateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-32);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIView * estimateView = [[UIView alloc] init];
    estimateView.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:estimateView];
    [estimateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(2));
        make.top.equalTo(applyView.mas_bottom);
        make.bottom.equalTo(estimateImageView.mas_top);
        make.centerX.equalTo(applyView);
    }];
    
    NSString *subTitle2 = [NSString stringWithFormat:XYBString(@"str_expect_in_account_some", @"%@预计到账%@元"),self.estimateDate ,self.estimateMoney];
    
    UILabel * estimateLab = [[UILabel alloc] init];
    estimateLab.font = NORMAL_TEXT_FONT_15;
    estimateLab.textColor = COLOR_LIGHT_GREY;
    estimateLab.text =  subTitle2;
    [contentView addSubview:estimateLab];
    [estimateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(estimateImageView.mas_centerY);
        make.left.equalTo(estimateImageView.mas_right).offset(10);
    }];
    
    
    ColorButton * completeButton = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_common_complete", @"完成")  ByGradientType:leftToRight];
    [completeButton addTarget:self action:@selector(clickCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(contentView.mas_bottom).offset(20);
    }];
}

-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)clickCompleteButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
