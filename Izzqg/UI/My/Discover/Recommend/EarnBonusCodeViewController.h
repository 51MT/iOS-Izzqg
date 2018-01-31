//
//  EarnBonusCodeViewController.h
//  Ixyb
//
//  Created by wang on 15/9/1.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

//推荐好友拿礼金
@interface EarnBonusCodeViewController : HiddenNavBarBaseViewController <UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) NSString *recommendUrl;

@end
