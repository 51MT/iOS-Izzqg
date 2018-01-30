//
//  StatusViewController.m
//  Ixyb
//
//  Created by dengjian on 12/15/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "StatusViewController.h"
#import "Utility.h"

#define VIEW_TAG_ITEM_BEGIN 101001

@interface StatusViewController ()

@property (nonatomic, strong) UIView *infoView;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
    self.navigationItem.hidesBackButton = YES;
}

- (void)initUI {

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 50, 22);
    closeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    closeBtn.titleLabel.font = TEXT_FONT_14;
    [closeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    UIBarButtonItem *distance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    distance.width = -10;
    self.navigationItem.rightBarButtonItems = @[ distance, rightBarButton ];

    self.view.backgroundColor = COLOR_BG;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    UIView *vi = [[UIView alloc] init];
    [scrollView addSubview:vi];
    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = COLOR_COMMON_WHITE;
    [scrollView addSubview:self.infoView];
    [self.infoView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
    }];

    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [self.infoView addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoView.mas_bottom);
        make.left.right.equalTo(@0);
    }];

    self.goToButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollView addSubview:self.goToButton];
    [self.goToButton addTarget:self action:@selector(clickGoToButton:) forControlEvents:UIControlEventTouchUpInside];
    if (self.nextTitleStr) {
        [self.goToButton setTitle:self.nextTitleStr forState:UIControlStateNormal];
    } else {
        [self.goToButton setTitle:XYBString(@"string_look", @"查看") forState:UIControlStateNormal];
    }
    [self.goToButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];

    self.goToButton.clipsToBounds = YES;
    self.goToButton.layer.cornerRadius = Corner_Radius;
    [self.goToButton setBackgroundColor:COLOR_MAIN];
}

- (void)refreshUI {

    for (UIView *v in [self.infoView subviews]) {
        [v removeFromSuperview];
    }

    [self.dataArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *item = obj;
        NSString *iconName = [item objectForKey:@"iconName"];
        NSString *title = [item objectForKey:@"title"];
        NSString *subTitle = [item objectForKey:@"subTitle"];
        BOOL isDone = [[item objectForKey:@"isDone"] boolValue];

        BOOL isFirst = (idx == 0);
        BOOL isLast = (idx == ([self.dataArray count] - 1));
        CGFloat upLineH = 30;
        CGFloat downLineH = 30;
        CGFloat lineWidth = 2;

        UIView *itemView = [[UIView alloc] init];
        itemView.tag = VIEW_TAG_ITEM_BEGIN + idx;
        [self.infoView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {

            if (isFirst) {
                make.top.equalTo(@20);
            } else {
                UIView *lastItemView = [self.infoView viewWithTag:VIEW_TAG_ITEM_BEGIN + idx - 1];
                make.top.equalTo(lastItemView.mas_bottom);
            }

            make.left.right.equalTo(@0);

            if (isLast) {
                make.bottom.equalTo(self.infoView.mas_bottom);
            }
        }];

        UIView *upLine = [[UIView alloc] init];
        if (isDone) {
            upLine.backgroundColor = COLOR_MAIN;
        } else {
            upLine.backgroundColor = COLOR_LINE;
        }
        [itemView addSubview:upLine];
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@40);
            make.width.equalTo(@(lineWidth));
            if (isFirst) {
                make.height.equalTo(@(0));
            } else {
                make.height.equalTo(@(upLineH));
            }
        }];

        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:iconName];
        [itemView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(upLine.mas_centerX);
            make.top.equalTo(upLine.mas_bottom);
        }];

        UIView *downLine = [[UIView alloc] init];
        if (isDone) {
            downLine.backgroundColor = COLOR_MAIN;
        } else {
            downLine.backgroundColor = COLOR_LINE;
        }

        [itemView addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom);
            make.centerX.equalTo(upLine.mas_centerX);
            make.width.equalTo(@(lineWidth));
            if (isLast) {
                make.height.equalTo(@(0));
            } else {
                make.height.equalTo(@(downLineH));
                make.bottom.equalTo(itemView.mas_bottom);
            }
        }];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = TEXT_FONT_16;
        titleLabel.textColor = COLOR_MAIN_GREY;
        titleLabel.text = title;
        [itemView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconView.mas_centerY);
            make.left.equalTo(iconView.mas_right).offset(10);
        }];

        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.text = subTitle;
        subTitleLabel.font = TEXT_FONT_12;
        subTitleLabel.textColor = COLOR_LIGHT_GREY;
        [itemView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.left.equalTo(titleLabel.mas_left);
            if (isLast) {
                make.bottom.equalTo(itemView.mas_bottom).offset(-20);
            }
        }];

    }];

    if ([self.nextTitleStr isEqualToString:@"确定"]) {
        [self.goToButton setTitle:self.nextTitleStr forState:UIControlStateNormal];
        [self.goToButton setHidden:YES];
    }
}

- (void)clickGoToButton:(id)sender {
    if (self.gotoVC) {
        [self.navigationController popToViewController:self.gotoVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickBackBtn:(id)sender {
    if (self.backVC) {
        [self.navigationController popToViewController:self.backVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
