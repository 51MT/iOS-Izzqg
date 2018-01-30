//
//  OneFriendsRecordViewController.h
//  Ixyb
//
//  Created by wang on 2017/2/13.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "HiddenNavBarBaseViewController.h"

typedef enum {
    oneRecord,
    twoRecord
}RecodeType;

@interface OneFriendsRecordViewController : HiddenNavBarBaseViewController

@property(nonatomic,copy)NSString * namePhone;
@property(nonatomic,copy)NSString * investMoney;
@property(nonatomic,copy)NSString * investId;
@property(nonatomic,assign)RecodeType recodeType;
@end
