//
//  Utility.m
//  Ixyb
//
//  Created by wang on 15/4/30.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "Utility.h"

@implementation Utility

@synthesize isGestureUnlock;
@synthesize isAddScoreFromHome;

static Utility *_utility = nil;

//获取实例
+ (Utility *)shareInstance {
    if (_utility) {
        return _utility;
    } else {
        _utility = [[Utility alloc] init];
        return _utility;
    }
}

+ (void)clearInstance {
    if (_utility) {
        _utility = nil;
    }
}
- (BOOL)isLogin {
    if ([UserDefaultsUtil getUser] && [UserDefaultsUtil getUser].loginToken.length != 0) {
        return YES;
    }
    return NO;
}
// 是否为数字字母下划线组成
+ (BOOL)isValidateCharStr:(NSString *)str {
    NSString *phoneRegex = @"[a-zA-Z0-9_]*";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:str];
}

/*邮箱验证*/
+ (BOOL)isValidateEmail:(NSString *)email {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证*/
+ (BOOL)isValidateMobile:(NSString *)mobile {
    //@"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$"
    NSString *phoneRegex = @"^1[345789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/*金额验证*/
+ (BOOL)isValidateNumber:(NSString *)number {
    //@"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$"
    NSString *numberRegex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

/*输入数值*/
+ (BOOL)isValidateinvestNum:(NSString *)money {
    //@"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$"
    NSString *moneyRegex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,8})?$";
    NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", moneyRegex];
    return [moneyTest evaluateWithObject:money];
}

/*定投金额验证*/
+ (BOOL)isValidateMoney:(NSString *)money {
    //@"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$"
    NSString *moneyRegex = @"^[1-9]\\d*000";
    NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", moneyRegex];
    return [moneyTest evaluateWithObject:money];
}

/*汉字 字母 数字*/
+ (BOOL)isValidateChinaStr:(NSString *)str {
    //NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{6,40}$";
    NSString *regex = @"^[\u4e00-\u9fa5]{6,40}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
//网址
+ (BOOL)isValidateWebsiteStr:(NSString *)urlWeb
{
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *webSite = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [webSite evaluateWithObject:urlWeb];
}

//财务计数（必须传入带有两位小数的字符串）
+ (NSString *)replaceTheNumberForNSNumberFormatter:(NSString *)numStr {
    
    numStr = [NSString stringWithFormat:@"%.2f",[numStr doubleValue]];
    
    NSString *currentStr = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSRange range = [numStr rangeOfString:@"."];
    if (range.length > 0) {
        NSArray *array = [numStr componentsSeparatedByString:@"."];

        NSString *pointStr = [array objectAtIndex:1];
        if ([pointStr isEqualToString:@"00"]) {
            currentStr = [array objectAtIndex:0]; //@"###,##0.##"]
            [formatter setPositiveFormat:@"###,##0.##"];
        } else {
            currentStr = numStr;
            [formatter setPositiveFormat:@"###,##0.00"];
        }
    } else {
        currentStr = numStr;
        [formatter setPositiveFormat:@"###,##0"];
    }

    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:[currentStr doubleValue]]];
    
    if ([numStr doubleValue] == 0) {
        
        string = @"0.00";
        return string;
    }
    
    return string;
}

//利率计数（必须传入带有两位小数的字符串）
+ (NSString *)rateReplaceTheNumberForNSNumberFormatter:(NSString *)numStr {
    numStr = [NSString stringWithFormat:@"%.2f",[numStr doubleValue]];
    NSMutableString *mutNum = [[NSMutableString alloc] initWithString:numStr];
    NSString *currentStr = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSRange range = [numStr rangeOfString:@"."];
    if (range.length > 0) {
        NSArray *array = [numStr componentsSeparatedByString:@"."];
        
        NSString *pointStr = [array objectAtIndex:1];
        if ([pointStr isEqualToString:@"00"]) {
            currentStr = [array objectAtIndex:0]; //@"###,##0.##"]
            [formatter setPositiveFormat:@"###,##0.##"];
        } else {
            if ([[pointStr substringFromIndex:1] isEqualToString:@"0"]) {
                [mutNum deleteCharactersInRange:NSMakeRange(mutNum.length - 1, 1)];
                currentStr = mutNum;
                [formatter setPositiveFormat:@"###,###.#"]; //小数位后面
            } else {
                currentStr = numStr;
                [formatter setPositiveFormat:@"###,##0.00"];
            }
        }
    } else {
        currentStr = numStr;
        [formatter setPositiveFormat:@"###,##0"];
    }
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:[currentStr doubleValue]]];
    
    return string;
}

/**
 四舍五入（解决数据传输途中问题：服务器给数据10.00，前端接收到却成了9.99）

 @param price 需要四舍五入的小数
 @param position 保留几位小数
 @return 字符串
 */
+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//金额格式化
//  金钱：0：0.00
//  整数：1,000
//  两位小数：1,000.55
//  一位小数：1,000.50
+ (NSString *)formatFinance:(id)number {
    NSString *numberStr = @"";
    if ([number isKindOfClass:[NSString class]]) {
        numberStr = number;
    } else if ([number isKindOfClass:[NSNumber class]]) {
        numberStr = [NSString stringWithFormat:@"%.2f", [number doubleValue]];
    } else if ([number respondsToSelector:@selector(doubleValue)]) {
        numberStr = [NSString stringWithFormat:@"%.2f", [number doubleValue]];
    } else {
        numberStr = 0;
    }
    return @"";
}

//利率格式化
//  利率: 0：0%
//  整数：11%
//  两位小数：10.55%
//  一位小数：10.5%
+ (NSString *)formatInterest:(id)number {
    return @"";
}

//计算高度
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    //boundingRectWithSize:options:attributes:context
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] } context:nil].size;
    //    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

//银行卡
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber {
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    } //@"^(\\d{15,30})"
    NSString *regex2 = @"^([0-9]{14,30})$";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}



/*银行卡格式化*/
+ (NSString *)firendlyCardString:(NSString *)cardStr {

    NSString *newString = @"";
    while (cardStr.length > 0) {
        NSString *subString = [cardStr substringToIndex:MIN(cardStr.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        cardStr = [cardStr substringFromIndex:MIN(cardStr.length, 4)];
    }
    return newString;
}

/*字符串前后加俩空格*/
+ (NSString *)frontAfterString:(NSString *)str
{
    NSString *newString = @"  ";
    newString = [newString stringByAppendingString:str];
    if (str.length) {
        newString = [newString stringByAppendingString:@"  "];
    }
    return newString;
}

// 银行卡号转正常号 － 去除4位间的空格
+ (NSString *)bankNumToNormalNum:(NSString *)bankStr {
    return [bankStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (BOOL)isValidatePassword:(NSString *)password {

    if (password.length >= 6 && password.length <= 20) {
        return YES;
    } else {
        return NO;
    }
}

// 是否为6位数的验证码
+ (BOOL)isSixVerifyCode:(NSString *)varifyCode {
   BOOL isPureInt = [StrUtil isPureInt:varifyCode];
    
    if (isPureInt && varifyCode.length == 6) {
        return YES;
    }
    
    return NO;
}

// 是否为4位数的验证码
+ (BOOL)isFourVerifyCode:(NSString *)varifyCode {
    BOOL isPureInt = [StrUtil isPureInt:varifyCode];
    
    if (isPureInt && varifyCode.length == 4) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidateEmailCode:(NSString *)EmailCode {

    if (EmailCode.length == 6) {
        return YES;
    } else {
        return NO;
    }
}

/*隐藏部分号码*/
+ (NSString *)thePhoneReplaceTheStr:(NSString *)phone {
    if (phone.length < 4) {
        return nil;
    }
    phone = [NSString stringWithFormat:@"%@****%@", [phone substringToIndex:3], [phone substringWithRange:NSMakeRange(phone.length - 4, 4)]];
    return phone;
}

+ (BOOL)isExistenceNetwork {
    BOOL isExistenceNetwork = false;
    AFAppDotNetAPIClient *r = [AFAppDotNetAPIClient sharedClient];
    isExistenceNetwork = r.reachabilityManager.reachable;
    return isExistenceNetwork;
}

//匹配小数位
+ (NSString *)stringrangeStr:(NSString *)str {

    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *pointStr = [array objectAtIndex:1];
    NSString *returnStr;

    if ([pointStr isEqualToString:@"00"]) {
        returnStr = [array objectAtIndex:0];
    } else {
        NSRange range;
        range.location = pointStr.length - 1;
        range.length = 1;
        NSString *lastString = [pointStr substringWithRange:range];
        if ([lastString isEqualToString:@"0"]) {
            returnStr = [str substringToIndex:str.length - 1];
        } else {
            returnStr = str;
        }
    }

    return returnStr;
}

+ (NSString *)sha1:(NSString *)input {

    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

+ (NSString *)withThesha:(NSDictionary *)inputDic {

    NSString *output;

    //是否有参数：没有参数（未登录、已登录）
    if (!inputDic || inputDic.allKeys.count == 0) {

        output = [NSString stringWithFormat:@"%@%@", SHA1KEY, SHA1SECRET];

    } else { //是否有参数：有参数（未登录、已登录）

        NSString *shaSecretStr;
        //已登录 且 有参数 且 参数包含userId
        if ([UserDefaultsUtil getUser].loginToken && [inputDic.allKeys containsObject:@"userId"]) {

            shaSecretStr = [NSString stringWithFormat:@"%@", [UserDefaultsUtil getUser].loginToken];

        } else { //未登录 或 已登录且参数不包含userId

            shaSecretStr = [NSString stringWithFormat:@"%@", SHA1SECRET];
        }

        //遍历取出keyValue并加密
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSArray *sortedArray = [[inputDic allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];

        NSMutableString *shaStr = [NSMutableString stringWithString:@""];
        for (int a = 0; a < sortedArray.count; a++) {

            NSString *appendStr = [NSString stringWithFormat:@"%@%@", [sortedArray objectAtIndex:a], [inputDic objectForKey:[sortedArray objectAtIndex:a]]];

            [shaStr appendString:[NSString stringWithFormat:@"%@", appendStr]];
        }

        output = [NSString stringWithFormat:@"%@%@%@", SHA1KEY, shaStr, shaSecretStr];
    }

    output = [self sha1:output];

    return output;
}

+ (NSString *)setUserAgent {

    UIDevice *device = [[UIDevice alloc] init];
    NSString *userAgent = [NSString stringWithFormat:@"XYB/%@/IOS/%@/%@/%@", [ToolUtil getAppVersion], device.systemVersion, device.model, device.identifierForVendor.UUIDString];

    return userAgent;
}

/**********字符串中搜索空格**************/
+ (BOOL)checkThenullStringBystring:(NSString *)str {

    NSString *nullStr = @" ";
    if ([str rangeOfString:nullStr].location != NSNotFound) {
        return NO;
    }
    return YES;
}

//去除空格
+ (NSString *)removeTheBlank:(NSString *)blankStr {
    return [blankStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//检测并去掉emoji
+ (NSString *)disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

+ (NSString *)checkPassword:(NSString *)password {
    NSString *errMsg = nil;
    if (password == nil || password.length <= 0) {
        errMsg = XYBString(@"string_enter_ps", @"请输入密码");
    } else if (!(password.length >= 6 && password.length <= 20)) {
        errMsg = XYBString(@"string_length_password", @"请输入6-20位字符的密码");
    } else if (![Utility checkThenullStringBystring:password]) {
        errMsg = XYBString(@"string_no_space", @"密码中不能包含空格");
    } else if (![Utility isValidateCharStr:password]) {
        errMsg = XYBString(@"string_role_password", @"密码由数字、英文字母或下划线组成");
    }
    return errMsg;
}

+ (NSString *)checkUserName:(NSString *)userName {
    NSString *errMsg = nil;
    if (userName == nil || userName.length <= 0) {
        errMsg = XYBString(@"string_enter_phone", @"请输入手机号");
    } else if (![Utility isValidateMobile:userName]) {
        errMsg = XYBString(@"string_input_correct_phone_number", @"请输入正确的手机号");
    }
    return errMsg;
}

+ (NSString *)checkVerifyCode:(NSString *)verifyCode {
    NSString *errMsg = nil;
    if (verifyCode == nil || verifyCode.length <= 0) {
        errMsg = XYBString(@"string_please_input_code", @"请输入验证码");
    }
    return errMsg;
}

+ (NSString *)checkEmail:(NSString *)email {
    NSString *errMsg = nil;
    if (email == nil || email.length <= 0) {
        errMsg = XYBString(@"string_email_empty_error", @"请输入邮箱");
    } else if (![Utility isValidateEmail:email]) {
        errMsg = XYBString(@"string_email_error", @"请输入正确的邮箱");
    }
    return errMsg;
}

+ (NSMutableAttributedString *)rateAttributedStr:(CGFloat)rate size:(CGFloat)sizeText sizeSymble:(CGFloat)sizeSymbel color:(UIColor *)color {
    NSString *actualRateStr = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", rate * 100]];
    NSMutableAttributedString *precentStr;
    if ([actualRateStr containsString:@"."]) {
        NSArray *strArr = [actualRateStr componentsSeparatedByString:@"."];
        if (strArr) {
            NSString *intStr = [strArr objectAtIndex:0];
            NSRange pointRange;
            pointRange.location = intStr.length;
            pointRange.length = 1;

            NSString *precentText = [NSString stringWithFormat:@"%@%%", actualRateStr];
            precentStr = [[NSMutableAttributedString alloc] initWithString:precentText];
            [precentStr addAttributes:@{ NSForegroundColorAttributeName : color,
                                         NSFontAttributeName : [UIFont systemFontOfSize:sizeText] }
                                range:NSMakeRange(0, [intStr length])];
            [precentStr addAttributes:@{ NSForegroundColorAttributeName : color,
                                         NSFontAttributeName : [UIFont systemFontOfSize:sizeSymbel] }
                                range:NSMakeRange([intStr length], precentStr.length - intStr.length)];
        }

    } else {
        NSString *precentText = [NSString stringWithFormat:@"%@%%", actualRateStr];
        precentStr = [[NSMutableAttributedString alloc] initWithString:precentText];
        [precentStr addAttributes:@{ NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : [UIFont systemFontOfSize:sizeText] }
                            range:NSMakeRange(0, [precentText length] - 1)];
        [precentStr addAttributes:@{ NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : [UIFont systemFontOfSize:sizeSymbel] }
                            range:NSMakeRange([precentText length] - 1, 1)];
    }
    return precentStr;
}

+ (NSMutableAttributedString *)multAttributedString:(NSArray *)attrArray {

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in attrArray) {
        NSString *str = [dic objectForKey:@"kStr"];
        UIFont *font = [dic objectForKey:@"kFont"];
        UIColor *color = [dic objectForKey:@"kColor"];
        NSMutableAttributedString *subAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [subAttrStr addAttributes:@{ NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font }
                            range:NSMakeRange(0, str.length)];
        [attrString appendAttributedString:subAttrStr];
    }

    return attrString;

    //    NSString *settingJson = [[NSBundle mainBundle]pathForResource:@"setting" ofType:@"json"];
    //
    //    NSMutableArray *sectionMutableArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:settingJson] options:NSJSONReadingMutableContainers error:nil];
    //
    //    for (NSMutableArray *mySetionMutableArray in sectionMutableArray)
    //    {
    //        MySection *mySection = [[MySection alloc]init];
    //
    //        for (NSMutableDictionary *myRowMutableDictionary in mySetionMutableArray)
    //        {
    //            MyRow *myRow = [[MyRow alloc]init];
    //            myRow.rowImageName = [myRowMutableDictionary objectForKey:@"rowImageName"];
    //            myRow.rowSelectedImageName = [myRowMutableDictionary objectForKey:@"rowSelectedImageName"];
    //            myRow.rowName = [myRowMutableDictionary objectForKey:@"rowName"];
    //            myRow.rowDetail = [myRowMutableDictionary objectForKey:@"rowDetail"];
    //            [mySection.myRowMutableArray addObject:myRow];
    //        }
    //        [self.sectionArray addObject:mySection];
    //    }
}

+ (NSMutableAttributedString *)processTheDecimalTheRate:(CGFloat)rate size:(CGFloat)sizeText sizeSymble:(CGFloat)sizeSymbel color:(UIColor *)color {
    NSString *str = [Utility stringrangeStr:[NSString stringWithFormat:@"%.2f", rate * 100]];
    NSArray *array = [str componentsSeparatedByString:@"."];
    if (array.count < 1) {
        return nil;
    }
    NSString *intStr = [array objectAtIndex:0];

    NSString *pointStr;

    NSString *returnStr;
    if (array.count < 2) {
        pointStr = @"0";
    } else {
        pointStr = [array objectAtIndex:1];
    }
    if ([pointStr intValue] == 0) {
        returnStr = [array objectAtIndex:0];
    } else {

        NSRange range;
        range.location = pointStr.length - 1;
        range.length = 1;
        NSString *lastString = [pointStr substringWithRange:range];
        if ([lastString isEqualToString:@"0"]) {
            returnStr = [str substringToIndex:str.length - 1];
        } else {
            returnStr = str;
        }
    }
    NSMutableAttributedString *rateStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", returnStr, @"%"]];
    [rateStr addAttributes:@{ NSForegroundColorAttributeName : color,
                              NSFontAttributeName : [UIFont systemFontOfSize:sizeText] }
                     range:NSMakeRange(0, intStr.length)];
    [rateStr addAttributes:@{ NSForegroundColorAttributeName : color,
                              NSFontAttributeName : [UIFont systemFontOfSize:sizeSymbel] }
                     range:NSMakeRange(intStr.length, rateStr.length - intStr.length)];
    return rateStr;
}

+ (void)modifyLabel:(UILabel *)label color:(UIColor *)color font:(UIFont *)font space:(CGFloat)space {
    if (label == nil) {
        return;
    }
    NSString *text = label.text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space; // 字体的行间距
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSForegroundColorAttributeName : color,
        NSFontAttributeName : font
    };

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    label.attributedText = attrStr;
}

+ (NSURL *)emailWebAddress:(NSString *)email {
    if (email == nil || email.length <= 0) {
        return [NSURL URLWithString:@""];
    }

    NSDictionary *addDict = @{ @"qq.com" : @"https://mail.qq.com",
                               @"gmail.com" : @"https://mail.google.com", //不行
                               @"sina.com" : @"https://mail.sina.com.cn",
                               @"163.com" : @"https://mail.163.com",
                               @"126.com" : @"https://mail.126.com",
                               @"yeah.net" : @"https://www.yeah.net/", //不行
                               @"sohu.com" : @"https://mail.sohu.com/",
                               @"tom.com" : @"https://mail.tom.com/",
                               @"139.com" : @"https://mail.10086.cn/",
                               @"hotmail.com" : @"https://www.hotmail.com",
                               @"live.com" : @"https://login.live.com/",
                               @"live.cn" : @"https://login.live.cn/",            //不行
                               @"live.com.cn" : @"https://login.live.com.cn",     //不行
                               @"189.com" : @"https://webmail16.189.cn/webmail/", //不行
                               @"yahoo.com.cn" : @"https://mail.cn.yahoo.com/",   //不行
                               @"yahoo.cn" : @"https://mail.cn.yahoo.com/",       //不行
                               @"eyou.com" : @"https://www.eyou.com/",            //不行
                               @"21cn.com" : @"https://mail.21cn.com/",           //不行
                               @"188.com" : @"https://www.188.com/",              //不行
                               @"foxmail.com" : @"https://www.foxmail.com",
                               @"outlook.com" : @"https://www.outlook.com"
    };

    NSRange r = [email rangeOfString:@"@"];
    NSString *emailKey = @"email";
    if (r.length > 0) {
        emailKey = [email substringFromIndex:(r.location + 1)];
    }

    NSString *v = [addDict objectForKey:emailKey];
    if (v == nil) {
        v = [NSString stringWithFormat:@"https://%@", emailKey];
    }

    return [NSURL URLWithString:v];
}

+ (NSString *)dateFormate:(NSDate *)date formate:(NSString *)fmt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    return [dateFormatter stringFromDate:date];
}

/**
 *    设置label 字体不同颜色
 *
 */
+ (NSMutableAttributedString *)getAttributedstring:(NSString *)haxStr tailStr:(NSString *)tailStr labColor:(id)value{
    NSString *allStr = [haxStr stringByAppendingString:tailStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSRange range = [allStr rangeOfString:haxStr];

    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:value
                          range:range];

    return AttributedStr;
}

+ (NSDictionary *)findBankInfoByType:(int)type {
    //    bankTypeNumber = [[resultDic objectForKey:@"bankType"] intValue];
    NSString *bankJson = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"json"];
    NSArray *bankArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:bankJson] options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dic in bankArr) {
        int bankType = [[dic objectForKey:@"bankType"] intValue];
        if (bankType == type) {
            return dic;
        }
    }
    return nil;
}

+ (NSString *)getUserAgent {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *userAgent = [NSString stringWithFormat:@"XYB/%@/IOS/%@/%@/%@", [ToolUtil getAppVersion], device.systemVersion, device.model, device.identifierForVendor.UUIDString];
    return userAgent;
}

@end
