//
//  WelcomeViewController.m
//  Ixyb
//
//  Created by wangjianimac on 15/4/9.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AdvertiseView.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "WebService.h"

#import "Welcome.h"
#define BTTOM_HEAD_IMAGE 120

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];

    NSString *filePath = [self getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    BOOL isExist = [self isFileExistwithFilePath:filePath];
    // 图片存在
    if (isExist) {
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        advertiseView.filePath = filePath;
        [advertiseView show];
        [self.view addSubview:advertiseView];
        
        
        advertiseView.blcok = ^(void)
        {
         if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedLoadWelcomeViewController:)]) {
             [self.delegate didFinishedLoadWelcomeViewController:self];
         }

        };
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedLoadWelcomeViewController:)]) {
            [self.delegate didFinishedLoadWelcomeViewController:self];
        }
    }


}

//判断文件是否存在
-(BOOL)isFileExistwithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
//初始化广告页
-(void)getAdvertisingImage
{
    NSString *urlPath = [RequestURL getRequestURL:LaunchIcon_URL param:[NSMutableDictionary dictionary]];
    
    [WebService postRequest:urlPath param:[NSDictionary dictionary] JSONModelClass:[Welcome class]
     
                    Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideLoading];
                        Welcome *welcome = responseObject;
                        if (welcome.resultCode == 1) {
                            NSString * imageUrl = welcome.icon;
                            if (![StrUtil isEmptyString:imageUrl]) {
                                //获取图片名字
                                NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
                                NSString *imageName = stringArr.lastObject;
                                NSString *filePath = [self getFilePathWithImageName:imageName];
                                BOOL isExist = [self isFileExistwithFilePath:filePath];
                                if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                                    
                                    [self downloadAdImageWithUrl:imageUrl imageName:imageName];
                                    
                                }
                            }else
                            {
                                //如果服气器 未配广告图 把之前本地缓存图片删掉
                                [self deleteOldImage];
                            }
                     
                        }
                        
                    }
     
                       fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
                           [self hideLoading];
                           [self showPromptTip:errorMessage];
                       }
     
     ];
}
 
//下载图片
-(void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName];
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            NSLog(@"保存成功");
            [self deleteOldImage];
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果有广告链接，将广告链接也保存下来
            
        }else{
            NSLog(@"保存失败");
        }
    });
    
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    
}
//拼接图片文件路径
-(NSString *)getFilePathWithImageName:(NSString *)imageName
{
    
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingString:imageName];
        return filePath;
    }
    return nil;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////隐藏状态栏
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

@end
