//
//  ScanLoginViewController.h
//  Ixyb
//
//  Created by wang on 2017/2/14.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef void (^returnBlock)(void);
@interface ScanLoginViewController : HiddenNavBarBaseViewController

@property(nonatomic,copy)NSString * qcodeCode;//二维码获得的Code
@property(nonatomic,copy)returnBlock blcok;

@end
