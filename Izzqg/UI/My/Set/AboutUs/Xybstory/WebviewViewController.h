//
//  WebviewViewController.h
//  Ixyb
//
//  Created by wang on 15/8/31.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ProgressWebViewController.h"

@interface WebviewViewController : ProgressWebViewController

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString;
@property(nonatomic,strong)UIImage * shareImage;

@end
