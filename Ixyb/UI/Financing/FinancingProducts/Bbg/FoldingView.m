//
//  FoldingView.m
//  Ixyb
//
//  Created by wang on 15/12/10.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "FoldingView.h"

#import "Utility.h"

@implementation FoldingView

//- (id)initWithFrame:(CGRect)frame  {
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = COLOR_COMMON_CLEAR;
//        [self setUIWithTitle:nil contentStr:nil isShowSelectImage:NO];
//
//    }
//    return self;
//}

- (id)initWithTitle:(NSString *)title contentDescribeStr:(NSString *)contentDescribeStr isShowSelectImage:(BOOL)isSelect {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        _describeStr = contentDescribeStr;
        [self setUIWithTitle:title contentStr:contentDescribeStr isShowSelectImage:isSelect];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title contentStr:(NSString *)contentStr isShowSelectImage:(BOOL)isSelect {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    [self addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(@(Margin_Left));
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];

    foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    foldBtn.selected = isSelect;
    [foldBtn setImage:[UIImage imageNamed:@"bbg_downAllow"] forState:UIControlStateNormal];
    [foldBtn setImage:[UIImage imageNamed:@"bbg_upAllow"] forState:UIControlStateSelected];
    [foldBtn addTarget:self action:@selector(clickFoldButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:foldBtn];

    [foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-Margin_Right);
    }];

    verLaneImage = [[UIImageView alloc] init];
    verLaneImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:verLaneImage];

    [verLaneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
    }];

    contentLab = [[UILabel alloc] init];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];

    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verLaneImage.mas_bottom);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
    }];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; // 字体的行间距
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
        NSFontAttributeName : TEXT_FONT_14
    };
    if (foldBtn.selected) {
        contentLab.hidden = NO;
        contentLab.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];
    } else {
        contentLab.hidden = YES;
        contentLab.attributedText = nil;
    }

    foldBtn.hidden = YES; //将显示和隐藏按钮隐藏
    bootomVerImage = [[UIImageView alloc] init];
    bootomVerImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:bootomVerImage];

    [bootomVerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLab.mas_bottom).offset(0);
        make.right.left.equalTo(contentLab);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(self);
    }];
}

- (id)initWithTitle:(NSString *)title contentDescribeStr:(NSString *)contentDescribeStr DescriptionStr:(NSString *)desStri isShowSelectImage:(BOOL)isSelect {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        _describeStr = contentDescribeStr;
        _bottomStr = desStri;
        [self setUIWithTitle:title contentStr:contentDescribeStr DescriptionStr:desStri sShowSelectImage:isSelect];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title contentStr:(NSString *)contentStr DescriptionStr:(NSString *)desStri sShowSelectImage:(BOOL)isSelect {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    [self addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(@(Margin_Left));
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];

    foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    foldBtn.selected = isSelect;
    [foldBtn setImage:[UIImage imageNamed:@"bbg_downAllow"] forState:UIControlStateNormal];
    [foldBtn setImage:[UIImage imageNamed:@"bbg_upAllow"] forState:UIControlStateSelected];
    [foldBtn addTarget:self action:@selector(clickFoldButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:foldBtn];

    [foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-Margin_Right);
    }];

    verLaneImage = [[UIImageView alloc] init];
    verLaneImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:verLaneImage];

    [verLaneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.height.equalTo(@(Line_Height));
    }];

    contentLab = [[UILabel alloc] init];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];

    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verLaneImage.mas_bottom);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
    }];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; // 字体的行间距
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
        NSFontAttributeName : TEXT_FONT_14
    };

    if (foldBtn.selected) {
        contentLab.hidden = NO;
        contentLab.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:attributes];

    } else {
        contentLab.hidden = YES;
        contentLab.attributedText = nil;
    }

    foldBtn.hidden = YES; //将显示和隐藏按钮隐藏
    NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:desStri];
    [returnStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_RED_LEVEL1,
                                NSFontAttributeName : TEXT_FONT_12 }
                       range:NSMakeRange(0, 1)];
    [returnStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
                                NSFontAttributeName : TEXT_FONT_12 }
                       range:NSMakeRange(1, returnStr.length - 1)];
    [returnStr addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle } range:NSMakeRange(0, returnStr.length)];

    bottomLab = [[UILabel alloc] init];
    bottomLab.numberOfLines = 0;
    [self addSubview:bottomLab];

    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLab.mas_bottom);
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
    }];

    if (foldBtn.selected) {

        bottomLab.hidden = NO;
        bottomLab.attributedText = returnStr;
    } else {
        bottomLab.hidden = YES;
        bottomLab.attributedText = nil;
    }

    bootomVerImage = [[UIImageView alloc] init];
    bootomVerImage.image = [UIImage imageNamed:@"onePoint"];
    [self addSubview:bootomVerImage];

    [bootomVerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLab.mas_bottom).offset(0);
        make.right.left.equalTo(bottomLab);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(self);
    }];
}

- (void)clickFoldButton:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.selected) {
        contentLab.hidden = YES;
        contentLab.attributedText = nil;
        bootomVerImage.hidden = YES;
        if (bottomLab) {
            bottomLab.hidden = YES;
            bottomLab.attributedText = nil;
        }

    } else {
        bootomVerImage.hidden = NO;
        contentLab.hidden = NO;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8; // 字体的行间距
        NSDictionary *attributes = @{
            NSParagraphStyleAttributeName : paragraphStyle,
            NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
            NSFontAttributeName : TEXT_FONT_14
        };
        contentLab.attributedText = [[NSAttributedString alloc] initWithString:_describeStr attributes:attributes];
        if (bottomLab) {
            bottomLab.hidden = NO;
            NSMutableAttributedString *tagStr = [[NSMutableAttributedString alloc] initWithString:_bottomStr];
            [tagStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_RED_LEVEL1,
                                     NSFontAttributeName : TEXT_FONT_16 }
                            range:NSMakeRange(0, 1)];
            [tagStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
                                     NSFontAttributeName : TEXT_FONT_14 }
                            range:NSMakeRange(1, tagStr.length - 1)];
            [tagStr addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle } range:NSMakeRange(0, tagStr.length)];
            bottomLab.attributedText = tagStr;
        }
    }
    btn.selected = !btn.selected;
}

@end
