//
//  ProjectIntroduceView.m
//  Ixyb
//
//  Created by wang on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "ProjectIntroduceView.h"
#import "Utility.h"

#define LABWIDTH  78.f

@interface ProjectIntroduceView () {
    
    UILabel * projectNameLab;        //项目名称
    
    UILabel * projectJjLab;          //项目简介
    UILabel * projectJeLab;          //项目金额
    UILabel * projectQxLab;          //项目期限
    
    UILabel * qtJeLab;               //起投金额
    UILabel * nhjklxLab;             //年化借款利率
    UILabel * yjjxrLab;              //预计计息日
    
    UILabel * hkFsLab;               //还款方式
    UILabel * projectStateLab;       //项目状态
    UILabel * jkJdLab;               //借款进度
    
    UILabel * xgFyLab;               //相关费用
    UILabel * zjytLab;               //资金用途
    UILabel * hkLyLab;               //还款来源
    
    UILabel * xeGlLab;               //限额管理
    UILabel * hkbzCsLab;             //还款保障措施
    
   
   
}
@end

@implementation ProjectIntroduceView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = COLOR_BG;
    }
    return self;
}

-(void)initUI
{
    XYScrollView *  mainScorllview = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:mainScorllview];
    [mainScorllview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(MainScreenWidth));
    }];
    

    UIView * projectNameView = [[UIView alloc] initWithFrame:CGRectZero];
    projectNameView.backgroundColor = COLOR_COMMON_WHITE;
    projectNameView.layer.cornerRadius = 4.f;
    [mainScorllview addSubview:projectNameView];
    
    [projectNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(10.f));
        make.right.equalTo(@(-10.f));
        make.width.equalTo(@(MainScreenWidth-20.f));
    }];
    
    UILabel * tipsProjectName = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsProjectName.font = BIG_TEXT_FONT_17;
    tipsProjectName.textColor = COLOR_MAIN_GREY;
    tipsProjectName.text = XYBString(@"str_financing_projectName", @"项目名称");
    [projectNameView addSubview:tipsProjectName];
    
    [tipsProjectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(22.f));
        make.left.equalTo(@(Margin_Left));
    }];
    
    projectNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectNameLab.font = SMALL_TEXT_FONT_13;
    projectNameLab.textColor = COLOR_XTB_ORANGE;
    projectNameLab.text = @"信闪贷——消费贷款（项目编号：2017010212145）";
    projectNameLab.numberOfLines = 0;
    [projectNameView addSubview:projectNameLab];
    
    [projectNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsProjectName.mas_bottom).offset(18.f);
        make.right.equalTo(@(-Margin_Right));
        make.bottom.equalTo(@(-Margin_Bottom));
        make.left.equalTo(tipsProjectName.mas_left);
    }];
    
    
    UIView * projectJJView = [[UIView alloc] initWithFrame:CGRectZero];
    projectJJView.backgroundColor = COLOR_COMMON_WHITE;
    projectJJView.layer.cornerRadius = 4.f;
    [mainScorllview addSubview:projectJJView];
    
    [projectJJView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectNameView.mas_bottom).offset(10.f);
        make.left.equalTo(@(10.f));
        make.height.equalTo(@(427.f));
        make.right.equalTo(@(-10.f));
        make.width.equalTo(@(MainScreenWidth-20.f));
        make.bottom.equalTo(mainScorllview.mas_bottom);
    }];
    
    UILabel * tipsProjectJjName = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsProjectJjName.font = BIG_TEXT_FONT_17;
    tipsProjectJjName.textColor = COLOR_MAIN_GREY;
    tipsProjectJjName.text = XYBString(@"str_financing_projectJj", @"项目简介");
    [projectJJView addSubview:tipsProjectJjName];
    
    [tipsProjectJjName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(22.f));
        make.left.equalTo(@(Margin_Left));
    }];
    
    projectJjLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectJjLab.font = SMALL_TEXT_FONT_13;
    projectJjLab.textColor = COLOR_AUXILIARY_GREY;
    projectJjLab.numberOfLines = 0;
    projectJjLab.text = @"融资方于2017年11月29日申请融资用于经营（融资方保证按照借款用途使用资金";
    [projectJJView addSubview:projectJjLab];
    
    [projectJjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsProjectJjName.mas_bottom).offset(18.f);
        make.left.equalTo(tipsProjectJjName.mas_left);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UILabel * tipsProjectJeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsProjectJeLab.font = SMALL_TEXT_FONT_13;
    tipsProjectJeLab.textColor = COLOR_AUXILIARY_GREY;
    tipsProjectJeLab.text = XYBString(@"str_financing_projectJe", @"项目金额");
    [projectJJView addSubview:tipsProjectJeLab];
    
    [tipsProjectJeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectJjLab.mas_bottom).offset(22.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    projectJeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectJeLab.font = SMALL_TEXT_FONT_13;
    projectJeLab.textColor = COLOR_AUXILIARY_GREY;
    projectJeLab.text = @"0.00 元";
    [projectJJView addSubview:projectJeLab];
    
    [projectJeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsProjectJeLab.mas_centerY);
        make.left.equalTo(tipsProjectJeLab.mas_right).offset(37.f);
    }];
    
    
    UILabel * tipsProjectQxLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsProjectQxLab.font = SMALL_TEXT_FONT_13;
    tipsProjectQxLab.textColor = COLOR_AUXILIARY_GREY;
    tipsProjectQxLab.text = XYBString(@"str_financing_projectQx", @"项目期限");
    [projectJJView addSubview:tipsProjectQxLab];
    
    [tipsProjectQxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsProjectJeLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    projectQxLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectQxLab.font = SMALL_TEXT_FONT_13;
    projectQxLab.textColor = COLOR_AUXILIARY_GREY;
    projectQxLab.text = @"1个月";
    [projectJJView addSubview:projectQxLab];
    
    [projectQxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsProjectQxLab.mas_centerY);
        make.left.equalTo(tipsProjectQxLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsQtjeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsQtjeLab.font = SMALL_TEXT_FONT_13;
    tipsQtjeLab.textColor = COLOR_AUXILIARY_GREY;
    tipsQtjeLab.text = XYBString(@"bbg_minimumMoney", @"起投金额");
    [projectJJView addSubview:tipsQtjeLab];
    
    [tipsQtjeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsProjectQxLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    qtJeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    qtJeLab.font = SMALL_TEXT_FONT_13;
    qtJeLab.textColor = COLOR_AUXILIARY_GREY;
    qtJeLab.text = @"100元";
    [projectJJView addSubview:qtJeLab];
    
    [qtJeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsQtjeLab.mas_centerY);
        make.left.equalTo(tipsQtjeLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsNhjklxLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsNhjklxLab.font = SMALL_TEXT_FONT_13;
    tipsNhjklxLab.textColor = COLOR_AUXILIARY_GREY;
    tipsNhjklxLab.text = XYBString(@"str_financing_nhjklv", @"年化借款利率");
    [projectJJView addSubview:tipsNhjklxLab];
    
    [tipsNhjklxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsQtjeLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    nhjklxLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nhjklxLab.font = SMALL_TEXT_FONT_13;
    nhjklxLab.textColor = COLOR_AUXILIARY_GREY;
    nhjklxLab.text = @"12%";
    [projectJJView addSubview:nhjklxLab];
    
    [nhjklxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsNhjklxLab.mas_centerY);
        make.left.equalTo(tipsNhjklxLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsYjjxrLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsYjjxrLab.font = SMALL_TEXT_FONT_13;
    tipsYjjxrLab.textColor = COLOR_AUXILIARY_GREY;
    tipsYjjxrLab.text = XYBString(@"str_financing_yjjxr", @"预计计息日");
    [projectJJView addSubview:tipsYjjxrLab];
    
    [tipsYjjxrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsNhjklxLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    yjjxrLab = [[UILabel alloc] initWithFrame:CGRectZero];
    yjjxrLab.font = SMALL_TEXT_FONT_13;
    yjjxrLab.textColor = COLOR_AUXILIARY_GREY;
    yjjxrLab.text = @"满标当日";
    [projectJJView addSubview:yjjxrLab];
    
    [yjjxrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsYjjxrLab.mas_centerY);
        make.left.equalTo(tipsYjjxrLab.mas_right).offset(37.f);
    }];
    
    
    UILabel * tipsHkFsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsHkFsLab.font = SMALL_TEXT_FONT_13;
    tipsHkFsLab.textColor = COLOR_AUXILIARY_GREY;
    tipsHkFsLab.text = XYBString(@"string_back_money_type", @"还款方式");
    [projectJJView addSubview:tipsHkFsLab];
    
    [tipsHkFsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsYjjxrLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    hkFsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    hkFsLab.font = SMALL_TEXT_FONT_13;
    hkFsLab.textColor = COLOR_AUXILIARY_GREY;
    hkFsLab.text = @"等额本息";
    [projectJJView addSubview:hkFsLab];
    
    [hkFsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsHkFsLab.mas_centerY);
        make.left.equalTo(tipsHkFsLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsProjectStateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsProjectStateLab.font = SMALL_TEXT_FONT_13;
    tipsProjectStateLab.textColor = COLOR_AUXILIARY_GREY;
    tipsProjectStateLab.text = XYBString(@"str_financing_projectState", @"项目状态");
    [projectJJView addSubview:tipsProjectStateLab];
    
    [tipsProjectStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsHkFsLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    projectStateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    projectStateLab.font = SMALL_TEXT_FONT_13;
    projectStateLab.textColor = COLOR_AUXILIARY_GREY;
    projectStateLab.text = @"借款中";
    [projectJJView addSubview:projectStateLab];
    
    [projectStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsProjectStateLab.mas_centerY);
        make.left.equalTo(tipsProjectStateLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipskJdLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipskJdLab.font = SMALL_TEXT_FONT_13;
    tipskJdLab.textColor = COLOR_AUXILIARY_GREY;
    tipskJdLab.text = XYBString(@"str_financing_borrowjd", @"借款进度");
    [projectJJView addSubview:tipskJdLab];
    
    [tipskJdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsProjectStateLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    jkJdLab = [[UILabel alloc] initWithFrame:CGRectZero];
    jkJdLab.font = SMALL_TEXT_FONT_13;
    jkJdLab.textColor = COLOR_AUXILIARY_GREY;
    jkJdLab.text = @"10%";
    [projectJJView addSubview:jkJdLab];
    
    [jkJdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipskJdLab.mas_centerY);
        make.left.equalTo(tipskJdLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsXgFyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsXgFyLab.font = SMALL_TEXT_FONT_13;
    tipsXgFyLab.textColor = COLOR_AUXILIARY_GREY;
    tipsXgFyLab.text = XYBString(@"str_financing_xgfy", @"相关费用");
    [projectJJView addSubview:tipsXgFyLab];
    
    [tipsXgFyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipskJdLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    xgFyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    xgFyLab.font = SMALL_TEXT_FONT_13;
    xgFyLab.textColor = COLOR_AUXILIARY_GREY;
    xgFyLab.text = @"无";
    [projectJJView addSubview:xgFyLab];
    
    [xgFyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsXgFyLab.mas_centerY);
        make.left.equalTo(tipsXgFyLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsZjytLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsZjytLab.font = SMALL_TEXT_FONT_13;
    tipsZjytLab.textColor = COLOR_AUXILIARY_GREY;
    tipsZjytLab.text = XYBString(@"str_financing_zjyt", @"资金用途");
    [projectJJView addSubview:tipsZjytLab];
    
    [tipsZjytLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsXgFyLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    zjytLab = [[UILabel alloc] initWithFrame:CGRectZero];
    zjytLab.font = SMALL_TEXT_FONT_13;
    zjytLab.textColor = COLOR_AUXILIARY_GREY;
    zjytLab.text = @"租房";
    [projectJJView addSubview:zjytLab];
    
    [zjytLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsZjytLab.mas_centerY);
        make.left.equalTo(tipsZjytLab.mas_right).offset(37.f);
    }];
    
    UILabel * tipsHkLyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsHkLyLab.font = SMALL_TEXT_FONT_13;
    tipsHkLyLab.textColor = COLOR_AUXILIARY_GREY;
    tipsHkLyLab.text = XYBString(@"str_financing_hkly", @"还款来源");
    [projectJJView addSubview:tipsHkLyLab];
    
    [tipsHkLyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsZjytLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    hkLyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    hkLyLab.font = SMALL_TEXT_FONT_13;
    hkLyLab.textColor = COLOR_AUXILIARY_GREY;
    hkLyLab.numberOfLines = 0;
    hkLyLab.text = @"融资方拥有稳当的工作收入以偿还借款";
    [projectJJView addSubview:hkLyLab];
    
    [hkLyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipsHkLyLab.mas_centerY);
        make.left.equalTo(tipsHkLyLab.mas_right).offset(37.f);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UILabel * tipsXeGlLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsXeGlLab.font = SMALL_TEXT_FONT_13;
    tipsXeGlLab.textColor = COLOR_AUXILIARY_GREY;
    tipsXeGlLab.text = XYBString(@"str_financing_xegl", @"限额管理");
    [projectJJView addSubview:tipsXeGlLab];
    
    [tipsXeGlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hkLyLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    xeGlLab = [[UILabel alloc] initWithFrame:CGRectZero];
    xeGlLab.font = SMALL_TEXT_FONT_13;
    xeGlLab.textColor = COLOR_AUXILIARY_GREY;
    xeGlLab.numberOfLines = 0;
    xeGlLab.text = @"融资方该笔借款没有超过监管要求的借款余额上限";
    [projectJJView addSubview:xeGlLab];
    
    [xeGlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsXeGlLab.mas_top);
        make.left.equalTo(tipsXeGlLab.mas_right).offset(37.f);
        make.right.equalTo(@(-Margin_Right));
    }];
    
    UILabel * tipsHkbzCsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsHkbzCsLab.font = SMALL_TEXT_FONT_13;
    tipsHkbzCsLab.textColor = COLOR_AUXILIARY_GREY;
    tipsHkbzCsLab.text = XYBString(@"str_financing_hkbzcs", @"还款保障措施");
    [projectJJView addSubview:tipsHkbzCsLab];
    
    [tipsHkbzCsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xeGlLab.mas_bottom).offset(5.f);
        make.width.equalTo(@(85.f));
        make.left.equalTo(projectJjLab.mas_left);
    }];
    
    hkbzCsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    hkbzCsLab.font = SMALL_TEXT_FONT_13;
    hkbzCsLab.textColor = COLOR_AUXILIARY_GREY;
    hkbzCsLab.numberOfLines = 0;
    hkbzCsLab.text = @"该项目无抵押、质押、保证、保险措施";
    [projectJJView addSubview:hkbzCsLab];
    
    [hkbzCsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsHkbzCsLab.mas_top);
        make.left.equalTo(tipsHkbzCsLab.mas_right).offset(37.f);
        make.right.equalTo(@(-Margin_Right));
    }];
}


-(void)setProductInfo:(BidProduct *)productInfo
{
    NSInteger loanType = [productInfo.ptype integerValue];
    NSString * strProjectTitle;
    if(loanType== 4){
        strProjectTitle = @"惠农宝-";
    }else if(loanType== 5){
        strProjectTitle = @"格莱珉-";
    }else if(loanType== 6){
        strProjectTitle = @"信闪贷-";
    }else if(loanType== 7){
        strProjectTitle = @"人人车-";
    }else if(loanType==8){
        strProjectTitle = @"诸葛亮-";
    }else {
        strProjectTitle = @"信投宝-";
    }
    
    projectNameLab.text  =  [NSString stringWithFormat:@"%@%@(项目编号:%@)",strProjectTitle,productInfo.title,productInfo.loanId];
    projectJjLab.text    =  productInfo.productDescription;
    projectJeLab.text    =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:productInfo.bidRequestAmount]];
    projectQxLab.text    =  [NSString stringWithFormat:@"%@", productInfo.monthes2ReturnStr];
    qtJeLab.text         =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:productInfo.minBidAmount]];
    float rate = [productInfo.baseRate floatValue] * 100;
    nhjklxLab.text       =  [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",rate]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    hkFsLab.text         =  productInfo.returnTypeString;
    projectStateLab.text =  productInfo.loanStateStr;
    
    
    jkJdLab.text    =   [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[productInfo.bidProgressRate floatValue]]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    zjytLab.text    =   productInfo.purpose;
}

-(void)setProductModel:(NPBidProductModel *)productModel {
    
    _productModel = productModel;
    
    NSInteger loanType = [productModel.ptype integerValue];
    NSString * strProjectTitle;
    if(loanType== 4){
        strProjectTitle = @"惠农宝-";
    }else if(loanType== 5){
        strProjectTitle = @"格莱珉-";
    }else if(loanType== 6){
        strProjectTitle = @"信闪贷-";
    }else if(loanType== 7){
        strProjectTitle = @"人人车-";
    }else if(loanType==8){
        strProjectTitle = @"诸葛亮-";
    }else {
        strProjectTitle = @"信投宝-";
    }
    
    projectNameLab.text  =  [NSString stringWithFormat:@"%@%@(项目编号:%@)",strProjectTitle,_productModel.title,_productModel.loanId];
    projectJjLab.text    =  _productModel.descrip;
    projectJeLab.text    =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:_productModel.bidRequestAmount]];
    projectQxLab.text    =  [NSString stringWithFormat:@"%@", _productModel.monthes2ReturnStr];
    qtJeLab.text         =  [NSString stringWithFormat:@"%@元",[Utility replaceTheNumberForNSNumberFormatter:_productModel.minBidAmount]];
    float rate = [_productModel.baseRate floatValue] * 100;
    nhjklxLab.text       =  [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",rate]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    hkFsLab.text         =  _productModel.returnTypeString;
    projectStateLab.text =  _productModel.loanStateStr;
    
    
    jkJdLab.text    =   [[Utility rateReplaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f",[productModel.bidProgressRate floatValue] * 100]] stringByAppendingString:XYBString(@"str_financing_percentSymbol", @"%")];
    zjytLab.text    =   _productModel.purpose;
}


@end
