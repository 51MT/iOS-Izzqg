//
//  PromptView.m
//  Ixyb
//
//  Created by wang on 15/5/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "PromptView.h"
#import "Utility.h"

@implementation PromptView

- (id)initWithFrame:(CGRect)frame ShowStr:(NSString *)showStr {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        UILabel *contenLab = [[UILabel alloc] init];
        contenLab.numberOfLines = 0;
        contenLab.font = TEXT_FONT_BOLD_15;
        contenLab.textAlignment = NSTextAlignmentCenter;
        contenLab.text = showStr;
        contenLab.textColor = COLOR_COMMON_WHITE;
        contenLab.backgroundColor = COLOR_COMMON_BLACK_TRANS_65;
        [contenLab.layer setMasksToBounds:YES];
        [contenLab.layer setCornerRadius:4.0];
        [self addSubview:contenLab];

        CGFloat width = [showStr boundingRectWithSize:frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : TEXT_FONT_BOLD_15 } context:nil].size.width;
        [contenLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.width.equalTo(@(width + 30));
            make.height.equalTo(@Prompt_Lable_Height);
        }];

        contenLab.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.5f, 0.5f));
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.50];
        contenLab.alpha = 1.0f;
        contenLab.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }

    return self;
}

- (void)hideDelayed {
    if (self) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

@end
