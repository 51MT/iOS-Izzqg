//
//  ProductProgressView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "ProductProgressView.h"

#import "Utility.h"

#define VIEW_TAG_REMAIN_TIP_VIEW 101001
#define VIEW_TAG_PROGRESS_VIEW 101002
#define VIEW_TAG_PRECENT_TIP_LABEL 101003

@implementation ProductProgressView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_WHITE;

        UIProgressView *progressView = [[UIProgressView alloc] init];
        [self addSubview:progressView];
        progressView.progress = 0.9f;
        progressView.trackTintColor = COLOR_LINE;
        progressView.progressTintColor = COLOR_LIGHT_GREEN;
        progressView.tag = VIEW_TAG_PROGRESS_VIEW;
        progressView.layer.cornerRadius = Corner_Radius;
        progressView.clipsToBounds = YES;

        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@4);
        }];

        UILabel *remaiTipLabel = [[UILabel alloc] init];
        remaiTipLabel.text = XYBString(@"string_remain_yuan", @"剩0.00/0.00元");
        remaiTipLabel.font = TEXT_FONT_14;
        remaiTipLabel.textColor = COLOR_AUXILIARY_GREY;
        remaiTipLabel.tag = VIEW_TAG_REMAIN_TIP_VIEW;
        [self addSubview:remaiTipLabel];
        [remaiTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(progressView.mas_bottom).offset(10);
            make.left.equalTo(@0);
        }];

        UILabel *precentTipLabel = [[UILabel alloc] init];
        precentTipLabel.text = XYBString(@"string_sale_zero", @"已售0%");
        precentTipLabel.font = TEXT_FONT_14;
        precentTipLabel.textColor = COLOR_AUXILIARY_GREY;
        precentTipLabel.tag = VIEW_TAG_PRECENT_TIP_LABEL;
        [self addSubview:precentTipLabel];
        [precentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(progressView.mas_bottom).offset(5);
            make.right.equalTo(@0);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(remaiTipLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (void)refreshRemainTipLabel {
    NSString *toataiAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.totalAmount]];
    NSString *restAmountStr = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", self.restAmount]];
    UILabel *remainTipLabel = [self viewWithTag:VIEW_TAG_REMAIN_TIP_VIEW];
    if (_restAmount == 0) {
        remainTipLabel.text = [NSString stringWithFormat:XYBString(@"string_total_some_yuan", @"总额%@元"), toataiAmountStr];
    } else {
        remainTipLabel.text = [NSString stringWithFormat:XYBString(@"string_remain_some_yuan", @"剩%@/%@元"), restAmountStr, toataiAmountStr];
    }
}

- (void)setTotalAmount:(CGFloat)totalAmount {
    _totalAmount = totalAmount;
    [self refreshRemainTipLabel];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    UIProgressView *progressView = [self viewWithTag:VIEW_TAG_PROGRESS_VIEW];
    progressView.progress = progress;
    UILabel *precentTipLabel = [self viewWithTag:VIEW_TAG_PRECENT_TIP_LABEL];
    NSString *bidProgressRateStr = [NSString stringWithFormat:@"%.0f", progress * 100]; // [Utility stringrangeStr: [NSString stringWithFormat:@"%.2f",progress *100]];
    precentTipLabel.text = [NSString stringWithFormat:XYBString(@"string_saled_some_yuan", @"已售%@%%"), bidProgressRateStr];
}

- (void)setRestAmount:(CGFloat)restAmount {
    _restAmount = restAmount;
    [self refreshRemainTipLabel];
}

@end
