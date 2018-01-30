//
//  BorrowDetailMainViewController.h
//  Ixyb
//
//  Created by wang on 2018/1/1.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "XtbDetailResponseModel.h"
#import "NPBidDetailResModel.h"

@interface BorrowDetailMainViewController : HiddenNavBarBaseViewController

@property(nonatomic,strong) XtbDetailResponseModel *xtbDetailModel; //信投保模型
@property(nonatomic,strong) NPBidDetailResModel *bidDetailModel;

@end
