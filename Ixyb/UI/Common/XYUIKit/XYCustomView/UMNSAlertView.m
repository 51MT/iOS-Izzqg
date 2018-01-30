//
//  NotificationAlertView.m
//  Ixyb
//
//  Created by 董镇华 on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "UMNSAlertView.h"
#import "UMessage.h"
#import "Utility.h"

#define VIEW_TAG_CONTENT_LABEL 1002003
#define VIEW_TAG_TITLE_LABEL 1002004

@implementation UMNSAlertView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self initUI];
    }
    return self;
}

- (void)initUI {

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius;
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(270));
        make.center.equalTo(@0);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"推送消息";
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.font = TEXT_FONT_16;
    [contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(24));
        make.centerX.equalTo(self);
    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = TEXT_FONT_14;
    contentLabel.textColor = COLOR_AUXILIARY_GREY;
    contentLabel.tag = VIEW_TAG_CONTENT_LABEL;
    [contentView addSubview:contentLabel];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [contentView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(24);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(Line_Height));
    }];

    XYButton *cancelButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_known", @"知道了") isUserInteractionEnabled:YES];
    cancelButton.titleLabel.font = TEXT_FONT_16;
    [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];

    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(lineView.mas_top);
        make.height.equalTo(@(Cell_Height));
    }];

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = COLOR_LINE;
    [contentView addSubview:lineView2];

    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(cancelButton.mas_right);
        make.centerX.equalTo(@0);
    }];

    XYButton *checkButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_look", @"查看") isUserInteractionEnabled:YES];
    checkButton.titleLabel.font = TEXT_FONT_BOLD_16;
    [checkButton addTarget:self action:@selector(clickTheCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:checkButton];

    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView2.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(@0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

/**
 *  将友盟推送消息弹窗弹出
 */
- (void)show {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    [app.window bringSubviewToFront:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;

    UILabel *titleLabel = [self viewWithTag:VIEW_TAG_TITLE_LABEL];
    UILabel *contentLabel = [self viewWithTag:VIEW_TAG_CONTENT_LABEL];

    titleLabel.text = [dataSource objectForKey:@"title"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0f; // 字体的行间距
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
        NSFontAttributeName : TEXT_FONT_14
    };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[dataSource objectForKey:@"content"] attributes:attributes];
    contentLabel.attributedText = attrStr;
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
}

/**
 *  点击查看进入消息分类页面
 *
 *  @param sender 查看按钮
 */
- (void)clickTheCheckBtn:(id)sender {
    //统计消息点击事件
    [UMessage sendClickReportForRemoteNotification:self.userInfoDic];
    //消除Windows上的UMNSAlertView弹窗
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    for (UIView *view in app.window.subviews) {
        if ([view isKindOfClass:[UMNSAlertView class]]) {
            [view removeFromSuperview];
        }
    }
    //回调进入分类消息页面（切换过程为：先切换tabbarController，然后再push进入分类消息页面）
    self.block();
}

@end
