//
//  BaseViewController.h
//  Ixyb
//
//  Created by dengjian on 9/2/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYUIKit.h"

#import "XYDefine.h"

#import "IQKeyboardReturnKeyHandler.h"
#import "MJRefreshCustomGifHeader.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader1;
@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader2;
@property (nonatomic, strong) MJRefreshCustomGifHeader *gifHeader3;

//- (void)showLoading;
- (void)showLoadingWithLabelText:(NSString *)labelText;
- (void)showLoadingWithLabelText:(NSString *)labelText andDetailsLabelText:(NSString *)detailsLabelText;
//- (void)showLoadingOnAlertView;

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
 *  @brief 数据加载loading
 */
- (void)showDataLoading;
- (void)showDataLoadingOnAlertView;

/**
 *  @author xyb, 16-3-23 11:19:39
 *
 *  @brief 二维码识别loading
 */
- (void)showQrcodeLoadingOnAlertView;

/**
 *  @author Dzg
 *
 *  @brief 上拉动画刷新响应的方法（仅限于当前控制器中只有一个scrollView或者一个tableView）
 */
- (void)headerRereshing;


@end
