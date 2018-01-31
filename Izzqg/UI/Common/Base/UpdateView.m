//
//  UpdateView.m
//  Ixyb
//
//  Created by dengjian on 12/8/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "DMUpdateInfo.h"

#import "UpdateView.h"
#import "Utility.h"

#define VIEW_TAG_SPLIT_MID_VIEW 1002001
#define VIEW_TAG_UPDATE_BUTTON 1002002
#define VIEW_TAG_CONTENT_LABEL 1002003
#define VIEW_TAG_TITLE_LABEL 1002004

@interface UpdateView ()
@property (nonatomic, strong) MASConstraint *updateButtonLeftConstraint;
@property (nonatomic, strong) void (^completion)();

@end

@implementation UpdateView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)show:(void (^)(int state))completion {
    self.completion = completion;
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    for (UIView * view  in app.window.subviews) {
        if (![view isKindOfClass:[UpdateView class]]) {
            [app.window addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(app.window);
            }];
        }else
        {
                [self removeFromSuperview];
        }
    }
}

- (void)setUpdateInfo:(VersionModel *)updateInfo {
    _updateInfo = updateInfo;

    UILabel *titleLabel = [self viewWithTag:VIEW_TAG_TITLE_LABEL];
    UIButton *updateButton = [self viewWithTag:VIEW_TAG_UPDATE_BUTTON];
    UIView *splitMidView = [self viewWithTag:VIEW_TAG_SPLIT_MID_VIEW];
    UILabel *contentLabel = [self viewWithTag:VIEW_TAG_CONTENT_LABEL];

    titleLabel.text = [NSString stringWithFormat:XYBString(@"string_new_version", @"新版本V%@"), updateInfo.appVersion];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f; // 字体的行间距
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
        NSFontAttributeName : TEXT_FONT_16
    };

    NSString *tipFomatStr = [updateInfo.updateTips stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
    NSString *text = [NSString stringWithFormat:XYBString(@"string_some_yuan_amount", @"%@"), tipFomatStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    //    [attrStr addAttributes:@{NSForegroundColorAttributeName:COLOR_LIGHT_GREY} range:NSMakeRange(0, 5)];
    //    [attrStr addAttributes:@{NSForegroundColorAttributeName:COLOR_LIGHT_GREY} range:NSMakeRange([text length] - 5, 5)];
    contentLabel.attributedText = attrStr;

    if (self.updateButtonLeftConstraint) {
        [self.updateButtonLeftConstraint uninstall];
    }
    //    updateInfo.isForceUpdate = NO;
    if ([updateInfo.isForceUpdate boolValue]) {
        [updateButton mas_updateConstraints:^(MASConstraintMaker *make) {
            self.updateButtonLeftConstraint = make.left.equalTo(self.mas_left);
        }];

    } else {

        [updateButton mas_updateConstraints:^(MASConstraintMaker *make) {
            self.updateButtonLeftConstraint = make.left.equalTo(splitMidView.mas_right);
        }];
    }
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.center.equalTo(@0);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = XYBString(@"string_find_newversion", @"新版本");
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.tag = VIEW_TAG_TITLE_LABEL;
    titleLabel.font = TEXT_FONT_18;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@25);
        make.top.equalTo(@Margin_Length);
    }];

    //    UIView * split1View = [[UIView alloc] init];
    //    split1View.backgroundColor = COLOR_LINE;
    //    [contentView addSubview:split1View];
    //    [split1View mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    //        make.left.equalTo(@25);
    //        make.right.equalTo(@-25);
    //        make.height.equalTo(@(Line_Height));
    //    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = TEXT_FONT_16;
    contentLabel.textColor = COLOR_AUXILIARY_GREY;
    contentLabel.tag = VIEW_TAG_CONTENT_LABEL;

    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-25);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:XYBString(@"string_cancel", @"取消") forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(split2View.mas_top);
        make.height.equalTo(@50);
    }];

    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    split3View.tag = VIEW_TAG_SPLIT_MID_VIEW;
    [contentView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(cancelButton.mas_right);
        make.centerX.equalTo(@0);
    }];

    //#pragma mark - button修改处1
    //#if 0

    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:XYBString(@"string_now_update", @"现在升级") forState:UIControlStateNormal];
    [updateButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [updateButton setBackgroundColor:COLOR_COMMON_WHITE];
    updateButton.tag = VIEW_TAG_UPDATE_BUTTON;
    [updateButton addTarget:self action:@selector(clickUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    updateButton.clipsToBounds = YES;
    [contentView addSubview:updateButton];
    //#else
    //
    //    XYButton *updateButton = [[XYButton alloc]initWithSubordinationButtonTitle:XYBString(@"string_now_update",@"现在升级") isUserInteractionEnabled:YES];
    //    [updateButton addTarget:self action:@selector(clickUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [contentView addSubview:updateButton];
    //    updateButton.tag = VIEW_TAG_CONTENT_LABEL;
    //
    //#endif
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@50);
        //        make.left.equalTo(split3View.mas_right);
        self.updateButtonLeftConstraint = make.left.equalTo(@0);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(1);
    }
    self.completion = nil;
}

- (void)clickUpdateButton:(id)sender {
    [self removeFromSuperview];

    if (self.completion) {
        self.completion(0);
    }
    self.completion = nil;

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xin-yong-bao/id785078356?mt=8"]];
    sleep(1);
    exit(0);
}

@end
