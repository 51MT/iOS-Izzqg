//
//  BaseView.h
//  Ixyb
//
//  Created by wangjianimac on 16/7/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader1;
@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader2;
@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader3;

- (void)showLoading;
- (void)showLoadingWithLabelText:(NSString *)labelText;                                                  //菊花下方带一行字
- (void)showLoadingWithLabelText:(NSString *)labelText andDetailsLabelText:(NSString *)detailsLabelText; //菊花下方带两行字
- (void)showLoadingOnAlertView;

- (void)hideLoading;

- (void)showDelayTip:(NSString *)msg;
- (void)showPromptTip:(NSString *)msg;

/**
 *  @author xyb, 16-11-17 17:11:50
 *
 *  @brief 安全交易loading
 */
- (void)showTradeLoading;
- (void)showTradeLoadingOnAlertView;

/**
 *  @author xyb, 16-11-17 17:11:39
 *
 *  @brief 信用宝出借loading
 */
- (void)showDataLoading;
- (void)showDataLoadingOnAlertView;

/**
 *  @author Dzg
 *
 *  @brief 动画刷新响应的方法
 */
- (void)headerRereshing;

@end
