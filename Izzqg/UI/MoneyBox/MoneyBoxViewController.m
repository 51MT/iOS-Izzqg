//
//  MoneyBoxViewController.m
//  Izzqg
//
//  Created by DzgMac on 2018/2/28.
//  Copyright © 2018年 xyb. All rights reserved.
//

#import "MoneyBoxViewController.h"
#import "IPhoneXNavHeight.h"
#import "Masonry.h"
#import "XYUtil.h"

#define ScreenHeight ([UIScreen mainScreen].bounds.size.height);

#define ViewSafeAreaInsets(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#define SafeAreaTopHeight (ScreenHeight == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (ScreenHeight == 812.0 ? 34 : 0)

@interface MoneyBoxViewController ()<UIScrollViewDelegate, UIWebViewDelegate>
{
    UIView *backview;
}

@property (nonatomic, strong) UIView *navBackView;  //自定义导航栏
@property (nonatomic, strong) UILabel *navTitleLab; //自定义导航栏上的title
@property (nonatomic, strong) UIImageView *leftNavRedPointImage;
@property (nonatomic, strong) XYScrollView *mainScroll;
@property (nonatomic, strong) UIImageView *shakeRedPoint;

@end

@implementation MoneyBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
