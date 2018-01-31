//
//  TableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 16/4/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "TableViewCell.h"

#import "Utility.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//在自定义的UITableViewCell里重写drawRect：方法
#pragma mark - 绘制Cell分割线
- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, COLOR_COMMON_CLEAR.CGColor);
    CGContextFillRect(context, rect);

    //上分割线，
    CGContextSetStrokeColorWithColor(context, COLOR_LINE.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, Line_Height));

    //下分割线
    CGContextSetStrokeColorWithColor(context, COLOR_LIGHT_GREEN.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width - 14.f, Line_Height));
}

@end
