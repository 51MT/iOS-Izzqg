//
//  XYWebViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XYWebViewController.h"
#import "RequestURL.h"
#import "Utility.h"

@interface XYWebViewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *backBtn;

@property (strong,nonatomic) UIProgressView *progressView;
@property (nonatomic,copy) NSString *statuStr;

@end

@implementation XYWebViewController

- (id)initWithStatus:(int)status {
    self = [super init];
    if (self) {
        
        switch (status) {
            case 1:
                _statuStr = @"account";
                break;
                
            case 2:
                _statuStr = @"prize";
                break;
                
            case 3:
                _statuStr = @"myself";
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)setNav {
    
    _backBtn = [[UIButton alloc] init];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"backItem"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.hidden = YES;
    [self.navBar addSubview:_backBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(self.navBar.mas_left).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"closeItem"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    [self.navBar addSubview:_closeBtn];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(_backBtn.mas_right).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BG;
    [self setNav];
    [self createProgressView];
    [self createWKWebViewAnd_PostTaskWithSession];
}


/**
 WKWebview的进度条
 */
- (void)createProgressView {
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, IS_IPHONE_X ? 88:64, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = COLOR_COMMON_WHITE;
    self.progressView.tintColor = COLOR_BLUE;
    self.progressView.trackTintColor = COLOR_COMMON_WHITE;
    
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.view bringSubviewToFront:self.progressView];
}

/**
 创建WKWebview，并请求数据
 */
- (void)createWKWebViewAnd_PostTaskWithSession {
    
    if (_webView) {
        [_webView removeFromSuperview];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getMessage"];
        _webView = nil;
    }
    
    //创建一个WKWebView的配置对象
    WKWebViewConfiguration *configur = [[WKWebViewConfiguration alloc] init];
    
    //设置configur对象的preferences属性的信息
    WKPreferences *preferences = [[WKPreferences alloc] init];
    configur.preferences = preferences;
    
    //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
    preferences.javaScriptEnabled = YES;
    
    //注册供js调用的方法
    WKUserContentController *userContentController =[[WKUserContentController alloc]init];
    configur.userContentController = userContentController;
    configur.preferences.javaScriptEnabled = YES;
    configur.allowsInlineMediaPlayback = YES;
    
    [userContentController addScriptMessageHandler:self name:@"getMessage"];
    configur.userContentController = userContentController;
    
    if (!_webView) {
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configur];
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = COLOR_BG;
    _webView.UIDelegate = self;
    //如果只是调用 loadRequest 这个代理不能写
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;//打开网页间的 滑动返回
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = YES;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(2);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(MainScreenHeight - 49 - 64 - 2));
    }];
    
    //访问请求
    NSString *reqestUrl = [RequestURL getZzqg_BaseUrl:baseRequest_Url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reqestUrl]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[RequestURL getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[UserDefaultsUtil getUser].userId ? [UserDefaultsUtil getUser].userId:@"" forKey:@"userId"];
    [param setValue:[UserDefaultsUtil getUser].loginToken ? [UserDefaultsUtil getUser].loginToken:@"" forKey:@"token"];
    [param setValue:_statuStr forKey:@"status"];
    
    //转成json
    NSError *error;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    request.HTTPBody = jsonData;
    
    if (error) {
        NSLog(@"jsonDataError:%@",error);
    }
    
    // 实例化网络会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建请求Task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data) {
            return ;
        }
        
        NSError *err;
        NSMutableDictionary *param = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&err];
        
        if (error){
            NSLog(@"getMessageError:%@",error);
        }
        
        NSString *linkUrl = [param objectForKey:@"linkUrl"];
        
        //必须放到主线程中处理，不然会线程报错
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkUrl]]];
        });
    }];
    
    //开启任务task
    [task resume];
}

#pragma mark - 响应事件

- (void)clickBackBtn:(id)sender {
    
    //webView至少两层
    if ([self.webView canGoBack]) {
        
        NSArray *webArr = _webView.backForwardList.backList;
        
        if (webArr.count > 2) {
            _backBtn.hidden = NO;
            _closeBtn.hidden = NO;
            [self hidesTabBar:YES];
            
        }else if(webArr.count == 1){
            _backBtn.hidden = YES;
            _closeBtn.hidden = YES;
            [self hidesTabBar:NO];
            
        }else{
            _backBtn.hidden = NO;
            _closeBtn.hidden = YES;
            [self hidesTabBar:NO];
        }
        
        [self.webView goBack];
        
    } else {//webView只有一层了
        _backBtn.hidden = YES;
        _closeBtn.hidden = YES;
    }
    
    //刷新标题
    [_webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable value , NSError * _Nullable error) {
        self.navItem.title = value;
    }];
}

- (void)clickCloseBtn:(id)sender {
    
    NSArray *webArr = _webView.backForwardList.backList;
    if (webArr.count > 0) {
        [_webView goToBackForwardListItem:[webArr firstObject]];
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


/**
 显示/隐藏tabbar
 
 @param hidden 是否隐藏
 */
- (void)hidesTabBar:(BOOL)hidden {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width, view.frame.size.height)];
                view.hidden = YES;
                
            }else{
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
                view.hidden = NO;
            }
        }else{
            if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
                
                if (hidden) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                    
                    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(MainScreenHeight - 64 - 2));
                    }];
                    
                }else{
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 )];
                    
                    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(MainScreenHeight - 49 - 64 - 2));
                    }];
                }
            }
        }
    }
    [UIView commitAnimations];
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getMessage:"];
}


/**
 WKWebview清理缓存
 */
- (void)clearWebCache {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        
                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        
                                                        WKWebsiteDataTypeMemoryCache,
                                                        
                                                        //WKWebsiteDataTypeLocalStorage,
                                                        
                                                        //WKWebsiteDataTypeCookies,
                                                        
                                                        //WKWebsiteDataTypeSessionStorage,
                                                        
                                                        //WKWebsiteDataTypeIndexedDBDatabases,
                                                        
                                                        //WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        
        // All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        // Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        // Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            [self createWKWebViewAnd_PostTaskWithSession];
            
        }];
        
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
        if (errors) {
            NSLog(@"WKWebview清理失败：%@",errors);
        }
        
        [self createWKWebViewAnd_PostTaskWithSession];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"开始加载网页");
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    //防止progressView被网页挡住
    [self.navBar bringSubviewToFront:self.progressView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"加载完成");
    [self.webView stopLoading];
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
    //设置标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable value , NSError * _Nullable error) {
        self.navItem.title = value;
    }];
    
    NSArray *webArr = _webView.backForwardList.backList;
    
    if(webArr.count >= 1) {
        
        _backBtn.hidden = NO;
        [self hidesTabBar:YES];
        self.tabBarController.tabBar.hidden = YES;
        
    } else{
        
        _backBtn.hidden = YES;
        _closeBtn.hidden = YES;
        [self hidesTabBar:NO];
        self.tabBarController.tabBar.hidden = NO;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
    
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - WKUIDelegate

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"--------message:%@",message);
    
    if ([message.name isEqualToString:@"getMessage"]) {
        
        NSError *error;
        NSMutableDictionary *param = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&error];
        
        if (error){
            NSLog(@"getMessageError:%@",error);
        }
        
        NSString *fromStr = [param objectForKey:@"from"];
        
        //1.登录注册，保存用户userId + token
        if ([fromStr isEqualToString:@"login"] || [fromStr isEqualToString:@"register"]) {
            
            NSString *tokenStr = [param objectForKey:@"token"];
            NSString *userIdStr = [param objectForKey:@"userId"];
            
            User *user = [[User alloc] init];
            user.userId = userIdStr;
            user.loginToken = tokenStr;
            user.from = fromStr;
            [UserDefaultsUtil setUser:user];
            
            [self clearWebCache];
            _backBtn.hidden = YES;
            _closeBtn.hidden = YES;
        }
        
        //2.退出登录，删除本地user
        if ([fromStr isEqualToString:@"exit"]) {
            [UserDefaultsUtil clearUser];
            
            [self clearWebCache];
            _backBtn.hidden = YES;
            _closeBtn.hidden = YES;
        }
        
        //3.分享
        if ([fromStr isEqualToString:@"share"]) {
            
            //分享路径
            NSString *shareUrl = [param objectForKey:@"shareUrl"];
            
            //分享标题
            NSString *shareTitle = [param objectForKey:@"shareTitle"];
            
            //分享内容
            NSString *contentStr = [param objectForKey:@"contentStr"];
            
            //分享图片的url
            NSString *shareImgUrl = [param objectForKey:@"shareImgUrl"];
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]]];
            
            //调用分享方法
            [UMShareUtil shareUrl:shareUrl title:shareTitle content:contentStr image:shareImage controller:self];
        }
        
    }
}


@end
