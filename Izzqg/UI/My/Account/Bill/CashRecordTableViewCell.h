//
//  CashRecordTableViewCell.h
//  Ixyb
//
//  Created by wangjianimac on 15/6/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CashRecord.h"
@class CashRecordTableViewCell;
@protocol CashRecordTableViewCellDelegate <NSObject>

- (void)cashRecordTableViewCell:(CashRecordTableViewCell *)cell didClickCancelButtonOfId:(NSInteger)cashId;

@end

@interface CashRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) WithdrawalsRecord *cashRecord;

@property (nonatomic, weak) id<CashRecordTableViewCellDelegate> cellDelegate;

@end
