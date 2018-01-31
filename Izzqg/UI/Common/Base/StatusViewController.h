//
//  StatusViewController.h
//  Ixyb
//
//  Created by dengjian on 12/15/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "BaseViewController.h"

@interface StatusViewController : BaseViewController

@property (nonatomic, weak) UIViewController *backVC;
@property (nonatomic, weak) UIViewController *gotoVC;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *nextTitleStr;
@property (nonatomic, strong) UIButton *goToButton;

@end
