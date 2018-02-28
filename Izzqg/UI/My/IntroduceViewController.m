//
//  IntroduceViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/9/17.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "IntroduceViewController.h"

#import "Utility.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) XYButton *btnSkip;

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = COLOR_LIGHTGRAY_GUIDEVIEWBG;
    [self initScrollView];
}

- (void)initScrollView {

    if (MainScreenHeight == 480.0f) {
        self.imageArray = [@[ @"GuideFourFirst", @"GuideFourSecond", @"GuideFourThird" ] mutableCopy];
    } else if (MainScreenHeight == 568.0f) {
        self.imageArray = [@[ @"GuideFiveFirst", @"GuideFiveSecond", @"GuideFiveThird" ] mutableCopy];
    } else if (MainScreenHeight == 667.0f) {
        self.imageArray = [@[ @"GuideSixFirst", @"GuideSixSecond", @"GuideSixThird" ] mutableCopy];
    } else {
        self.imageArray = [@[ @"GuidePlusFirst", @"GuidePlusSecond", @"GuidePlusThird" ] mutableCopy];
    }

    // 初始化 scrollImageView
    self.pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, MainScreenHeight)];
    self.pageScroll.bounces = YES;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
    self.pageScroll.userInteractionEnabled = YES;
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.backgroundColor = COLOR_COMMON_WHITE;
    self.pageScroll.contentSize = CGSizeMake(MainScreenWidth * self.imageArray.count, MainScreenHeight - 20.0f);
    [self.view addSubview:self.pageScroll];

    // 初始化 pagecontrol
    self.pageControl = [[MyPageControl alloc] init];
    self.pageControl.numberOfPages = [self.imageArray count];
    self.pageControl.currentPage = kCurrentPage;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];

    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (IS_IPHONE_4_OR_LESS) {
            make.centerY.equalTo(self.view.mas_bottom).offset(-20);
        } else {
            make.centerY.equalTo(self.view.mas_bottom).offset(-MainScreenWidth / 6);
        }
    }];

    self.btnSkip = [[XYButton alloc] initWithTitle:XYBString(@"string_Skip", @"跳过") btnType:SkipButton];
    [self.btnSkip addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSkip.hidden = NO;
    [self.view addSubview:self.btnSkip];

    [self.btnSkip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(@40);
        make.height.equalTo(@30);
        make.width.equalTo(@61);

    }];

    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (self.isNoWelcome) {
            imageView.frame = CGRectMake((MainScreenWidth * i), -20.0f, MainScreenWidth, MainScreenHeight);
        } else {
            imageView.frame = CGRectMake((MainScreenWidth * i), 0.0f, MainScreenWidth, MainScreenHeight);
        }

        // 下载图片
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", self.imageArray[i]]]];
        //事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.pageScroll addSubview:imageView];
        if (i == self.imageArray.count - 1) {
            self.gotoBtn = [[XYButton alloc] initWithTitle:XYBString(@"string_practice_immediately", @"立即体验") btnType:ExperienceButton];
            [self.gotoBtn addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
            self.gotoBtn.hidden = YES;
            [self.view addSubview:self.gotoBtn];

            [self.gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(MainScreenWidth / 4));
                make.right.equalTo(@(-MainScreenWidth / 4));
                if (IS_IPHONE_4_OR_LESS) {
                    make.centerY.equalTo(self.view.mas_bottom).offset(-59);
                }else if(IS_IPHONE_5)
                {
                    make.centerY.equalTo(self.view.mas_bottom).offset(-50);
                }else {
                    make.centerY.equalTo(self.view.mas_bottom).offset(-(MainScreenWidth / 6 + 49));
                }
                make.height.equalTo(@45);
            }];
        } else {
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat pageWidth = MainScreenWidth;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    if (page == self.imageArray.count - 1) {
        self.btnSkip.hidden = YES;
        self.gotoBtn.hidden = NO;
    } else {
        self.pageControl.hidden = NO;
        self.btnSkip.hidden = NO;
        self.gotoBtn.hidden = YES;
    }

    //  在第一页的时候,不让向左滑动, 在最后一页的时候,滚动到和点击 立即体验一样的效果
    CGPoint currPoint = scrollView.contentOffset;
    if (currPoint.x < 0) {
        currPoint.x = 0;
        [scrollView setContentOffset:currPoint animated:NO];
    }

    CGFloat offset = pageWidth / 5;
    if (self.imageArray.count > 0 && currPoint.x > (self.imageArray.count - 1) * pageWidth + offset) {
        [self gotoMainView:nil];
    }
}

// pagecontrol 选择器的方法
- (void)turnPage {
    int page = (int) self.pageControl.currentPage; // 获取当前的page

    [self.pageScroll scrollRectToVisible:CGRectMake(MainScreenWidth * (page + 1), 0.0f, MainScreenWidth, MainScreenHeight) animated:NO]; // 触摸pagecontroller那个点 往后翻一页 +1
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"split"] && finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedLoadIntroduceViewController:)]) {
            [self.delegate didFinishedLoadIntroduceViewController:self];
        }
    }
}

- (IBAction)gotoMainView:(id)sender {
    if (self.isNoWelcome) {
        [self clickBackBtn];
    } else {
        [self gotoMainViewController];
    }
}

- (void)gotoMainViewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedLoadIntroduceViewController:)]) {
        [self.delegate didFinishedLoadIntroduceViewController:self];
    }
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
