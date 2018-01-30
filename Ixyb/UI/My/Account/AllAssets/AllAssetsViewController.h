//
//  AllAssetsViewController.h
//  Ixyb
//
//  Created by dengjian on 10/22/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "XYTableView.h"
@class User;

/**
 * 总资产页面视图
 *
 */
@interface AllAssetsViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) User *accountInfo;
@property (nonatomic, strong) NSDictionary *accountDic;
@property (nonatomic, strong) XYTableView *tableView;

@end
