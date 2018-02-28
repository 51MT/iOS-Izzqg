//
//  HqbProjectInvestDetailModel.h
//  Ixyb
//
//  Created by dengjian on 16/7/19.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol MatchAssetListModel;
@interface MatchAssetListModel : JSONModel

@property(nonatomic,strong) NSNumber <Optional>*holdAmount;
@property(nonatomic,strong) NSString <Optional>*holdTime;
@property(nonatomic,strong) NSString <Optional>*matchAssetType;
//@property(nonatomic,strong) NSString <Optional>*matchTime;
@property(nonatomic,strong) NSNumber <Optional>*projectId;
@property(nonatomic,strong) NSString <Optional>*projectName;
@property(nonatomic,assign) NSInteger productType;

@end

@interface HqbProjectInvestDetailModel : ResponseModel

@property(nonatomic,strong) NSArray <MatchAssetListModel,Optional>*matchAssetList;
@property(nonatomic,strong) NSNumber <Optional>*matchedNumber;
@property(nonatomic,strong) NSNumber <Optional>*tranAmount;
@property(nonatomic,strong) NSNumber <Optional>*unTranAmount;

@end


/*
{
matchAssetList =     (
{
    holdAmount = 100;
    holdTime = "2016-06-23";
    matchAssetType = BID;
    matchTime = "2016-06-23";
    projectId = 24290;
    projectName = "\U8d2d\U4e70\U519c\U673a";
},
{
    holdAmount = 800;
    holdTime = "2016-07-18";
    matchAssetType = BID;
    matchTime = "2016-06-22";
    projectId = 24278;
    projectName = "\U8d2d\U4e70\U519c\U673a";
},
{
    holdAmount = "5173.27";
    holdTime = "2016-06-15";
    matchAssetType = BID;
    matchTime = "2016-05-30";
    projectId = 21375;
    projectName = "\U5907\U8d27";
},
);
matchedNumber = 5;
resultCode = 1;
tranAmount = 32200;
unTranAmount = 0;
}
 */
