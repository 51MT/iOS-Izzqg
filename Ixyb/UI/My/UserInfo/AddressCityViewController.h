//
//  AddressCityViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "AddressCountyViewController.h"
#import "ProvinceModel.h"

@interface AddressCityViewController : HiddenNavBarBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AreasModel *provinceModel;

@end
