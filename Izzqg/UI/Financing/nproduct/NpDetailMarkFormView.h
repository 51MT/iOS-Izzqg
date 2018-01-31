//
//  NpDetailMarkFormView.h
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "XYTableView.h"
#import "NpDetailMarkTableViewCell.h"
#import "Utility.h"
#import "NoDataView.h"

typedef void (^allBlock)(NSString *productID);//点击“查看全部标的组成”时回调
typedef void (^singleBlock)(NPBidListModel *model);//点击单个cell时回调

@interface NpDetailMarkFormView : BaseView

@property (nonatomic, copy) allBlock block;
@property (nonatomic, copy) singleBlock sinBlock;

- (id)initWithFrame:(CGRect)frame productId:(NSString *)productId;
- (void)reloadWithDataSourse:(NSArray *)dataSourse;

@end
