//
//  PosGetViewController.h
//  Ixyb
//
//  Created by wang on 16/4/7.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"
typedef void (^changeStatueBlock)(NSInteger statue); //改变call里面领取的状态的block

@interface PosGetViewController : HiddenNavBarBaseViewController

@property (nonatomic, strong) NSString *prizeLogId;
@property (nonatomic, copy) changeStatueBlock changeStatue;

@end
