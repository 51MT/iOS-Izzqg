//
//  NPIntroduceViewController.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NPIntroduceViewController.h"
#import "Utility.h"

@interface NPIntroduceViewController ()
{
    XYScrollView * mainScroll;
    UIView       * productOverView; //产品概述
    UIView       * jrxxgzView;      //加入信息规则
    UIView       * fbqView;         //封闭期
    UIView       * zrgzView;        //转让规则
}

@end

@implementation NPIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self createPOverview];
    [self createjxRuleUI];
    [self createFbqView];
    [self createZrgzView];
//    [self createBottomView];
}

#pragma mark -- 初始化 UI
- (void)setNav {
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

//产品概述
-(void)createPOverview
{
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    productOverView = [[UIView alloc] initWithFrame:CGRectZero];
    productOverView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:productOverView];
    
    [productOverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.top.equalTo(@(Margin_Top));
        make.width.equalTo(@(MainScreenWidth));
//        make.height.equalTo(@(147.f));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"cg_cpgs"]];
    [productOverView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(productOverView).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_cpgs", @"产品概述");
    [productOverView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(6);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(productOverView.mas_right);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [productOverView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(productOverView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_14;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.numberOfLines = 0;
    [productOverView addSubview:remaindLab];
    
    NSString *remaindStr = XYBString(@"str_financing_tipscpgs", @"\"一键出借\"是信用宝推出的一键分散出借工具，将用户的出借本金分散到同类型散标集合的各个项目中，并且在用户需要退出时帮助用户快速转让的自动化出借工具。");
    remaindLab.attributedText = [self getAttributedStringWithString:remaindStr color:COLOR_AUXILIARY_GREY font:TEXT_FONT_14 space:6];
    
    CGFloat textHight = [ToolUtil getLabelHightWithLabelStr:remaindStr MaxSize:CGSizeMake(MainScreenWidth - 60, MainScreenHeight) AndFont:14 LineSpace:6.f];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(grayLine.mas_bottom).offset(15);
        make.right.equalTo(productOverView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(textHight + 3));
        make.bottom.equalTo(productOverView.mas_bottom).offset(-Margin_Length);
    }];
}

//加入计息规则
- (void)createjxRuleUI {
    
    jrxxgzView = [[UIView alloc] initWithFrame:CGRectZero];
    jrxxgzView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:jrxxgzView];
    
    [jrxxgzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(129.f));
        make.top.equalTo(productOverView.mas_bottom).offset(15.f);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"joinImage"]];
    [jrxxgzView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(jrxxgzView).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_financing_jrjjxgz", @"加入及计息规则");
    [jrxxgzView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(6);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [jrxxgzView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(jrxxgzView);
        make.height.equalTo(@(Line_Height));
    }];
    
    //100元起投
    UILabel *remaindLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab1.font = TEXT_FONT_14;
    remaindLab1.textColor = COLOR_AUXILIARY_GREY;
    remaindLab1.textAlignment = NSTextAlignmentLeft;
    remaindLab1.numberOfLines = 0;
    remaindLab1.text = XYBString(@"str_financing_100YuanQT", @"100元起投");
    [jrxxgzView addSubview:remaindLab1];
    
    [remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(grayLine.mas_bottom).offset(12);
        make.right.equalTo(jrxxgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [jrxxgzView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab1.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //T（出借日）+1工作日开始计息
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_14;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.numberOfLines = 0;
    remaindLab2.text = XYBString(@"str_financing_gsbmbhdljx", @"各散标满标后独立计息");
    [jrxxgzView addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab1.mas_bottom).offset(6);
        make.right.equalTo(jrxxgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [jrxxgzView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab2.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //计息金额不足1分时,不计入收益
    UILabel *remaindLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab3.font = TEXT_FONT_14;
    remaindLab3.textColor = COLOR_AUXILIARY_GREY;
    remaindLab3.textAlignment = NSTextAlignmentLeft;
    remaindLab3.numberOfLines = 0;
    remaindLab3.text = XYBString(@"str_financing_jxjebz", @"计息金额不足1分时,不计入收益");
    [jrxxgzView addSubview:remaindLab3];
    
    [remaindLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab2.mas_bottom).offset(6);
        make.right.equalTo(jrxxgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_LINE_GREY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [jrxxgzView addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab3.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
}

//封闭期
-(void)createFbqView
{
    fbqView = [[UIView alloc] initWithFrame:CGRectZero];
    fbqView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:fbqView];
    
    [fbqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(jrxxgzView.mas_bottom).offset(15.f);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"cg_jsfbq"]];
    [fbqView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(fbqView).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_account_fbqtips", @"封闭期");
    [fbqView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(6);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [fbqView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(jrxxgzView);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *fbqTipsLab = [[UILabel alloc] initWithFrame:CGRectZero];
    fbqTipsLab.font = TEXT_FONT_14;
    fbqTipsLab.textColor = COLOR_AUXILIARY_GREY;
    fbqTipsLab.textAlignment = NSTextAlignmentLeft;
    fbqTipsLab.numberOfLines = 0;
    fbqTipsLab.text = XYBString(@"str_financing_tipsjh", @"不同期限的散标集合封闭期不同。");
    [fbqView addSubview:fbqTipsLab];
    
    [fbqTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left);
        make.top.equalTo(grayLine.mas_bottom).offset(15.f);
    }];
    
    UIImageView * imageButtom = [[UIImageView alloc] init];
    UIImage *formImage = [UIImage imageNamed:@"cg_buttom"];
    imageButtom.image = formImage;
    [fbqView addSubview:imageButtom];
    
    CGSize imageSize = formImage.size;
    CGFloat imageHight = (MainScreenWidth - 30) /imageSize.width *imageSize.height;
    
    [imageButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fbqTipsLab.mas_left);
        make.top.equalTo(fbqTipsLab.mas_bottom).offset(Margin_Length);
        make.right.equalTo(fbqView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(imageHight));
        make.bottom.equalTo(@(-24.f));
    }];
}

//转让规则
-(void)createZrgzView
{
    zrgzView = [[UIView alloc] initWithFrame:CGRectZero];
    zrgzView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:zrgzView];
    
    [zrgzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(fbqView.mas_bottom).offset(15.f);
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"cg_zrgz"]];
    [zrgzView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(zrgzView).offset(Margin_Length);
        make.width.height.equalTo(@22);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_BOLD_15;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_trans_rule", @"转让规则");
    [zrgzView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(6);
    }];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectZero];
    grayLine.backgroundColor = COLOR_LINE;
    [zrgzView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.right.equalTo(jrxxgzView);
        make.height.equalTo(@(Line_Height));
    }];

    //封闭期内不可转让；
    UILabel *remaindLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab1.font = TEXT_FONT_14;
    remaindLab1.textColor = COLOR_AUXILIARY_GREY;
    remaindLab1.textAlignment = NSTextAlignmentLeft;
    remaindLab1.numberOfLines = 0;
    remaindLab1.text = XYBString(@"str_financing_fbqtips1", @"封闭期内不可转让；");
    [zrgzView addSubview:remaindLab1];
    
    [remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(grayLine.mas_bottom).offset(12);
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab1.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //转让本金必须大于等于1元；
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_14;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.numberOfLines = 0;
    remaindLab2.text = XYBString(@"str_financing_fbqtips2", @"转让本金必须大于等于1元；");
    [zrgzView addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab1.mas_bottom).offset(6);
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab2.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //申请转让后，系统自动匹配受让人完成转让。持有的同一集合散标全部转让成功则转让结束；
    UILabel *remaindLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab3.font = TEXT_FONT_14;
    remaindLab3.textColor = COLOR_AUXILIARY_GREY;
    remaindLab3.textAlignment = NSTextAlignmentLeft;
    remaindLab3.numberOfLines = 0;
    NSString *remaindStr = XYBString(@"str_financing_fbqtips3", @"申请转让后，系统自动匹配受让人完成转让。持有的同一集合散标全部转让成功则转让结束；");
    remaindLab3.attributedText = [self getAttributedStringWithString:remaindStr color:COLOR_AUXILIARY_GREY font:TEXT_FONT_14 space:6];
    [zrgzView addSubview:remaindLab3];
    
    CGFloat textHight = [ToolUtil getLabelHightWithLabelStr:remaindStr MaxSize:CGSizeMake(MainScreenWidth - 73, MainScreenHeight) AndFont:14 LineSpace:6.f];
    
    [remaindLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab2.mas_bottom).offset(6);
        make.height.equalTo(@(textHight + 2));
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_LINE_GREY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab3.mas_top).offset(7.f);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //申请转让后，系统自动匹配受让人完成转让。持有的同一集合散标全部转让成功则转让结束；
    UILabel *remaindLab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab4.font = TEXT_FONT_14;
    remaindLab4.textColor = COLOR_AUXILIARY_GREY;
    remaindLab4.textAlignment = NSTextAlignmentLeft;
    remaindLab4.numberOfLines = 0;
    remaindLab4.text = XYBString(@"str_financing_fbqtips4", @"转让期间正常计息；");
    [zrgzView addSubview:remaindLab4];
    
    [remaindLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab3.mas_bottom).offset(6);
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound4 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound4.backgroundColor = COLOR_LINE_GREY;
    grayRound4.layer.cornerRadius = Circular_WH/2;
    grayRound4.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound4];
    
    [grayRound4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.centerY.equalTo(remaindLab4.mas_centerY);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //申请转让后，系统自动匹配受让人完成转让。持有的同一集合散标全部转让成功则转让结束；
    UILabel *remaindLab5 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab5.font = TEXT_FONT_14;
    remaindLab5.textColor = COLOR_AUXILIARY_GREY;
    remaindLab5.textAlignment = NSTextAlignmentLeft;
    remaindLab5.numberOfLines = 0;
    NSString *remaindStr5 = XYBString(@"str_financing_fbqtips5", @"转让成功时，收取成功转让金额的0.5%(试运行期间免费)；");
    remaindLab5.attributedText = [self getAttributedStringWithString:remaindStr5 color:COLOR_AUXILIARY_GREY font:TEXT_FONT_14 space:6];
    [zrgzView addSubview:remaindLab5];
    
    CGFloat textHight5 = [ToolUtil getLabelHightWithLabelStr:remaindStr5 MaxSize:CGSizeMake(MainScreenWidth - 73, MainScreenHeight) AndFont:14 LineSpace:6.f];
    
    [remaindLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab4.mas_bottom).offset(6);
        make.height.equalTo(@(textHight5 + 2));
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *grayRound5 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound5.backgroundColor = COLOR_LINE_GREY;
    grayRound5.layer.cornerRadius = Circular_WH/2;
    grayRound5.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound5];
    
    [grayRound5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab5.mas_top).offset(7.f);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    UILabel *remaindLab6 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab6.font = TEXT_FONT_14;
    remaindLab6.textColor = COLOR_AUXILIARY_GREY;
    remaindLab6.textAlignment = NSTextAlignmentLeft;
    remaindLab6.numberOfLines = 0;
    NSString *remaindStr6 = XYBString(@"str_financing_cyzqcg12monthmszrsxf", @"持有债权超过12个月，免收转让手续费。");
    remaindLab6.attributedText = [self getAttributedStringWithString:remaindStr6 color:COLOR_AUXILIARY_GREY font:TEXT_FONT_14 space:6];
    [zrgzView addSubview:remaindLab6];
    
    CGFloat textHight6 = [ToolUtil getLabelHightWithLabelStr:remaindStr6 MaxSize:CGSizeMake(MainScreenWidth - 73, MainScreenHeight) AndFont:14 LineSpace:6.f];
    
    [remaindLab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(10);
        make.top.equalTo(remaindLab5.mas_bottom).offset(6);
        make.height.equalTo(@(textHight6 + 2));
        make.right.equalTo(zrgzView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(zrgzView.mas_bottom).offset(-Margin_Length);
    }];
    
    UIView *grayRound6 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound6.backgroundColor = COLOR_LINE_GREY;
    grayRound6.layer.cornerRadius = Circular_WH/2;
    grayRound6.layer.masksToBounds = YES;
    [zrgzView addSubview:grayRound6];
    
    [grayRound6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(0);
        make.top.equalTo(remaindLab6.mas_top).offset(7.f);
        make.width.height.equalTo(@Circular_WH);
    }];
}

/**
 *  @brief 底部安全部分 图片+文字(风险缓释金保障)
 */
- (void)createBottomView {
    
    UIView *tipSafeView = [[UIView alloc] initWithFrame:CGRectZero];
    tipSafeView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:tipSafeView];
    
    [tipSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainScroll);
        make.height.equalTo(@40);
        make.top.equalTo(zrgzView.mas_bottom).offset(0);
        make.bottom.equalTo(mainScroll.mas_bottom);
    }];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectZero];
    [tipSafeView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipSafeView.mas_centerX);
        make.centerY.equalTo(tipSafeView.mas_centerY);
    }];
    
    UIImageView *insureImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *img = [UIImage imageNamed:@"bsj_icon"];
    [insureImageView setImage:img];
    [tipView addSubview:insureImageView];
    
    [insureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(tipView.mas_left).offset(0);
        make.size.mas_equalTo(img.size);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = XYBString(@"str_financing_platformRiskProtectMoney", @"风险缓释金保障");
    tipLab.font = TEXT_FONT_14;
    tipLab.textColor = COLOR_AUXILIARY_GREY;
    [tipView addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_top).offset(0);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
        make.bottom.equalTo(tipView.mas_bottom);
    }];
}

- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)text color:(UIColor *)color font:(UIFont *)font space:(CGFloat)space {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space; // 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : color,
                                 NSFontAttributeName : font
                                 };
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attrStr;
}

#pragma mark -- 点击事件
-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 数据处理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
