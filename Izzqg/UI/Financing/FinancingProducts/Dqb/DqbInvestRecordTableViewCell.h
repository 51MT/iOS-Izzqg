//
//  TrendRecordCell.h
//  Ixyb
//
//  Created by wang on 15/7/20.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DqbInvestRecordsResponseModel.h"
#import "XtbZqzrInvestRecordResponseModel.h"

@interface DqbInvestRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) TrendRecordInfo *model;
@property (nonatomic, strong) BidsModel *xtbModel;

@end
