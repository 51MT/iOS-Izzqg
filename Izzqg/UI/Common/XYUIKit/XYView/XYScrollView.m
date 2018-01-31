//
//  XYScrollView.m
//  Ixyb
//
//  Created by wangjianimac on 16/8/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYScrollView.h"

@implementation XYScrollView

- (id)init {
    self = [super init];
    if (self) {
        //1.解决UIScrollView的子Button高亮延迟问题
        self.delaysContentTouches = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //1.解决UIScrollView的子Button高亮延迟问题
        self.delaysContentTouches = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delaysContentTouches = NO;
    }
    return self;
}

//2.解决UIScrollView的子Button高亮延迟问题
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];
    
    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
        return NO;
    }
    return YES;
}

@end

//问题Q：UIButton在某些情况下不能立刻响应TouchDown事件，换句话说，迅速点击按钮时，你是永远看不见这个按钮的高亮状态的。而你会发现，出现这种情况时，这些按钮都在UIScrollView（UITableView）上。

//答案A：UIScrollView：
//1、属性delaysContentTouches，布尔类型，默认值为YES。值为YES时，UIScrollView会在接收到手势时延迟150ms来判断该手势是否能够出发UIScrollView的滑动事件；值为NO时，UIScrollView会立马将接收到的手势分发到子视图上。
//（注：仅仅设置这个是不够的，你会发现如果想要拖动scrollView而起点落在其他有手势识别的视图上时会拖不动）

//2、方法- (BOOL)touchesShouldCancelInContentView:(UIView *)view，此方法的重载是帮助我们完美解决问题的重点，决定手势是否取消传递到view上，拖动ScrollView时触发。返回NO时，拖动手势将留在ScrollView上，返回YES则将手势传到view上。（若view是UIControl，则默认返回YES）
