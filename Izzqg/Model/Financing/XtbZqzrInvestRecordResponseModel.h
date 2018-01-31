//
//  XtbZqzrInvestRecordResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/9/9.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol BidsModel ;
@interface BidsModel : JSONModel

@property (nonatomic, copy) NSString<Optional>* username;
@property (nonatomic, copy) NSString<Optional>* availableAmount;
@property (nonatomic, copy) NSString<Optional>* bidDate;

@end


@interface XtbZqzrInvestRecordResponseModel : ResponseModel

@property (nonatomic, strong) NSArray <BidsModel>*bids;

@end

/*债权转让
 "resultCode": 1,
 "bids": [
 {
 "username": "perfe******",
 "availableAmount": 3928.41,
 "bidDate": "2015-09-18 16:35:25"
 }
 ]
 */

/*信投保
 “resultCode” : 1,
 “bids” : [ {
 “username” : “用户名”,
 “availableAmount” : 总投标金额,
 “bidDate”:”投标时间”
 }]
 */
