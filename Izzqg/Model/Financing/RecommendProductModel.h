//
//  RecommendProductModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RecommendProductModel : JSONModel

/**
 *  都有的字段
 */
@property (nonatomic, copy) NSString <Optional>*investProgress;////已出借进度
@property (nonatomic, copy) NSString <Optional>*amount; // 发售金额
@property (nonatomic, copy) NSString <Optional>*soldAmount; // 已售金额
@property (nonatomic, copy) NSString <Optional>*minBidAmount; // 最小出借金额
@property (nonatomic, copy) NSString <Optional>*state; //发售状态， 1: 发售中 2：发售完
@property (nonatomic, copy) NSString <Optional>*restAmount;// 剩余可投金额

/**
 *  活期宝字段
 */
@property (nonatomic, copy) NSString <Optional>*nextTime; // 下期更新时间
@property (nonatomic, copy) NSString <Optional>*currentTime; // 当前时间
@property (nonatomic, copy) NSString <Optional>*quota; //今日活期剩余额度
@property (nonatomic, copy) NSString <Optional>*totalQuota; // 今日活期总额度
@property (nonatomic, copy) NSString <Optional>*yesterRate; //昨日年化收益率
@property (nonatomic, copy) NSString <Optional>*yesterIncome; //  昨日万元收益



/**
 *  定期宝字段（周周盈+策诚年盈）
 */
@property (nonatomic, copy) NSString <Optional>*id; // 产品id
@property (nonatomic, copy) NSString <Optional>*type; // 产品类型代码 RXYY
@property (nonatomic, copy) NSString <Optional>*typeStr; // 产品类型名称 日新月益
@property (nonatomic, copy) NSString <Optional>*periods; // 期数
@property (nonatomic, copy) NSString <Optional>*periodsStr; // 期数字符串
@property (nonatomic, copy) NSString <Optional>*perunit; // 期数单位D：天 M 月
@property (nonatomic, copy) NSString <Optional>*rate; // 年化收益
@property (nonatomic, copy) NSString <Optional>*addRate; // 加送利率
@property (nonatomic, copy) NSString <Optional>*refundTypeString; // 还款方式
@property (nonatomic, copy) NSString <Optional>*createdDate;// 创建时间 "2015-07-17 10:07:56"
@property (nonatomic, copy) NSString <Optional>*sncode;// 产品期数编号 RXYY0717_NEW
@property (nonatomic, copy) NSString <Optional>*isNew; // 是否新手标
@property (nonatomic, copy) NSString <Optional>*sort;//标的类型，FRESH、和信投宝一样，NORMAL普通标，FRESH新手标，MIAO秒杀标，COMPET竞投标
@property (nonatomic, copy) NSString <Optional>*interestDay;// 计息日
@property (nonatomic, copy) NSString <Optional>*interestDate;// //计息日期
@property (nonatomic, copy) NSString <Optional>*lastRefundDate;//最后还款时间
@property (nonatomic, copy) NSString <Optional>*investNumber;//出借人数
@property (nonatomic, copy) NSString <Optional>*maxBidAmount;//用户最大出借额度
@property (nonatomic, copy) NSString <Optional>*restInvestCount;  //剩余可投
@property (nonatomic, copy) NSString <Optional>*zzyDefaultCount;//周周盈默认次数

/**
 *  步步高字段
 */
//@property (nonatomic, copy) NSString <Optional>*productId;// 产品id
//@property (nonatomic, copy) NSString <Optional>*title; // 标题
//@property (nonatomic, strong) NSString <Optional>*sn; // 产品编号
//@property (nonatomic, assign) double baseRate; // 年化利率
//@property (nonatomic, assign) double paddRate; // 每期增加年化
//@property (nonatomic, assign) double maxRate; //最大年化
//@property (nonatomic,copy) NSString <Optional>*productUrl;//步步高视图中图片的路径
//@property (nonatomic,copy) NSString <Optional>*minPeriods;//最低出借期限

@property (nonatomic, copy) NSString <Optional>*projectId;
@property (nonatomic, copy) NSString <Optional>*title; // 标题
@property (nonatomic, copy) NSString <Optional>*sn; // 产品编号



@property (nonatomic, copy) NSString <Optional>*baseRate; // 年化利率
@property (nonatomic, copy) NSString <Optional>*paddRate; // 每期增加年化
@property (nonatomic, copy) NSString <Optional>*maxRate; //最大年化


@property (nonatomic, copy) NSString <Optional>*productUrl;//步步高视图中图片的路径
@property (nonatomic, copy) NSString <Optional>*minPeriods;//最低出借期限





@end

/*
{
    indexIcons =     (
    );
    recommendProduct =     {
        addRate = 0;
        amount = 10000;
        createdDate = "2016-07-14 10:05:21";
        id = 2246;
        interestDay = "\U5f53\U65e5\U8ba1\U606f";
        investNumber = 0;
        investProgress = "0.17";
        isNew = 0;
        maxBidAmount = 10000;
        minBidAmount = 100;
        periods = 7;
        periodsStr = "7\U5929";
        perunit = D;
        rate = "0.12";
        refundTypeString = "\U5230\U671f\U8fd8\U672c\U606f";
        restAmount = 8300;
        restInvestCount = 6;
        sncode = ZZY20160714100606;
        soldAmount = 1700;
        state = 1;
        type = ZZY;
        typeStr = "\U5468\U5468\U76c8";
        zzyDefaultCount = 0;
    };
    recommendType = 0;
    resultCode = 1;
    totalInvestAmount = 715562471;
    unreadMsg = 0;
    user =     {
        isBankSaved = 0;
        isEmailAuth = 0;
        isHaveAddr = 0;
        isIdentityAuth = 0;
        isNewUser = 0;
        isPhoneAuth = 0;
        isTradePassword = 0;
    };
}*/

/*
 recommendProduct =     {
    investProgress = 0;
    name = "\U6d3b\U671f\U5b9d";
    quota = 14504;
    rateOfWeek = 0;
    totalQuota = 0;
    yesterIncome = "2.3835";
    yesterRate = "0.08699999999999999";
};
 */
