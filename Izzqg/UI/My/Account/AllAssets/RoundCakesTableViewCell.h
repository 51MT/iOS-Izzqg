//
//  RoundCakesTableViewCell.h
//  Ixyb
//
//  Created by wang on 16/11/16.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "JHRingChart.h"
#import <UIKit/UIKit.h>

#define ALL_ASERT_Round_DETAIL_TABLEVEIW_CELL_HEIGHT 321
@interface RoundCakesTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) UILabel *labAcountAllAssets;
@property (nonatomic, strong) JHRingChart *ring;
@property (strong, nonatomic) NSMutableArray *valueArray;
@end
