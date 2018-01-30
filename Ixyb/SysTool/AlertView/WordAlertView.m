//
//  WordAlertView.m
//  Ixyb
//
//  Created by wang on 15/8/13.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "WordAlertView.h"

#import "Utility.h"

@implementation WordAlertView

static WordAlertView *_wordView = nil;

+ (WordAlertView *)shareInstancewordView {

    if (_wordView) {

        return _wordView;

    } else {
        _wordView = [[WordAlertView alloc] init];

        [_wordView setUI];
    }

    return _wordView;
}

- (void)setUI {

    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.4f];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.cornerRadius = Corner_Radius_3;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@230);
        make.centerY.equalTo(self.mas_centerY);
    }];

    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.userInteractionEnabled = NO;
    contentTextView.textColor = COLOR_MAIN_GREY;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; // 字体的行间距

    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_LIGHT_GREY,
        NSFontAttributeName : TEXT_FONT_14
    };
    contentTextView.attributedText = [[NSAttributedString alloc] initWithString:@"① 首次注册、升级VIP或抽奖赠送收益提升卡：用户首次注册、升级VIP或抽奖时，可获得收益提升卡（用户可在购买定期宝或信投宝时使用），收益提升卡可提升产品收益，收益提升卡有效期为1周；\n② 产品的实际收益=产品收益*收益提升卡倍数；\n" attributes:attributes];

    [contentView addSubview:contentTextView];

    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.height.equalTo(@170);
    }];
    UIImageView *pointsImage = [[UIImageView alloc] init];
    pointsImage.image = [UIImage imageNamed:@"onePoint"];
    [contentView addSubview:pointsImage];

    [pointsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentTextView.mas_bottom);
        make.height.equalTo(@1);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hiddenTheView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(pointsImage.mas_top).offset(5);
        make.height.equalTo(@50);
    }];
}

- (void)hiddenTheView {
    [self removeFromSuperview];
}

@end
