//
//  ResetPassWordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utility.h"
#import "HiddenNavBarBaseViewController.h"

@interface ResetPassWordViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) UITextField *olderTextField;
@property (nonatomic, strong) UITextField *payNewTextField;
@property (nonatomic, strong) UITextField *payPasswordTextField;
@property (nonatomic, strong) ColorButton *reviseButton;

@end
