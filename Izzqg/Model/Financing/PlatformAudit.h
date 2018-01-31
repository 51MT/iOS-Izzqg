//
//  PlatformAudit.h
//  Ixyb
//
//  Created by wang on 15/6/11.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "JSONModel.h"

@interface PlatformAudit : JSONModel

@property (nonatomic, assign) BOOL antiFraud;
@property (nonatomic, assign) BOOL creditReport;
@property (nonatomic, assign) BOOL hasCreditCard;
@property (nonatomic, copy) NSString<Optional> *idNumber;
@property (nonatomic, assign) BOOL identityAuth;
@property (nonatomic, assign) BOOL incomeCertify;
@property (nonatomic, assign) BOOL liveCertify;
@property (nonatomic, copy) NSString<Optional> *mobilePhone;
@property (nonatomic, assign) BOOL mobilePhoneAuth;
@property (nonatomic, assign) BOOL webConsume;
@property (nonatomic, assign) BOOL workCertify;

@end

/*
 platformAudit =     {
 antiFraud = 1;
 creditReport = 0;
 hasCreditCard = 0;
 idNumber = 60175;
 identityAuth = 1;
 incomeCertify = 0;
 liveCertify = 0;
 mobilePhone = "138****0099";
 mobilePhoneAuth = 1;
 webConsume = 0;
 workCertify = 0;
 };

 */