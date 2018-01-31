//
//  ChargeFailureViewController.m
//  Ixyb
//
//  Created by dengjian on 2017/2/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ChargeFailureViewController.h"
#import "Utility.h"

@interface ChargeFailureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) XYScrollView *mainScroll;
@property (nonatomic, strong) UICollectionView *collectionView;   //限额表
@property (nonatomic, strong) NSMutableArray *dataSource;         //collectionView的数据源

@end

@implementation ChargeFailureViewController

-(id)initWithObject:(NSArray *)array {
    self = [super init];
    if (self) {
       _dataSource = [[NSMutableArray alloc] initWithObjects:XYBString(@"str_bankName", @"银行名称"),XYBString(@"str_singleLimitAmount", @"单笔限额"),XYBString(@"str_dayLimitAmount", @"单日限额"),XYBString(@"str_monthLimitAmount", @"单月限额"), nil];
        [_dataSource addObjectsFromArray:array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createMainUI];
    [self createCollectionView];
    [self createInternetErrorView];
}

/*
 * 导航栏创建
 */
- (void)setNav {
    self.navItem.title = XYBString(@"str_chargeDetail",@"结果详情");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitle:XYBString(@"str_common_complete", @"完成") forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

/*
 *  支付失败的视图创建
 */
- (void)createMainUI {
    
    //1.创建_mainScroll，将所有子视图均放在_mainScroll之上
    _mainScroll = [[XYScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_mainScroll];
    
    [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //2.图片 + 交易失败
    UIImageView *failureImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tradeFailuer"]];
    [_mainScroll addSubview:failureImgView];
    
    [failureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mainScroll.mas_centerX);
        make.top.equalTo(_mainScroll.mas_top).offset(25);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = XYBString(@"str_chargeFailuer", @"交易失败");
    [_mainScroll addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mainScroll.mas_centerX);
        make.top.equalTo(failureImgView.mas_bottom).offset(7);
    }];
    
    //3.交易失败下的虚线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = COLOR_LINE;
    [_mainScroll addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll.mas_left).offset(Margin_Length);
        make.width.equalTo(@(MainScreenWidth - 30));
        make.top.equalTo(titleLab.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@(Line_Height));
    }];
    
    //4.可能失败的原因
    UILabel *possReasonLab = [[UILabel alloc] initWithFrame:CGRectZero];
    possReasonLab.font = TEXT_FONT_14;
    possReasonLab.textColor = COLOR_MAIN_GREY;
    possReasonLab.text = XYBString(@"str_possibleReason", @"可能的原因：");
    [_mainScroll addSubview:possReasonLab];
    
    [possReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(lineView.mas_bottom).offset(17);
        make.right.equalTo(_mainScroll.mas_right).offset(-Margin_Length);
//        make.height.equalTo(@(Margin_Length));
    }];
    
    UILabel *reasonLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    reasonLab1.font = TEXT_FONT_14;
    reasonLab1.textColor = COLOR_AUXILIARY_GREY;
    reasonLab1.text = XYBString(@"str_chargeFailureOne", @"1.银行卡内余额不足或超出银行卡限额");
    reasonLab1.tag = 1000;
    [_mainScroll addSubview:reasonLab1];
    
    [reasonLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(possReasonLab.mas_left);
        make.top.equalTo(possReasonLab.mas_bottom).offset(8);
    }];
}

/*
 * 创建银行卡限额表格
 */
-(void)createCollectionView {
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake((MainScreenWidth - 30 - 5*Line_Height)/4, 31);
    layOut.minimumLineSpacing = Line_Height;
    layOut.minimumInteritemSpacing = Line_Height;
    layOut.sectionInset = UIEdgeInsetsMake(Line_Height, Line_Height, Line_Height, Line_Height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = COLOR_LINE;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"identifer"];
    [_mainScroll addSubview:_collectionView];
    
    UILabel *reasonLab1 = (UILabel *)[self.view viewWithTag:1000];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(reasonLab1.mas_bottom).offset(17);
        make.height.equalTo(@(63.5));
        make.width.equalTo(@(MainScreenWidth - 30));
    }];
}

//创建网络错误view
- (void)createInternetErrorView {
    
    UILabel *reasonLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *str = XYBString(@"str_chargeFailureTwo", @"2.网络错误(建议寻找更好的网路环境 进行调试)") ;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:TEXT_FONT_14 range:NSMakeRange(0, 6)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_AUXILIARY_GREY range:NSMakeRange(0, str.length)];
    [attributedStr addAttribute:NSFontAttributeName value:TEXT_FONT_10 range:NSMakeRange(6, str.length - 6)];
    reasonLab2.attributedText = attributedStr;
    [_mainScroll addSubview:reasonLab2];
    
    [reasonLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScroll.mas_left).offset(Margin_Length);
        make.top.equalTo(_collectionView.mas_bottom).offset(18);
        make.bottom.equalTo(_mainScroll.mas_bottom);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifer" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor = COLOR_COMMON_WHITE;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = TEXT_FONT_12;
    titleLab.textColor = COLOR_AUXILIARY_GREY;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [_dataSource objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.centerY.equalTo(cell.mas_centerY);
    }];
    
    return cell;
}



/*
 *  完成 点击事件
 */
- (void)clickTheRightBtn:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
