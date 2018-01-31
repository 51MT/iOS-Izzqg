//
//  NpDetailMarkTableViewCell.m
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "NpDetailMarkTableViewCell.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"

@implementation NpDetailMarkTableViewCell
{
    UIImageView *projectIconImage;  //项目图标
    UILabel *projectNameLab;        //名称
    UILabel *numberLab;             //编号
    UILabel *totalLab;              //总额
    UILabel *balanceLab;            //余额
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR_COMMON_WHITE;
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI {
    
    projectIconImage = [[UIImageView alloc] init];
    projectIconImage.image = [UIImage imageNamed:@"xtb_xin"];
    [self addSubview:projectIconImage];
    
    [projectIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(18));
        make.left.equalTo(@(Margin_Left));
    }];
    
    //用来包含projectNameLab + numberLab
    UIView *containView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:containView];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(projectIconImage.mas_right).offset(6);
        make.centerY.equalTo(self);
        make.width.equalTo(@(MainScreenWidth/3));
    }];
    
    projectNameLab = [[UILabel alloc] init];
    projectNameLab.font = SMALL_TEXT_FONT_13;
    projectNameLab.textColor = COLOR_AUXILIARY_GREY;
    projectNameLab.text = @"******";
    [containView addSubview:projectNameLab];
    
    [projectNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containView);
    }];
    
    numberLab = [[UILabel alloc] init];
    numberLab.font = SMALL_TEXT_FONT_13;
    numberLab.textColor = COLOR_LIGHT_GREY;
    numberLab.text = @"00000";
    [containView addSubview:numberLab];
    
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(containView);
        make.top.equalTo(projectNameLab.mas_bottom).offset(1);
    }];
    
    totalLab = [[UILabel alloc] init];
    totalLab.font = TEXT_FONT_14;
    totalLab.textColor = COLOR_AUXILIARY_GREY;
    totalLab.textAlignment = NSTextAlignmentLeft;
    totalLab.lineBreakMode = NSLineBreakByTruncatingTail;
    totalLab.text = @"0.00";
    [self addSubview:totalLab];
    
    [totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImgView.image = [UIImage imageNamed:@"cell_arrow"];
    [self addSubview:arrowImgView];
    
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(self);
    }];
    
    balanceLab = [[UILabel alloc] init];
    balanceLab.font = TEXT_FONT_14;
    balanceLab.textColor = COLOR_AUXILIARY_GREY;
    balanceLab.text = @"0.00";
    [self addSubview:balanceLab];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(arrowImgView.mas_left).offset(-6);
    }];
}

-(void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    if (_showBottomLine == YES) {
        [XYCellLine initWithBottomLineAtSuperView:self.contentView];
    }
}

-(void)setModel:(NPBidListModel *)model {
    
    _model = model;
    if (_model) {
        [projectIconImage sd_setImageWithURL:[NSURL URLWithString:model.assetIcon] placeholderImage:[UIImage imageNamed:@"xtb_xin"]];
        projectNameLab.text = model.title;
        numberLab.text = model.loanId;
        totalLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.finAmt];
        balanceLab.text = [Utility replaceTheNumberForNSNumberFormatter:model.restAmt];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
