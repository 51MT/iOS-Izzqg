//
//  UserVoiceModel.h
//  Ixyb
//
//  Created by wang on 16/12/17.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ResponseModel.h"
@protocol UserCommentsModel
@end

@interface UserCommentsModel : JSONModel
/*!
 *  @author JiangJJ, 16-12-17 14:12:41
 *
 *  评论拿积分测试
 */
@property (nonatomic, copy) NSString<Optional> *content;

/*!
 *  @author JiangJJ, 16-12-17 14:12:50
 *
 *  vip等级
 */
@property (nonatomic, copy) NSString<Optional> *vipLevel;

/*!
 *  @author JiangJJ, 16-12-17 14:12:58
 *
 *  用户名称
 */
@property (nonatomic, copy) NSString<Optional> *nickName;

/*!
 *  @author JiangJJ, 16-12-17 14:12:12
 *
 *  用户头像
 */
@property (nonatomic, copy) NSString<Optional> *portraitUrl;

/*!
 *  @author JiangJJ, 16-12-17 14:12:33
 *
 *  时间
 */
@property (nonatomic, copy) NSString<Optional> *createdDate;

/*!
 *  @author JiangJJ, 16-12-17 14:12:49
 *
 *  是否过期
 */
@property (nonatomic, copy) NSString<Optional> *isExpired;
@end

@interface UserVoiceModel : ResponseModel
@property (nonatomic, strong) NSMutableArray <UserCommentsModel, Optional> *userComments;
@end
