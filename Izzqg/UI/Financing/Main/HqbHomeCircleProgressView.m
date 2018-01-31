//
//  HqbHomeCircleProgressView.m
//  Ixyb
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HqbHomeCircleProgressView.h"

#import "Utility.h"

@implementation HqbHomeCircleProgressView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _trackLayer = [[CAShapeLayer alloc] init]; //背景圈
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;

        _progressLayer = [[CAShapeLayer alloc] init]; //进度圈
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        //        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;

        //        _backLayer = [CAShapeLayer alloc] init];
        //        [self.layer addSublayer:_backLayer];
        //        _backLayer.fillColor = nil;
        //        _backLayer.lineCap = kCALineCapRound;
        //        _backLayer.frame = self.bounds;
        //
        //默认5
        self.progressWidth = 5;
        self.trackWidth = 2;
        self.currentInterval = 0.0f;
    }
    return self;
}
- (id)init {

    self = [super init];
    if (self) {
        // Initialization code
        _trackLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;

        _progressLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        //        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;

        //        _backLayer = [CAShapeLayer alloc] init];
        //        [self.layer addSublayer:_backLayer];
        //        _backLayer.fillColor = nil;
        //        _backLayer.lineCap = kCALineCapRound;
        //        _backLayer.frame = self.bounds;
        //默认5
        self.progressWidth = 5;
        self.trackWidth = 1;
        self.currentInterval = 0.0f;
    }
    return self;
}

- (void)setTrack {

    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width + _progressWidth + 1) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    ;
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress {

    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width - _progressWidth + _trackWidth) / 2 startAngle:-M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}

- (void)setBack {
    _backPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width + _progressWidth + _trackWidth) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    ;
    _backLayer.path = _backPath.CGPath;
}

- (void)setProgressWidth:(float)progressWidth {
    _progressWidth = progressWidth;
    //    _trackLayer.lineWidth = _progressWidth-1;
    _trackLayer.lineWidth = 7;
    _progressLayer.lineWidth = _progressWidth;
    _backLayer.lineWidth = _progressWidth;
    [self setTrack];
    [self setProgress];
    [self setBack];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setBackColor:(UIColor *)backColor {
    _backLayer.strokeColor = backColor.CGColor;
}

- (void)setProgress:(double)progress {
    _progress = progress;

    [self setProgress];
}

- (void)setProgress:(double)progress animated:(BOOL)animated {
    _progress = progress;

    //去掉转圈效果
    //    if (animated) {
    //        if (displayLink) {
    //            displayLink = nil;
    //            self.currentInterval = 0.0f;
    //        }
    //        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgressCircle)];
    //        displayLink.frameInterval = 1;
    //        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //    }
}

- (void)updateProgressCircle {

    if (_progress == 0) {

        _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width - _progressWidth) / 2 startAngle:-M_PI_2 endAngle:(M_PI * 2) * 0 - M_PI_2 clockwise:YES];
        _progressLayer.path = _progressPath.CGPath;
    }
    if (self.currentInterval < _progress) {
        self.currentInterval += 0.005;
        _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width - _progressWidth) / 2 startAngle:-M_PI_2 endAngle:(M_PI * 2) * self.currentInterval - M_PI_2 clockwise:YES];
        _progressLayer.path = _progressPath.CGPath;

    } else {

        [displayLink invalidate];
        displayLink.paused = YES;

        return;
    }
}

@end
