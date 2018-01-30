//
//  BbgDescriptionItemView.m
//  Ixyb
//
//  Created by dengjian on 16/5/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BbgDescriptionItemView.h"

@implementation BbgDescriptionItemView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = COLOR_BG;

    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipLabel.text = @" ";
    self.tipLabel.font = TEXT_FONT_14;
    self.tipLabel.textColor = COLOR_COMMON_WHITE;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipLabel];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.left.right.equalTo(@0);
    }];

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.imgView];
    [self.imgView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-10);
    }];

    self.precentBgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.precentBgImgView.image = [UIImage imageNamed:@"bbg_precent_bg"];
    [self addSubview:self.precentBgImgView];
    [self.precentBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bgPrecentBottom = make.bottom.equalTo(self.imgView.mas_top).offset(10);
        make.centerX.equalTo(self.imgView.mas_centerX);
    }];

    self.precentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.precentLabel.textColor = COLOR_COMMON_WHITE;
    [self addSubview:self.precentLabel];
    [self.precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.precentBgImgView.mas_centerY);
        make.centerX.equalTo(self.imgView.mas_centerX);
    }];
}

- (void)setState:(NSInteger)state {

    _state = state;
    NSString *s = @"2";

    if (self.bgPrecentBottom) {
        [self.bgPrecentBottom uninstall];
    }

    if (state == 0) {
        s = @"0";
        self.tipLabel.backgroundColor = COLOR_BBGDESCRIPTION_ITEM_1;
        [self.precentBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bgPrecentBottom = make.bottom.equalTo(self.imgView.mas_top).offset(10);
        }];
        self.precentBgImgView.hidden = YES;
        self.precentLabel.textColor = COLOR_MAIN_GREY;
    } else if (state == 1) {
        s = @"1";
        self.tipLabel.backgroundColor = COLOR_BBGDESCRIPTION_ITEM_2;

        [self.precentBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bgPrecentBottom = make.bottom.equalTo(self.imgView.mas_top).offset(-5);
        }];
        self.precentBgImgView.hidden = NO;
        self.precentLabel.textColor = COLOR_COMMON_WHITE;

    } else if (state == 2) {
        s = @"0";
        self.tipLabel.backgroundColor = COLOR_LIGHTGRAY_BUTTONDISABLE;

        [self.precentBgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bgPrecentBottom = make.bottom.equalTo(self.imgView.mas_top).offset(10);
        }];
        self.precentBgImgView.hidden = YES;
        self.precentLabel.textColor = COLOR_LIGHT_GREY;
    }

    NSString *imgName = [NSString stringWithFormat:@"bbg_step%zi_%@", _step, s];
    self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setStep:(NSInteger)step {
    _step = step;
    NSString *s = @"2";
    if (_state != 1) {
        s = @"0";
    } else {
        s = @"1";
    }
    NSString *imgName = [NSString stringWithFormat:@"bbg_step%zi_%@", _step, s];
    self.imgView.image = [UIImage imageNamed:imgName];
    if (step == 1) {
        self.tipLabel.text = XYBString(@"string_one_month", @"1个月");
    } else if (step == 2) {
        self.tipLabel.text = XYBString(@"string_two_months", @"2个月");
    } else if (step == 3) {
        self.tipLabel.text = XYBString(@"string_three_months", @"3个月");
    } else if (step == 4) {
        self.tipLabel.text = XYBString(@"string_four_months", @"4个月");
    } else if (step == 5) {
        self.tipLabel.text = XYBString(@"string_more_than_five_months", @"≥5个月");
    }
}

@end
