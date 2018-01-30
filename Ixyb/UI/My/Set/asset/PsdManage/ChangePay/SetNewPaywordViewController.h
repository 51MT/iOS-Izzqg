//
//  SetNewPaywordViewController.h
//  Ixyb
//
//  Created by dengjian on 16/4/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "HiddenNavBarBaseViewController.h"

@interface SetNewPaywordViewController : HiddenNavBarBaseViewController

@property(nonatomic,strong)UITextField *payWordText;
@property(nonatomic,strong)UITextField *secondPayWordText;
@property(nonatomic,strong)ColorButton *finishButton;

@end
