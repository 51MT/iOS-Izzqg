//
//  BbgDescriptionView.m
//  Ixyb
//
//  Created by dengjian on 12/14/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "BbgDescriptionView.h"
#import "Utility.h"

#define VIEW_TAG_ITEM_BEGIN 1001001

@implementation BbgDescriptionView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {

    self.backgroundColor = COLOR_COMMON_WHITE;

    UILabel *tip1Label = [[UILabel alloc] initWithFrame:CGRectZero];
    tip1Label.text = XYBString(@"str_bbg_dq_rate", @"历史年化结算利率");
    tip1Label.font = TEXT_FONT_16;
    tip1Label.textColor = COLOR_MAIN_GREY;
    [self addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@Margin_Length);
    }];
    UIImageView *infoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [self addSubview:infoIconView];
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(tip1Label.mas_bottom).offset(10);
    }];

    self.maxRateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.maxRateLabel.text = XYBString(@"string_invest_five_month_last", @"出借5个月后持续0.00%");
    self.maxRateLabel.font = TEXT_FONT_14;
    self.maxRateLabel.textColor = COLOR_LIGHT_GREY;
    [self addSubview:self.maxRateLabel];
    [self.maxRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoIconView.mas_right).offset(3);
        make.centerY.equalTo(infoIconView.mas_centerY);
    }];

    _item1View = [[BbgDescriptionItemView alloc] init];
    _item1View.tag = VIEW_TAG_ITEM_BEGIN + 0;
    [self addSubview:_item1View];
    _item1View.step = 1;
    _item1View.state = 1;
    [_item1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.bottom.equalTo(@-30);
    }];

    UIView *space1View = [[UIView alloc] initWithFrame:CGRectZero];
    space1View.backgroundColor = COLOR_COMMON_CLEAR;
    [self addSubview:space1View];
    [space1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_item1View);
    }];

    _item2View = [[BbgDescriptionItemView alloc] init];
    _item2View.tag = VIEW_TAG_ITEM_BEGIN + 1;
    [self addSubview:_item2View];
    _item2View.step = 2;
    _item2View.state = 0;
    [_item2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space1View.mas_right);
        make.bottom.equalTo(_item1View.mas_bottom);
        make.width.equalTo(_item1View);
    }];

    UIView *space2View = [[UIView alloc] initWithFrame:CGRectZero];
    space2View.backgroundColor = COLOR_COMMON_CLEAR;
    [self addSubview:space2View];
    [space2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_item2View);
        make.width.equalTo(space1View.mas_width);
    }];

    _item3View = [[BbgDescriptionItemView alloc] init];
    _item3View.tag = VIEW_TAG_ITEM_BEGIN + 2;
    [self addSubview:_item3View];
    _item3View.step = 3;
    _item3View.state = 0;
    [_item3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space2View.mas_right);
        make.bottom.equalTo(_item1View.mas_bottom);
        make.width.equalTo(_item1View);
    }];

    UIView *space3View = [[UIView alloc] initWithFrame:CGRectZero];
    space3View.backgroundColor = COLOR_COMMON_CLEAR;
    [self addSubview:space3View];
    [space3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_item3View);
        make.width.equalTo(space1View.mas_width);
    }];

    _item4View = [[BbgDescriptionItemView alloc] init];
    _item4View.tag = VIEW_TAG_ITEM_BEGIN + 3;
    [self addSubview:_item4View];
    _item4View.step = 4;
    _item4View.state = 0;
    [_item4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space3View.mas_right);
        make.bottom.equalTo(_item1View.mas_bottom);
        make.width.equalTo(_item1View);
    }];

    UIView *space4View = [[UIView alloc] initWithFrame:CGRectZero];
    space4View.backgroundColor = COLOR_COMMON_CLEAR;
    [self addSubview:space4View];
    [space4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_item4View);
        make.width.equalTo(space1View.mas_width);
    }];

    _item5View = [[BbgDescriptionItemView alloc] init];
    _item5View.tag = VIEW_TAG_ITEM_BEGIN + 4;
    [self addSubview:_item5View];
    _item5View.step = 5;
    _item5View.state = 0;
    [_item5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space4View.mas_right);
        make.bottom.equalTo(_item1View.mas_bottom);
        make.right.equalTo(@-30);
        make.width.equalTo(_item1View);
    }];

    UIView *splitBottomView = [[UIView alloc] initWithFrame:CGRectZero];
    splitBottomView.backgroundColor = COLOR_LINE;
    [self addSubview:splitBottomView];
    [splitBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setCurrentStep:(NSInteger)currentStep {
    _currentStep = currentStep;
    NSInteger sIndex = currentStep - 1;
    for (int i = 0; i < 5; i++) {
        BbgDescriptionItemView *itemView = [self viewWithTag:(VIEW_TAG_ITEM_BEGIN + i)];
        if (i < sIndex) {
            itemView.state = 0;
        } else if (i == sIndex) {
            itemView.state = 1;
        } else if (i > sIndex) {
            itemView.state = 2;
        }
    }
}

@end
