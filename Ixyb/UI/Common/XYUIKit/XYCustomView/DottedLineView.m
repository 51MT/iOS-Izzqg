//
//  XYBDottedLineView.m
//  Ixyb
//
//  Created by wang on 16/6/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "DottedLineView.h"

@implementation DottedLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();          //设置上下文
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor); //线条颜色
    CGContextSetLineWidth(context, 1.f);                           //线条宽度
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);   //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);    //画直线, x，y 为线条结束点的坐标
    CGFloat lengths[] = {_solidWidth, _spaceWidth};
    CGContextSetLineDash(context, 0, lengths, 1.5f);
    CGContextStrokePath(context); //开始画线
}

@end
