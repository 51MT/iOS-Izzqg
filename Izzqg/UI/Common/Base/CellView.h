//
//  CellView.h
//  Ixyb
//
//  Created by dengjian on 12/10/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block)(void);

typedef enum {
    CellViewStyleDefault
} CellViewStyle;

@class CellView;


@interface CellView : UIView

- (id)initWithStyle:(CellViewStyle)style;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, copy)block blcokClick;

@end
