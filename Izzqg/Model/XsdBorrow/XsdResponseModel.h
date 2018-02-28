//
//  XsdResponseModel.h
//  Ixyb
//
//  Created by dengjian on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XsdUploadDataModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *message;
@property (nonatomic, copy) NSString<Optional> *verifyResult;   //比对结果(1通过,0不通过)
@property (nonatomic, copy) NSString<Optional> *verifycanagain; //是否可以再次认证(1可以,0不可以)

@end

@interface XsdResponseModel : JSONModel

@property (nonatomic, assign) int result;
@property (nonatomic, strong) XsdUploadDataModel<Optional> *data;

@end
