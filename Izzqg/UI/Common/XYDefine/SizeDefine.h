//
//  SizeDefine.h
//  Ixyb
//
//  Created by wangjianimac on 16/7/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  View间距、View宽高大小定义 SizeDefine
 *
 */
#ifndef SizeDefine_h
#define SizeDefine_h

//获取iOS系统屏幕全屏大小/宽高
#define MainScreenBounds [[UIScreen mainScreen] bounds]
#define MainScreenSize   MainScreenBounds.size
#define MainScreenWidth  MainScreenSize.width
#define MainScreenHeight MainScreenSize.height

//iPhone4|4s(3.5inch) iPhone5|5s(4inch) iPhone6(4.7inch) iPhone6plus(5.5inch) 屏幕宽度、高度
#define IPhone4MainScreenWidth      320.0f
#define IPhone4MainScreenHeight     480.0f

#define IPhone5MainScreenWidth      320.0f
#define IPhone5MainScreenHeight     568.0f

#define IPhone6MainScreenWidth      375.0f
#define IPhone6MainScreenHeight     667.0f

#define IPhone6plusMainScreenWidth  414.0f
#define IPhone6plusMainScreenHeight 736.0f

#define IPhoneXMainScreenWidth  375.0f
#define IPhoneXMainScreenHeight 812.0f

//ios判断是否为iphone6或iphone6plus
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(MainScreenWidth, MainScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(MainScreenWidth, MainScreenHeight))


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0f)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0f)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0f)
#define IS_IPHONE_6_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0f)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0f)

//定义iOS Version
#define IS_iOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f)
#define IS_iOS10AtLeast ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)
#define IS_iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] == 8.0f)
#define IS_iOS8TouID ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0f)
#define IS_iOS7AtLeast ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) //至少iOS7

#define IS_iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] == 6.0f)
#define IS_iOS5 ([[[UIDevice currentDevice] systemVersion] floatValue] == 5.0f)
#define IS_iOS6AtLeast ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) //至少iOS6
#define IS_iOS6AtMost ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0f)  //至多iOS6

//IntroduceViewController
#define kNumberOfPages 3
#define kCurrentPage 0

#define GuideViewPageControlWidth      100.0f
#define GuideViewPageControlHeight     7.5f
#define GuideViewPageControlFromBottom 20.0f

#define GuideViewGotoButtonWidth      100.0f
#define GuideViewGotoButtonHeight     30.0f
#define GuideViewGotoButtonFromBottom 70.0f

#define OFFSET_RIGHT_BUTTON (26)

//00 全局 状态栏、选项卡栏、导航栏
#define StatusBarHeight 20.0f

//01 界面布局 页面基于宽度iOS750px为准

//距左右上下宽 30px
#define Margin_Length 15.f
#define Margin_Left   15.f
#define Margin_Right  15.f
#define Margin_Top    15.f
#define Margin_Bottom 15.f

//导航栏高 88px
#define NavigationBar_Height    44.f
//分段空间高 56px
#define SegmentedControl_Height 28.f

//选项卡高 98px
#define Tab_Height     49.f
//选项卡线条 2px
#define TabLine_Height 1.f

//圆的大小 3px
#define Circular_WH 3.f

//线条 1px
#define Line_Height    0.5f

//边框宽度 1px
#define Border_Width         0.5f
//边框宽度 2px(首页头像)
#define Border_Width_2       1.0f
//边框宽度 20px(我的联盟_赚佣金_qrcode边距)
#define Border_Width_3       10.0f

//按钮高 90px
#define Button_Height        45.f

//按钮高 96px
#define Button_Height_2      48.f

//距离箭头间距 6px
#define Right_Arrow_Length   6.f

//按钮距离顶底部 30px
#define Button_Margin_Length 15.f

//圆角 6px
#define Corner_Radius         3.0f
//弹框 12px
#define Corner_Radius_BombBox 6.0f
//圆角 2px(步步高_进度条)
#define Corner_Radius_2       1.0f
//圆角 （13.0f/2）(信投宝_信用等级)
#define Corner_Radius_3       6.5f
//圆角 20px(信投宝_CreditLevelView)
#define Corner_Radius_4       10.0f
//圆角 26px(定期宝_剩余)
#define Corner_Radius_5       13.0f
//圆角 40px(推荐Lable)
#define Corner_Radius_6       20.0f
//圆角 5px
#define Corner_Radius_7       2.5f
//圆角 10.5px
#define Corner_Radius_8       10.5f
//圆角 （18.0f/2）(活动)
#define Corner_Radius_9       9.0f

//侧边栏_我的 栏高 100px
#define My_Cell_Height     50.f
//栏高 90px
#define Cell_Height        45.f
//栏高 108px 两行字
#define Double_Cell_Height 54.f

//栏距上下 45px
#define Cell_Margin_Length 22.5f

//文本间距 距离上下 26px
#define Text_Margin_Length  13.f
//文本间距 中间 12px
#define Text_Margin_Middle  6.f
//文本间距 段落
#define Text_Margin_Section 22.5f
//文本间距 距离箭头 20px
#define Text_Margin_Arrow   10.f

//弹出框距离左右 40px
#define Alert_Margin_Length 20.f
//弹出框标题高 90px
#define AlertTitle_Height   45.f
//弹出框文本框高 90px
#define AlertText_Height    45.f

//弹出框文本框距离顶部 40px
#define AlertText_Margin_Top    20.f
//弹出框文本框距离左右 30px
#define AlertText_Margin_Length 15.f

//弹出框按钮 距离顶部  30px
#define AlertButton_Margin_Top 15.f

//弹出框超链接 距离顶部  26px
#define AlertLink_Margin_Top    13.f
//弹出框超链接 距离底部  30px
#define AlertLink_Margin_Bottom 20.f

//弹出框提示文字 距离左  24px
#define AlertTip_Margin_Left 12.f

//弹出框错误提示 距离顶部  40px
#define AlertError_Margin_Top    20.f
//弹出框超链接 距离底部   20px
#define AlertError_Margin_Bottom 10.f

//单个选项 在屏幕居中显示（带图标和无图标）
//弹出框图标 距离顶部和底部  74px
#define AlertImage_Margin_Length   37.f
//弹出框标题 距离顶部  30px
#define AlertTitle_Margin_Top      15.f
//弹出框描述 距离顶部  24px
#define AlertContent_Margin_Top    12.f
//弹出框描述 距离左右  40px
#define AlertContent_Margin_Length 20.f
//弹出框描述 中间间隔  20px
#define AlertContent_Margin_Middle 10.f
//弹出框按钮高  90px
#define AlertButton_Height         45.f

//气泡警示框 在屏幕相应位置弹出、两秒内淡出消失
//气泡警示框高  78px
#define AlertHub_Height        39.f
//气泡警示框 内容距离左右  38px
#define AlertHub_Margin_Length 19.f

//带箭头气泡警示框高  62px
#define AlertArrow_Height        31.f
//带箭头气泡警示框高  62px
#define AlertArrow_Height        31.f
//带箭头气泡警示框箭头高  9px
#define AlertArrow_ArrowHeight   4.5f
//带箭头气泡警示框 内容距离左右  18px
#define AlertArrow_Margin_Length 9.f

//Prompt提示框Lable高度
#define Prompt_Lable_Height 54.f

//电子签购单页面marginLenght大小(5s以下机型，字体大小设定为10，其它为15)
#define SignView_MarginLenght (IS_IPHONE_5_OR_LESS ? 10.f :15.f)

//电子签购单页面行间距(5s以下机型，行间距设定为5，其它为8)
#define SignView_LineSpace (IS_IPHONE_5_OR_LESS ? 3.f:8.f)

#endif /* SizeDefine_h */
