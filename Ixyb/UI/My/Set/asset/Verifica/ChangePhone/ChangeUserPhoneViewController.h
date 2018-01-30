//
//  ChangeUserPhoneViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

@interface ChangeUserPhoneViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) XYButton *codeButton;
@property (nonatomic, strong) ColorButton *nextButton;

@end
