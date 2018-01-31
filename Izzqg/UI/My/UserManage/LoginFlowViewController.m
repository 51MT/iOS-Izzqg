//
//  LoginFlowViewController.m
//  Ixyb
//
//  Created by dengjian on 11/18/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "LoginFlowViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Utility.h"

@interface LoginFlowViewController () <LoginFlowDelegate>

@property (nonatomic, strong) LoginFlowCompletion completion;

@property (nonatomic) NSInteger type; //1. 呼出登录   2. 呼出注册

@end

@implementation LoginFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentWith:(UIViewController *)viewController animated:(BOOL)animated completion:(LoginFlowCompletion)completion {
    self.type = 1;
    self.completion = completion;

    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.loginFlowDelegate = self;

    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationItem setHidesBackButton:YES];
    [self pushViewController:loginViewController animated:NO];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [viewController presentViewController:self animated:animated completion:nil];
}

- (void)presentRegisterWith:(UIViewController *)viewController animated:(BOOL)animated completion:(LoginFlowCompletion)completion {
    self.type = 2;
    self.completion = completion;

    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.loginFlowDelegate = self;

    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.loginFlowDelegate = self;
    [self pushViewController:loginViewController animated:NO];
    [self pushViewController:registerViewController animated:NO];

    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationItem setHidesBackButton:YES];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [viewController presentViewController:self animated:animated completion:nil];
}

- (void)loginFlowDidFinish:(LoginFlowState)state {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.completion) {
            self.completion(state);
        }
        self.completion = nil;
        if (state != LoginFlowStateCancel) {
            [UserDefaultsUtil setIsAlreadyLogin]; //已经登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessNotification" object:nil];
        }
    }];
}

//这个其实是dataSource
- (NSInteger)flowType {
    return self.type;
}

@end
