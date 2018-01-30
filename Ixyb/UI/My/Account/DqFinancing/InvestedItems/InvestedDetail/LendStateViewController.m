//
//  LendStateViewController.m
//  Ixyb
//
//  Created by wang on 2017/9/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "LendStateViewController.h"
#import "Utility.h"
#import "ColorButton.h"

@interface LendStateViewController ()

@end

@implementation LendStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

}

- (void)initUI {
    
    //导航栏
    self.navigationItem.title             = XYBString(@"str_lend_state", @"出借状态");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    self.view.backgroundColor = COLOR_BG;
    
    UIView * contentView        = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(282));
    }];
    
    
    //出借成功
    UIImageView * imageViewSuccess = [[UIImageView alloc] init];
    imageViewSuccess.image         = [UIImage imageNamed:@"lendstatehight"];
    [contentView addSubview:imageViewSuccess];
    [imageViewSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(28));
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * lendSuccessLab = [[UILabel alloc] init];
    lendSuccessLab.font      = TEXT_FONT_BOLD_15;
    lendSuccessLab.textColor = COLOR_BUT_BLUE;
    lendSuccessLab.text      = XYBString(@"str_lend_success", @"出借成功");
    [contentView addSubview:lendSuccessLab];
    [lendSuccessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewSuccess.mas_top);
        make.left.equalTo(imageViewSuccess.mas_right).offset(Margin_Left);
    }];
    
    UILabel * lendDateLab = [[UILabel alloc] init];
    lendDateLab.font      = SMALL_TEXT_FONT_13;
    lendDateLab.textColor = COLOR_LEND_STATE_GRAY;
    lendDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_success_date", @"%@"),@"2017-07-09"];
    [contentView addSubview:lendDateLab];
    [lendDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lendSuccessLab.mas_bottom).offset(10);
        make.left.equalTo(lendSuccessLab.mas_left);
    }];
    
    UIView * successViewLine = [[UIView alloc] init];
    successViewLine.backgroundColor = COLOR_HAVECAST_GREEN;
    [contentView addSubview:successViewLine];
    [successViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.height.equalTo(@(28));
        make.top.equalTo(imageViewSuccess.mas_bottom);
        make.centerX.equalTo(imageViewSuccess.mas_centerX);
    }];
    
    //开始计息
    UIImageView * imageViewStartJx = [[UIImageView alloc] init];
    imageViewStartJx.image         = [UIImage imageNamed:@"lendstatenormal"];
    [contentView addSubview:imageViewStartJx];
    [imageViewStartJx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewSuccess.mas_bottom).offset(43);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIView * startJxViewLine = [[UIView alloc] init];
    startJxViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:startJxViewLine];
    [startJxViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(successViewLine.mas_bottom);
        make.bottom.equalTo(imageViewStartJx.mas_top);
        make.centerX.equalTo(successViewLine);
    }];
    
    UILabel * startJxLab = [[UILabel alloc] init];
    startJxLab.font      = TEXT_FONT_BOLD_15;
    startJxLab.textColor = COLOR_TITLE_GREY;
    startJxLab.text      = XYBString(@"str_lend_startjx", @"开始计息");
    [contentView addSubview:startJxLab];
    [startJxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewStartJx.mas_top);
        make.left.equalTo(imageViewStartJx.mas_right).offset(Margin_Left);
    }];
    
    UILabel * jxDateLab = [[UILabel alloc] init];
    jxDateLab.font      = SMALL_TEXT_FONT_13;
    jxDateLab.textColor = COLOR_LEND_STATE_GRAY;
    jxDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),@"2017-07-09"];
    [contentView addSubview:jxDateLab];
    [jxDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startJxLab.mas_bottom).offset(9);
        make.left.equalTo(startJxLab.mas_left);
    }];
    
    //赎回
    UIImageView * imageViewRedeem = [[UIImageView alloc] init];
    imageViewRedeem.image         = [UIImage imageNamed:@"lendstatenormal"];
    [contentView addSubview:imageViewRedeem];
    [imageViewRedeem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewStartJx.mas_bottom).offset(43);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIView * redeemViewLine = [[UIView alloc] init];
    redeemViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:redeemViewLine];
    [redeemViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewStartJx.mas_bottom);
        make.bottom.equalTo(imageViewRedeem.mas_top);
        make.centerX.equalTo(imageViewStartJx);
    }];
    
    UILabel * redeemLab = [[UILabel alloc] init];
    redeemLab.font      = TEXT_FONT_BOLD_15;
    redeemLab.textColor = COLOR_TITLE_GREY;
    redeemLab.text      = XYBString(@"str_lend_redeem", @"赎回");
    [contentView addSubview:redeemLab];
    [redeemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewRedeem.mas_top);
        make.left.equalTo(imageViewRedeem.mas_right).offset(Margin_Left);
    }];
    
    UILabel * redeemTipsLab = [[UILabel alloc] init];
    redeemTipsLab.font      = SMALL_TEXT_FONT_13;
    redeemTipsLab.textColor = COLOR_LEND_STATE_GRAY;
    redeemTipsLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_redeem_tips", @"%@"),@"赎回方式为债权转让，赎回期间不计息"];
    [contentView addSubview:redeemTipsLab];
    [redeemTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redeemLab.mas_bottom).offset(9);
        make.left.equalTo(redeemLab.mas_left);
    }];
    
    //结束
    UIImageView * imageViewEnd = [[UIImageView alloc] init];
    imageViewEnd.image         = [UIImage imageNamed:@"lendstatenormal"];
    [contentView addSubview:imageViewEnd];
    [imageViewEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewRedeem.mas_bottom).offset(43);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UIView * endViewLine        = [[UIView alloc] init];
    endViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:endViewLine];
    [endViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewRedeem.mas_bottom);
        make.bottom.equalTo(imageViewEnd.mas_top);
        make.centerX.equalTo(imageViewEnd);
    }];
    
    UILabel * endLab = [[UILabel alloc] init];
    endLab.font      = TEXT_FONT_BOLD_15;
    endLab.textColor = COLOR_TITLE_GREY;
    endLab.text      = XYBString(@"str_lend_redeem_end", @"已结束");
    [contentView addSubview:endLab];
    [endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewEnd.mas_top);
        make.left.equalTo(imageViewEnd.mas_right).offset(Margin_Left);
    }];
    
    
    //底部按钮
    ColorButton * completeButton = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_known", @"知道了")  ByGradientType:leftToRight];
    [completeButton addTarget:self action:@selector(clickKnownButton:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)clickKnownButton:(id)sender
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
