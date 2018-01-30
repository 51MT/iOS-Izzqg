//
//  HomePageAttendenceModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface HomePageAttendenceModel : ResponseModel

/**
 *  首页签到Model
 */
@property(nonatomic,assign) NSInteger addScore;         //持续签到，每次多送的积分数
@property(nonatomic,assign) NSInteger continueDay;      //持续签到的时间
@property(nonatomic,assign) NSInteger maxScore;         //签到获得的最大积分
@property(nonatomic,assign) NSInteger score;            //签到获得的积分

@end

/*
    addScore = 50;
    continueDay = 1;
    maxScore = 200;
    resultCode = 1;
    score = 50;
*/
