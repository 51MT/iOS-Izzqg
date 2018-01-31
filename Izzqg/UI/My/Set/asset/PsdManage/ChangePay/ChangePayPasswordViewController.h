//
//  ChangePayPasswordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/27.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utility.h"

#import "HiddenNavBarBaseViewController.h"

@interface ChangePayPasswordViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) XYButton *codeButton;
@property (nonatomic, strong) ColorButton *nextButton;

@end
