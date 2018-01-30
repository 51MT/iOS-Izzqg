//
//  ProgressView.m
//  Ixyb
//
//  Created by wang on 2017/12/15.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ProgressView.h"
#import "Utility.h"

@interface ProgressView ()

@property (nonatomic,strong)CALayer *progressLayer;
@property (nonatomic,assign)CGFloat currentViewWidth;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressLayer = [CALayer layer];
        self.progressImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,-3.5f, 8.f, 8.f)];
        self.progressImage.image = [UIImage imageNamed:@"progress"];
        self.backgroundColor = COLOR_GRAY_LINE;
        
        self.progressLayer.backgroundColor = [UIColor redColor].CGColor;
        self.progressLayer.frame = CGRectMake(0, 0, 0, frame.size.height);
        
        [self.layer addSublayer:self.progressImage.layer];
        [self.layer addSublayer:self.progressLayer];
        //储存当前view的宽度值
        self.currentViewWidth = frame.size.width;
    }
    return self;
}

#pragma mark - 重写setter,getter方法

@synthesize progress = _progress;
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    }else if (progress <= 1) {
        self.progressLayer.frame = CGRectMake(0, 0, progress *self.currentViewWidth, self.frame.size.height);
    }else {
        self.progressLayer.frame = CGRectMake(0, 0, self.currentViewWidth, self.frame.size.height);
    }
    self.progressImage.frame = CGRectMake(self.progressLayer.frame.size.width,-3.5f,8.f,8.f);
}

- (CGFloat)progress {
    return _progress;
}

@synthesize progressColor = _progressColor;
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressLayer.backgroundColor = progressColor.CGColor;
}

- (UIColor *)progressColor {
    return _progressColor;
}

@end
