//
//  UnionpayStModel.h
//  Ixyb
//
//  Created by Jiang_Dryan on 16/11/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UnionpayStModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *merchantName;
@property (nonatomic, copy) NSString<Optional> *merchantNo;
@property (nonatomic, copy) NSString<Optional> *terSerialNo;
@property (nonatomic, copy) NSString<Optional> *issuingBank;
@property (nonatomic, copy) NSString<Optional> *maskedPAN;
@property (nonatomic, copy) NSString<Optional> *transType;
@property (nonatomic, copy) NSString<Optional> *dateTime;
@property (nonatomic, copy) NSString<Optional> *posSeqId;
@property (nonatomic, copy) NSString<Optional> *batchNo;
@property (nonatomic, copy) NSString<Optional> *referenceNo;
@property (nonatomic, copy) NSString<Optional> *orderAmt;
@property (nonatomic, copy) NSString<Optional> *retCode;
@property (nonatomic, copy) NSString<Optional> *retMsg;
@property (nonatomic, copy) NSString<Optional> *torderId;
@property (nonatomic, copy) NSString<Optional> *orderno;

@end
