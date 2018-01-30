//
//  ProjectIntroduceView.h
//  Ixyb
//
//  Created by wang on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "BaseView.h"
#import "BidProduct.h"
#import "NPBidDetailResModel.h"

@interface ProjectIntroduceView : BaseView

@property (nonatomic,strong) BidProduct *productInfo;
@property (nonatomic,strong) NPBidProductModel *productModel;
@end
