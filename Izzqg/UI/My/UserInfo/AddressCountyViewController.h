//
//  AddressCountyViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/15.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "ProvinceModel.h"
#import "CityModel.h"

@interface AddressCountyViewController : HiddenNavBarBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) AreasModel*provinceModel;
@property(nonatomic,strong) CityModel *cityModel;

@end
