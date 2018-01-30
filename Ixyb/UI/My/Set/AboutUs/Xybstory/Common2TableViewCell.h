//
//  Common2TableViewCell.h
//  Ixyb
//
//  Created by wangjianimac on 16/6/30.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyRow.h"
#import "Utility.h"

@interface Common2TableViewCell : UITableViewCell

@property (nonatomic, strong) MyRow *myRow;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end
