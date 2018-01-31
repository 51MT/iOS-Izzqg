//
//  BbgHomeProductView.h
//  Ixyb
//
//  Created by wang on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "BaseView.h"

#import "BbgProductModel.h"

@interface BbgHomeProductView : BaseView

@property (nonatomic, copy) BbgProductModel *bbgProduct;

@property (nonatomic, copy) void (^clickTheInvestButton)(BbgProductModel *product);
@property (nonatomic, copy) void (^clickDetailButton)(BbgProductModel *product);

- (void)reloadTheDataForUI:(BbgProductModel *)product;

@end
