//
//  CGAccountOpenDialogView.m
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "CGAccountOpenDialogView.h"
#import "Utility.h"

@interface CGAccountOpenDialogView ()

@property (nonatomic, assign) BOOL isLC;//是否理财账户

@end

@implementation CGAccountOpenDialogView

-(id)initWithFrame:(CGRect)frame isLC:(BOOL)isLC
{
    self = [super initWithFrame:frame];
    if (self) {
        _isLC = isLC;
        [self initUI];
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
    }
    return self;
}

-(void)initUI
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.cornerRadius = Corner_Radius + 2;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    UIImageView * xyb_icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    xyb_icon.image = [UIImage imageNamed:@"xyb_Icon"];
    [contentView addSubview:xyb_icon];
    
    [xyb_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(26.f));
        make.top.equalTo(@(25.f));
    }];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:verticalLine];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(18.f));
        make.centerX.equalTo(contentView);
        make.centerY.equalTo(xyb_icon);
        make.width.equalTo(@(Line_Height));
    }];
    
    UIImageView * shBank_icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    shBank_icon.image = [UIImage imageNamed:@"shbank_Icon"];
    [contentView addSubview:shBank_icon];
    
    [shBank_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(24.f);
        make.top.equalTo(xyb_icon.mas_top);
    }];
    
    UILabel * xyborshTipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    xyborshTipsLab.font = TEXT_FONT_16;
    xyborshTipsLab.text = XYBString(@"str_xyborshyh", @"信用宝携手上海银行");
    xyborshTipsLab.textColor = COLOR_MAIN_GREY;
    [contentView addSubview:xyborshTipsLab];
    
    [xyborshTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(xyb_icon.mas_bottom).offset(25.f);
    }];
    
    UILabel * zjaqTipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zjaqTipsLab.textColor = COLOR_AUXILIARY_GREY;
    zjaqTipsLab.textAlignment = NSTextAlignmentCenter;
    zjaqTipsLab.numberOfLines = 0;
    zjaqTipsLab.font = TEXT_FONT_14;
    if (_isLC == YES) {
        zjaqTipsLab.text = XYBString(@"str_cgtipsyh", @"为保证您的资金安全，请先开通存管账户");
    }else{
        zjaqTipsLab.text = XYBString(@"str_cgtipsOpenJKAccount", @"为保证您的资金安全，请先开通借款账户");
    }
    [contentView addSubview:zjaqTipsLab];
    
    [zjaqTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(xyborshTipsLab.mas_bottom).offset(14.f);
    }];
 
    UIView *horizonLine = [[UIView alloc] initWithFrame:CGRectZero];
    horizonLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:horizonLine];
    
    [horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zjaqTipsLab.mas_bottom).offset(27);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];
    
    XYButton *cancelButton = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"string_cancel", @"取消") titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    cancelButton.titleLabel.font = TEXT_FONT_16;
    [cancelButton addTarget:self action:@selector(clickMoreSelectViewCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(horizonLine.mas_bottom);
        make.height.equalTo(@45);
    }];
    
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine2.backgroundColor = COLOR_LINE;
    [contentView addSubview:verticalLine2];
    
    [verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizonLine.mas_bottom);
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(cancelButton.mas_right);
        make.height.equalTo(@(45));
    }];
    
    XYButton *sureButton = [[XYButton alloc] initWithGeneralBtnTitle:XYBString(@"str_gokh", @"去开户") titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    sureButton.titleLabel.font = TEXT_FONT_16;
    [sureButton addTarget:self action:@selector(clickMoreSelectViewSureButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine2.mas_right);
        make.top.equalTo(horizonLine.mas_bottom);
        make.right.equalTo(@0);
        make.height.equalTo(@45);
        make.width.equalTo(cancelButton.mas_width);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

-(void)clickMoreSelectViewCancelButton:(id)sender
{
    [self removeFromSuperview];
    if (_clickCancelBut) {
        _clickCancelBut();
    }
}

-(void)clickMoreSelectViewSureButton:(id)sender
{
    [self removeFromSuperview];
    if (_clickGokhBut) {
        _clickGokhBut();
    }
}
@end
