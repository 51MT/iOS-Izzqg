//
//  ColorButton.m
//  btn
//
//  Created by LYZ on 14-1-10.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "ColorButton.h"
@implementation ColorButton

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title  ByGradientType:(GradientType)gradientType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *colorArray = [@[COLOR_LIGHT_BUT_BLUE,COLOR_MAIN] mutableCopy];
        UIImage *backImage = [self buttonImageFromColors:colorArray ByGradientType:gradientType];
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (void)setIsColorEnabled:(BOOL)isColorEnabled{
    self.userInteractionEnabled = isColorEnabled;
    if (isColorEnabled) {
        
        NSMutableArray *colorArray = [@[COLOR_LIGHT_BUT_BLUE,COLOR_MAIN] mutableCopy];
        UIImage *backImage = [self buttonImageFromColors:colorArray ByGradientType:leftToRight];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        
    } else {
        [self setBackgroundImage:[ColorUtil imageWithColor:COLOR_LIGHTGRAY_BUTTONDISABLE] forState:UIControlStateNormal];
    }
}


@end

