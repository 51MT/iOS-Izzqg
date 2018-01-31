//
//  XYTableView.m
//  Ixyb
//
//  Created by wangjianimac on 16/8/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYTableView.h"

@implementation XYTableView

- (id)init {
    self = [super init];
    if (self) {
        [self setDelaysContentTouchesOnTableView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelaysContentTouchesOnTableView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDelaysContentTouchesOnTableView];
    }
    return self;
}

//1.解决UITableView的子Button高亮延迟问题
- (void)setDelaysContentTouchesOnTableView {

    self.delaysContentTouches = NO;

    // iterate over all the UITableView's subviews
    for (id view in self.subviews) {

        // looking for a UITableViewWrapperView
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {

            // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
            if ([view isKindOfClass:[UIScrollView class]]) {

                // turn OFF delaysContentTouches in the hidden subview
                UIScrollView *scroll = (UIScrollView *) view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }
}

//2.解决UITableView的子Button高亮延迟问题
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
//
//
//
//
//
//问题Q：UIButton在某些情况下不能立刻响应TouchDown事件，换句话说，迅速点击按钮时，你是永远看不见这个按钮的高亮状态的。而你会发现，出现这种情况时，这些按钮都在UIScrollView（UITableView）上。

//答案A：UITableView：
//不得不说，UITableView（包括UITableViewCell在内）在iOS7和iOS8中的视图结构是不同的，且存在着很多我们在编码时永远接触不到的视图，但我们可通过Debug将其subviews逐个逐个找出来。这关系到我们这个问题坑比较深的层次。

//iOS7：UITableView中存在n + 1个UIScrollView，一个是UITableView本身，另外n个存在于UITableViewCell与cell的contentView之间，类名为UITableViewCellScrollView，活的不久，仅存在于iOS7中，在iOS8中已被移除。

//iOS8：UITableView中存在2个UIScrollView，一个是UITableView本身，另外一个存在于UITableView与UITableViewCell之间，类名为UITableViewWrapperView。需要注意的是，UITableViewWrapperView在iOS7中并不是一个UIScrollView。

//科普知识完，那么我们就有了以下的问题解决方案了： 1、将UIButton所有属于UIScrollView的父视图的delaysContentTouches属性设置成为NO。 2、继承UIScrollView或UITableView，并重写 -(BOOL) touchesShouldCancelInContentView : (UIView *) view方法，让其响应拖动方法。

//以上代码仍未能解决iOS7下UITableView的子Button高亮延迟问题。可加入以下代码来解决：

//for (id obj in cell.subviews) {
//    if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"]) {
//        UIScrollView *scroll = (UIScrollView *) obj;
//        scroll.delaysContentTouches = NO;
//        break;
//    }
//}

//这段代码可加在Custom的UITableViewCell的initWithCoder : 方法中，也可以放在UITableViewDelegate的cellForRowAtIndexPath : 方法中设置对应cell中的UITableViewCellScrollView。
