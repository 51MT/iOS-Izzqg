//
//  HomeCircleProgressView.h
//  Ixyb
//
//  Created by wang on 15/10/14.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCircleProgressView : UIView {
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
    CADisplayLink *displayLink;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) double progress;        //0~1之间的数
@property (nonatomic) double currentInterval; //0~1之间的数
@property (nonatomic) float progressWidth;

- (void)setProgress:(double)progress animated:(BOOL)animated;

@end
