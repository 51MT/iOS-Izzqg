//
//  UMShareUtil.m
//  Ixyb
//
//  Created by wang on 16/10/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "UMShareUtil.h"

@implementation UMShareUtil

+ (UMShareUtil *)shareUMShareUtil {
    
    static UMShareUtil *shareUtil = nil;
    @synchronized (self) {
        if (shareUtil == nil) {
            shareUtil = [[UMShareUtil alloc] init];
        }
    }
    
    return shareUtil;
}

+ (void)setUmSocialAppkey:(NSString *)appKey {
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:appKey];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXAppSecret redirectURL:UmShareUrl];
    
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppId appSecret:QQAppSecret redirectURL:UmShareUrl];
    
    //该方法设置展示面板上的分享类型（增删改的控制直接通过该方法实现）
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
}

//分享
+ (void)shareUrl:(NSString *)url title:(NSString *)title content:(NSString *)content image:(UIImage *)image controller:(UIViewController *)controller {

    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        // 根据获取的platformType确定所选平台进行下一步操作
        UMShareWebpageObject *shareObject  = [[UMShareWebpageObject alloc]init];
        if (platformType == UMSocialPlatformType_WechatTimeLine ) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@ %@",title,content] descr:content thumImage:image];
        } else {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
        }
        
        //设置网页地址
        shareObject.webpageUrl = url;
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.shareObject = shareObject;
    
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}


@end
