//
//  AccountStatisticsCell.h
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#define INVESTED_DETAIL_TABLEVEIW_CELL_HEIGHT 46
@interface AccountStatisticsCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic) BOOL hasSplitLine;
@end
