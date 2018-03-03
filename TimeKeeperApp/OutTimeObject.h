//
//  OutTimeObject.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutTimeObject : NSObject
+(NSString *)getNowDate;
+(NSString *)getNowDateForNowTime; // 現在時刻の日付のみ取得用
+(NSString *)getNowTime;
+(NSString *)getNowMonthForTab; // たぶ？用に年月を取得
+(NSString *)getNowDateForTab; // たぶ？用に日曜日を取得
+(NSString *)getNowDateForUnitMonth; // 月度別取得用
+(NSString *) getWorkingTime: (NSString *)inTime out:(NSString *)outTime;// 各日の総勤務時間の算出

+(void)lastDayOfMonth;
+(void)lastDayOfMonth2;
+(NSString *)getNextMonth: (NSDate *)monthDate; // 1ヵ月後のデータ取得
+(NSString *)getLastMonth: (NSDate *)monthDate; // 前月のデータ取得
+(NSString *) getSumWoringTime:(NSMutableArray *)workingTimeArray; // 各月の総勤務時間
@property NSArray *savedOutDateArray;
@property NSArray *savedOutTimeArray;

@end
