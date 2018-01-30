//
//  MJRefreshCustomGifHeader.m
//  Ixyb
//
//  Created by dengjian on 16/12/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "MJRefreshCustomGifHeader.h"
#import "Utility.h"

@interface MJRefreshCustomGifHeader ()

@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation MJRefreshCustomGifHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action Type:(int)type {
    [super headerWithRefreshingTarget:target refreshingAction:action];
    MJRefreshCustomGifHeader *cmp = [[self alloc] init];
    cmp.type = type;
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 懒加载
- (UIImageView *)gifView {
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

- (UILabel *)showLab {
    if (!_showLab) {
        _showLab = [[UILabel alloc] init];
        _showLab.font = TEXT_FONT_10;
        _showLab.textColor = COLOR_LIGHT_GREY;
        _showLab.textAlignment = NSTextAlignmentCenter;
        if (_type == 3) {
            _showLab.hidden = YES;
        }
        [self addSubview:_showLab];
        
        [_showLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            if (_type == 1) {
                make.top.equalTo(self.gifView.mas_bottom).offset(4);
            }else if (_type == 2) {
                make.top.equalTo(self.gifView.mas_bottom).offset(4);
            }else if (_type == 3) {
                make.top.equalTo(self.gifView.mas_bottom);
                make.height.equalTo(@(0));
            }
        }];
    }
    return _showLab;
}

#pragma mark - 公共方法

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration); 
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    [self setImages:images duration:images.count * 0.1 forState:state];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    /* 根据type设置控件的高度 */
    if (_type == 1) {
        self.mj_h = 100.f;
    }else if (_type == 2) {
        self.mj_h = 80.f;
    }else if (_type == 3) {
        self.mj_h = 63.f;
    }
}

#pragma mark - 实现父类的方法

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    self.gifView.image = [images firstObject];
}

- (void)placeSubviews {
    [super placeSubviews];
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        /* 根据type设置控件的高度 */
        if (_type == 1) {
            self.gifView.frame = CGRectMake((self.bounds.size.width - 50)/2, 24, 50, 50);
        }else if (_type == 2) {
            self.gifView.frame = CGRectMake((self.bounds.size.width - 50)/2, 4, 50, 50);
        }else if (_type == 3) {
            self.gifView.frame = CGRectMake((self.bounds.size.width - 50)/2, 8, 50, 50);
        }
        self.gifView.contentMode = UIViewContentModeCenter;
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images firstObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    }
}

@end
