//
//  ShakingResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/24.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@interface ShakeInfoModel : JSONModel

@property (nonatomic, copy) NSString <Optional>* title;
@property (nonatomic, copy) NSString <Optional>* content;
@property (nonatomic, copy) NSString <Optional>* iconUrl;
@property (nonatomic, copy) NSString <Optional>* shareUrl;

@end

@interface ShakingResponseModel : ResponseModel

@property (nonatomic, assign) NSInteger addNum;
@property (nonatomic, copy) NSString <Optional>* prizeId;
@property (nonatomic, copy) NSString <Optional>*prizeCode;
@property (nonatomic, copy) NSString <Optional>*prizeName;
@property (nonatomic, assign) CGFloat prizeValue;
@property (nonatomic, assign) NSInteger todayRestNum;
@property (nonatomic, strong) ShakeInfoModel<Optional>* shareInfo;//增加的分享数据

@end


 /*
 "prizeCode": "EMPTY",//奖品代码 empty:未中奖, REWARD:礼金, SLEEPREWARD:红包, INCREASECARD:收益卡,ZZY:周周盈,MPOS: 刷卡器
 "resultCode": 1,
 "prizeName": "无任何奖品" //奖品名称
 "prizeValue": 100,//奖品价值
 "addNum": 1, //出借增加次数
 "totalNum": 1, //累计摇次数
 "todayRestNum": 1//今日剩余次数
 */

