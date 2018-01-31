//
//  BbgLendStateViewController.m
//  Ixyb
//
//  Created by wang on 2017/9/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BbgLendStateViewController.h"
#import "Utility.h"
#import "BbgHaveCastDetailModel.h"

@interface BbgLendStateViewController ()

@end

@implementation BbgLendStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

- (void)initUI {
    
    //导航栏
    self.navItem.title             = XYBString(@"str_lend_state", @"出借状态");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    
    self.view.backgroundColor = COLOR_BG;
    
    XYScrollView * scrollView = [[XYScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    BOOL isReback = [self.bbgOrderInfo.isReback boolValue];
    UIView * contentView        = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.width.equalTo(@(MainScreenWidth));
        make.left.right.equalTo(scrollView);
        make.height.equalTo(@(345));
       
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
    lendSuccessLab.textColor = COLOR_MAIN;
    lendSuccessLab.text      = XYBString(@"str_lend_success", @"出借成功");
    [contentView addSubview:lendSuccessLab];
    [lendSuccessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewSuccess.mas_top);
        make.left.equalTo(imageViewSuccess.mas_right).offset(Margin_Left);
    }];
    
    UILabel * lendDateLab = [[UILabel alloc] init];
    lendDateLab.font      = SMALL_TEXT_FONT_13;
    lendDateLab.textColor = COLOR_LEND_STATE_GRAY;
    lendDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_success_date", @"%@"),self.bbgOrderInfo.investDate];
    [contentView addSubview:lendDateLab];
    [lendDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lendSuccessLab.mas_bottom).offset(10);
        make.left.equalTo(lendSuccessLab.mas_left);
    }];
    
    //出成功上半部分线
    UIView * successViewLine = [[UIView alloc] init];
    successViewLine.backgroundColor = COLOR_MAIN;
    [contentView addSubview:successViewLine];
    [successViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewSuccess.mas_bottom);
        make.height.equalTo(@(43/2));
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
    
    //出成功下半部分线
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
    startJxLab.text      = XYBString(@"str_lend_startjx", @"开始计息");
    startJxLab.font      = TEXT_FONT_BOLD_15;
    startJxLab.textColor = COLOR_TITLE_GREY;
    [contentView addSubview:startJxLab];
    [startJxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewStartJx.mas_top);
        make.left.equalTo(imageViewStartJx.mas_right).offset(Margin_Left);
    }];
    
    UILabel * jxDateLab = [[UILabel alloc] init];
    jxDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),self.bbgOrderInfo.interestDate];
    jxDateLab.font      = SMALL_TEXT_FONT_13;
    jxDateLab.textColor = COLOR_LEND_STATE_GRAY;
    [contentView addSubview:jxDateLab];
    [jxDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startJxLab.mas_bottom).offset(9);
        make.left.equalTo(startJxLab.mas_left);
    }];
    
    //申请赎回
    UIView * applyRedeemView = [[UIView alloc] init];
    applyRedeemView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:applyRedeemView];
    [applyRedeemView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageViewStartJx.mas_bottom).offset(43);
        make.height.equalTo(@(63));
        make.left.right.equalTo(contentView);
    }];

    
    UIImageView * imageViewApplyRedeem = [[UIImageView alloc] init];
    imageViewApplyRedeem.image         = [UIImage imageNamed:@"lendstatenormal"];
    [applyRedeemView addSubview:imageViewApplyRedeem];
    [imageViewApplyRedeem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyRedeemView.mas_top);
        make.left.equalTo(@(Margin_Left));
    }];
    
    UILabel * applyredeemLab = [[UILabel alloc] init];
    applyredeemLab.font      = TEXT_FONT_BOLD_15;
    applyredeemLab.textColor = COLOR_TITLE_GREY;
    applyredeemLab.text      = XYBString(@"str_apply_sh", @"申请赎回");
    [applyRedeemView addSubview:applyredeemLab];
    [applyredeemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewApplyRedeem.mas_top);
        make.left.equalTo(imageViewApplyRedeem.mas_right).offset(Margin_Left);
    }];
    
    UILabel * applyRedeemDateLab = [[UILabel alloc] init];
    applyRedeemDateLab.font      = SMALL_TEXT_FONT_13;
    applyRedeemDateLab.textColor = COLOR_LEND_STATE_GRAY;
    applyRedeemDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),[StrUtil isEmptyString:self.bbgOrderInfo.rebackDate] ? @"" : self.bbgOrderInfo.rebackDate];
    [applyRedeemView addSubview:applyRedeemDateLab];
    [applyRedeemDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyredeemLab.mas_bottom).offset(9);
        make.left.equalTo(applyredeemLab.mas_left);
    }];
    
    //申请赎回上线
    UIView * applyTopRedeemViewLine = [[UIView alloc] init];
    applyTopRedeemViewLine.backgroundColor = COLOR_LINE_GREY;
    [applyRedeemView addSubview:applyTopRedeemViewLine];
    [applyTopRedeemViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewApplyRedeem.mas_bottom);
        make.height.equalTo(@(43/2));
        make.centerX.equalTo(imageViewStartJx);
    }];
    
    //申请赎回下线
    UIView * applyButtomRedeemViewLine = [[UIView alloc] init];
    applyButtomRedeemViewLine.backgroundColor = COLOR_LINE_GREY;
    [applyRedeemView addSubview:applyButtomRedeemViewLine];
    [applyButtomRedeemViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(applyTopRedeemViewLine.mas_bottom);
        make.bottom.equalTo(applyRedeemView.mas_bottom);
        make.centerX.equalTo(imageViewStartJx);
    }];
    
    //赎回上线
    UIView * redeemTopViewLine = [[UIView alloc] init];
    redeemTopViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:redeemTopViewLine];
    [redeemTopViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewStartJx.mas_bottom);;
        make.height.equalTo(@(43/2));
        make.centerX.equalTo(imageViewStartJx);
    }];
    
    //赎回
    UIImageView * imageViewRedeem = [[UIImageView alloc] init];
    imageViewRedeem.image         = [UIImage imageNamed:@"lendstatenormal"];
    [contentView addSubview:imageViewRedeem];
    [imageViewRedeem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(applyRedeemView.mas_bottom);
        make.left.equalTo(@(Margin_Left));
    }];
    
    //赎回下线
    UIView * redeemButtomViewLine = [[UIView alloc] init];
    redeemButtomViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:redeemButtomViewLine];
    [redeemButtomViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(redeemTopViewLine.mas_bottom);;
        make.bottom.equalTo(applyRedeemView.mas_top);
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
    
    //已结束上半部分线
    UIView * endTopViewLine        = [[UIView alloc] init];
    endTopViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:endTopViewLine];
    [endTopViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(imageViewRedeem.mas_bottom);
        make.height.equalTo(@(43/2));
        make.centerX.equalTo(imageViewEnd);
    }];
    
    //已结束下半部分线
    UIView * endButtomViewLine        = [[UIView alloc] init];
    endButtomViewLine.backgroundColor = COLOR_LINE_GREY;
    [contentView addSubview:endButtomViewLine];
    [endButtomViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Border_Width_2));
        make.top.equalTo(endTopViewLine.mas_bottom);
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
    
    
    //根据计息时间判断进度条显示 当前时候如果大于等于计息时间 进度条亮 当前时候如果大于等于申请时间 当前时候如果大于等于到账时间 进度条亮
    
    NSDate * currentDate = [DateTimeUtil dateFromString:self.bbgOrderInfo.currentDate];//当前时间
    NSDate * interestDate = [DateTimeUtil dateFromString:self.bbgOrderInfo.interestDate];//计息时间
    
    NSArray *array = [self.bbgOrderInfo.rebackDate componentsSeparatedByString:@" "];
    
    NSDate * rebackDate = [DateTimeUtil dateFromString:array[0]];//申请时间
    NSDate * refundDate = [DateTimeUtil dateFromString:self.bbgOrderInfo.refundDate];//到账时间
    
    
    int satejxDay = [DateTimeUtil compareOneDay:currentDate withAnotherDay:interestDate];
    int sateSqDay = [DateTimeUtil compareOneDay:currentDate withAnotherDay:rebackDate];
    int sateKsDate = [DateTimeUtil compareOneDay:rebackDate withAnotherDay:interestDate];
    int sateDzDay = [DateTimeUtil compareOneDay:currentDate withAnotherDay:refundDate];
    
    if (satejxDay >= 0) {
        
        imageViewStartJx.image = [UIImage imageNamed:@"lendstatehight"];
        startJxViewLine.backgroundColor = COLOR_MAIN;
        startJxLab.textColor = COLOR_MAIN;
        redeemTopViewLine.backgroundColor = COLOR_MAIN;
    }
    
    //已赎回时
    if (isReback == NO) {
        
        //当前时间 大于 申请赎回时间
        if (sateSqDay > 0 || sateKsDate > 0) {
            
            imageViewApplyRedeem.image  = [UIImage imageNamed:@"lendstatehight"];
            applyredeemLab.textColor  = COLOR_MAIN;
            applyTopRedeemViewLine.backgroundColor = COLOR_MAIN;
            redeemButtomViewLine.backgroundColor = COLOR_MAIN;
            startJxLab.text      = XYBString(@"str_lend_startjx", @"开始计息");
            jxDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),self.bbgOrderInfo.interestDate];
            
            applyredeemLab.text      = XYBString(@"str_apply_sh", @"申请赎回");
            applyRedeemDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),[StrUtil isEmptyString:self.bbgOrderInfo.rebackDate] ? @"" : self.bbgOrderInfo.rebackDate];
            
            
        }else
        {
        
            //当前时间 等于 申请赎回时间
            if (sateSqDay == 0) {
                
                imageViewStartJx.image  = [UIImage imageNamed:@"lendstatehight"];
                startJxLab.textColor  = COLOR_MAIN;
                startJxViewLine.backgroundColor = COLOR_MAIN;
                redeemTopViewLine.backgroundColor = COLOR_MAIN;
                
                startJxLab.text      = XYBString(@"str_apply_sh", @"申请赎回");
                jxDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),[StrUtil isEmptyString:self.bbgOrderInfo.rebackDate] ? @"" : self.bbgOrderInfo.rebackDate];
                
                applyredeemLab.text      = XYBString(@"str_lend_startjx", @"开始计息");
                applyRedeemDateLab.text      = [NSString stringWithFormat:XYBString(@"str_lend_jxdate", @"%@"),self.bbgOrderInfo.interestDate];
            }
        }
        
        if (sateDzDay >= 0) {
            
            imageViewRedeem.image  = [UIImage imageNamed:@"lendstatehight"];
            redeemLab.textColor = COLOR_MAIN;
            applyButtomRedeemViewLine.backgroundColor = COLOR_MAIN;
            endTopViewLine.backgroundColor = COLOR_MAIN;
            
        }
    }
    
    //底部按钮
    ColorButton * completeButton = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_known", @"知道了")  ByGradientType:leftToRight];
    [completeButton addTarget:self action:@selector(clickKnownButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:completeButton];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.width.equalTo(@(MainScreenWidth - 30));
        make.height.equalTo(@(Cell_Height));
        make.top.equalTo(contentView.mas_bottom).offset(20);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-Margin_Bottom);
    }];
    
}

-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickKnownButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
