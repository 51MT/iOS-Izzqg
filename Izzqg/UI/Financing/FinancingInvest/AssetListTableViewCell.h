//
//  BidTableViewCell.h
//  Ixyb
//
//  Created by dengjian on 2017/3/9.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "AssetListModel.h"

/**
 匹配资产和待匹配资产列表的cell
 */
@interface AssetListTableViewCell : XYTableViewCell

@property (nonatomic, strong) AssetModel *model;

@end
