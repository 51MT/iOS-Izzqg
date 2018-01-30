//
//  BannerScrollView.m
//  Ixyb
//
//  Created by dengjian on 16/11/15.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BannerScrollView.h"
#import "HomePageResponseModel.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"

@interface BannerScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *defaultImgView; //默认底图
@property (nonatomic, strong) UIPageControl *page;         //分页控制器
@property (nonatomic, strong) NSTimer *timer;              //计时器
@property (nonatomic, assign) int currentPage;

@end

@implementation BannerScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollview];
    }
    return self;
}

/**
 *  创建滚动视图
 */
- (void)createScrollview {

    _currentPage = 0;
    _scrollView = [[XYScrollView alloc] initWithFrame:CGRectZero];
    //_scrollView.backgroundColor = COLOR_MAIN;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIImage *image = [UIImage imageNamed:@"bannerDefaultImage"];
    _defaultImgView = [[UIImageView alloc] initWithImage:image];
    [_scrollView addSubview:_defaultImgView];

    [_defaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_scrollView);
        make.height.equalTo(@(image.size.height));
        make.width.equalTo(@(MainScreenWidth));
    }];

    _page = [[UIPageControl alloc] init];
//    _page.backgroundColor = COLOR_MAIN;
    _page.pageIndicatorTintColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.5];
    _page.currentPageIndicatorTintColor = COLOR_COMMON_WHITE;
    _page.hidden = YES;
    [_page addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_page];

    [_page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@(10));
    }];

    // 定时器 循环
    _timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  分页控制器上的按钮的触发方法
 */
- (void)pageClick:(UIPageControl *)page {
    NSInteger num = page.currentPage;
    [_scrollView setContentOffset:CGPointMake(num * MainScreenWidth, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int num = scrollView.contentOffset.x / MainScreenWidth;
    _page.currentPage = num;
    _currentPage = num;
    [_timer invalidate];
    _timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)runTimePage {
    _currentPage++;
    if (_currentPage >= self.dataSourse.count) {
        _currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(MainScreenWidth * _currentPage, 0) animated:NO];
        _page.currentPage = _currentPage;
        return;
    }
    [_scrollView setContentOffset:CGPointMake(MainScreenWidth * _currentPage, 0) animated:YES];
    _page.currentPage = _currentPage;
}

/**
 *  赋值
 */
- (void)setDataSourse:(NSMutableArray *)dataSourse {
    _dataSourse = dataSourse;
    //当传入数据源有值时才进行赋值，否则不赋值，显示默认的图片
    if (_dataSourse.count > 0) {
        [_defaultImgView removeFromSuperview];
        UIImage *image = [UIImage imageNamed:@"bannerDefaultImage"];
        _scrollView.contentSize = CGSizeMake(_dataSourse.count * MainScreenWidth, image.size.height);
        _page.hidden = NO;
        _page.numberOfPages = _dataSourse.count;

        for (int i = 0; i < _dataSourse.count; i++) {
            BannerHomePageModel *banner = [_dataSourse objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString: banner.imgPath] placeholderImage:image];
            imageView.tag = 1000 + i;
            [_scrollView addSubview:imageView];

            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [imageView addGestureRecognizer:tap];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(MainScreenWidth * i));
                make.top.equalTo(self);
                make.width.equalTo(@(MainScreenWidth));
                make.height.equalTo(@(self.bounds.size.height));
            }];
        }
    }
}

/**
 *  scrollview上的图片点击的触发方法
 */
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    if (self.dataSourse.count > 0) {
        UIImageView *imageView = (UIImageView *) tap.view;
        self.block(imageView.tag - 1000);
    }
}

@end
