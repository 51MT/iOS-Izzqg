//
//  CCPClipCaremaImage.h
//  QHPay
//
//  Created by liqunfei on 16/3/15.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CCPClipCaremaImage : UIView

@property (nonatomic, copy) void (^clickCaremalButton)(UIImage * image);
@property (nonatomic, strong) UIButton *takePhotoButton;

- (id)initWithFrame:(CGRect)frame title:(NSString * )title;
- (void)startCamera;
- (void)stopCamera;
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock;
- (BOOL)isOpenFlash;
@end
