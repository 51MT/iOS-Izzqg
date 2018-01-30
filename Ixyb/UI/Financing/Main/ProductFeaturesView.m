//
//  ProductFeaturesView.m
//  Ixyb
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ProductFeaturesView.h"

#import "Utility.h"

#define FEATURESTAG1 1001
#define FEATURESTAG2 1002
#define FEATURESTAG3 1003

@implementation ProductFeaturesView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIView *featuresView2 = [[UIView alloc] init];
    [self addSubview:featuresView2];

    [featuresView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];

    UIImageView *featuresImage2 = [[UIImageView alloc] init];
    featuresImage2.image = [UIImage imageNamed:@"features"];
    [featuresView2 addSubview:featuresImage2];

    [featuresImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresView2.mas_left);
        make.centerY.equalTo(featuresView2.mas_centerY);
        make.width.height.equalTo(@17);
    }];

    UILabel *features2 = [[UILabel alloc] init];
    features2.textColor = COLOR_MAIN_GREY;
    features2.font = TEXT_FONT_14;
    features2.tag = FEATURESTAG2;
    [featuresView2 addSubview:features2];

    [features2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresImage2.mas_right).offset(2);
        make.centerY.equalTo(featuresView2.mas_centerY);
        make.width.equalTo(@64);
        make.bottom.equalTo(self.mas_bottom);
    }];

    UIView *featuresView1 = [[UIView alloc] init];
    [self addSubview:featuresView1];

    [featuresView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(featuresView2.mas_left).offset(-20);
        make.top.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];

    UIImageView *featuresImage1 = [[UIImageView alloc] init];
    featuresImage1.image = [UIImage imageNamed:@"time_logo"];
    [featuresView1 addSubview:featuresImage1];

    [featuresImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresView1.mas_left);
        make.centerY.equalTo(featuresView1.mas_centerY);
        make.width.height.equalTo(@17);
    }];

    UILabel *features1 = [[UILabel alloc] init];
    features1.textColor = COLOR_MAIN_GREY;
    features1.font = TEXT_FONT_14;
    features1.tag = FEATURESTAG1;
    [featuresView1 addSubview:features1];

    [features1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresImage1.mas_right).offset(2);
        make.centerY.equalTo(featuresView1.mas_centerY);
        make.right.equalTo(featuresView1.mas_right);
    }];

    UIView *featuresView3 = [[UIView alloc] init];
    [self addSubview:featuresView3];

    [featuresView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresView2.mas_right).offset(20);
        make.top.equalTo(@0);
        make.width.equalTo(@95);
        make.height.equalTo(@20);
    }];

    UIImageView *featuresImage3 = [[UIImageView alloc] init];
    featuresImage3.image = [UIImage imageNamed:@"money_logo"];
    [featuresView3 addSubview:featuresImage3];

    [featuresImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresView3.mas_left).offset(2);
        make.centerY.equalTo(featuresView3.mas_centerY);
        make.width.height.equalTo(@17);
    }];

    UILabel *features3 = [[UILabel alloc] init];
    features3.textColor = COLOR_MAIN_GREY;
    features3.font = TEXT_FONT_14;
    features3.tag = FEATURESTAG3;
    [featuresView3 addSubview:features3];

    [features3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(featuresImage3.mas_right).offset(2);
        make.centerY.equalTo(featuresView3.mas_centerY);
        make.right.equalTo(featuresView3.mas_right);
    }];
}

- (void)setProductArr:(NSArray *)productArr {
    if (productArr.count == 0) {
        return;
    }
    UILabel *lab1 = (UILabel *) [self viewWithTag:FEATURESTAG1];
    UILabel *lab2 = (UILabel *) [self viewWithTag:FEATURESTAG2];
    UILabel *lab3 = (UILabel *) [self viewWithTag:FEATURESTAG3];

    lab1.text = [productArr objectAtIndex:0];
    if (productArr.count < 2) {
        return;
    }
    lab2.text = [productArr objectAtIndex:1];
    if (productArr.count < 3) {
        return;
    }
    lab3.text = [productArr objectAtIndex:2];
}

@end
