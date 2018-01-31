//
//  SGScanningQRCodeVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanLoginViewController.h"
#import "SGScanningQRCodeView.h"
#import "ScanSuccessJumpVC.h"
#import "SGQRCodeTool.h"
#import "Utility.h"
#import "WebService.h"
#import "ResponseModel.h"

@interface SGScanningQRCodeVC () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) SGScanningQRCodeView *scanningView;

@property (nonatomic, strong) UIButton *right_Button;
@property(nonatomic,copy)NSString * urlStr;
@property (nonatomic, assign) BOOL first_push;

@end

@implementation SGScanningQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 二维码扫描
    [self setupScanningQRCode];

    
    // 创建扫描边框
    self.scanningView = [[SGScanningQRCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanningView];
    
    [self.view bringSubviewToFront:self.navBar];
    [self initNav];

    self.first_push = YES;
}

- (void)initNav {
    self.navItem.title = XYBString(@"scan_code", @"二维码");
    self.view.backgroundColor = COLOR_BG;
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

-(void)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    // 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [SGQRCodeTool SG_scanningQRCodeOutsideVC:self session:_session previewLayer:_previewLayer];
}

#pragma mark - - - 二维码扫描代理方法
// 调用代理方法，会频繁的扫描
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 0、扫描成功之后的提示音
    [self playSoundEffect:@"sound.caf"];

    // 1、如果扫描完成，停止会话
   [self.session stopRunning];
    // 2、删除预览图层
//   [self.previewLayer removeFromSuperlayer];
    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        self.urlStr = obj.stringValue;
        if ([Utility isValidateWebsiteStr:obj.stringValue]) {
            if (![obj.stringValue hasPrefix:@"https://www.xyb100.com"]) {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_alert", @"提示")
                                                                    message:[NSString stringWithFormat:XYBString(@"str_lj_tip", @"该链接将跳转到外部页面,可能存在风险。\n %@"),obj.stringValue]
                                                                   delegate:self
                                                          cancelButtonTitle:XYBString(@"str_cancel", @"取消")
                                                          otherButtonTitles:XYBString(@"str_dklj", @"打开链接"), nil];
                alertview.tag = 1000;
                [alertview show];
            }else{
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setObject: [UserDefaultsUtil getUser].userId forKey:@"userId"];
                [params setObject:obj.stringValue forKey:@"loginCode"];
                [self requestTheQrcodeScanWebServiceWithParam:params];
            }
        }else
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_scancode", @"扫描到的内容")
                                                                message:[NSString stringWithFormat:XYBString(@"str_nr", @"%@"),obj.stringValue]
                                                               delegate:self
                                                      cancelButtonTitle:XYBString(@"string_ok", @"确定")
                                                      otherButtonTitles:nil];
            alertview.tag = 1001;
            [alertview show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlStr]];
            [self performSelector:@selector(startRunningSession) withObject:nil afterDelay:0.5];
        }else
        {
            [self.session startRunning];
        }
    }else
    {
        [self.session startRunning];
    }
}

-(void)startRunningSession
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session startRunning];
    });
}

/****************************二维码扫码******************************/
- (void)requestTheQrcodeScanWebServiceWithParam:(NSDictionary *)param {
    NSString *requestURL = [RequestURL getRequestURL:QrcodeScanURL param:param];
    [self showQrcodeLoadingOnAlertView];
    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ResponseModel * response = responseObject;
        [self hideLoading];
        if (response.resultCode == 1) {
            ScanLoginViewController * scanLogin = [[ScanLoginViewController alloc]init];
            scanLogin.qcodeCode = [param objectForKey:@"loginCode"];
            scanLogin.blcok =^(void){
                
                [self.session startRunning];
            };
            [self.navigationController pushViewController:scanLogin animated:YES];
        }
    }
   fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
        [self.session startRunning];
       [self hideLoading];
       [self showPromptTip:errorMessage];
   }];
}

#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}

#pragma mark - - - 移除定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}



@end

/*
 
 二维码扫描的步骤：
     1、创建设备会话对象，用来设置设备数据输入
     2、获取摄像头，并且将摄像头对象加入当前会话中
     3、实时获取摄像头原始数据显示在屏幕上
     4、扫描到二维码/条形码数据，通过协议方法回调
 
 AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
 AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
 AVCaptureMetadataOutput 输出类。这个支持二维码、条形码等图像数据的识别
 AVCaptureVideoPreviewLayer 图层类。用来快速呈现摄像头获取的原始数据
 二维码扫描功能的实现步骤是创建好会话对象，用来获取从硬件设备输入的数据，并实时显示在界面上。在扫描到相应图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
 
 */

