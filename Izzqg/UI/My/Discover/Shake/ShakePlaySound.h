//
//  ShakePlaySound.h
//  Ixyb
//
//  Created by wang on 15/11/23.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface ShakePlaySound : NSObject {
    SystemSoundID sound;    //系统声音的id 取值范围为：1000-2000
    SystemSoundID endSound; //系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;                                                               //系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType; //初始化系统声音
- (void)beginPlay;                                                                   //播放
- (void)endPlay;                                                                     //播放
@end
