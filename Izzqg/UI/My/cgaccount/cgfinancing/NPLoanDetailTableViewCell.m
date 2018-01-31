//
//  NPLoanDetailTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPLoanDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@interface NPLoanDetailTableViewCell ()
{
    UIImageView *  projectIconImage; //项目图标
    UILabel     *  titleLab;         //项目名字
    UILabel     *  dateLab;          //日期
    UILabel     *  amountLab;        //金额
    XYButton    *  detailsBtn;       //详情
    XYButton    *  contractBtn;      //合同
    UILabel     *  detailsLab;
    UIView      *  contentView;
    UIView      *  spliteSLine;
    UIView      *  spliteHLine;
}

@end

@implementation NPLoanDetailTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_BG;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = 5.3f;
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.bottom.equalTo(self);
    }];
    
    //项目图标
    projectIconImage = [[UIImageView alloc] init];
    projectIconImage.image = [UIImage imageNamed:@"xtb_xin"];
    [contentView addSubview:projectIconImage];
    [projectIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20.f));
        make.width.height.equalTo(@(18.f));
        make.left.equalTo(@(Margin_Left));
    }];
    
    //项目标题
    titleLab = [[UILabel alloc] init];
    titleLab.font  = TEXT_FONT_16;
    titleLab.text  = @"租房";
    titleLab.textColor = COLOR_TITLE_GREY;
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(projectIconImage.mas_right).offset(9);
        make.centerY.equalTo(projectIconImage.mas_centerY);
    }];
    
    //日期
    dateLab = [[UILabel alloc] init];
    dateLab.font  = TEXT_FONT_12;
    dateLab.text  = @"2010-10-08";
    dateLab.textColor = COLOR_AUXILIARY_GREY;
    [contentView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(6);
    }];
    
    //金额
    amountLab = [[UILabel alloc] init];
    amountLab.font  = TEXT_FONT_14;
    amountLab.text  = @"100.00";
    amountLab.textColor = COLOR_XTB_ORANGE;
    [contentView addSubview:amountLab];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Right));
        make.centerY.equalTo(titleLab.mas_centerY);
    }];
    
    //横线
    spliteHLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteHLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:spliteHLine];
    [spliteHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(75));
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
    }];
    
    //竖线
    spliteSLine = [[UIView alloc] initWithFrame:CGRectZero];
    spliteSLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:spliteSLine];
    [spliteSLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-14));
        make.centerX.equalTo(contentView);
        make.width.equalTo(@(Line_Height));
        make.height.equalTo(@(25.f));
    }];
    
    //详情
    detailsBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [detailsBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [detailsBtn addTarget:self action:@selector(clickDetailsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:detailsBtn];
    
    [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spliteHLine.mas_bottom);
        make.bottom.left.equalTo(contentView);
        make.right.equalTo(spliteSLine.mas_left);
    }];
    
    detailsLab = [[UILabel alloc] init];
    detailsLab.font  = TEXT_FONT_14;
    detailsLab.text  = XYBString(@"str_financing_details", @"详情");
    detailsLab.textColor = COLOR_MAIN;
    [detailsBtn addSubview:detailsLab];
    [detailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(detailsBtn);
    }];
    
    //合同
    contractBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [contractBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_COMMON_CLEAR] forState:UIControlStateNormal];
    [contractBtn addTarget:self action:@selector(clickContractBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:contractBtn];
    
    [contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spliteHLine.mas_bottom);
        make.left.equalTo(spliteSLine.mas_right);
        make.right.bottom.equalTo(contentView);
    }];
    
    UILabel *  contractLab = [[UILabel alloc] init];
    contractLab.font  = TEXT_FONT_14;
    contractLab.text  = XYBString(@"str_product_contract", @"合同");
    contractLab.textColor = COLOR_MAIN;
    [contractBtn addSubview:contractLab];
    [contractLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(contractBtn);
    }];
    
}

-(void)clickDetailsBtn:(id)sender
{
    if (_detaileBlcok) {
        _detaileBlcok(_mathList);
    }
}

-(void)clickContractBtn:(id)sender
{
    if (_contractBlock) {
        _contractBlock(_mathList);
    }
}

-(void)setMathList:(CgMathListModel *)mathList
{
    _mathList = mathList;
    
    [projectIconImage sd_setImageWithURL:[NSURL URLWithString:mathList.assetIcon] placeholderImage:[UIImage imageNamed:@"xtb_xin"]];
    titleLab.text  = mathList.loanTitle;
    dateLab.text   = mathList.matchTime;
    amountLab.text = [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:mathList.matchAmt]];
    
    if ([mathList.hasContract intValue] == 0) {//1:已生成，0:未生成
        
        spliteSLine.hidden = YES;
        contractBtn.hidden = YES;
        
        [detailsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(spliteHLine.mas_bottom);
            make.left.right.bottom.equalTo(contentView);
        }];
        
        [detailsLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(detailsBtn);
        }];
        
    }
}


@end
