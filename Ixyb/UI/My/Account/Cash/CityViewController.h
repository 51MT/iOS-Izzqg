//
//  CityViewController.h
//  Ixyb
//
//  Created by wang on 15/7/8.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "ProvinceModel.h"

@interface CityViewController : HiddenNavBarBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) AreasModel *provinceModel;

@end
