//
//  ChargePayRouteResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/8/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"

@protocol LLResultDataModel;
@interface LLResultDataModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *acct_name;
@property (nonatomic, copy) NSString<Optional> *busi_partner;
@property (nonatomic, copy) NSString<Optional> *card_no;
@property (nonatomic, copy) NSString<Optional> *dt_order;
@property (nonatomic, copy) NSString<Optional> *id_no;
@property (nonatomic, copy) NSString<Optional> *info_order;
@property (nonatomic, copy) NSString<Optional> *money_order;
@property (nonatomic, copy) NSString<Optional> *name_goods;
@property (nonatomic, copy) NSString<Optional> *no_order;
@property (nonatomic, copy) NSString<Optional> *notify_url;
@property (nonatomic, copy) NSString<Optional> *oid_partner;
@property (nonatomic, copy) NSString<Optional> *risk_item;
@property (nonatomic, copy) NSString<Optional> *sign;
@property (nonatomic, copy) NSString<Optional> *sign_type;
@property (nonatomic, copy) NSString<Optional> *user_id;
@property (nonatomic, copy) NSString<Optional> *valid_order;
//@property (nonatomic, copy) NSString <Optional>*url_return;

@end

@interface ChargePayRouteResponseModel : ResponseModel

@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, copy) NSString<Optional>* bankType;
@property (nonatomic, copy) NSString<Optional>* userId;
@property (nonatomic, copy) NSString<Optional>* orderno;
@property (nonatomic, copy) NSString<Optional>* mobilePhone;
@property (nonatomic, copy) NSString<Optional>* orderId;
@property (nonatomic, strong) LLResultDataModel<Optional> *resultData;


@end

/*    
 mobilePhone = "138****9903";
 orderno = "XYB20160822085312374438_366988";
 payType = 10;
 resultCode = 1;
 userId = 374438;
 */

/*
 bankType = 1;
 payType = 5;
 resultCode = 1;
 resultData =     {
 "acct_name" = "\U8463\U5fd7\U521a";
 "busi_partner" = 101001;
 "card_no" = 6222024000072938455;
 "dt_order" = 20160818052119;
 "id_no" = 374438;
 "info_order" = "";
 "money_order" = "0.01";
 "name_goods" = "\U4fe1\U7528\U5b9dAPP\U5145\U503c";
 "no_order" = "XYB20160818052118374438_365565";
 "notify_url" = "https://apptest.xyb100.com/callback/lianlpaynotify";
 "oid_partner" = 201408071000001543;
 "risk_item" = "{\"user_info_full_name\":\"\U8463\U5fd7\U521a\",\"user_info_identify_type\":\"4\",\"user_info_dt_register\":\"20160628150307\",\"frms_ware_category\":\"2009\",\"user_info_identify_state\":\"1\",\"user_info_id_no\":\"374438\",\"user_info_mercht_userno\":\"374438\"}";
 sign = fceada4e07fafb747d740811e6c386b1;
 "sign_type" = MD5;
 "user_id" = 374438;
 "valid_order" = 10080;
 };
 userId = 374438;
 */
