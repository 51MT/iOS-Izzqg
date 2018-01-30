//
//  ShakeResultMassageView.h
//  Ixyb
//
//  Created by wang on 15/11/23.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Winning = 0,                  //中奖了
    NotWinAndHaveOpportunity = 1, //没中奖还有机会
    NotWinAndNoOpportunity = 2,   //没中奖没机会
    NoOpportunity = 3,            //最后一次摇一摇
    Financing = 4,                //出借
    IsNullOpportunity = 5,        //次数已用完
} shakeType;

@interface ShakeResultMassageView : UIView

+ (ShakeResultMassageView *)shareInstanceResulView:(shakeType)type dataDic:(NSDictionary *)resultDic;

@property (assign, nonatomic) shakeType type;

@property (nonatomic, copy) void (^clickHiddenButton)();

@property (nonatomic, copy) void (^clickFinancingButton)();
@property (nonatomic, copy) void (^clickMyCardButton)(NSDictionary *param);
@property(nonatomic,copy)void(^clickShareButton)();

@end
