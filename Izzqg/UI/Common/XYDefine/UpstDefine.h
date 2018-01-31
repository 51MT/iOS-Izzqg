//
//  UpstDefine.h
//  Ixyb
//
//  Created by wangjianimac on 16/11/5.
//  Copyright © 2016年 xyb. All rights reserved.
//

#ifndef UpstDefine_h
#define UpstDefine_h

/*银联商通返回状态码*/
#define UPST_INIT_DEVICE @"0000"             //初始化设备
#define UPST_AUDIO_DEVICE_CONNECTION @"0002" //音频设备已连接
#define UPST_INIT_DEVICE_SUCCESS @"0029"     //初始化设备成功
#define UPST_CARD_NOT_INSERT @"0004"         //刷卡器未插入
#define UPST_CARD_BATTERY_LOW @"0005"        //刷卡器电量不足
#define UPST_PLEASE_CARD @"0006"             //请刷卡或插入IC卡
#define UPST_IC_CARD_INSERT @"0007"          //IC卡插入
#define UPST_IC_CARD_PULL_OUT @"0008"        //IC卡拔出
#define UPST_BRUSH_CARD_FAILURE @"0010"      //刷卡失败,请重试
#define UPST_IC_CARD_OPERATION @"0012"       //该卡为IC卡,请插卡操作
#define UPST_Zz_TRADING @"0033"              //用户终止交易
#define UPST_ARE_TRADING @"0035"             //正在交易
#define UPST_CARD_RECEIVED @"0022"           //设备收到刷卡指令
#define UPST_CARD_TIMEOUT @"0023"            //刷卡指令超时
#define UPST_TO_DEL_WITH @"0024"             //正在处理
#define UPST_TRADING_SUCCESS @"0036"         //交易成功
#define UPST_UPLOADSIGN_FAIL @"0037"         //上传签单失败
#define UPST_TRADING_FAILURE @"0038"         //交易失败
#define UPST_INPUT_CONFIRM @"0044"           //用户输入了密码

#endif /* UpstDefine_h */
