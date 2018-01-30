//
//  BbgDescriptionItemView.h
//  Ixyb
//
//  Created by dengjian on 16/5/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

@interface BbgDescriptionItemView : UIView

@property (nonatomic, assign) NSInteger state; // 0 完成 1 当前  2:将来
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *precentLabel;
@property (nonatomic, strong) UIImageView *precentBgImgView;

@property (nonatomic, strong) MASConstraint *bgPrecentBottom;

@end
