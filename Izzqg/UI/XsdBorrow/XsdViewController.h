//
//  XsdViewController.h
//  Ixyb
//
//  Created by wang on 16/1/25.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HiddenNavBarBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface XsdViewController : HiddenNavBarBaseViewController <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@property (nonatomic, strong) UIButton *closeBtn;

@end
