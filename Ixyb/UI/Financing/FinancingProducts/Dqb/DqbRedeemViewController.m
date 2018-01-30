//
//  DqbRuleViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/7.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "DqbRedeemViewController.h"
#import "XYUtil.h"
#import "Masonry.h"

@interface DqbRedeemViewController ()
{
    UIView * backView;
}

@property (nonatomic,strong) CcProductModel *dqbMode;;

@end

@implementation DqbRedeemViewController

- (instancetype)initWithDqbProductModel:(CcProductModel *)dqbModel {
    self = [super init];
    if (self) {
        _dqbMode = dqbModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createMainUI];
//    [self createBottomView];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_back_rule", @"赎回规则");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

- (void)createMainUI {
    
    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom).offset(10);
    }];
    
    //到期赎回方式
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_LINE_GREY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(backView.mas_top).offset(27);
        make.width.height.equalTo(@(Circular_WH));
    }];
    
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_14;
    remaindLab.textColor = COLOR_MAIN_GREY;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.text = XYBString(@"str_financing_dqshfs", @"到期赎回方式");
    [backView addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound.mas_right).offset(6);
        make.centerY.equalTo(grayRound.mas_centerY);
    }];
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab.font = TEXT_FONT_12;
    detailLab.textColor = COLOR_LIGHT_GREY;
    detailLab.text = XYBString(@"str_financing_ptzdfhsyje", @"平台自动返还剩余本金和当期利息");
    detailLab.numberOfLines = 0;
    [backView addSubview:detailLab];
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab.mas_left).offset(0);
        make.top.equalTo(remaindLab.mas_bottom).offset(11);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];
    
    //提前赎回方式
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_LINE_GREY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [backView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(grayRound.mas_bottom).offset(61);
        make.width.height.equalTo(@(Circular_WH));
    }];
    
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_14;
    remaindLab2.textColor = COLOR_MAIN_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.text = XYBString(@"str_financing_tqshfs", @"提前赎回方式");
    [backView addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayRound2.mas_right).offset(6);
        make.centerY.equalTo(grayRound2.mas_centerY);
    }];
    
    UILabel *detailLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLab2.font = TEXT_FONT_12;
    detailLab2.textColor = COLOR_LIGHT_GREY;
    detailLab2.numberOfLines = 0;
    
    // 不支持赎回的产品：周周盈、日新月异、单季满盈、双季满盈、策诚月盈
    if ([_dqbMode.type isEqualToString:@"ZZY"] || [_dqbMode.type isEqualToString:@"RXYY"] ||[_dqbMode.type isEqualToString:@"DJMY"] ||[_dqbMode.type isEqualToString:@"SJMY"] || [_dqbMode.type isEqualToString:@"CCYY"]) {
        detailLab2.text = XYBString(@"str_financing_bzctqsh", @"不支持提前赎回");
        
    }else{
        
        NSString *detailStr;
        if ([_dqbMode.type isEqualToString:@"CCNY"]) {
           detailStr = [NSString stringWithFormat:XYBString(@"str_financing_tzhsh", @"投资%@个月后可赎回,平台收取%@%%违约金"),@"4",@"5"];
        }else{
            detailStr = [NSString stringWithFormat:XYBString(@"str_financing_tzhsh", @"投资%@个月后可赎回,平台收取%@%%违约金"),@"12",@"5"];
        }
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
        
        if ([_dqbMode.type isEqualToString:@"CCNY"]) {
            [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_INTRODUCE_ORANGE range:NSMakeRange(2, 1)];
        }else{
            [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_INTRODUCE_ORANGE range:NSMakeRange(2, 2)];
        }
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_INTRODUCE_ORANGE range:NSMakeRange(detailStr.length - 5, 2)];
        detailLab2.attributedText = attributeStr;
    }
    [backView addSubview:detailLab2];
    
    [detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab2.mas_left).offset(0);
        make.top.equalTo(remaindLab2.mas_bottom).offset(11);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
    }];
}

/**
 *  @brief 底部安全部分 图片+文字(风险缓释金保障)
 */
- (void)createBottomView {
    
    UIView *tipSafeView = [[UIView alloc] initWithFrame:CGRectZero];
    tipSafeView.backgroundColor = COLOR_BG;
    [self.view addSubview:tipSafeView];
    
    [tipSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.top.equalTo(backView.mas_bottom).offset(0);
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
    tipLab.font = TEXT_FONT_12;
    tipLab.textColor = COLOR_AUXILIARY_GREY;
    [tipView addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(insureImageView.mas_centerY);
        make.left.equalTo(insureImageView.mas_right).offset(6.0f);
        make.right.equalTo(tipView.mas_right);
        make.bottom.equalTo(tipView.mas_bottom);
    }];
}


-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
