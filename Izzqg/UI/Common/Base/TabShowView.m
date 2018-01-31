//
//  TabShowView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "CreditLevelView.h"

#import "TabShowView.h"
#import "Utility.h"

@implementation XYBTabItem

@end

@interface TabShowViewContainerView : UIView
@property (nonatomic) CGSize contentSize;
@end

@implementation TabShowViewContainerView

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

@end

@interface TabShowView ()

@property (nonatomic, strong) TabShowViewContainerView *containerView;
@property (nonatomic, strong) UIView *selectedLineView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) MASConstraint *edgeConstraint;

@end

#define VIEW_TAG_BEGIN 201001
#define VIEW_TAG_CONTROL_BEGIN 301001
#define VIEW_TAG_TITLE_LABEL_BEGIN 401001

#define VIEW_TAG_CONTENT_VIEW_BEGIN 501001

#define VIEW_TAG_LEVEL_VIEW_BEGIN 502001

@implementation TabShowView

- (id)init {
    if (self = [super init]) {
        [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 5 forAxis:UILayoutConstraintAxisVertical];
        _selectedIndex = -1;
        self.items = [NSMutableArray arrayWithCapacity:5];
        self.headView = [[UIView alloc] init];
        [self addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@45);
        }];

        self.selectedLineView = [[UIView alloc] init];
        self.selectedLineView.backgroundColor = COLOR_MAIN;
        [self.headView addSubview:self.selectedLineView];
        [self.selectedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.right.bottom.equalTo(@0);
        }];

        self.containerView = [[TabShowViewContainerView alloc] init];
        [self.containerView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 10 forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.headView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];

        self.headView.backgroundColor = COLOR_COMMON_WHITE;
        self.containerView.backgroundColor = COLOR_COMMON_WHITE;
    }
    return self;
}

- (void)dealloc {
    for (XYBTabItem *item in _items) {
        if (item.style == 1) {
            [item removeObserver:self forKeyPath:@"userData"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([object isKindOfClass:[XYBTabItem class]]) {
        if ([keyPath isEqualToString:@"userData"]) {
            NSDictionary *newUserData = [change objectForKey:@"new"];
            NSInteger level = [[newUserData objectForKey:@"level"] integerValue];
            for (int i = 0; i < self.items.count; i++) {
                if ([object isEqual:self.items[i]]) {
                    CreditLevelView *creditLevelView = [self.headView viewWithTag:VIEW_TAG_LEVEL_VIEW_BEGIN + i];
                    creditLevelView.level = level;
                    break;
                }
            }
        }
    }
}

- (void)addTabItem:(XYBTabItem *)item contentView:(UIView *)contentView {

    NSInteger tag = VIEW_TAG_BEGIN + self.items.count;
    NSInteger tagControl = VIEW_TAG_CONTROL_BEGIN + self.items.count;
    NSInteger tagTitleLabel = VIEW_TAG_TITLE_LABEL_BEGIN + self.items.count;
    NSInteger tagContentView = VIEW_TAG_CONTENT_VIEW_BEGIN + self.items.count;
    NSInteger tagCerditLevelView = VIEW_TAG_LEVEL_VIEW_BEGIN + self.items.count;
    [self.items addObject:item];
    UIView *view = [[UIView alloc] init];
    view.tag = tag;

    UIView *vCb = [[UIView alloc] init];
    [view addSubview:vCb];
    [vCb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.top.bottom.equalTo(view);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = item.title;
    titleLabel.font = TEXT_FONT_16;
    titleLabel.tag = tagTitleLabel;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [vCb addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vCb.mas_centerY);
        make.left.equalTo(vCb.mas_left);
        if (item.style != 1) {
            make.right.equalTo(vCb.mas_right);
        }
    }];

    if (item.style == 1) { //带等级的view
        CreditLevelView *creditLevelView = [[CreditLevelView alloc] init];
        NSInteger level = [[item.userData objectForKey:@"level"] integerValue];
        creditLevelView.level = level;
        creditLevelView.tag = tagCerditLevelView;
        [vCb addSubview:creditLevelView];
        [creditLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vCb.mas_centerY);
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.right.equalTo(vCb.mas_right);
        }];

        [item addObserver:self forKeyPath:@"userData" options:NSKeyValueObservingOptionNew context:nil];
    }

    [self.headView addSubview:view];
    CGFloat width = MainScreenWidth / self.items.count;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@(width));
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [view addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.bottom.equalTo(view.mas_bottom);
    }];

    UIView *lastView = [self viewWithTag:tag - 1];
    if (lastView) {
        UIView *split2View = [[UIView alloc] init];
        split2View.backgroundColor = COLOR_LINE;
        [view addSubview:split2View];
        [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.width.equalTo(@(Line_Height));
            make.top.bottom.equalTo(@0);
        }];

        [lastView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.width.equalTo(view);
            make.right.equalTo(view.mas_left);
        }];
    }

    UIControl *control = [[UIControl alloc] init];
    control.tag = tagControl;
    [view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [control addTarget:self action:@selector(clickControl:) forControlEvents:UIControlEventTouchUpInside];

    [contentView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 15 forAxis:UILayoutConstraintAxisVertical];

    [self.containerView addSubview:contentView];
    contentView.tag = tagContentView;

    if (self.edgeConstraint) {
        [self.edgeConstraint uninstall];
    }
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.edgeConstraint = make.edges.equalTo(self.containerView);
    }];
    //
    //    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.equalTo(@0);
    //        make.top.equalTo(self.headView.mas_bottom);
    //        make.bottom.equalTo(self.mas_bottom);
    //    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    NSInteger lastSelected = _selectedIndex;
    if (lastSelected == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;

    //变色.变动画
    for (int i = 0; i < self.items.count; i++) {
        UILabel *l = (UILabel *) [self.headView viewWithTag:VIEW_TAG_TITLE_LABEL_BEGIN + i];
        if (l) {
            if (selectedIndex == i) {
                l.textColor = COLOR_MAIN;
            } else {
                l.textColor = COLOR_MAIN_GREY;
            }
        }
    }

    CGFloat w = MainScreenWidth / self.items.count;
    [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.equalTo(@(w * selectedIndex));
        make.bottom.equalTo(@0);
        make.width.equalTo(@(w));
    }];

    //隐藏显示contentView
    for (int i = 0; i < self.items.count; i++) {
        UIView *contentView = [self.containerView viewWithTag:VIEW_TAG_CONTENT_VIEW_BEGIN + i];
        if (contentView) {
            if (selectedIndex == i) {
                contentView.hidden = NO;
                self.containerView.contentSize = contentView.intrinsicContentSize;
                if (self.edgeConstraint) {
                    [self.edgeConstraint uninstall];
                }

                [self invalidateIntrinsicContentSize];
                [self.containerView invalidateIntrinsicContentSize];

                [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    self.edgeConstraint = make.edges.equalTo(self.containerView);
                }];

            } else {
                contentView.hidden = YES;
            }
        }
    }
}

- (void)clickControl:(id)ctr {
    UIControl *control = ctr;
    NSInteger index = control.tag - VIEW_TAG_CONTROL_BEGIN;
    self.selectedIndex = index;
}

@end
