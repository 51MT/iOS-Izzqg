//
//  AllianceQuestionView.m
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AllianceQuestionView.h"

#import "Utility.h"

@implementation AllianceQuestionView

static AllianceQuestionView *_saidView = nil;

+ (AllianceQuestionView *)shareInstancesaidView {

    if (_saidView) {

        return _saidView;

    } else {
        _saidView = [[AllianceQuestionView alloc] init];

        [_saidView setUI];
    }

    return _saidView;
}

- (void)setUI {

    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.4f];

    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@1);
    }];

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    [self addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [mainScroll addSubview:contentView];
    if (MainScreenWidth >= IPhone6MainScreenWidth) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.width.equalTo(vi.mas_width);
            make.centerY.equalTo(mainScroll.mas_centerY);
            make.height.equalTo(@500);
            make.bottom.equalTo(mainScroll.mas_bottom).offset(-10);
        }];
    } else {

        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.top.equalTo(mainScroll.mas_top).offset(10);
            make.left.equalTo(@10);
            make.width.equalTo(vi.mas_width);
            make.centerY.equalTo(mainScroll.mas_centerY);
            make.height.equalTo(@460);
            make.bottom.equalTo(mainScroll.mas_bottom).offset(-10);
        }];
    }

    UILabel *unionTitleLab = [[UILabel alloc] init];
    unionTitleLab.textColor = COLOR_MAIN_GREY;
    unionTitleLab.font = TEXT_FONT_14;
    unionTitleLab.text = XYBString(@"str_reward_explain", @"奖励说明");
    [contentView addSubview:unionTitleLab];

    [unionTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
    }];

    UIImageView *unionPlanImage = [[UIImageView alloc] init];
    unionPlanImage.image = [UIImage imageNamed:@"unionPlan"];
    unionPlanImage.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:unionPlanImage];

    UIImageView *pointsImage = [[UIImageView alloc] init];
    pointsImage.image = [UIImage imageNamed:@"onePoint"];
    [contentView addSubview:pointsImage];

    if (MainScreenWidth >= IPhone6MainScreenWidth) {
        [unionPlanImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(unionTitleLab.mas_bottom).offset(30);
            //            make.left.equalTo(@10);
            //            make.right.equalTo(@(-10));
            make.centerX.equalTo(contentView.mas_centerX);
        }];

        [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.equalTo(unionPlanImage.mas_bottom).offset(30);

            make.height.equalTo(@1);
        }];

    } else {
        [unionPlanImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(unionTitleLab.mas_bottom).offset(10);
            make.centerX.equalTo(contentView.mas_centerX);
            //            make.left.equalTo(@10);
            //            make.right.equalTo(@(-10));
        }];

        [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.equalTo(unionPlanImage.mas_bottom).offset(Margin_Length);
            make.height.equalTo(@1);
        }];
    }
    UILabel *roleTitleLab = [[UILabel alloc] init];
    roleTitleLab.textColor = COLOR_MAIN_GREY;
    roleTitleLab.font = TEXT_FONT_14;
    roleTitleLab.text = XYBString(@"str_rule_description", @"规则说明");
    [contentView addSubview:roleTitleLab];

    [roleTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(pointsImage.mas_bottom).offset(10);
    }];

    UITextView *dqbTextView = [[UITextView alloc] init];
    dqbTextView.userInteractionEnabled = NO;
    dqbTextView.textColor = COLOR_LIGHT_GREY;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; // 字体的行间距

    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_LIGHT_GREY,
        NSFontAttributeName : ADDAMOUNT_FONT
    };
    dqbTextView.attributedText = [[NSAttributedString alloc] initWithString:XYBString(@"roleDescription", @"① 推荐好友里的推荐人和被推荐人有两层的从属关系；\n② 推荐人可以从1级推荐和2级推荐的年化出借额中获得相应比例的推荐奖励（如上图示例：推荐人与好友A是1级推荐关系，好友A的好友B是推荐人的2级推荐关系；好友B的推荐好友C跟推荐人没有从属关系）；\n③ 推荐奖励计算：推荐人总收益=1级推荐人年化出借额*1.0%+2级推荐人年化出借额*0.2%；备注：年化出借额=用户出借额*标的期数/12；\n④ 推荐获得的收益将直接进入信用宝账户余额；\n⑤ 本推荐奖励规则最终解释权归信用宝所有。") attributes:attributes];

    [contentView addSubview:dqbTextView];

    [dqbTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(roleTitleLab.mas_bottom).offset(2);
        make.left.equalTo(roleTitleLab.mas_left);
        make.right.equalTo(contentView).offset(-5);
        make.height.equalTo(@220);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:XYBString(@"str_known", @"知道了") forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hiddenTheView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-5);
        make.height.equalTo(@40);
    }];

    UIImageView *pointsImage2 = [[UIImageView alloc] init];
    pointsImage2.image = [UIImage imageNamed:@"onePoint"];
    [contentView addSubview:pointsImage2];

    [pointsImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(btn.mas_top).offset(-10);
        make.height.equalTo(@1);
    }];
}

- (void)hiddenTheView {
    [self removeFromSuperview];
}

@end
