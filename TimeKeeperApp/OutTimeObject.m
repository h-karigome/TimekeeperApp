//
//  OutTimeObject.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//
#import "OutTimeObject.h"

@interface OutTimeObject()



@end

@implementation OutTimeObject {
    
}

// 現在時刻(日付のみ)取得用(ほんとはメソッドまとめたい) // add 20171126
+(NSString *)getNowDateForNowTime {
    
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"dd(E)"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowDateString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowDateString);
    
    return nowDateString;
}

+(NSString *)getNowDate {
    
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"yyyy/MM/dd(E)"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowDateString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowDateString);
    
    return nowDateString;
}

// 月度別取得のため用
+(NSString *)getNowDateForUnitMonth {
    
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"dd"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowDateString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowDateString);
    
    return nowDateString;
}

+(NSString *)getNowMonthForTab {
    
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"yyyy年MM月"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowDateString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowDateString);
    
    return nowDateString;
}

/**
 * 翌月の退勤データを取得
 */
+(NSString *)getNextMonth: (NSDate *)monthDate{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy年MM月"];

    // 1年2ヶ月後を指定
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:1];
    [comps setMonth:1];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *nextMonth = [calendar dateByAddingComponents:comps toDate:monthDate options:0];
    
    NSLog(@"*****1ヵ月ご%@", [format stringFromDate:nextMonth]);
    NSString *nextMonthString = [format stringFromDate:nextMonth];
    
    return nextMonthString;
}

/**
 * 前月の退勤データを取得
 */
+(NSString *)getLastMonth: (NSDate *)monthDate{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy年MM月"];
    
    // 1ヵ月前を指定
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *nextMonth = [calendar dateByAddingComponents:comps toDate:monthDate options:0];
    
    NSString *beforeMonthString = [format stringFromDate:nextMonth];
    
    return beforeMonthString;
}

// 現在時刻を取得
+(NSString *)getNowTime {
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"HH:mm"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowTimeString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowTimeString);
    
    return nowTimeString;
}

// リスト画面に月表示用
+(NSString *)getNowDateForTab {
    //NSDateFormatterクラスを出力する。
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //Localeを指定。ここでは日本を設定。
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    //出力形式を文字列で指定する。
    [format setDateFormat:@"yyyy年MM月"];
    
    // 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
    NSString *nowTimeString = [format stringFromDate:[NSDate date]]; NSLog(@"%@",nowTimeString);
    
    return nowTimeString;
}

/**
 * 休憩時間を引いた登録日の勤務時間
 * @param inTime 出勤時間 
 * @param outTime 退勤時間
 * @return resultWorkingTime 勤務時間
 */
+(NSString *) getWorkingTime: (NSString *)inTime out:(NSString *)outTime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    //タイムゾーンの指定
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *inTimeDate = [formatter dateFromString:inTime];
    NSDate *outTimeDate = [formatter dateFromString:outTime];
    
    float time = [outTimeDate timeIntervalSinceDate:inTimeDate];
    // 時
    float workingTime  = (time / 3600);
    float breakTime1 = 8.5;
    float breakTime2 = 9.5;
    // 休憩時間を自動でひく
    if (workingTime < breakTime1) {
        // マイナス一時間(19:00までの勤務)
        workingTime = workingTime - 1.0;

    } else if (breakTime1 <= workingTime < breakTime2) {
        // マイナス一時間半(19:00以降の勤務)
        workingTime = workingTime - 1.5;
    } else {
        // マイナス二時間(22:00以降の勤務)
        workingTime = workingTime - 2.0;
    }
    
    NSString *resultWorkingTime = [NSString stringWithFormat:@"%.1f", workingTime];
    // FIXME: キリのいい数字の時も5.0みたいに返ってきてほしい
    return resultWorkingTime;
}

/**
 * 休憩時間を引いた各月の総勤務時間
 * @param workingTimeArray 勤務時間
 * @return sumWorkingTime 各月の総勤務時間
 */
+(NSString *) getSumWoringTime:(NSMutableArray *)workingTimeArray {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < workingTimeArray.count; i++) {
        NSInteger workingTimeInteger = [workingTimeArray[i] intValue];
        NSNumber *workingTimeNum = [NSNumber numberWithInteger:workingTimeInteger];
        [array addObject:workingTimeNum];
    }
    
    NSExpression *sumExpression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForConstantValue:array]]];
    id sumValue = [sumExpression expressionValueWithObject:nil context:nil];
    NSLog(@"合計値:%f", [sumValue floatValue]);
    NSString *sumWorkingTime = [NSString stringWithFormat:@"%@", sumValue];
 
    return sumWorkingTime;
}
// 月ごとに日付を取り出す
//+(NSString *)select {
//    
//}


//+(NSArray *)saveOutTimeArray: (NSString *)outTimeString {
//    NSMutableArray *outTimeArray = [NSMutableArray array];
//    [outTimeArray addObject: outTimeString];
//
//
//    [[NSUserDefaults standardUserDefaults] setObject:outTimeArray forKey:@"outTimeArray"];
//    NSArray *savedOutTimeArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"outTimeArray"];
//
//    return savedOutTimeArray;
//}



//-(void) setOutTimeArray:(NSArray *)outTimeArray {
//
//}


@end
