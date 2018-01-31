//
//  EmailInputNoticeAlertView.h
//  Ixyb
//
//  Created by wang on 16/12/21.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "BaseView.h"

typedef enum{
    EmailInputAlertViewActionCancel,
    EmailInputAlertViewActionEmail
}EmailInputNoctionAlertViewAction;

@interface EmailInputNoticeAlertView : BaseView

-(void)show:(void(^)(EmailInputNoctionAlertViewAction action, NSString * email))completion;

@end
