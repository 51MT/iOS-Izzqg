//
//  PinlessNewPhoneViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
#import "Utility.h"

@interface PinlessNewPhoneViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) XYButton *codeButton;
@property (nonatomic, strong) ColorButton *pinlessButton;

@end
