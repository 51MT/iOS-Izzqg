//
//  StartPageViewController.m
//  Ixyb
//
//  Created by wang on 16/6/12.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "StartPageViewController.h"
#import "Utility.h"
#import "XYButton.h"

@interface StartPageViewController ()

@property (nonatomic, strong) UIImageView *startImageView;
@property (nonatomic, strong) UIView *viewBttom;
@property (nonatomic, strong) UIImageView *bttomimageView;
@property (nonatomic, strong) UIImageView *rightArrowimageView;
@property (nonatomic, strong) UIButton *goinBtn;

@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG;

    [self.view addSubview:_startImageView];
    [self.view addSubview:_viewBttom];
    [self.view addSubview:_bttomimageView];
    [self.view addSubview:_goinBtn];
    [self.view addSubview:_rightArrowimageView];
    [self.startImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(@-100);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(MainScreenHeight - 100));
    }];
    [self.viewBttom mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(CGRectGetMaxY(self.startImageView.frame)));
        make.height.equalTo(@100);
        make.width.equalTo(@(MainScreenWidth));
    }];
    [self.bttomimageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(@(CGRectGetWidth(self.viewBttom.frame)));
        make.centerY.equalTo(@(CGRectGetHeight(self.viewBttom.frame)));
        make.width.equalTo(@142);
        make.height.equalTo(@37);

    }];
    [self.goinBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(@(CGRectGetHeight(self.viewBttom.frame)));
        make.right.equalTo(@-9);
        make.width.equalTo(@40);
        make.height.equalTo(@35);
    }];
    [self.rightArrowimageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(@(CGRectGetHeight(self.viewBttom.frame)));
        make.right.equalTo(@-15);
        make.left.equalTo(self.goinBtn).offset(9);
        make.width.equalTo(@8);
        make.height.equalTo(@18);

    }];
    [self loadData];
}

//  加载数据
- (void)loadData {
}

//懒加载 减少应用 内存资源
- (UIImageView *)startImageView {
    if (!_startImageView) {

        _startImageView = [[UIImageView alloc] init];
        _startImageView.clipsToBounds = YES;
        _startImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _startImageView;
}
- (UIView *)viewBttom {
    if (!_viewBttom) {

        _viewBttom = [[UIView alloc] init];
        _viewBttom.backgroundColor = COLOR_COMMON_WHITE;
    }
    return _viewBttom;
}
- (UIImageView *)bttomimageView {
    if (!_bttomimageView) {

        _bttomimageView = [[UIImageView alloc] init];
        _bttomimageView.clipsToBounds = YES;
        _bttomimageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bttomimageView;
}
- (UIImageView *)rightArrowimafeView {
    if (!_rightArrowimageView) {

        _rightArrowimageView = [[UIImageView alloc] init];
        _rightArrowimageView.clipsToBounds = YES;
        _rightArrowimageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightArrowimageView;
}
- (UIButton *)goinBtn {
    if (!_goinBtn) {

        _goinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goinBtn setTitle:XYBString(@"string_Into", @"进入") forState:UIControlStateNormal];
        _goinBtn.titleLabel.font = TEXT_FONT_18;
        [_goinBtn setTitleColor:COLOR_DARK_GREY forState:UIControlStateNormal];
        [_goinBtn setTitleColor:COLOR_MAIN_HIGHT forState:UIControlStateHighlighted];
        [_goinBtn addTarget:self action:@selector(initMainPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goinBtn;
}

/**
 *    进入主页面
 */
- (void)initMainPage {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
