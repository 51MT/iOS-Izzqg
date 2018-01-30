//
//  JHRingChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHRingChart.h"
#import "Utility.h"

#define k_COLOR_STOCK @[ COLOR_STRONG_RED, COLOR_MAIN,COLOR_XTB_BG, COLOR_ORANGE, COLOR_STRONG_LIGHT_RED, COLOR_LIGHT_GREEN ]
#define k_COLOR_STOCK_BG @[ COLOR_ASSERT_BG ]
@interface JHRingChart ()

//环图间隔 单位为π
@property (nonatomic, assign) CGFloat itemsSpace;

//数值和
@property (nonatomic, assign) CGFloat totolCount;

@property (nonatomic, assign) CGFloat redius;

@end

@implementation JHRingChart

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        _redius = (CGRectGetHeight(self.frame) - 45) / 2;
    }
    return self;
}
- (void)setValueDataArr:(NSArray *)valueDataArr {
    _valueDataArr = valueDataArr;
    [self configBaseData];
}

- (void)configBaseData {
    _totolCount = 0;
    //去掉分割线
    //  _itemsSpace = (M_PI * 2.0 * 8 / 360) / _valueDataArr.count;
    for (id obj in _valueDataArr) {
        _totolCount += [obj floatValue];
    }
}

//开始动画
- (void)showAnimation {
    /*        动画开始前，应当移除之前的layer         */
    //    for (CALayer *layer in self.layer.sublayers) {
    //        [layer removeFromSuperlayer];
    //    }

    CGFloat lastBegin = -M_PI / 22;

    CGFloat totloL = 0;
    NSInteger i = 0;
    for (id obj in _valueDataArr) {

        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        layer.fillColor = [UIColor clearColor].CGColor;
        if (_valueDataArr.count > 1) {
            layer.strokeColor = [k_COLOR_STOCK[i] CGColor];
        } else {
            layer.strokeColor = [k_COLOR_STOCK_BG[i] CGColor];
        }
        CGFloat cuttentpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        totloL += [obj floatValue] / _totolCount;

        [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin endAngle:lastBegin + cuttentpace clockwise:YES];
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        if (IS_IPHONE_5_OR_LESS) {
            layer.lineWidth = 48 * k_Width_Scale;
        } else {
            layer.lineWidth = 64 * k_Width_Scale;
        }
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basic.fromValue = @(0);
        basic.toValue = @(1);
        basic.duration = 0.5;
        basic.fillMode = kCAFillModeForwards;

        [layer addAnimation:basic forKey:@"circleAnimation"];
        lastBegin += (cuttentpace + _itemsSpace);
        i++;
    }
}

@end
