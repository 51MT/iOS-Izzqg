//
//  InvestmentListCell.h
//  Ixyb
//
//  Created by wang on 16/4/11.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvestmentModel.h"
@class InvestmentListCell;
@protocol InvestmentListCellTableViewCellDelegate <NSObject>

- (void)cashContractTableViewCell:(InvestmentListCell *)cell didClickContractButtonOfId:(NSDictionary *)dic;
- (void)cashDetailsTableViewCell:(InvestmentListCell *)cell didClickDetailsButtonOfId:(NSDictionary *)dic;

@end

@interface InvestmentListCell : XYTableViewCell

@property (nonatomic, strong) MatchAssetListProjectModel * matchAssetList;
@property (nonatomic, weak) id<InvestmentListCellTableViewCellDelegate> cellDelegate;
@end
