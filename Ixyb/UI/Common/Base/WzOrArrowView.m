//
//  WzOrArrowView.m
//  Ixyb
//
//  Created by wang on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "WzOrArrowView.h"
#import "Utility.h"

@implementation WzOrArrowView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    
    UIButton * clickBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBut addTarget:self
                 action:@selector(clickControl:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBut];
    [clickBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [clickBut addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(clickBut.mas_right);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = SMALL_TEXT_FONT_13;
    self.titleLabel.textColor = COLOR_MAIN;
    [clickBut addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@(10));
    }];
    
}

-(void)clickControl:(id)sender
{
    if (self.blcokClick) {
          self.blcokClick();
    }
}

@end
