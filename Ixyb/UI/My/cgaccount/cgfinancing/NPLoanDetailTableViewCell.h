//
//  NPLoanDetailTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "CgDepMathListModel.h"

#define NPLOAN_CELL_HIGHT 146.f

typedef enum {
    DtailsOrContractBtn,
    DtailsBtn
} ButtomType;

typedef void (^DetaileBlock)(CgMathListModel * mathList);
typedef void (^ContractBlock)(CgMathListModel * mathList);

@interface NPLoanDetailTableViewCell : XYTableViewCell

@property (nonatomic, assign) ButtomType buttomType; //区分是否有合同

@property (nonatomic, strong)CgMathListModel * mathList;

@property (nonatomic, copy)DetaileBlock detaileBlcok;
@property (nonatomic, copy)ContractBlock contractBlock;

@end
