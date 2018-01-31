//
//  XsdGetBorrowResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/23.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
#import "XsdAuthorized.h"


@interface XsdGetBorrowResponseModel : JSONModel

@property (nonatomic, strong) XsdAuthorized <Optional>*data;
@property (nonatomic, copy) NSString <Optional>*result;
@property (strong, nonatomic) NSString<Optional> *message; //接口调用成功时，没有错误信息

@end

/*
 data =     {
 applyAmount = "";
 approvedAmount = "";
 approvedState = "";
 bankName = "<null>";
 borrowId = "";
 cardNo = "<null>";
 customerName = "";
 dayRate = "0.02%/\U5929";
 historyUrl = "";
 idNumber = "";
 loanLimit = "7-30\U5929 \U968f\U501f\U968f\U8fd8";
 loanProvider = "\U4fe1\U7528\U5b9d\U3001\U4fe1\U95ea\U8d37";
 loanTerm = "1\U671f";
 repayAmount = "";
 repayEndDay = "";
 repayInfoList =         (
 );
 type = "H5_LINK";
 url = "http://xsd.test.xybao.com/app-granted/error?msg=\U7528\U6237\U5f02\U5e38\Uff0c\U8bf7\U8054\U7cfb\U6211\U4eec\U7684\U5ba2\U670dMM\Uff0c\U6211\U4eec\U4f1a\U5c3d\U5feb\U4e3a\U60a8\U89e3\U51b3\Uff01";
 };
 result = 1;

 */