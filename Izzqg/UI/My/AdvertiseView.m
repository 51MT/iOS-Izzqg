//
//  AdvertiseView.m
//

#import "AdvertiseView.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"

@interface AdvertiseView()

@property (nonatomic,strong) UIImageView *adView;
@property (nonatomic,strong) UIImageView * imageBttom;
@property (nonatomic,strong) UIButton *countBtn;
@property (nonatomic,strong) UILabel  *skipLab;
@property (nonatomic,strong) NSTimer *countTimer;
@property (nonatomic,assign)int count;

@end
//广告时间
static int const showtime = 3;

@implementation AdvertiseView
-(NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        
    }
    return _countTimer;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self setUI];
    }
    return self;
}

-(void)setUI
{
    // 1.广告图片
    _adView = [[UIImageView alloc] init];
    _adView.userInteractionEnabled = YES;
    _adView.contentMode = UIViewContentModeScaleAspectFill;
    _adView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
    [_adView addGestureRecognizer:tap];
    [self addSubview:_adView];
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(@(-120));
    }];
    
    // 2.跳过按钮
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    _countBtn = [[UIButton alloc] init];
    [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
    _countBtn.layer.borderWidth = Border_Width;
    _countBtn.layer.borderColor = COLOR_LINE.CGColor;
    _countBtn.backgroundColor = COLOR_COMMON_WHITE;
    _countBtn.clipsToBounds = YES;
    _countBtn.layer.cornerRadius = Corner_Radius;
    [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_countBtn];
    [_countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(MainScreenWidth - btnW - 24));
        make.top.equalTo(@(btnH));
        make.width.equalTo(@(btnW));
        make.height.equalTo(@(btnH));
    }];
    
    _skipLab = [[UILabel alloc] init];
    _skipLab.textColor = COLOR_LIGHT_GREEN;
    _skipLab.font = TEXT_FONT_14;
    _skipLab.attributedText = [self getAttributedstring:XYBString(@"string_Skip", @"跳过") tailStr:@" 3"];
    [self addSubview:_skipLab];
    
    [_skipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_countBtn.mas_centerX);
        make.centerY.equalTo(_countBtn.mas_centerY);
    }];
    
    //3. 底部图片
    UIImage *image = [UIImage imageNamed:@"WelcomeIcon"];
                      
    _imageBttom = [[UIImageView alloc] init];
    _imageBttom.image = image;
    [self addSubview:_imageBttom];
    [_imageBttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@(image.size.height));
    }];
    
}


- (NSMutableAttributedString *)getAttributedstring:(NSString *)haxStr tailStr:(NSString *)tailStr {
    NSString *allStr = [haxStr stringByAppendingString:tailStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSRange range = [allStr rangeOfString:haxStr];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:COLOR_MAIN_GREY
     
                          range:range];
    
    return AttributedStr;
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}
- (void)pushToAd{
    
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}
- (void)countDown
{
    _count --;
    NSString *skipCount = [NSString stringWithFormat:@" %d", _count];
    _skipLab.attributedText = [self getAttributedstring:XYBString(@"string_Skip", @"跳过") tailStr:skipCount];
    
    if (_count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self dismiss];
    }
}
- (void)show
{
    // 倒计时方法1：GCD
        [self startCoundown];
    
    // 倒计时方法2：定时器
//    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
// 定时器倒计时
- (void)startTimer
{
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
// GCD倒计时
- (void)startCoundown
{
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _skipLab.textColor = COLOR_LIGHT_GREEN;
                NSString *skipTime = [NSString stringWithFormat:@" %d", timeout];
                _skipLab.attributedText = [self getAttributedstring:XYBString(@"string_Skip", @"跳过") tailStr:skipTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

// 移除广告页面
- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
    if (_blcok) {
        _blcok();
    }
}

@end
