//
//  AdvertiseView.h
//
//  Copyright © 2017年 liujie. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

typedef void (^advertiseViewblock)(void);

@interface AdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) advertiseViewblock blcok;

@end
