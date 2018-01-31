//
//  NPListView.h
//  Ixyb
//
//  Created by wang on 2017/12/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "NProductListResModel.h"
#import "NoDataView.h"
#import "Utility.h"

//新产品一键出借 列表
@interface NPListView : BaseView<UITableViewDataSource,UITableViewDelegate> 

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void (^clickTheDetailVC)(NProductModel *product);
@property (nonatomic, copy) void (^clickTheInvestButton)(NProductModel *product);

- (id)initWithFrame:(CGRect)frame navigationController:(UINavigationController *)nav;
- (void)setTheRequest;

@end
