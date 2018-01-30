//
//  ServicePhoneTableViewCell.h
//  Ixyb
//
//  Created by wangjianimac on 15/6/2.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyRow.h"

@interface ServicePhoneTableViewCell : UITableViewCell

@property (nonatomic, strong) MyRow *myRow;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *detailLabel2;

@end
