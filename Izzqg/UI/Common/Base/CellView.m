//
//  CellView.m
//  Ixyb
//
//  Created by dengjian on 12/10/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "CellView.h"

#import "Utility.h"

@interface CellView ()

@property (nonatomic) CellViewStyle style;

@property (nonatomic, strong) UIImageView * arrowImageView;

@end

@implementation CellView

- (id)initWithStyle:(CellViewStyle)style {
    if (self = [super init]) {
        self.style = style;

        [self initUI];
    }
    return self;
}

- (void)initUI {
 
    XYButton * clickBut = [[XYButton alloc] initWithGeneralBtnTitle:nil
                                                          titleColor:nil
                                            isUserInteractionEnabled:YES];
    [clickBut addTarget:self
                   action:@selector(clickControl:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBut];
    [clickBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"contract_security"];
    [clickBut addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@Margin_Length);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = TEXT_FONT_16;
    self.titleLabel.textColor = COLOR_MAIN_GREY;
    [clickBut addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(12);
    }];
    
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
    [clickBut addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(clickBut.mas_right).offset(-Margin_Right);
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.text  = @"";
    self.rightLabel.hidden = YES;
    self.rightLabel.font  = TEXT_FONT_14;
    self.rightLabel.textColor = COLOR_CHU_ORANGE;
    [clickBut addSubview: self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-3);
    }];
}

-(void)clickControl:(UIButton *)sender
{
    if (self.blcokClick) {
        self.blcokClick();
    }
}

@end
