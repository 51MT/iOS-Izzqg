//
//  ActionInformation.h
//  Ixyb
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol MachineInfosModel;
@interface MachineInfosModel : JSONModel
@property(nonatomic,copy)NSString <Optional> * machineName;
@property(nonatomic,copy)NSString <Optional> * model;
@end

@interface ActionInformation : JSONModel
@property(nonatomic,retain)NSArray <Optional,MachineInfosModel> * machineInfos;
@property(nonatomic,copy)NSString <Optional> *  machineTotalPrice;
@property(nonatomic,copy)NSString <Optional> *  firstPayment;
@property(nonatomic,copy)NSString <Optional> *  borrowAmount;
@property(nonatomic,copy)NSString <Optional> *  depositPayment;
@end
