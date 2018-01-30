//
//  XYCellLine.m
//  Ixyb
//
//  Created by wangjianimac on 16/4/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYCellLine.h"

#import "Utility.h"

@implementation XYCellLine

- (id)initXYCellLine {
    if (self = [super init]) {
        self.backgroundColor = COLOR_LINE;
    }
    return self;
}

+ (void)initWithTopAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [cellContentView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellContentView.mas_top);
        make.left.equalTo(cellContentView.mas_left);
        make.right.equalTo(cellContentView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithMiddleAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView {

    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [cellContentView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellContentView.mas_top);
        make.left.equalTo(cellContentView.mas_left).offset(Margin_Length);
        make.right.equalTo(cellContentView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithBottomAtIndexPath:(NSIndexPath *)indexPath addSuperView:(UIView *)cellContentView {

    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [cellContentView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellContentView.mas_bottom);
        make.left.equalTo(cellContentView.mas_left);
        make.right.equalTo(cellContentView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithTopLineAtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
}
+ (void)initWithTopLineDqbAtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(0.4));
    }];
}

+ (void)initWithMiddleLineAtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY).offset(-Line_Height / 2);
        make.left.equalTo(superView.mas_left).offset(Margin_Length);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithHalfMiddleLineAtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY).offset(-Line_Height / 2);
        make.left.equalTo(superView.mas_left).offset(Margin_Length);
        make.right.equalTo(superView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithBottomLineAtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithBottomLine_2_AtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(Margin_Length);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(superView.mas_bottom).offset(0);
    }];
}

+ (void)initWithTopLine_3_AtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(Line_Height);
        make.left.equalTo(superView.mas_left).offset(Margin_Length);
        make.right.equalTo(superView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
}

+ (void)initWithBottomLine_3_AtSuperView:(UIView *)superView {
    XYCellLine *cellLine = [[XYCellLine alloc] initXYCellLine];
    [superView addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_bottom).offset(-Line_Height);
        make.left.equalTo(superView.mas_left).offset(Margin_Length);
        make.right.equalTo(superView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
}

@end
