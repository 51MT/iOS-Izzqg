//
//  ConstantDefine.h
//  Ixyb
//
//  Created by wangjianimac on 16/7/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#ifndef ConstantDefine_h
#define ConstantDefine_h

#define PageSize @"20"
#define PageSizeMin @"10"
#define PageSizeMax @"100"

#define DEGREES_TO_RADIANS(d) (d * M_PI_2 / 180)

//签名 key/secret
#import <CommonCrypto/CommonCrypto.h>
#define SHA1KEY    @"2b5d4963147f4cf4e7148a6bf8850e3c"
#define SHA1SECRET @"c90156984c4cce4138ae2c5e5480058d"

//信用宝Ixyb 友盟统计、友盟分享、友盟推送 APPKEY
#define UMENG_APPKEY @"5a951816f29d986fd000034a"

//友盟分享
#define WXAppId     @"wxb70a81ab4d871694"
#define WXAppSecret @"6de2721562021e8da3b4a002558ec11d"
#define QQAppId     @"1106674249"
#define QQAppSecret @"LGptq1k3uQEaBSN1"
#define UmShareUrl  @"http://www.zhuzhuqianguan.com"

//小能客服 APPKEY
#define XNAppKEY    @"PPSqQUStVqVk586Csc6fP2"
#define XNAppSecret @"a97dd95083ba46e084510981ddc2a689"

//Face++ 身份证／银行卡检测 Appkey、AppSecret
//开发环境
#define FaceIdEnvAppKEY    @"J2AdbNMrYEYzAstIKFvemDbf84tWSYPt"
#define FaceIdEnvAppSecret @"SXT3ye1nuJamjiHgjwgrK6gKeAOhGS3J"
//正式环境
#define FaceIdProAppKEY    @"G4aTvN3JtQA28rfw8lyBd0nVvEsAz1eL"
#define FaceIdProAppSecret @"HRJcWCkjP1hChmFRHF9QMpifbXSmhj_0"

#define IS_NEWUSER @"1"

//出借首页——重复计数——无限循环
#define MAXCOUNT (1.0 / 0.0)

#endif /* ConstantDefine_h */
