//
//  OutTimeDataManager.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface OutTimeDataManager : NSObject

//+(void)insertOutDateTime: (NSString *) outDate outTime: (NSString *) outTime outMonth: (NSString *) outMonth outDateForTab: (NSString *)outDateForTab; //退勤日時の取得
+(BOOL)insertOutDateTime: (NSString *) outDate inTime:(NSString *)inTime outTime: (NSString *) outTime outMonth: (NSString *) outMonth outDateForTab: (NSString *)outDateForTab; //退勤日時の取得
+(BOOL)upDateOutDateTime: (NSString *)outDate inTime: (NSString *)inTime outTime: (NSString *) outTime outMonth: (NSString *)outMonth outDateForTab: (NSString *)outDateForTab; // 退勤日時の上書き
+(BOOL)checkOutDateTime:(NSString *)outDateInfo; // 上書きチェック
+(void)testCreateDBfile;
+(BOOL)createDb;
+(void) testDrop;

+(NSMutableArray *)selectOutDateTime:(NSString *)monthString;
+(void)addColumnTest; // カラムの追加
//+(void)updateColumnTest; // カラムの値の更新
+(void)updateInTime:(NSString *)inTime outDateInfo:(NSString *)outDateInfo; // 出勤時間の更新

// 休日分の日にちをインサート
+(BOOL)insertDateForNotWorkday: (NSString *) outDate
                      outMonth: (NSString *) outMonth
                 outDateForTab: (NSString *)outDateForTab;
// add 20180131
+(NSMutableArray *)getInsertDateArray:(NSString *)lastInputDateStr
           inputDateStr:(NSString *)inputDateStr
            outMonthStr:(NSString *)outMonthStr
             outDateStr:(NSString *)outDateStr;
// 20180131
+(NSString *)selectLastInputDateStr:(NSString *)monthStr;

// 20180220
+(BOOL) deleteOutDateTime: (NSString *)outDateInfo;
@end
