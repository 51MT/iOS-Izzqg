//
//  NewProGuideView.m
//  Ixyb
//
//  Created by dengjian on 2017/12/23.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NewProGuideView.h"
#import "Masonry.h"

@interface NewProGuideView ()

@property(nonatomic,assign) int guideState;
@property(nonatomic,strong) UIImageView *imageview;

@end

@implementation NewProGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self createMainUI];
    }
    return self;
}

- (void)createMainUI {
    
    NSString *imageName = @"newProGuide1";
    UIImage *guide_1 = [UIImage imageNamed:imageName];
    CGSize image_size = guide_1.size;
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageview.image = guide_1;
    [self addSubview:_imageview];
    
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenWidth * image_size.height / image_size.width));
    }];
    
    
    UIImage *btn_iKnowImage = [UIImage imageNamed:@"btn_iKnow"];
    CGSize iKnowImage_size = btn_iKnowImage.size;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:btn_iKnowImage forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickIKnowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageview.mas_bottom).offset(0);
        make.right.equalTo(@(-Margin_Length));
        make.width.equalTo(@(iKnowImage_size.width));
        make.height.equalTo(@(iKnowImage_size.height));
    }];
}

- (void)clickIKnowButton:(id)sender {
    
    _guideState ++;
    if (_guideState == 1) {
        UIImage *guide_2 = [UIImage imageNamed:@"newProGuide2"];
        CGSize image_size = guide_2.size;
        
        [_imageview setImage:guide_2];
        [_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(MainScreenWidth * image_size.height / image_size.width));
        }];
        
    }else if (_guideState == 2) {
        
        UIImage *guide_3 = [UIImage imageNamed:@"newProGuide3"];
        CGSize image_size = guide_3.size;
        
        [_imageview setImage:guide_3];
        [_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(MainScreenWidth * image_size.height / image_size.width));
        }];
        
    }else if (_guideState == 3) {
        [self removeFromSuperview];
        _guideState = 0;
    }
}


@end
