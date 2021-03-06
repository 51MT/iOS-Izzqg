//
//  XNFirstHttpService.h
//  XNChatCore
//
//  Created by Ntalker on 15/8/19.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNFirstHttpService : NSObject

- (void)sendGetflashserverRequest:(NSString *)URLStr andParam:(id)param;

- (void)postTrailInfo:(NSString *)URLStr andParam:(id)param;

- (void)sendAppChatGetflashserverRequest:(NSString *)URLStr andParam:(id)param;

- (void)sendT2dServerConnectionRequest:(NSString *)URLStr andParam:(id)param backBlock:(void(^)(id response))backBlock;

- (void)sendTchatConnectionRequest:(NSString *)URLStr andParam:(id)param;

- (void)postImageFileUpRequest:(NSString *)URLStr andParam:(id)param andFilePath:(NSString *)path andType:(NSString *)type andBackResponse:(void(^)(id response))backResponse;

- (void)postVoiceFileUpRequest:(NSString *)URLStr andParam:(id)param andFilePath:(NSString *)path andType:(NSString *)type andBackResponse:(void(^)(id response))backResponse;

- (void)postVideoFileUpRequest:(NSString *)URLStr andParam:(id)param andFilePath:(NSString *)localPath andType:(NSString *)type andBackResponse:(void(^)(id response))backResponse;

- (void)postLeaveMessageWithURL:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id response))block;

- (void)sendProductInfoWithURL:(NSString *)URLStr andParam:(id)param andBlock:(void(^)(id response))block;

//*****link*****
-(void)sendLinkCardConfigureURL:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id))block;

- (void)sendDownloadVideoRequest:(NSString *)URLStr param:(id)params completeHandle:(void(^)(NSURL *videoURL))completeHandle;

//获取留言可配置
- (void)sendNoteLeaveConfigureURL:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id response))block;

- (void)sendChatConfigureInfoRequest:(NSString *)URLStr andParam:(id)param withBlock:(void (^)(id))block;

- (void)sendHotFixCheckRequest:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id response))handle;

- (void)updataHotFixFileRequest:(NSString *)URLStr andParam:(id)param withBlock:(void(^)(id response))handle;

- (void)cancelRequest;

@end
