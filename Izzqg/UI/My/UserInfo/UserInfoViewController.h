//
//  UserInfoViewController.h
//  Ixyb
//
//  Created by wang on 15/10/13.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AddressViewController.h"
#import "BirthdayViewController.h"
#import "HiddenNavBarBaseViewController.h"
#import "NickNameViewController.h"
#import "SexViewController.h"
#import "VIPViewController.h"

@interface UserInfoViewController : HiddenNavBarBaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NickNameViewControllerDelegate, SexViewControllerDelegate, BirthdayViewControllerDelegate, AddressViewControllerDelegate>

@end
