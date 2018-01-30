//
//  FinishTableViewCell.h
//  Ixyb
//
//  Created by wangjianimac on 16/7/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMInvestedProject.h"

#define STOPFINISH_TABLEVEIW_CELL_HEIGHT 60

/**
 *  已完成 Cell
 */
@interface FinishTableViewCell : UITableViewCell

@property (nonatomic, strong) ProductsProject *investFinishProject;

@end
