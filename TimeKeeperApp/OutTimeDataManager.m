//
//  OutTimeDataManager.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "OutTimeDataManager.h"
#import "OutTimeObject.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface OutTimeDataManager() {
    FMDatabase *_db;// ここ書くのなんだっけ。。。
}

@end

@implementation OutTimeDataManager
static NSString* const DB_FILE = @"/app.sqlite";
static NSString* const DB_NAME = @"tbr_work_info.db";


// テーブル作成
+(void)testCreateDBfile {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME]])
    {
    NSString *sql =
    @"CREATE TABLE  "
    "tbr_out_time  "
    "(id INTEGER PRIMARY KEY,  "
    "	out_date_info DATETIME,  "
    "	out_month DATETIME,  "
    "	out_date DATETIME,  "
    "	work_time DATETIME,  "
    "	in_time DATETIME,  "
    "	out_time DATETIME,  "
    "	delete_flg INTEGER DEFAULT 0) ";
    
    [db open]; //DB開く
    [db executeUpdate:sql]; //SQL実行
    
        if ([db hadError]) {
            [db close];
            return;
        }
    }
    [db close]; //DB閉じる
}
// テーブル削除
+(void)testDrop {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    
    NSString *sql = @"DROP TABLE tbr_out_time;";
    
    [db open]; //DB開く
    BOOL ret = [db executeUpdate:sql]; // execute 実行
    [db close]; //DB閉じる
    NSLog(@"テーブル削除：%@", ret ? @"YES" :@"NO");
}

// カラム追加
+(void)addColumnTest {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    
    NSString *sql =
    @"ALTER TABLE tbr_out_time ADD in_time TEXT";
    
    [db open]; //DB開く
    BOOL ret = [db executeUpdate:sql]; // execute 実行
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
    NSLog(@"カラム追加：%@", ret ? @"YES" :@"NO");
}

// 退勤日時の取り込み
+(BOOL)insertOutDateTime: (NSString *) outDate inTime:(NSString *)inTime outTime: (NSString *) outTime outMonth: (NSString *) outMonth outDateForTab: (NSString *)outDateForTab {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    NSString *workingTime = @"-";
    
    if (inTime) {
        workingTime = [OutTimeObject getWorkingTime:inTime out:outTime];
    }
    NSString *insert=
    [[NSString alloc] initWithFormat:
     @"INSERT INTO tbr_out_time(out_date_info, out_month, out_date, work_time, in_time, out_time, delete_flg) VALUES('%@','%@','%@','%@','%@','%@','0') ", outDate, outMonth, outDateForTab,workingTime, inTime, outTime];
    
        [db open];
        [db executeUpdate:insert];
    
        if ([db hadError]) {
            [db close];
            return NO;
        }
        [db close];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isSelectedTodayOutTime = YES;
    
    return YES;
}

// 退勤日時の上書き
+(BOOL)upDateOutDateTime: (NSString *)outDate inTime: (NSString *)inTime outTime: (NSString *) outTime outMonth: (NSString *)outMonth outDateForTab: (NSString *)outDateForTab {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
        NSString *workingTime = @"-";
        if (inTime) {
            workingTime = [OutTimeObject getWorkingTime:inTime out:outTime];
        }
        //insert文の作成
        NSString *update = [[NSString alloc] initWithFormat:
                            @"UPDATE "
                            "    tbr_out_time "
                            "SET "
                            "    out_time = '%@',"
                            "    work_time = '%@',"
                            "out_date = '%@'"
                            "WHERE "
                            "    out_date_info = '%@' "
                            "AND out_month = '%@' "
                            ,outTime, workingTime,outDateForTab, outDate, outMonth];
        
        [db open];
        [db executeUpdate:update];
        
        if ([db hadError]) {
            [db close];
            return NO;
        }
        
        [db close];
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isSelectedTodayOutTime = YES;
    
    return YES;
}

// 退勤日時の取得
+(NSMutableArray *)selectOutDateTime:(NSString *)monthString{
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    NSString *select = [[NSString alloc] initWithFormat:
                        @"SELECT "
                        "ot.out_date_info, "
                        "    ot.out_month, "
                        "    ot.out_date, "
                        "    ot.work_time, "
                        "    ot.in_time, "
                        "    ot.out_time "
                        "FROM "
                        "    tbr_out_time as ot "
                        "WHERE "
                        "    ot.out_month = '%@' "
                        "AND ot.delete_flg = '0' "
                        "order by "
                        "    ot.out_date_info ",monthString];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:select];
    NSMutableArray *array = [NSMutableArray array];
    
    while ([results next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[results stringForColumn:@"out_date_info"] forKey:@"out_date_info"];
        [dic setValue:[results stringForColumn:@"out_month"] forKey:@"out_month"];
        [dic setValue:[results stringForColumn:@"out_date"] forKey:@"out_date"];
        [dic setValue:[results stringForColumn:@"work_time"] forKey:@"work_time"];
        [dic setValue:[results stringForColumn:@"in_time"] forKey:@"in_time"];
        [dic setValue:[results stringForColumn:@"out_time"] forKey:@"out_time"];
        
        [array addObject:dic];
    }
    
    if ([db hadError]) {
        [db close];
        return nil;
    }
    [db close];
    
    return array;
}

// 上書きチェック
+(BOOL)checkOutDateTime:(NSString *)outDateInfo {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    NSString *sql = [[NSString alloc] initWithFormat:
                     @"SELECT out_date_info FROM tbr_out_time WHERE out_date_info = '%@' ", outDateInfo];
        
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    BOOL updateFlg = NO;
    while ([results next]) {
        [results stringForColumn:@"out_date_info"];
        updateFlg = YES;
    }
    
    if ([db hadError]) {
        [db close];
    }
    
    [db close];
    
    return updateFlg;
}

// 試しにカラムの追加
+(void)updateInTime:(NSString *)inTime outDateInfo:(NSString *)outDateInfo {
    
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];

    NSString *sql = [NSString stringWithFormat:
                     @"UPDATE tbr_out_time SET in_time_info = '%@' WHERE out_date_info = '%@'", inTime, outDateInfo];
    [db open];
    [db executeQuery:sql];
    
    if ([db hadError]) {
        [db close];
        return;
    }
    
    [db close];
}


/**
 行の削除
 @param outDateInfo 削除する日にち add 20180228
 @return 削除の有無
 */
+(BOOL) deleteOutDateTime: (NSString *)outDateInfo {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];

    NSString *update = [NSString stringWithFormat:
                        @"UPDATE "
                        "    tbr_out_time "
                        "SET "
                        "    delete_flg = '1' "
                        "WHERE "
                        "    out_date_info = '%@' ",outDateInfo];
    [db open];
//    FMResultSet *results = [db executeQuery:update]; この書き方じゃダメだったっぽい
    [db executeUpdate:update];
    
    if ([db hadError]) {
        [db close];
        return NO;
    }
    [db close];
    return YES;
}

// 休日分の日にちをインサート add 20180228
+(BOOL)insertDateForNotWorkday: (NSString *) outDate
         outMonth: (NSString *) outMonth
    outDateForTab: (NSString *)outDateForTab {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME]];
    
    NSString *insert=
    [[NSString alloc] initWithFormat:
     @"INSERT INTO tbr_out_time(out_date_info, out_month, out_date, work_time, in_time, out_time, delete_flg) VALUES('%@','%@','%@','%@','%@','%@','0') ", outDate, outMonth, outDateForTab, @"",@"", @""];
    
    [db open];
    [db executeUpdate:insert];
    
    if ([db hadError]) {
        [db close];
        return NO;
    }
    [db close];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isSelectedTodayOutTime = YES; // これ何
    
    return YES;
}

// add 20180131

+(NSMutableArray *)getInsertDateArray:(NSString *)lastInputDateStr
                         inputDateStr:(NSString *)inputDateStr
                          outMonthStr:(NSString *)outMonthStr
                           outDateStr:(NSString *)outDateStr {
    // NSDateFormatter を用意します。
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //Localeを指定。ここでは日本を設定。
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    // 変換用の書式を設定します。
    [formatter setDateFormat:@"yyyy/MM/dd(E)"];
    
    // NSDateFormatter を用意します。
    NSDateFormatter* formatterForDate = [[NSDateFormatter alloc] init];
    //Localeを指定。ここでは日本を設定。
    [formatterForDate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    // 変換用の書式を設定します。
    [formatterForDate setDateFormat:@"dd(E)"];
    
    // NSString を NSDate に変換します。
    NSDate* lastInputDate = [formatter dateFromString:lastInputDateStr];
    NSDate* inputDate = [formatter dateFromString:inputDateStr];
    NSLog(@"文字%@,%@", lastInputDateStr,inputDateStr);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    // 日付の差分を、日を基準にして取得する。
    NSDateComponents *def = [calendar components:NSCalendarUnitDay fromDate:lastInputDate toDate:inputDate options:0];
    
    NSDate *nextDate = [NSDate date];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0 ; i < [def day]; i++) {
        // １日プラス
        components.day = i+1;
        nextDate = [calendar dateByAddingComponents:components
                                             toDate:lastInputDate options:0];
        NSString *insertDateInfoStr  = [NSString stringWithFormat:@"%@", [formatter stringFromDate:nextDate]];
        NSLog(@"%@",insertDateInfoStr);
        
        NSString *insertDateStr = [NSString stringWithFormat:@"%@",[formatterForDate stringFromDate:nextDate]];
        
        if (![insertDateStr isEqualToString:inputDateStr]) { // add 20180220
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:insertDateInfoStr forKey:@"out_date_info"];
            [dic setObject:outMonthStr forKey:@"out_month"];
            [dic setObject:insertDateStr forKey:@"out_date"];
            [dic setObject:@"" forKey:@"out_time"]; // 一旦空文字入れとく
            [dic setObject:@"" forKey:@"in_time"];
            [dic setObject:@"" forKey:@"work_time"];
            
            [resultArray addObject:dic];
        }
    }
    // ログ出力
    NSLog(@"resultArray:%@",resultArray);
    
    return resultArray;
}


/**
 入力済みの情報で最新の日を取得する add 20180131

 @param monthStr 取得月
 @return 入力済みの情報で最新の日
 */
+(NSString *)selectLastInputDateStr:(NSString *)monthStr {
    
    NSMutableArray *arr = [OutTimeDataManager selectOutDateTime:monthStr];
    return [arr.lastObject objectForKey:@"out_date_info"];
}

@end
