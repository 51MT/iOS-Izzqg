//
//  NpDetailMarkTableViewCell.h
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XYTableViewCell.h"
#import "NProductDetailResModel.h"

@interface NpDetailMarkTableViewCell : XYTableViewCell

@property (nonatomic,strong) NPBidListModel *model;
@property (nonatomic,assign) BOOL showTopLine;//是否显示顶部的实线
@property (nonatomic,assign) BOOL showBottomLine;//是否显示底部的实线

@end
