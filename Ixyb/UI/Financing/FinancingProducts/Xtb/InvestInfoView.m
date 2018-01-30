//
//  InvestInfoView.m
//  Ixyb
//
//  Created by dengjian on 11/23/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "HUD.h"
#import "XtbZqzrInvestRecordResponseModel.h"
#import "InvestInfoView.h"
#import "MJExtension.h"
#import "NoDataView.h"
#import "RecordInfo.h"
#import "Utility.h"
#import "WebService.h"
#import "XYTableView.h"
#define ROW_HEIGHT 60.0f

@interface InvestInfoView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) XYTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) NSString *fromTagStr;
@property (nonatomic, copy) NSString *requestIdStr;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGSize intrinsicContentSize;

@end

@implementation InvestInfoView

- (CGSize)intrinsicContentSize {
    if (self.dataArray && self.dataArray.count > 0) {
        return CGSizeMake(MainScreenWidth, self.dataArray.count * ROW_HEIGHT);
    } else {
        return CGSizeMake(MainScreenWidth, ROW_HEIGHT * 4);
    }
}

- (CGFloat)height {
    _height = [self.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : TEXT_FONT_12 } context:nil].size.height;

    return _height;
}

- (NSString *)text {
    return XYBString(@"str_financing_XYBPrinciple", @"*信用宝将以客观,公正的原则,最大程度地核实借入者的真实性,但不保证审核信息的100%真实.如果借入者长期逾期,其提供的信息将被公布.");
}

- (id)init {
    if (self = [super init]) {
        self.dataArray = [NSMutableArray arrayWithCapacity:15];

        self.tableView = [[XYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisVertical];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(self.intrinsicContentSize.height));
        }];

        self.noDataView = [[NoDataView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.noDataView];

        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self.tableView.mas_bottom); //需要将底部的文字显示出来就需要将noDataView单独作为一部分视图来处理；如果不显示就将noDataView的约束和self一致即可
        }];

        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = COLOR_BG;
        [self addSubview:self.bottomView];

        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.tableView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }];

        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = TEXT_FONT_12;
        tipLabel.textColor = COLOR_MAIN_GREY;
        tipLabel.numberOfLines = 0;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
        [str addAttributes:@{ NSForegroundColorAttributeName : COLOR_COMMON_RED } range:NSMakeRange(0, 1)];
        tipLabel.attributedText = str;
        [self.bottomView addSubview:tipLabel];

        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView.mas_left).offset(Margin_Length);
            make.right.equalTo(self.bottomView.mas_right).offset(-Margin_Length);
            make.centerY.equalTo(self.bottomView.mas_centerY);
            make.height.equalTo(@(self.height + 30));
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(0);
        }];

        UIView *splitBottom2View = [[UIView alloc] init];
        splitBottom2View.backgroundColor = COLOR_LINE;
        [self.bottomView addSubview:splitBottom2View];

        [splitBottom2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.height.equalTo(@(Line_Height));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }

    return self;
}

- (void)setViewData:(NSDictionary *)viewData {
    _viewData = viewData;
    if (viewData.count > 0) {
        self.fromTagStr = [viewData objectForKey:@"fromTagStr"];
        self.requestIdStr = [viewData objectForKey:@"requestIdStr"];
        [self updateInvestRecord];
    }
}

- (void)setBidList:(NSArray *)bidList
{
    if (bidList.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:bidList];
        
        [self.tableView reloadData];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(self.intrinsicContentSize.height));
        }];
        
        if (self.dataArray.count > 0) {
            self.noDataView.hidden = YES;
            self.bottomView.hidden = NO;
        } else {
            self.noDataView.hidden = NO;
            self.bottomView.hidden = NO; //测试要求将下方的提醒文字显示出来
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BidsModel *record = self.dataArray[indexPath.row];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_16;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = record.username;
    [cell.contentView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@Margin_Length);
    }];

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = record.bidDate;
    timeLabel.font = TEXT_FONT_14;
    timeLabel.textColor = COLOR_AUXILIARY_GREY;
    [cell.contentView addSubview:timeLabel];

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
    }];

    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [record.availableAmount doubleValue]]];
    amountLabel.font = TEXT_FONT_16;
    amountLabel.textColor = COLOR_MAIN_GREY;
    amountLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:amountLabel];

    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Length);
        make.centerY.equalTo(@0);
    }];

    [XYCellLine initWithBottomLine_3_AtSuperView:cell.contentView];
    return cell;
}

//理论上不应该这样拉取数据,但是为了封装,暂时如此
- (void)updateInvestRecord {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([self.fromTagStr isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
        [param setObject:self.requestIdStr forKey:@"assignId"];
    } else {
        [param setObject:self.requestIdStr forKey:@"bidRequestId"];
    }

    [self requestXtbOrZqzrInvestBidWebServiceWithParam:param];
}

#pragma mark - 信投保和债权转让的投标记录接口

- (void)requestXtbOrZqzrInvestBidWebServiceWithParam:(NSDictionary *)param {
    NSString *UrlStr = XtbInvestRecordURL;
    if ([self.fromTagStr isEqualToString:XYBString(@"str_common_zqzr", @"债权转让")]) {
        UrlStr = ZqzrInvestRecordURL;
    }
    NSString *requestURL = [RequestURL getRequestURL:UrlStr param:param];
    [WebService postRequest:requestURL param:param JSONModelClass:[XtbZqzrInvestRecordResponseModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {

        XtbZqzrInvestRecordResponseModel *responseModel = responseObject;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:responseModel.bids];

        [self.tableView reloadData];

        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(self.intrinsicContentSize.height));
        }];

        if (self.dataArray.count > 0) {
            self.noDataView.hidden = YES;
            self.bottomView.hidden = NO;
        } else {
            self.noDataView.hidden = NO;
            self.bottomView.hidden = NO; //测试要求将下方的提醒文字显示出来
        }

    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

@end
