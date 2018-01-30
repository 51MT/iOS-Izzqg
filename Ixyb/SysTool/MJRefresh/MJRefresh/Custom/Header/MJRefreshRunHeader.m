//
//  MJRefreshRunHeader.m
//  Ixyb
//
//  Created by dengjian on 16/12/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefreshRunHeader.h"

@implementation MJRefreshRunHeader {
    CGFloat pullDownOffset;
    CGFloat scale; //图片尺寸变化比例
    CGFloat lastValue;//上一次下拉的比例
}

- (void)placeSubviews {
    [super placeSubviews];
    self.arrowView.hidden = YES;
    self.loadingView.hidden = YES;
    [self addSubview:_peopleImageView];
    [self addSubview:_animationImageView];
    [self addSubview:_boxView];
}

- (UIImageView *)peopleImageView {
    if (!_peopleImageView) {
        UIImage *peopleImage = [UIImage imageNamed:@"staticDeliveryStaff"];
        CGFloat width = peopleImage.size.width * MJRefreshHeaderHeight / peopleImage.size.height;
        scale = width / peopleImage.size.width;
        _peopleImageView = [[UIImageView alloc] initWithImage:peopleImage];
        _peopleImageView.frame = CGRectMake(10, 0, width, MJRefreshHeaderHeight);
        _peopleImageView.hidden = NO;
        _peopleImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    return _peopleImageView;
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 34.5, 48)];
        NSArray *images = @[ [UIImage imageNamed:@"deliveryStaff0"],
                             [UIImage imageNamed:@"deliveryStaff1"],
                             [UIImage imageNamed:@"deliveryStaff2"],
                             [UIImage imageNamed:@"deliveryStaff3"] ];
        _animationImageView.animationImages = images;
        _animationImageView.hidden = YES;
        _animationImageView.animationDuration = 0.3;
    }
    return _animationImageView;
}

- (UIImageView *)boxView {
    if (!_boxView) {
        UIImage *boxImage = [UIImage imageNamed:@"box"];
        CGFloat width = boxImage.size.width * scale;
        CGFloat height = boxImage.size.height * scale;
        _boxView = [[UIImageView alloc] initWithImage:boxImage];
        _boxView.frame = CGRectMake(100, 0, width, height);
        _boxView.hidden = NO;
    }
    return _boxView;
}

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    switch (state) {
        case MJRefreshStatePulling:
            [self normal];
            break;

        case MJRefreshStateRefreshing:
            [self refreing];
            break;
            
        case MJRefreshStateIdle:
            [self endRefresing];
            break;

        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    CGFloat thum;
    if (pullingPercent <= 1) {
        pullDownOffset = pullingPercent * self.mj_h;
        thum = pullDownOffset / MJRefreshHeaderHeight;
    } else {
        thum = 1;
    }
    self.peopleImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(thum * 30, 0), CGAffineTransformMakeScale(thum, thum));
    self.boxView.transform = CGAffineTransformMakeTranslation(-thum * 35, thum * 20);
}

- (void)normal {
    self.peopleImageView.hidden = NO;
    self.boxView.hidden = NO;
    self.animationImageView.hidden = YES;
    [self.animationImageView stopAnimating];
}

- (void)endRefresing {
    self.animationImageView.hidden = YES;
    [self.animationImageView stopAnimating];
    self.peopleImageView.hidden = YES;
    self.boxView.hidden = NO;

    if (self.state == MJRefreshStateIdle && !self.scrollView.isDragging) {
        CGFloat thum = 0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.boxView.transform = CGAffineTransformMakeTranslation(-thum * 35, thum * 20);
        }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (void)refreing {
    self.peopleImageView.hidden = YES;
    self.boxView.hidden = YES;
    self.animationImageView.hidden = NO;
    [self.animationImageView startAnimating];
}

#pragma mark - Propertys

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        // sectionheader停留解决
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        }
        else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }else{
            self.state = MJRefreshStatePulling;
        }
    } else if (self.state == MJRefreshStatePulling) { // 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
        self.state = MJRefreshStateIdle;
    }
}

@end
