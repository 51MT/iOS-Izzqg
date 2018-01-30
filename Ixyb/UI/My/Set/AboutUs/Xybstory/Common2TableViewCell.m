//
//  Common2TableViewCell.m
//  Ixyb
//
//  Created by wangjianimac on 16/6/30.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "Common2TableViewCell.h"

@implementation Common2TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 17.0f, 150.0f, 16.0f)];
        self.nameLabel.textColor = MAINTEXTCOLOR;
        self.nameLabel.font = [UIFont systemFontOfSize:17.0f];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        [self.contentView addSubview:self.nameLabel];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 215.0f, 10.0f, 200.0f, 30.0f)];
        self.detailLabel.textColor = WEAKTEXTCOLOR;
        self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
        self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailLabel.numberOfLines = 1;
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        self.detailLabel.adjustsFontSizeToFitWidth = YES;
        self.detailLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.nameLabel.text = [NSString stringWithFormat:@"%@", self.myRow.rowName];
    self.detailLabel.text = [NSString stringWithFormat:@"%@", self.myRow.rowDetail];
}

@end
