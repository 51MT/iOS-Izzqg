//
//  NoticeView.m
//  Ixyb
//
//  Created by dengjian on 16/12/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self createMainUI];
    }
    return self;
}

- (void)createMainUI {

    XYButton *button = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    [button addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.image = [UIImage imageNamed:@"notice"];
    [self addSubview:_imgView];

    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Margin_Length);
        make.centerY.equalTo(self);
    }];

    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = TEXT_FONT_14;
    _titleLab.textColor = COLOR_MAIN_GREY;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = XYBString(@"str_financing_notice", @"公告");
    [self addSubview:_titleLab];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(Margin_Length);
        make.top.equalTo(self.mas_top).offset(13);
        make.height.equalTo(@(15));
    }];

    _detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLab.font = TEXT_FONT_12;
    _detailLab.textColor = COLOR_AUXILIARY_GREY;
    _detailLab.textAlignment = NSTextAlignmentLeft;
    _detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _detailLab.text = XYBString(@"str_message_defaultContent", @"........................");
    [self addSubview:_detailLab];

    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_left);
        make.top.equalTo(_titleLab.mas_bottom).offset(5);
        make.height.equalTo(@(13));
        make.width.equalTo(@(MainScreenWidth - 97));
    }];

    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = TEXT_FONT_12;
    _timeLab.textColor = COLOR_LIGHT_GREY;
    _timeLab.text = @"2000:01:01 12:00";
    [self addSubview:_timeLab];

    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(_titleLab);
        make.height.equalTo(@(13));
    }];

    _redPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPoint"]];
    _redPoint.hidden = YES;
    [self addSubview:_redPoint];

    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeLab.mas_right);
        make.centerY.equalTo(_detailLab.mas_centerY);
    }];

    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = COLOR_LINE;
    [self addSubview:_bottomLine];

    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_left);
        make.right.bottom.equalTo(self);
        make.height.equalTo(@(Line_Height));
    }];
}

- (void)clickTheButton:(id)sender {
    //点击回调，然后跳转到对应页面
    self.block(self.type);
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 0) {
        _imgView.image = [UIImage imageNamed:@"notice"];
        _titleLab.text = XYBString(@"str_financing_notice", @"公告");
        
    } else if (type == 1) {
        _imgView.image = [UIImage imageNamed:@"activity"];
        _titleLab.text = XYBString(@"str_financing_activity", @"活动");
        
    } else if (type == 4) {
        _imgView.image = [UIImage imageNamed:@"news"];
        _titleLab.text = XYBString(@"str_message_news", @"新闻");

    } else if (type == 3) {
        _imgView.image = [UIImage imageNamed:@"borrow"];
        _titleLab.text = XYBString(@"str_sidebar_loan", @"借款");
        
    } else if (type == 2) {
        _imgView.image = [UIImage imageNamed:@"finance"];
        _titleLab.text = XYBString(@"str_message_finance", @"出借");
    }
}

@end
