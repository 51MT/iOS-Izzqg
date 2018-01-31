//
//  DqbRebackSuccessViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/4/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DqbRebackSuccessViewController.h"
#import "InvestedDetailDqbViewController.h"
#import "Utility.h"

@interface DqbRebackSuccessViewController ()

@end

@implementation DqbRebackSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    
    self.navItem.title = XYBString(@"str_apply_sh", @"申请赎回");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    self.view.backgroundColor = COLOR_BG;
    
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.cornerRadius = Corner_Radius;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(401));
        make.top.equalTo(self.navBar.mas_bottom).offset(Margin_Top);
        
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
        make.top.equalTo(iconImageView.mas_bottom).offset(2.f);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    UIView * viewTopLine = [[UIView alloc] init];
    viewTopLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:viewTopLine];
    [viewTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(@(175));
        make.height.equalTo(@(Line_Height));
    }];
    
    UIImageView * applyImageView = [[UIImageView alloc] init];
    applyImageView.image = [UIImage imageNamed:@"tipsSuccess"];
    [contentView addSubview:applyImageView];
    [applyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTopLine.mas_bottom).offset(27);
        make.left.equalTo(@(34));
    }];
    
    NSString *title1 = [NSString stringWithFormat:XYBString(@"str_apply_sh_money", @"申请赎回%@元"),self.moneyStr];
    
    UILabel * applyLab = [[UILabel alloc] init];
    applyLab.font = TEXT_FONT_14;
    applyLab.textColor = COLOR_TITLE_GREY;
    applyLab.text =  title1;
    [contentView addSubview:applyLab];
    [applyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyImageView.mas_centerY);
        make.left.equalTo(applyImageView.mas_right).offset(30);
    }];
    
    UILabel * applyDataLab = [[UILabel alloc] init];
    applyDataLab.font = TEXT_FONT_12;
    applyDataLab.textColor = COLOR_NEWADDARY_GRAY;
    applyDataLab.text =  self.applyDate;
    [contentView addSubview:applyDataLab];
    [applyDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyLab.mas_bottom).offset(8);
        make.left.equalTo(applyLab.mas_left);
    }];
    
    
    UIImageView * estimateImageView = [[UIImageView alloc] init];
    estimateImageView.image = [UIImage imageNamed:@"estimatemoney"];
    [contentView addSubview:estimateImageView];
    [estimateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(applyImageView.mas_bottom).offset(58);
        make.left.equalTo(applyImageView.mas_left);
    }];
    
    UIView * estimateView = [[UIView alloc] init];
    estimateView.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:estimateView];
    [estimateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(2));
        make.top.equalTo(applyImageView.mas_bottom);
        make.bottom.equalTo(estimateImageView.mas_top);
        make.centerX.equalTo(applyImageView);
    }];
    
    NSString *subTitle2 = [NSString stringWithFormat:XYBString(@"str_expect_in_account_some", @"预计到账%@元"),self.estimateMoney];
    
    UILabel * estimateLab = [[UILabel alloc] init];
    estimateLab.font = TEXT_FONT_14;
    estimateLab.textColor = COLOR_AUXILIARY_GREY;
    estimateLab.text =  subTitle2;
    [contentView addSubview:estimateLab];
    [estimateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(estimateImageView.mas_centerY);
        make.left.equalTo(estimateImageView.mas_right).offset(30);
    }];
    
    UILabel * endDataLab = [[UILabel alloc] init];
    endDataLab.font = TEXT_FONT_12;
    endDataLab.textColor = COLOR_NEWADDARY_GRAY;
    endDataLab.text =  self.estimateDate;
    [contentView addSubview:endDataLab];
    [endDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(estimateLab.mas_bottom).offset(8);
        make.left.equalTo(estimateLab.mas_left);
    }];
    
    
    UIView * viewButtomLine = [[UIView alloc] init];
    viewButtomLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:viewButtomLine];
    [viewButtomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.bottom.equalTo(@(-90));
        make.height.equalTo(@(Line_Height));
    }];
    
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.backgroundColor = COLOR_COMMON_WHITE;
    completeButton.layer.cornerRadius = Corner_Radius;
    completeButton.layer.borderWidth = Border_Width_2;
    completeButton.layer.borderColor = COLOR_MAIN.CGColor;
    [completeButton addTarget:self action:@selector(clickCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:completeButton];
    [completeButton setTitle:XYBString(@"str_common_complete", @"完成") forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[ColorUtil imageWithColor:COLOR_BUTTON_HIGHLIGHT] forState:UIControlStateHighlighted];
    completeButton.titleLabel.font = TEXT_FONT_16;
    [completeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(60));
        make.right.equalTo(@(-60));
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(@(-19.5));
    }];
}

-(void)clickBackBtn:(id)sender
{
    NSArray *VCArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[VCArray objectAtIndex:VCArray.count - 4] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)clickCompleteButton:(id)sender
{
    NSArray *VCArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[VCArray objectAtIndex:VCArray.count - 4] animated:YES];
}

@end
