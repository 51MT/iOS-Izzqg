//
//  WzOrArrowView.h
//  Ixyb
//
//  Created by wang on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block)(void);

@interface WzOrArrowView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * arrowImageView;

@property (nonatomic, copy)block blcokClick;

@end
