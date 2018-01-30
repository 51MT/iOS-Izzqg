//
//  SandboxSaveUtil.h
//  Ixyb
//
//  Created by Jiang_Dryan on 16/11/6.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  保存成功回调
 *
 *  @param success 保存成功的block
 */
typedef void (^resultBlock)(BOOL success);

@interface SandboxSaveUtil : NSObject

/**
 *  保存图片到沙盒
 *
 *  @param image     要保存的图片
 *  @param imageName 保存的图片名称
 *  @param block     保存成功的值
 */
+ (void)saveImageToSandbox:(UIImage *)image
              andImageNage:(NSString *)imageName
            andResultBlock:(resultBlock)block;

/**
 *  沙盒中获取到的照片
 *
 *  @param imageName 读取的照片名称
 *
 *  @return 从沙盒读取到的照片
 */
+ (UIImage *)loadImageFromSandbox:(NSString *)imageName;

/**
 *  根据文件获取沙盒路径
 *
 *  @param fileName 文件名称
 *
 *  @return 文件在沙盒中的路径
 */
+ (NSString *)filePath:(NSString *)fileName;

@end
