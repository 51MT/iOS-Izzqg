//
//  VIPInterestsViewController.m
//  Ixyb
//
//  Created by wang on 15/9/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "VIPInterestsViewController.h"

#import "Utility.h"

#import "VIPServiseViewController.h"

@interface VIPInterestsViewController ()

@end

@implementation VIPInterestsViewController

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString {
    self = [super init];
    if (self) {
        self.navItem.title = title;
        self.URL = [NSURL URLWithString:webUrlString];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
