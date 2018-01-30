//
//  ColorDefine.h
//  Ixyb
//
//  Created by wang on 15/8/24.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ColorDefine.h"
#import "ColorUtil.h"

/**
 * iOS 字体颜色规范
 */
#ifndef ColorDefine_h
#define ColorDefine_h

//－－－－－－－－－－1.全局颜色、2.文字颜色、3.分隔线用色－－－－－－－－－－//

//主色 #0ab0ef 按钮、不可点击文字
#define COLOR_MAIN [ColorUtil colorWithHexString:@"2772ff"]

//辅色 #57ca8b  替换 #7ac406（浅绿）
#define COLOR_LIGHT_GREEN [ColorUtil colorWithHexString:@"7ac406"]


//辅色 #669cff (浅蓝) 品牌色(次)
#define COLOR_LIGHT_BLUE [ColorUtil colorWithHexString:@"669cff"]

//装点色 #ff8c1a 醒目、重要金额 （橘黄）、账户页面三个颜色 【#fbab1e被替换】#ff801a fffae8
#define COLOR_ORANGE [ColorUtil colorWithHexString:@"ff8c1a"]

#define COLOR_CHU_ORANGE [ColorUtil colorWithHexString:@"ff801a"]

#define COLOR_CHUBBG_ORANGE [ColorUtil colorWithHexString:@"ff6c24"]

#define COLOR_BG_ORANGE [ColorUtil colorWithHexString:@"fffae8"]

//装点色 #ff7800 点缀\强化
#define COLOR_XTB_ORANGE [ColorUtil colorWithHexString:@"ff7800"]

//装点色 #ffa348 活动、加息线框颜色
#define COLOR_ORANGE_BORDER [ColorUtil colorWithHexString:@"ffa348"]

//装点色 #fff5ed 活动、加息线框底色
#define COLOR_ORANGE_BACKGROUND [ColorUtil colorWithHexString:@"fff5ed"]

//装点色 #dc483e 强化/提醒、红色_强化、警示、错误 【#e46d58被替换】
#define COLOR_STRONG_RED [ColorUtil colorWithHexString:@"dc483e"]

//总资产 圆盘 颜色
#define COLOR_STRONG_LIGHT_RED [ColorUtil colorWithHexString:@"f27992"]

//黑白灰 #323741 深色（浅黑）导航条颜色 #292d34替换成#323741
#define COLOR_DARK_GREY [ColorUtil colorWithHexString:@"323741"]

//黑白灰 #293240 主标题、黑色_正文、标题、默认文字 【#434343被替换】【#292d34被替换】基础黑色(主)
#define COLOR_MAIN_GREY [ColorUtil colorWithHexString:@"293240"]

//蓝色 按钮渐变 #16ACF9
#define COLOR_LIGHT_BUT_BLUE [ColorUtil colorWithHexString:@"16ACF9"]


//蓝色 已投列表 头部渐变 #2EA4FF
#define COLOR_HAVECAST_BLUE [ColorUtil colorWithHexString:@"2EA4FF"]


//黑白灰 #0B0B0C Cell标题文字
#define COLOR_TITLE_GREY [ColorUtil colorWithHexString:@"0B0B0C"]

//黑白灰 #828a99 正文、灰色_副标题、内容 【#8D9199被替换】 灰色(次)
#define COLOR_AUXILIARY_GREY [ColorUtil colorWithHexString:@"828a99"]

#define COLOR_CELL_TITLE_GREY [ColorUtil colorWithHexString:@"4D535F"]

#define COLOR_NEWADDARY_GRAY [ColorUtil colorWithHexString:@"bfc1c5"]

#define COLOR_LEND_STATE_GRAY [ColorUtil colorWithHexString:@"B3B9C7"]

//黑白灰 #bcc1cc 注释/失效、浅灰色_注释、描述、失效 【#909090被替换】 [#c8ccd5] [#808692] [#bdc1c9] [#bdbdbd]
#define COLOR_LIGHT_GREY [ColorUtil colorWithHexString:@"bcc1cc"]

#define COLOR_LINE_GREY [ColorUtil colorWithHexString:@"c8ccd5"]

#define COLOR_CELL_GREY [ColorUtil colorWithHexString:@"808692"]

#define COLOR_DETAILE_GREY [ColorUtil colorWithHexString:@"bdc1c9"]

#define COLOR_RECORD_GREY [ColorUtil colorWithHexString:@"bdbdbd"]

//黑白灰 #e7e7ec 分割线、常用分隔线 1px（剩余可投———边框、圆圈进度背景、发现的背景边框的颜色）
#define COLOR_LINE [ColorUtil colorWithHexString:@"dadeef"]

#define COLOR_GRAY_LINE [ColorUtil colorWithHexString:@"dadee5"]

//蓝色线 #85BBFF 出借周期 1px
#define COLOR_LINE_BLUE_01 [ColorUtil colorWithHexString:@"85BBFF"]

//绿线 #7AC406 进度条 3px
#define COLOR_LINE_GREEN [ColorUtil colorWithHexString:@"7AC406"]

//按钮点击高亮状态下的颜色 #f3f3f6
#define COLOR_BUTTON_HIGHLIGHT [ColorUtil colorWithHexString:@"f3f3f6"]

//#6cd0f5 主题蓝色上的分割线、已投项目步步高、出借详情分割线
#define COLOR_LIGHT_BLUE_LINE [ColorUtil colorWithHexString:@"6cd0f5"]

//#2eb6eb 主题蓝色上的蓝色背景
//#define COLOR_LIGHT_BLUE [ColorUtil colorWithHexString:@"2eb6eb"]

//#47c4f3 主题蓝色上的分割线
#define COLOR_LINE_BLUE [ColorUtil colorWithHexString:@"47c4f3"]

//黑白灰 #fof2f5 背景色
#define COLOR_BG [ColorUtil colorWithHexString:@"f5f5f9"]

//黑白灰 #dddddd 背景色
#define COLOR_BG_1 [ColorUtil colorWithHexString:@"dddddd"]

//黑白灰 #d3d3d8 按钮边框颜色
#define COLOR_LAYER_LINE [ColorUtil colorWithHexString:@"d3d3d8"]

//步步高投影 #3C6CDE
#define COLOR_PROJECTION [ColorUtil colorWithHexString:@"3C6CDE"]

//步步高底部投影 #849DD9
#define COLOR_GRAY [ColorUtil colorWithHexString:@"849DD9"]

//产品介绍 #FF801A
#define COLOR_INTRODUCE_ORANGE [ColorUtil colorWithHexString:@"FF801A"]
//步步高赎回投影 #E8EDF6
#define COLOR_REDEEM [ColorUtil colorWithHexString:@"E8EDF6"]

//产品介绍 #F74C4C (警示\强化)
#define COLOR_INTRODUCE_RED [ColorUtil colorWithHexString:@"F74C4C"]

//渐变按钮颜色 #16ACF9
#define COLOR_BUTTON_BLUE [ColorUtil colorWithHexString:@"16ACF9"]



//黑白灰 #ffffff 白色、白色_按钮文字、黑色、透明色、 灰色
#define COLOR_COMMON_WHITE [UIColor whiteColor]
#define COLOR_COMMON_BLACK [UIColor blackColor]
#define COLOR_COMMON_CLEAR [UIColor clearColor]
#define COLOR_COMMON_RED [UIColor redColor]
#define COLOR_COMMON_GRAY [UIColor grayColor]

//特殊 #cdced1（如底部导航栏或tab按钮）横向分隔线 1px
#define COLOR_TAB_LINE [ColorUtil colorWithHexString:@"cdced1"]

//－－－－－－－－－－－－－保留的特殊颜色体系、后续会慢慢统一－－－－－－－－－－－－－－－－－//

//侧边栏透明背景
#define COLOR_LIGHTGRAY_SIDEVIEWBG [ColorUtil colorWithHexString:@"feffffff"]

//引导页颜色背景
#define COLOR_LIGHTGRAY_GUIDEVIEWBG [ColorUtil colorWithHexString:@"f6f6f6"]

//半透明黑色、弹出框背后的颜色
#define COLOR_COMMON_BLACK_TRANS [UIColor colorWithWhite:0 alpha:0.45f]
#define COLOR_COMMON_BLACK_TRANS_05 [UIColor colorWithWhite:0 alpha:0.05f]
#define COLOR_COMMON_BLACK_TRANS_65 [UIColor colorWithWhite:0 alpha:0.65f]
#define COLOR_COMMON_BLACK_TRANS_75 [[UIColor blackColor] colorWithAlphaComponent:0.75]

//半透明白色
#define COLOR_COMMON_WHITE_TRANS [UIColor colorWithWhite:1 alpha:0.5f]

//按钮高亮状态 深蓝色_蓝色按钮的点击效果、可点击文字超链接 #2063D5
#define COLOR_HIGHTBULE_BUTTON [ColorUtil colorWithHexString:@"2063D5"]

//按钮不可点击  #dcdce1
#define COLOR_LIGHTGRAY_BUTTONDISABLE [ColorUtil colorWithHexString:@"dcdce1"]

//分段空间的点击颜色UISegmentedControl  SEG
#define COLOR_LIGHTDARK_SEGMENTEDCONTROL [ColorUtil colorWithHexString:@"525966"]

//我要转让不可点击的颜色
#define COLOR_DISABLE_BTNTITLE [ColorUtil colorWithHexString:@"696b6e"]

//转圈背景颜色
#define COLOR_CIRCLE_BG [ColorUtil colorWithHexString:@"f3f4f5"]

//在红色底上的收益页面竖线颜色（红色）
#define COLOR_RED_VERTICALLINE [ColorUtil colorWithHexString:@"e98a79"]

//个人信息和信用等级颜色
//信用等级1~4
#define COLOR_RED_LEVEL1 [ColorUtil colorWithHexString:@"fd323e"]

//信用等级4~7、担保信息
#define COLOR_LIGHTRED_LEVEL2 [ColorUtil colorWithHexString:@"fd837a"]

//信用等级8~9、征信信息
#define COLOR_ORANGE_LEVEL3 [ColorUtil colorWithHexString:@"eec233"]

//信用等级10、企业信息
#define COLOR_LIGHT_GREEN_LEVEL4 [ColorUtil colorWithHexString:@"76cb99"]

//个人信息
#define COLOR_IDICATE_PERSON [ColorUtil colorWithHexString:@"3894ef"]

//安全页面_风险缓释金底图颜色
#define COLOR_ORANGE_LEVEL4 [ColorUtil colorWithHexString:@"e7764a"]

// 欢迎页面 跳过
#define COLOR_MAIN_HIGHT [ColorUtil colorWithHexString:@"c5c8cc"]

// 步步高详情页面
#define COLOR_BBGDESCRIPTION_ITEM_1 [ColorUtil colorWithHexString:@"4b566d"]
#define COLOR_BBGDESCRIPTION_ITEM_2 [ColorUtil colorWithHexString:@"ffb83b"]

// 信投宝_信用页面
#define COLOR_CREDITINFO [ColorUtil colorWithHexString:@"b6cbdf"]

// 利率走势图
#define COLOR_HQB_FSLINECHAERT [ColorUtil colorWithHexString:@"de6a54"]
// 详情页面_底部
#define COLOR_HQBDETAIL_FOOTER [ColorUtil colorWithHexString:@"f8fcfa"]

// 我的收益卡页面_倍数
#define COLOR_INCREASE_CARD_11 [ColorUtil colorWithHexString:@"8dd4ab"]
#define COLOR_INCREASE_CARD_12 [ColorUtil colorWithHexString:@"ffa9a1"]
#define COLOR_INCREASE_CARD_13 [ColorUtil colorWithHexString:@"61b0f4"]
#define COLOR_INCREASE_CARD_14 [ColorUtil colorWithHexString:@"e1cd7b"]
#define COLOR_INCREASE_CARD_15 [ColorUtil colorWithHexString:@"c3a1f0"]

// 信用宝联盟
#define COLOR_MYUNION_SECTIONHEADER [ColorUtil colorWithHexString:@"f4f4f6"]
#define COLOR_MYUNION_APPLY [ColorUtil colorWithHexString:@"d7d7da"]

// NoDataView
#define COLOR_NODATAVIEW_TITLE [ColorUtil colorWithHexString:@"999999"]

// 摇摇乐
#define COLOR_SHAKE [ColorUtil colorWithHexString:@"ff5c5c"]

// 安全页面Line
#define COLOR_SAFE_LINE [ColorUtil colorWithHexString:@"79bef8"]

// 信闪贷
#define COLOR_XSD_AUTH [ColorUtil colorWithHexString:@"6c6c6c"]
#define COLOR_XSD_UNAUTH [ColorUtil colorWithHexString:@"f5f2f7"]

//首页测评提示底色 黄色
#define COLOR_HOME_TEST [ColorUtil colorWithHexString:@"ffeec8"]

//圆饼默认颜色
#define COLOR_ASSERT_BG [ColorUtil colorWithHexString:@"d4d4d4"]
#define COLOR_ASSERT_BTTOM_BG [ColorUtil colorWithHexString:@"ebf1f4"]
//评测背景颜色
#define COLOR_EVALUATING_BG [ColorUtil colorWithHexString:@"fffbe8"]
//实时交易数据
#define COLOR_TRAD_RED [ColorUtil colorWithHexString:@"e46d58"]
//信投宝资产
#define COLOR_XTB_BG [ColorUtil colorWithHexString:@"b685ec"]

//步步高出借顶部区域阴影
#define COLOR_SHADOW_GRAY [ColorUtil colorWithHexString:@"000000"]

//产品介绍
#define COLOR_ROUND_GRAY [ColorUtil colorWithHexString:@"D9DDE6"]
/**
 * 颜色定义 ColorDefine 从UIdefine移过来的、后面合并
 *
 */
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]

#define MAINCOLOR [UIColor colorWithRed:(62.0f) / 255.0f green:(163.0f) / 255.0f blue:(254.0f) / 255.0f alpha:(1.0f)]
#define AUXILIARYCOLOR [UIColor colorWithRed:(66.0f) / 255.0f green:(78.0f) / 255.0f blue:(103.0f) / 255.0f alpha:(1.0f)]
#define MAINTEXTCOLOR [UIColor colorWithRed:(67.0f) / 255.0f green:(67.0f) / 255.0f blue:(67.0f) / 255.0f alpha:(1.0f)]
#define WEAKTEXTCOLOR [UIColor colorWithRed:(198.0f) / 255.0f green:(198.0f) / 255.0f blue:(198.0f) / 255.0f alpha:(1.0f)]
#define TEXTCOLOR [UIColor colorWithRed:(221.0f) / 255.0f green:(221.0f) / 255.0f blue:(221.0f) / 255.0f alpha:(1.0f)]
#define BGCOLOR [UIColor colorWithRed:(245.0f) / 255.0f green:(245.0f) / 255.0f blue:(245.0f) / 255.0f alpha:(1.0f)]
#define DARKBGCOLOR [UIColor colorWithRed:(39.0f) / 255.0f green:(40.0f) / 255.0f blue:(53.0f) / 255.0f alpha:(0.9f)]
#define BGLINECOLOR [UIColor colorWithRed:(238.0f) / 255.0f green:(238.0f) / 255.0f blue:(238.0f) / 255.0f alpha:(1.0f)]
#define HINTCOLOR [UIColor colorWithRed:(153.0f) / 255.0f green:(153.0f) / 255.0f blue:(153.0f) / 255.0f alpha:(1.0f)]

#endif
