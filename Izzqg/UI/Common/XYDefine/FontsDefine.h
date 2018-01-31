//
//  FontsDefine.h
//  Ixyb
//
//  Created by wang on 15/8/26.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

/**
 *  字体大小定义 FontsDefine
 *
 */
#ifndef FontsDefine_h
#define FontsDefine_h

//常用字体字号
//统一文字大小样式 以iPhone6为基准
#define TEXT_FONT_10 [UIFont systemFontOfSize:10.f] //10px 迷你小号
#define WEAK_TEXT_FONT_11 [UIFont systemFontOfSize:11.f]
#define TEXT_FONT_12 [UIFont systemFontOfSize:12.f] //12px 超小号      注释、失效、连接（可点击）
#define SMALL_TEXT_FONT_13 [UIFont systemFontOfSize:13.f]
#define TEXT_FONT_14 [UIFont systemFontOfSize:14.f] //14px 小号字      辅助文字
#define NORMAL_TEXT_FONT_15 [UIFont systemFontOfSize:15.f]
#define TEXT_FONT_BOLD_15 [UIFont boldSystemFontOfSize:15.f]
#define TEXT_FONT_16 [UIFont systemFontOfSize:16.f]          //16px 中号字      主要字体、输入框描述文字、正文、常用列表文字、主页侧边栏字体大小
#define TEXT_FONT_BOLD_16 [UIFont boldSystemFontOfSize:16.f] //16px  加粗中号字
#define BIG_TEXT_FONT_17 [UIFont systemFontOfSize:17.f]
#define TEXT_FONT_18 [UIFont systemFontOfSize:18.f] //18px 大号字      如按钮上、顶部导航栏、大标题
#define TEXT_FONT_19 [UIFont systemFontOfSize:19.f] //19px

//特殊字体大小、后续会慢慢统一
//信投宝增加利率
#define XTB_ADD_RATE_FONT [UIFont systemFontOfSize:8.67f]
#define FONT_SMALL_8 [UIFont systemFontOfSize:8.f]
#define FONT_SMALL_9 [UIFont systemFontOfSize:9.f]
//累计收益
#define ADDAMOUNT_FONT [UIFont systemFontOfSize:10.67f]
#define FONT_TEXT_20 [UIFont systemFontOfSize:20.f]
#define FONT_BUTTON_NORMAL [UIFont systemFontOfSize:22.0f]
#define GENERAL_MIDDLE_BIG_FONT [UIFont systemFontOfSize:24.f]
#define TEXT_FONT_25 [UIFont systemFontOfSize:25.f] //步步高历史年化结算利率中%号的大小
#define TEXT_FONT_26 [UIFont systemFontOfSize:26.f]
#define LARGE_TEXT_FONT_27 [UIFont systemFontOfSize:27.f]
//定期宝年化率
#define DQB_RATE_28 [UIFont systemFontOfSize:28.f]
//信投宝年化率
#define XTB_RATE_FONT [UIFont boldSystemFontOfSize:30.f]
//我的加息券的利率
#define MYCOUPONS_FONT [UIFont systemFontOfSize:34.f]
//可用余额
#define USABLEMOUNT_FONT [UIFont systemFontOfSize:35.f]
#define FONT_TEXT_LARGE_MORE [UIFont systemFontOfSize:36.f]
#define DQB_RATE_37 [UIFont systemFontOfSize:37.f]
#define BORROW_TEXT_FONT_40 [UIFont systemFontOfSize:40.f]
//定期宝增加年化率
#define DQB_ADD_RATE_FONT [UIFont systemFontOfSize:45.f]
#define FONT_HUGE_VERY_50 [UIFont systemFontOfSize:50.f]

#define SUPER_TEXT_FONT_54 [UIFont systemFontOfSize:54.f]
//定期宝年化率
#define DQB_RATE_59 [UIFont systemFontOfSize:59.f]
#define DQB_RATE_63 [UIFont systemFontOfSize:63.f]
#define DQB_RATE_FONT [UIFont systemFontOfSize:68.f]
#define DQB_RATE_70 [UIFont systemFontOfSize:70.f]

//电子签购单页面的字体大小(4s以下机型，字体大小设定为10，其它为12)
#define SignView_FontSize (IS_IPHONE_4_OR_LESS ? FONT_SMALL_8 : TEXT_FONT_12)

#endif


/** 苹果字体集合
Font Family: American Typewriter（ AmericanTypewriter，AmericanTypewriter-Bold）
Font Family: AppleGothic（AppleGothic）
Font Family: Arial（ArialMT，Arial-BoldMT，Arial-BoldItalicMT，Arial-ItalicMT）
Font Family: Arial Rounded MT Bold（ArialRoundedMTBold）
Font Family: Arial Unicode MS（ArialUnicodeMS）
Font Family: Courier（Courier，Courier-BoldOblique，Courier-Oblique，Courier-Bold）
Font Family: Courier New（CourierNewPS-BoldMT，CourierNewPS-ItalicMT，CourierNewPS-BoldItalicMT，CourierNewPSMT）
Font Family: DB LCD Temp （DBLCDTempBlack）
Font Family: Georgia（ Georgia-Bold， Georgia，Georgia-BoldItalic，Georgia-Italic）
Font Family: Helvetica（Helvetica-Oblique，Helvetica-BoldOblique，Helvetica，Helvetica-Bold）默认字体
Font Family: Helvetica Neue（HelveticaNeue，HelveticaNeue-Bold）
Font Family: Hiragino Kaku Gothic **** W3（HiraKakuProN-W3）
Font Family: Hiragino Kaku Gothic **** W6（HiraKakuProN-W6）
Font Family: Marker Felt（ MarkerFelt-Thin）
Font Family: STHeiti J  （STHeitiJ-Medium，STHeitiJ-Light）
Font Family: STHeiti K（ STHeitiK-Medium， STHeitiK-Light）
Font Family: STHeiti SC（STHeitiSC-Medium， STHeitiSC-Light）
Font Family: STHeiti TC（STHeitiTC-Light，STHeitiTC-Medium）
Font Family: Times New Roman（TimesNewRomanPSMT，TimesNewRomanPS-BoldMT， TimesNewRomanPS-BoldItalicMT， TimesNewRomanPS-ItalicMT）
Font Family: Trebuchet MS（ TrebuchetMS-Italic，TrebuchetMS，Trebuchet-BoldItalic，TrebuchetMS-Bold）
Font Family: Verdana（ Verdana-Bold，Verdana-BoldItalic， Verdana，Verdana-Italic）
Font Family: Zapfino（ Zapfino）
**/
