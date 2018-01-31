//
//  RunViewController.h
//  DZGTestDemo
//
//  Created by dengjian on 16/12/9.
//  Copyright © 2016年 dongzhigang. All rights reserved.
//

#import "XHJDRefreshView.h"
#import "XHRefreshControl.h"
#import <UIKit/UIKit.h>

@interface JDRefreshScrollViewController : BaseViewController <XHRefreshControlDelegate>

/**
 *  是否支持下拉刷新
 */
@property (nonatomic, assign) BOOL pullDownRefreshed;

/**
 *  是否支持上拉刷新
 */
@property (nonatomic, assign) BOOL loadMoreRefreshed;

/**
 *  加载数据的页码
 */
@property (nonatomic, assign) NSInteger requestCurrentPage;

@property (nonatomic, strong) XHJDRefreshView *refreshView;
@property (nonatomic, strong) XHRefreshControl *refreshControl;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSMutableArray *dataSource;

//该方法用于数据请求，请求完成后需要控制refreshView的各种状态（切记);外部继承本类以后必须实现的方法
- (void)loadDataSource;

@end
