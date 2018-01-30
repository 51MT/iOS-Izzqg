//
//  ShakePlaySound.m
//  Ixyb
//
//  Created by wang on 15/11/23.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "ShakePlaySound.h"

@implementation ShakePlaySound

- (id)initSystemShake {
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate; //震动
        //        endSound = kSystemSoundID_Vibrate;
        //        AudioServicesPlaySystemSound(1106);
        //        AudioServicesPlaySystemSound(sound);
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType {
    self = [super init];
    if (self) {

        //        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        //        if (path) {
        //            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&sound);
        //
        //            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
        //                sound = nil;
        //            }
        //        }
    }
    return self;
}
- (void)beginPlay {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"aw" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)endPlay {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:path], &endSound);
        AudioServicesPlaySystemSound(endSound);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
