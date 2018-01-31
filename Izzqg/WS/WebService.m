//
//  WebService.m
//  IXsd
//
//  Created by wangjianimac on 16/6/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "WebService.h"
#import "ServerErrorView.h"
#import "BaseViewController.h"

@implementation WebService

+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
     JSONModelClass:(Class)responseModelClass
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {

    //状态栏小菊花加载
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    //基本请求：返回基本数据
    ModelNetworkClient *manager = [ModelNetworkClient manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //设置服务器连接超时时间，默认60s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:urlPath param:params JSONModelClass:responseModelClass

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;
            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                }else if(operation.response.statusCode == 423)
                {
                    ServerErrorView *serverErrorView = [[ServerErrorView alloc] init];
                    [serverErrorView show:nil];
                    
                }else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }

    ];
}

+ (void)getRequest:(NSString *)urlPath
             param:(NSDictionary *)params
    JSONModelClass:(Class)responseModelClass
           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {

    //状态栏小菊花加载
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    //基本请求：返回基本数据
    ModelNetworkClient *manager = [ModelNetworkClient manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //设置服务器连接超时时间，默认60s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:urlPath param:params JSONModelClass:responseModelClass

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;
            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }

    ];
}

//图片上传接口
+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
        uploadImage:(UIImage *)image
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {

    //状态栏小菊花加载
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //图片上传设置服务器连接超时时间默认60s
    manger.responseSerializer = [AFJSONResponseSerializer serializer];

    [manger POST:urlPath parameters:params

        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
            //[_request addData:data withFileName:@"file.png" andContentType:@"multipart/form-data" forKey:@"file"];
        }

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;

            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }

    ];
}

//第三方图片上传接口
+ (void)postThirdPartyRequest:(NSString *)urlPath
                        param:(NSDictionary *)params
                  uploadImage:(UIImage *)image
                      Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //图片上传设置服务器连接超时时间默认60s
    manger.responseSerializer = [AFJSONResponseSerializer serializer];

    [manger POST:urlPath parameters:params

        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(image, 0.2);
            [formData appendPartWithFileData:data name:@"image" fileName:@"image.png" mimeType:@"image/png"];
            //[_request addData:data withFileName:@"file.png" andContentType:@"multipart/form-data" forKey:@"file"];
        }

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;

            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }

    ];
}

//多张图片上传接口
+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
       uploadImages:(NSMutableArray *)imageArray
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {

    //状态栏小菊花加载
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //图片上传设置服务器连接超时时间默认60s
    manger.responseSerializer = [AFJSONResponseSerializer serializer];

    [manger POST:urlPath parameters:params

        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (UIImage *image in imageArray) {
                NSData *data = UIImagePNGRepresentation(image);
                [formData appendPartWithFileData:data name:@"files" fileName:@"file.png" mimeType:@"multipart/form-data"];
            }
        }

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            NSString *errorMessage;

            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }

    ];
}

//信闪贷Post请求
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params JSONModelClass:(Class)responseModelClass
               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {
    //基本请求：返回基本数据
    ModelNetworkClient *manager = [ModelNetworkClient manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    //设置服务器连接超时时间，默认120s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 120.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:urlPath param:params JSONModelClass:responseModelClass

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;
            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }

            fail(operation, errorMessage);
        }];
}

//信闪贷单张图片上传接口
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params uploadImage:(UIImage *)image
               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"file"];
    //设置服务器连接超时时间，默认180s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 180.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
        timeString = [@"xsd_temp" stringByAppendingString:timeString];
        timeString = [timeString stringByAppendingString:@".png"];
        NSData *data = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:@"file" fileName:timeString mimeType:@"image/png"];
    }

        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        }

        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *errorMessage;
            if (operation.response) {
                if (operation.response.statusCode == 400) {
                    ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                    errorMessage = responseModel.message;
                } else {
                    errorMessage = @"服务器连接超时，请重试";
                }
            } else {
                errorMessage = @"网络连接不可用，请检查";
            }
            fail(operation, errorMessage);
        }];
}

//信闪贷两张图片上传接口
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params uploadImageArray:(NSArray *)imageArray
               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"file"];
    //设置服务器连接超时时间，默认180s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 180.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageArray.count; i++) {
            if (i == 0) { //最佳人脸照片
                NSData *data = [imageArray objectAtIndex:0];
                [formData appendPartWithFileData:data name:@"imageBest" fileName:@"imageBest.jpg" mimeType:@"image/jpeg"];
            }else if (i == 1) { //最佳全景照片
                NSData *data = [imageArray objectAtIndex:1];
                [formData appendPartWithFileData:data name:@"imageEnv" fileName:@"imageEnv.jpg" mimeType:@"image/jpeg"];
            }
        }
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSString *errorMessage;
              if (operation.response) {
                  if (operation.response.statusCode == 400) {
                      ResponseModel *responseModel = [[ResponseModel alloc] initWithString:operation.responseString error:nil];
                      errorMessage = responseModel.message;
                  } else {
                      errorMessage = @"服务器连接超时，请重试";
                  }
              } else {
                  errorMessage = @"网络连接不可用，请检查";
              }
              fail(operation, errorMessage);
          }];
}

@end
