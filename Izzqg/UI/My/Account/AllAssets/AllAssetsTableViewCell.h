//
//  AllAssetsTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALL_ASERT_DETAIL_TABLEVEIW_CELL_HEIGHT 46
@interface AllAssetsTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *btnleft;
@property (nonatomic) BOOL hasSplitLine;
@property (nonatomic) BOOL isStateArrow;
@end
