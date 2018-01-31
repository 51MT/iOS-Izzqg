//
//  VIPServiseViewController.m
//  Ixyb
//
//  Created by wang on 15/9/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "VIPServiseViewController.h"

@interface VIPServiseViewController ()

@end

@implementation VIPServiseViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
