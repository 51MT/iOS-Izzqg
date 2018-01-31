//
//  BbgRedeemViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/9/11.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BbgRedeemViewController.h"
#import "Utility.h"

@interface BbgRedeemViewController () {
    
    XYScrollView *mainScroll;
    UIView *backView;
}


@end

@implementation BbgRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self createMainUI];
//    [self createBottomView];
}

- (void)setNav {
    self.navItem.title = XYBString(@"str_financing_back_rule", @"赎回规则");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

-(void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createMainUI {
    
    mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mainScroll];
    
    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
    }];
    
    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
        make.top.equalTo(mainScroll.mas_top).offset(10);
    }];
    
    // • 计息后1个月为锁定期，退出到账日为锁定期结束日
    UILabel *remaindLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab.font = TEXT_FONT_12;
    remaindLab.textColor = COLOR_AUXILIARY_GREY;
    remaindLab.textAlignment = NSTextAlignmentLeft;
    remaindLab.numberOfLines = 0;
    NSString *text = XYBString(@"str_financing_jxhygysdq", @"计息后1个月为锁定期，退出到账日为锁定期结束日");
    remaindLab.text = text;
    [backView addSubview:remaindLab];
    
    [remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(26);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(backView.mas_top).offset(22);
    }];
    
    UIView *grayRound = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound.backgroundColor = COLOR_ROUND_GRAY;
    grayRound.layer.cornerRadius = Circular_WH/2;
    grayRound.layer.masksToBounds = YES;
    [backView addSubview:grayRound];
    
    [grayRound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remaindLab.mas_left).offset(-6);
        make.centerY.equalTo(remaindLab.mas_centerY).offset(0);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //• 每月多次申请，每月锁定期结束前任意时间申请
    UILabel *remaindLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab2.font = TEXT_FONT_12;
    remaindLab2.textColor = COLOR_AUXILIARY_GREY;
    remaindLab2.textAlignment = NSTextAlignmentLeft;
    remaindLab2.numberOfLines = 0;
    NSString *text2 = XYBString(@"str_financing_mydcsq", @"每月多次申请,每月锁定期结束日前任意时间申请");
    remaindLab2.text = text2;
    [backView addSubview:remaindLab2];
    
    [remaindLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(remaindLab.mas_bottom).offset(6);
    }];
    
    UIView *grayRound2 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound2.backgroundColor = COLOR_ROUND_GRAY;
    grayRound2.layer.cornerRadius = Circular_WH/2;
    grayRound2.layer.masksToBounds = YES;
    [backView addSubview:grayRound2];
    
    [grayRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remaindLab2.mas_left).offset(-6);
        make.centerY.equalTo(remaindLab2.mas_centerY).offset(0);
        make.width.height.equalTo(@Circular_WH);
    }];
    
    //• 当项目可赎回金额＞=100且为整数；当项目可赎回金额＜100元， 赎回申请金额=项目可赎回金额且为整数
    UILabel *remaindLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    remaindLab3.font = TEXT_FONT_12;
    remaindLab3.textColor = COLOR_AUXILIARY_GREY;
    remaindLab3.textAlignment = NSTextAlignmentLeft;
    remaindLab3.numberOfLines = 0;
    NSString *text3 = XYBString(@"str_financing_dxmkshje", @"当项目可赎回金额＞=100且为整数，赎回申请金额＞=100且为整数；当项目可赎回金额＜100元， 赎回申请金额=项目可赎回金额且为整数");
    remaindLab3.attributedText = [self getAttributedStringWithString:text3 color:COLOR_AUXILIARY_GREY font:TEXT_FONT_12 space:6];
    [backView addSubview:remaindLab3];
    
    [remaindLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remaindLab2.mas_left).offset(0);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(remaindLab2.mas_bottom).offset(6);
        make.bottom.equalTo(backView.mas_bottom).offset(-Margin_Length);
    }];
    
    UIView *grayRound3 = [[UIView alloc] initWithFrame:CGRectZero];
    grayRound3.backgroundColor = COLOR_ROUND_GRAY;
    grayRound3.layer.cornerRadius = Circular_WH/2;
    grayRound3.layer.masksToBounds = YES;
    [backView addSubview:grayRound3];
    
    [grayRound3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remaindLab3.mas_left).offset(-6);
        make.top.equalTo(remaindLab3.mas_top).offset(4);
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
