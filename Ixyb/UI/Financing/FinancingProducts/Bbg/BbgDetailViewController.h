//
//  BbgDetailViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/8.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "BbgProductModel.h"
#import "FromTo.h"
#import "XYButton.h"

@interface BbgDetailViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) BbgProductModel *bbgProduct;
@property (nonatomic, assign) ToNewUserFromType fromType;

@end
