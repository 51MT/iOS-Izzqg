//
//  NPInvestResultViewController.m
//  Ixyb
//
//  Created by DzgMac on 2018/1/2.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "NPInvestResultViewController.h"
#import "Utility.h"
#import "Masonry.h"
#import "NPInvestedListViewController.h"

@interface NPInvestResultViewController () {
    
    UIImageView *_proImageview1;
    UIView *_verticalLine;
    UIImageView *_proImageview2;
    
    UILabel *_remaindLab1;
    UILabel *_timeLab1;
    
    UILabel *_remaindLab2;
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *loanTime;
@property (nonatomic,strong) NPinvestResModel *model;

@end

@implementation NPInvestResultViewController

#pragma mark - 自定义初始化方法

- (instancetype)initWithName:(NSString *)name loanTime:(NSString *)loanTime model:(NPinvestResModel *)model {
    self = [super init];
    if (self) {
        _name = name;
        _loanTime = loanTime;
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createMainUI];
}

#pragma mark - 创建UI

- (void)setNav {
    self.navItem.title = @"出借结果";
}

- (void)createMainUI {
    
    XYScrollView *mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    mainScroll.backgroundColor = COLOR_BG;
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectZero];
    backview.backgroundColor = COLOR_COMMON_WHITE;
    backview.layer.cornerRadius = Corner_Radius;
    backview.layer.masksToBounds = YES;
    [mainScroll addSubview:backview];
    
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(mainScroll).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redeemsuccess"]];
    [backview addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backview.mas_top).offset(24);
        make.centerX.equalTo(backview.mas_centerX);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_19;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = @"出借成功";
    [backview addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(2);
    }];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLab.font = TEXT_FONT_14;
    tipLab.textColor = COLOR_AUXILIARY_GREY;
    tipLab.text = @"系统正在为你匹配项目";
    [backview addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLab);
        make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
    }];
    
    UIView *horizonLine = [[UIView alloc] initWithFrame:CGRectZero];
    horizonLine.backgroundColor = COLOR_LINE;
    [backview addSubview:horizonLine];
    
    [horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backview.mas_left).offset(Margin_Length);
        make.right.equalTo(backview.mas_right).offset(-Margin_Length);
        make.top.equalTo(tipLab.mas_bottom).offset(35);
        make.height.equalTo(@(Line_Height));
    }];
    
    //进度条
    UIImage *image = [UIImage imageNamed:@"tipsSuccess"];
    UIImage *grayImage = [UIImage imageNamed:@"estimatemoney"];
    
    _proImageview1 = [[UIImageView alloc] initWithImage:image];
    [backview addSubview:_proImageview1];
    
    [_proImageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backview.mas_left).offset(15);
        make.top.equalTo(horizonLine.mas_bottom).offset(33);
        make.width.height.equalTo(@(22));
    }];
    
    _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    _verticalLine.backgroundColor = COLOR_LINE;
    [backview addSubview:_verticalLine];
    
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_proImageview1.mas_bottom);
        make.centerX.equalTo(_proImageview1);
        make.height.equalTo(@42);
        make.width.equalTo(@(Line_Height));
    }];
    
    _proImageview2 = [[UIImageView alloc] initWithImage:grayImage];
    [backview addSubview:_proImageview2];
    
    [_proImageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_proImageview1.mas_centerX).offset(0);
        make.top.equalTo(_verticalLine.mas_bottom).offset(0);
        make.width.height.equalTo(@(22));
    }];
    
    _remaindLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _remaindLab1.font = TEXT_FONT_14;
    _remaindLab1.textColor = COLOR_MAIN_GREY;
    _remaindLab1.text = [NSString stringWithFormat:@"出借%@%@%@元",_name,_loanTime,_model.amount];
    [backview addSubview:_remaindLab1];
    
    [_remaindLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_proImageview1.mas_centerY);
        make.left.equalTo(_proImageview1.mas_right).offset(6.f);
    }];
    
    _timeLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab1.font = TEXT_FONT_10;
    _timeLab1.textColor = COLOR_MAIN_GREY;
    _timeLab1.text = _model.orderDate;
    [backview addSubview:_timeLab1];
    
    [_timeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remaindLab1.mas_bottom).offset(7);
        make.left.equalTo(_remaindLab1.mas_left).offset(0);
    }];
    
    _remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _remaindLab2.font = TEXT_FONT_14;
    _remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    _remaindLab2.text = @"各项目满标当日开始计息";
    [backview addSubview:_remaindLab2];
    
    [_remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_proImageview2.mas_centerY);
        make.left.equalTo(_proImageview2.mas_right).offset(6.f);
    }];
    
    UIView *horizonLine2 = [[UIView alloc] initWithFrame:CGRectZero];
    horizonLine2.backgroundColor = COLOR_LINE;
    [backview addSubview:horizonLine2];
    
    [horizonLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backview.mas_left).offset(Margin_Length);
        make.right.equalTo(backview.mas_right).offset(-Margin_Length);
        make.top.equalTo(_remaindLab2.mas_bottom).offset(31);
        make.height.equalTo(@(Line_Height));
    }];
    
    XYButton *checkBtn = [[XYButton alloc] initWithGeneralBtnTitle:@"查看已出借项目" titleColor:COLOR_MAIN_GREY isUserInteractionEnabled:YES];
    checkBtn.backgroundColor = COLOR_COMMON_CLEAR;
    checkBtn.titleLabel.font = TEXT_FONT_14;
    checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    checkBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [checkBtn addTarget:self action:@selector(clickTheCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:checkBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backview);
        make.top.equalTo(horizonLine2.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(backview.mas_bottom);
    }];
    
    UIImageView *cellArrow1 = [[UIImageView alloc] init];
    cellArrow1.image = [UIImage imageNamed:@"cell_arrow"];
    [checkBtn addSubview:cellArrow1];
    
    [cellArrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(checkBtn.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(checkBtn.mas_centerY);
    }];
    
    ColorButton *accomplishBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 150, Cell_Height) Title:@"完成" ByGradientType:leftToRight];
    [accomplishBtn addTarget:self action:@selector(clickAccomplishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:accomplishBtn];
    
    [accomplishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScroll.mas_left).offset(75);
        make.top.equalTo(backview.mas_bottom).offset(20);
        make.width.equalTo(@(MainScreenWidth - 150));
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(mainScroll.mas_bottom).offset(0);
    }];
}

#pragma mark - 响应事件


- (void)clickTheCheckBtn:(id)sender {
    NPInvestedListViewController * npInvested = [[NPInvestedListViewController alloc] init];
    [self.navigationController pushViewController:npInvested animated:YES];
}

- (void)clickAccomplishBtn:(id)sender {
    
    //返回到“一键出借”产品列表页面
    NSArray *vcArr = self.navigationController.viewControllers;
    BaseViewController *vc = [vcArr objectAtIndex:vcArr.count - 4];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
