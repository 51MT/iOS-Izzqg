//
//  CaculatorTableViewCell.h
//  Ixyb
//
//  Created by 董镇华 on 16/7/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "IncomeList.h"
#import <UIKit/UIKit.h>

@interface CaculatorTableViewCell : UITableViewCell

@property (nonatomic, strong) IncomeList *model;
@property (nonatomic, strong) UIView *bottomLine;

@end
