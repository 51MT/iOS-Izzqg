//
//  BbgHomeProductView.m
//  Ixyb
//
//  Created by wang on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BbgHomeProductView.h"
#import "ProductFeaturesView.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@implementation BbgHomeProductView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = XYBString(@"str_common_bbg", @"步步高");
    [self addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@34);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@17);
    }];

    UIView *remainView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:remainView];

    [remainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(11);
        make.centerX.equalTo(titleLab.mas_centerX);
        //        make.height.equalTo(@13);
    }];

    UILabel *remainLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remainLab.textColor = COLOR_AUXILIARY_GREY;
    remainLab.font = TEXT_FONT_16;
    remainLab.text = XYBString(@"str_financing_remainCanInvestMoney", @"剩余可投");
    [remainView addSubview:remainLab];

    [remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remainView.mas_centerY);
        make.left.equalTo(remainView.mas_left).offset(Margin_Length);
        make.bottom.equalTo(remainView.mas_bottom);
        //        make.height.equalTo(@13);
    }];

    UILabel *restAmountLab = [[UILabel alloc] initWithFrame:CGRectZero];
    restAmountLab.text = XYBString(@"str_financing_zero_yuan", @"0.00元");
    restAmountLab.textColor = COLOR_STRONG_RED;
    restAmountLab.font = TEXT_FONT_16;
    restAmountLab.tag = 213;
    [remainView addSubview:restAmountLab];

    [restAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remainLab.mas_centerY);
        make.left.equalTo(remainLab.mas_right).offset(5);
        make.right.equalTo(remainView.mas_right).offset(-Margin_Length);
    }];

    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *defaultImage = [UIImage imageNamed:@"bbg_defaultImage"];
    centerImage.image = defaultImage;
    centerImage.tag = 215;
    [self addSubview:centerImage];

    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remainView.mas_bottom).offset(34);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(defaultImage.size.height));
        make.width.equalTo(@(defaultImage.size.width));
    }];

    ProductFeaturesView *fratureView = [[ProductFeaturesView alloc] init];
    [self addSubview:fratureView];
    fratureView.productArr = @[ XYBString(@"str_financing_oneMonthAtLeast", @"1个月起"),
                                XYBString(@"str_financing_getProfitEveryMonth", @"每月返息"),
                                XYBString(@"str_financing_100yqt", @"100元起投") ];
    [fratureView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(centerImage.mas_bottom).offset(33);
        make.left.equalTo(self.mas_left).offset(30);
        make.height.equalTo(@18);

    }];

    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [detailBtn addTarget:self action:@selector(clickDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];

    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(fratureView.mas_bottom);
    }];

    ColorButton *investButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"str_financing_investedImmidiate", @"立即出借") ByGradientType:leftToRight];
    investButton.tag = 214;
    [investButton addTarget:self action:@selector(clickInvestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:investButton];

    [investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Margin_Length);
        make.right.equalTo(self.mas_right).offset(-Margin_Length);
        make.top.equalTo(fratureView.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(Button_Height));
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)clickDetailButton:(id)sender {
    if (self.clickDetailButton) {
        self.clickDetailButton(_bbgProduct);
    }
}

- (void)clickInvestButton:(id)sender {
    if (self.clickTheInvestButton) {
        self.clickTheInvestButton(_bbgProduct);
    }
}

- (void)reloadTheDataForUI:(BbgProductModel *)product {
    _bbgProduct = product;
    UILabel *lab4 = (UILabel *) [self viewWithTag:213];
    ColorButton *btn = (ColorButton *) [self viewWithTag:214];
    UIImageView *centerImage = (UIImageView *) [self viewWithTag:215];

    NSString *restAmount = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [product.restAmount doubleValue]]];
    lab4.text = [NSString stringWithFormat:@"%@元", restAmount];
    [centerImage sd_setImageWithURL:[NSURL URLWithString:self.bbgProduct.productUrl] placeholderImage:[UIImage imageNamed:@"bbg_defaultImage"]];

    if ([restAmount doubleValue] <= 0) {
        lab4.text = @"0.00元";
        btn.isColorEnabled = NO;
        [btn setTitle:XYBString(@"str_financing_haveSoldOut", @"已售罄") forState:UIControlStateNormal];
    } else {
        btn.isColorEnabled = YES;
    }
}

@end
