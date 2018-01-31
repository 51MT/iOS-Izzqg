//
//  BankBranchViewController.h
//  Ixyb
//
//  Created by wang on 15/10/22.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@interface BankBranchViewController : HiddenNavBarBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *cityCodeStr;
@property (nonatomic, strong) NSString *bankTypeNumber;

@end
