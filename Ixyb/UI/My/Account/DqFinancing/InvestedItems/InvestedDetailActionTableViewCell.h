//
//  InvestedDetailActionTableViewCell.h
//  Ixyb
//
//  Created by dengjian on 10/15/15.
//  Copyright (c) 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INVESTED_DETAIL_ACTION_TABLEVIEW_CELL_HEIGHT 70

@interface InvestedDetailActionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *detail;

@property (nonatomic, assign) NSInteger paymentDetailedType; //区分产品

@property (nonatomic, assign) BOOL isReback;//步步高是否赎回

@end
