//
//  CGCashTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "CgWithdrawModel.h"

@class CashRecordTableViewCell;
@protocol CashRecordTableViewCellDelegate <NSObject>

- (void)cashRecordTableViewCell:(CashRecordTableViewCell *)cell didClickCancelButtonOfId:(NSInteger)cashId;

@end

//提现记录
@interface CGCashTableViewCell : XYTableViewCell

@property (nonatomic, weak) id<CashRecordTableViewCellDelegate> cellDelegate;

@property (nonatomic, strong) WithdrawListModel * withDrawModel;

@end
