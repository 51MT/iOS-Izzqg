//
//  HqbHomeCircleProgressView.h
//  Ixyb
//
//  Created by wang on 16/1/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HqbHomeCircleProgressView : UIView {
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;

    CAShapeLayer *_backLayer;
    UIBezierPath *_backPath;

    CADisplayLink *displayLink;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic) double progress;        //0~1之间的数
@property (nonatomic) double currentInterval; //0~1之间的数
@property (nonatomic) float progressWidth;
@property (nonatomic) float trackWidth;

- (void)setProgress:(double)progress animated:(BOOL)animated;

@end
