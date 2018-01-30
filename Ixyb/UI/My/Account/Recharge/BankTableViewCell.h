//
//  BankTableViewCell.h
//  Ixyb
//
//  Created by wang on 15/6/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "BankInfoModel.h"
#import <UIKit/UIKit.h>
@interface BankTableViewCell : UITableViewCell

@property (nonatomic, strong) payLimitsModel *BankInfo;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *contenLabel;
@property (nonatomic, strong) UIImageView *bankImage;
@property (nonatomic, strong) UIImageView *selectImage;

@end
