//
//  InfoView.m
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "InfoView.h"

#import "RTLabel.h"
#import "Utility.h"

@interface InfoView () <RTLabelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RTLabel *infoLabel;

@property (nonatomic, strong) MASConstraint *bottomConstraint;

@end

@implementation InfoView

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoView:didSelectLinkWithURL:)]) {
        [self.delegate infoView:self didSelectLinkWithURL:url];
    }
}

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = TEXT_FONT_16;
        self.titleLabel.textColor = MAINTEXTCOLOR;
        self.titleLabel.text = @" ";
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(Margin_Length - Line_Height));
            make.left.equalTo(@Margin_Length);
            make.right.equalTo(@-Margin_Length);
        }];

        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = COLOR_LINE;
        [self addSubview:splitView];
        
        [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_Length);
            make.left.equalTo(@Margin_Length);
            make.right.equalTo(@(-Margin_Length));
            make.height.equalTo(@(Line_Height));
        }];

        self.infoLabel = [[RTLabel alloc] init];
        self.infoLabel.text = @" ";
        self.infoLabel.font = TEXT_FONT_14;
        self.infoLabel.textColor = COLOR_AUXILIARY_GREY;
        self.infoLabel.delegate = self;
        [self addSubview:self.infoLabel];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(splitView.mas_bottom).offset(15);
            make.left.equalTo(@Margin_Length);
            make.right.equalTo(@(-Margin_Length));
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomConstraint = make.bottom.equalTo(self.infoLabel.mas_bottom);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title && title.length > 0) {
        self.titleLabel.text = title;
    }
}

- (void)setInfo:(NSString *)info {
    _info = info;
    if (info && info.length > 0) {
        [self.infoLabel setText:[NSString stringWithFormat:@"%@", info]];
        if (self.bottomConstraint) {
            [self.bottomConstraint uninstall];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomConstraint = make.bottom.equalTo(self.infoLabel.mas_bottom);
            }];
        }
    }
}

@end
