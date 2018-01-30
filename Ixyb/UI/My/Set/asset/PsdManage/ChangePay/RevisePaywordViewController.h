//
//  RevisePaywordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "HiddenNavBarBaseViewController.h"

@interface RevisePaywordViewController : HiddenNavBarBaseViewController

@property(nonatomic,strong)UITextField *payNewTextField;
@property(nonatomic,strong)UITextField *payPasswordTextField;
@property(nonatomic,strong)ColorButton *reviseButton;
@property(nonatomic,copy)NSString *codeStr;

@end
