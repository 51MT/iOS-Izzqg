//
//  MJViewController.h
//  CNstorm
//
//  Created by Zhang Lisheng on 14-5-9.
//  Copyright (c) 2014年 cnstorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MJViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
