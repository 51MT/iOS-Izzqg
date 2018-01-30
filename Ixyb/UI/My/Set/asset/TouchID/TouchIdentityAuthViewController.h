//
//  TouchIdentityAuthViewController.h
//  Ixyb
//
//  Created by wangjianimac on 16/6/8.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"
#import "HBRSAHandler.h"
#import "OpenUDID.h"
#import "VerificationTouch.h"

/**
 *  TouchID 身份验证
 */
typedef void (^RefreshBlock)(void);

@interface TouchIdentityAuthViewController : HiddenNavBarBaseViewController

@property (nonatomic, copy) RefreshBlock block;

@end
