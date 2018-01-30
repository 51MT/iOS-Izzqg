//
//  ZqzrTableViewCell.h
//  Ixyb
//
//  Created by dengjian on 16/6/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BidProduct.h"
#import "Utility.h"
#import <UIKit/UIKit.h>

typedef void(^investBlock)();

@interface ZqzrTableViewCell : XYTableViewCell

@property (nonatomic, strong) ColorButton *investButton;//出借
@property (nonatomic, strong) XYButton *button;//扩大点击事件
@property (nonatomic,copy) investBlock block;//investButton和button点击时，开始回调
@property (nonatomic, strong) BidProduct *info;
@property (nonatomic, strong) UIImageView *backImageView;

@end
