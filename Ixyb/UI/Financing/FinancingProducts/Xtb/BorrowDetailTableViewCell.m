//
//  BorrowDetailTableViewCell.m
//  Ixyb
//
//  Created by dengjian on 2017/9/18.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BorrowDetailTableViewCell.h"
#import "Utility.h"

@interface BorrowDetailTableViewCell ()

@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UILabel *valueLab;

@end

@implementation BorrowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI
{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font  = SMALL_TEXT_FONT_13;
    self.titleLab.textColor = COLOR_AUXILIARY_GREY;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(MainScreenWidth/3));
        make.left.equalTo(@(Margin_Left));
    }];
    
    self.valueLab = [[UILabel alloc] init];
    self.valueLab.font  = SMALL_TEXT_FONT_13;
    self.valueLab.textColor = COLOR_AUXILIARY_GREY;
    self.valueLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.valueLab];
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(@(-Margin_Right));
    }];
}

-(void)setModel:(PairItemModel *)model {
    _model = model;
    
    _titleLab.text = model.name;
    _valueLab.text = model.value;
    
    CGSize  titleWidth = [ToolUtil getLabelSizeWithLabelStr:_titleLab.text andLabelFont:SMALL_TEXT_FONT_13];
    
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(titleWidth.width + 1));
    }];
    
    [self.valueLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.right.equalTo(@(-Margin_Right));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
