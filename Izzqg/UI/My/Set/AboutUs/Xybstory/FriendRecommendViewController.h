//
//  FriendRecommendViewController.h
//  Ixyb
//
//  Created by wangjianimac on 15/7/4.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiddenNavBarBaseViewController.h"

//信用宝联盟－赚佣金
@interface FriendRecommendViewController : HiddenNavBarBaseViewController <UIActionSheetDelegate> //UMSocialUIDelegate>

@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) NSString *recommendUrl;

@end
