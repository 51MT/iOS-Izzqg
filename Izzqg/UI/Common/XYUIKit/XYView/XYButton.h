//
//  XYButton.h
//  Ixyb
//
//  Created by wang on 16/3/17.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ImportanceButton,    //重要按钮
    GerenalButton,       //一般按钮
    SubordinationButton, //次要按钮
    PutButton,           //z置顶按钮
    LineButton,          //加线的按钮
    EspecialButton,      //特殊需求按钮
    CustomerButton,      //按钮
    SkipButton,          //欢迎页  跳过
    ExperienceButton     //引导页
} ButtonType;

@interface XYButton : UIButton

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) ButtonType type;

//重要按钮  置顶按钮
- (id)initWithTitle:(NSString *)title btnType:(ButtonType)type;

//一般按钮
- (id)initWithGeneralBtnTitle:(NSString *)title titleColor:(UIColor *)color isUserInteractionEnabled:(BOOL)isEnabled;

//次要按钮
- (id)initWithSubordinationButtonTitle:(NSString *)title isUserInteractionEnabled:(BOOL)isEnabled;

//带线按钮
- (id)initWithLineButtonTitle:(NSString *)title;

//特殊需求按钮
/*
 *  masksToBounds  是否圆角
 *  title     标题
 *  @param colorDic     颜色字典
 *  {
 *  @“titlenormalcolor” ：@“”，
 *  @“titlehighlightedcolor”：@“”，
 *  @“backnormalcolor”：@“”，
 *  @“backhlightcolor”：@“”
 *  }
 *  isEnabled  是否可点击
 */
- (id)initWithEspecialButtonTitle:(NSString *)title isMasksToBounds:(BOOL)masksToBounds color:(NSDictionary *)colorDic isUserInteractionEnabled:(BOOL)isEnabled;

- (id)initWithCustomerButtonTitle:(NSString *)title;

@end
