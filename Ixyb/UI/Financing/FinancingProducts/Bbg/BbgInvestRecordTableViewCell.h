//
//  BbgRecordCell.h
//  Ixyb
//
//  Created by dengjian on 16/8/31.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BbgInvestRecordResponseModel.h"
#import "NPLoanListResModel.h"

@interface BbgInvestRecordTableViewCell : UITableViewCell

@property (nonatomic,strong) BbgTradeRecords *bbgModel;
@property (nonatomic,strong) NPLoanListModel *loanModel;


@end
