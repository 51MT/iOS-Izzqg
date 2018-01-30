//
//  NPBackRecordTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "CgDepRefundDetailModel.h"

#define NPBACK_CELL_HIGHT 135.f

@interface NPBackRecordTableViewCell : XYTableViewCell

@property(nonatomic,strong)CgRefundedListModel * refundedList;

@property(nonatomic,assign)BOOL isPayment;   //是否回款

@end
