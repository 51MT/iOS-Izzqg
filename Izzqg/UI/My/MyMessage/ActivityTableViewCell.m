//
//  ActivityTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "XYButton.h"

@implementation ActivityTableViewCell {

    UILabel *titleLab;        //消息title
    UILabel *timeLab;         //消息时间
    UIImageView *imageView;   //消息图片
    UILabel *descripeLab;     //消息描述
    XYButton *checkDetailBtn; //查看详情
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.layer.cornerRadius = Corner_Radius;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    backView.layer.borderWidth = Border_Width;
    [self.contentView addSubview:backView];

    UIImage *image = [UIImage imageNamed:@"messageDefault"];
    CGFloat imageHight = (MainScreenWidth - 60) * image.size.height / image.size.width; //计算图片适配后的高度
    imageHight = imageHight + Margin_Length;                                            //加上图片的顶部距时间lab的间距

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(Margin_Length);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(158 + imageHight));
    }];

    titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_16;
    titleLab.text = @"公告";
    titleLab.textColor = COLOR_MAIN_GREY;
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    [backView addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(Margin_Length);
        make.right.equalTo(backView).offset(-Margin_Length);
    }];

    timeLab = [[UILabel alloc] init];
    timeLab.font = TEXT_FONT_12;
    timeLab.text = @"0000-00-00 00:00";
    timeLab.textColor = COLOR_AUXILIARY_GREY;
    [backView addSubview:timeLab];

    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab).offset(0);
        make.top.equalTo(titleLab.mas_bottom).offset(6);
    }];

    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = image;
    [backView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(timeLab.mas_bottom).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@((MainScreenWidth - Margin_Length * 4) * image.size.height / image.size.width)); //根据默认图片算出适配的高度
    }];

    descripeLab = [[UILabel alloc] init];
    descripeLab.textColor = COLOR_MAIN_GREY;
    descripeLab.font = TEXT_FONT_12;
    descripeLab.text = @"*************************";
    descripeLab.numberOfLines = 2;
    [backView addSubview:descripeLab];

    [descripeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLab).offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_LINE;
    [backView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(Margin_Length);
        make.right.equalTo(backView).offset(-Margin_Length);
        make.bottom.equalTo(backView.mas_bottom).offset(-40);
        make.height.equalTo(@(Line_Height));
    }];

    checkDetailBtn = [[XYButton alloc] initWithGeneralBtnTitle:@"查看详情" titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    checkDetailBtn.titleLabel.font = TEXT_FONT_14;
    [checkDetailBtn addTarget:self action:@selector(clickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:checkDetailBtn];

    [checkDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(Margin_Length);
        make.top.equalTo(lineView.mas_bottom).offset(13);
        make.bottom.equalTo(backView.mas_bottom).offset(-13);
    }];
}

- (void)setNotification:(NotificationsModel *)notification {
    _notification = notification;
    titleLab.text = _notification.title;
    timeLab.text = _notification.createdDate;
    if (_notification.pictureUrl != nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_notification.pictureUrl] placeholderImage:[UIImage imageNamed:@"messageDefault"]];
    } else {
        imageView.image = [UIImage imageNamed:@"messageDefault"];
    }

    NSMutableParagraphStyle *mutStyle = [[NSMutableParagraphStyle alloc] init];
    mutStyle.lineSpacing = 6;
    mutStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_notification.content attributes:@{NSForegroundColorAttributeName : COLOR_MAIN_GREY,
                                                                                                                                    NSFontAttributeName : TEXT_FONT_12,
                                                                                                                                    NSParagraphStyleAttributeName : mutStyle}];
    descripeLab.attributedText = attributedStr;
}

- (void)setIsRead:(BOOL)isRead {
    _isRead = isRead;
    if (_isRead) {
        titleLab.textColor = COLOR_AUXILIARY_GREY;
        timeLab.textColor = COLOR_AUXILIARY_GREY;
        NSMutableAttributedString *descripeStr = [[NSMutableAttributedString alloc] initWithAttributedString:descripeLab.attributedText];
        [descripeStr addAttribute:NSForegroundColorAttributeName value:COLOR_AUXILIARY_GREY range:NSMakeRange(0, _notification.content.length)];
        descripeLab.attributedText = descripeStr;
        [checkDetailBtn setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
    } else {
        titleLab.textColor = COLOR_MAIN_GREY;
        timeLab.textColor = COLOR_AUXILIARY_GREY;
        NSMutableAttributedString *descripeStr = [[NSMutableAttributedString alloc] initWithAttributedString:descripeLab.attributedText];
        [descripeStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_GREY range:NSMakeRange(0, _notification.content.length)];
        descripeLab.attributedText = descripeStr;
        [checkDetailBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    }
}

- (void)clickDetailBtn:(id)sender {
    self.block();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
