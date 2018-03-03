//
//  TextDataNSObject.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/12.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "TextDataManager.h"
#import "FMDatabase.h"


@implementation TextDataManager

static NSString* const DB_FILE = @"/app.sqlite";
static NSString* const DB_NAME_WORK_INFO = @"tbr_work_info.db";

// テーブル作成
// TODOメモテーブル作成
+(void)testCreateTodoDBfile {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *sql =
    @"CREATE TABLE tbr_todo_info (input_date DATETIME,todo_text TEXT, important_point TEXT, action_text TEXT, deadline_date DATETIME, delete_flg INTEGER DEFAULT 0)";
    
    [db open]; //DB開く
    [db executeUpdate:sql]; //SQL実行
    
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
}

// 業務内容メモテーブル作成
+(void)testCreateInpuDataDBfile {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *sql =
    @"CREATE TABLE tbr_work_info (input_date DATETIME ,work_info TEXT, good_point TEXT, bad_point TEXT, start_time DATETIME DEFAULT '10:00', delete_flg INTEGER DEFAULT 0)";
    
    [db open]; //DB開く
    [db executeUpdate:sql]; //SQL実行
    
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
}

+(BOOL)insertTextData:(NSString *)inputDate goodPoint:(NSString *) goodPoint badPoint:(NSString *) badPoint tryPoint:(NSString *)tryPoint workInfo:(NSString *)workInfo startTime:(NSString *) startTime {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
        
        if (!startTime) {
            startTime = @"10:00";
        }
        
        //insert文の作成
        NSString *insert = [[NSString alloc] initWithFormat:
                            @"INSERT INTO tbr_work_info( "
                            "    input_date, "
                            "    good_point, "
                            "    bad_point, "
                            "    try_point, "
//                            "    work_category, "
                            "    work_info, "
                            "    start_time, "
                            "    delete_flg "
                            ") "
                            "VALUES( "
                            "    '%@', "
                            "    '%@', "
                            "    '%@', "
                            "    '%@', "
                            "    '%@', "
                            "    '%@', "
                            "    '0' "
                            ") ",inputDate, goodPoint, badPoint, tryPoint, workInfo, startTime];
        [db open];
        [db executeUpdate:insert];
        
        if ([db hadError]) {
            [db close];
            return NO;
        }
        
        [db close];
    }
    return YES;
}

/**
 * TODOリストの作成
 * @param inputDate 入力日
 * @param tryPoint1 try項目1
 * @param tryPoint2 try項目2
 * @param tryPoint3 try項目3
 */
+(BOOL)insertTodoData:(NSString *)inputDate tryPoint1:(NSString *)tryPoint1 tryPoint2:(NSString *) tryPoint2 tryPoint3:(NSString *)tryPoint3 {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];

        NSMutableArray *tryPointArray = [NSMutableArray array];
        [tryPointArray addObject:tryPoint1];
        [tryPointArray addObject:tryPoint2];
        [tryPointArray addObject:tryPoint3];

        for (int i = 0;i<tryPointArray.count ; i++) {
            //insert文の作成
            NSString *insert = [[NSString alloc] initWithFormat:
                                @"INSERT INTO tbr_todo_info( "
                                "    input_date, "
                                "    todo_text, "
                                "    important_point, "
                                "    action_text, "
                                "    deadline_date, "
                                "    delete_flg "
                                ") "
                                "VALUES( "
                                "    '%@', "
                                "    '%@', "
                                "    '%@', "
                                "    '%@', "
                                "    '%@', "
                                "    '0' "
                                ") ",inputDate, tryPointArray[i], nil, nil, nil, nil];
            NSLog(@"******%d*******",i);
            if (tryPointArray[i] &&
                ![@"" isEqualToString:[NSString stringWithFormat:@"%@",tryPointArray[i]]]) {
                NSLog(@"******キタコレ*****");
                [db open];
                [db executeUpdate:insert];
                
                if ([db hadError]) {
                    [db close];
                    return NO;
                }
                [db close];
            }

        }

    }
    return YES;
}
// カラム追加
+(void)addColumnTest { // add 20171116
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *sql =
    @"ALTER TABLE tbr_work_info ADD try_point TEXT";
    
    [db open]; //DB開く
    BOOL ret = [db executeUpdate:sql]; // execute 実行
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
    NSLog(@"カラム追加：%@", ret ? @"YES" :@"NO");
}

// 入力情報の取得
+(NSDictionary *)selectInputData: (NSString *)inputDate {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    NSString *select =
    [[NSString alloc] initWithFormat:
     @"SELECT "
     "wi.good_point, "
     "    wi.bad_point, "
     "    wi.try_point, "
     "    wi.work_info, "
     "    wi.start_time "
     "FROM "
     "    tbr_work_info as wi "
     "WHERE "
     "wi.input_date = '%@' AND "
     "wi.delete_flg = '0' "
     ,inputDate];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:select];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    while ([results next]) {
        [dic setValue:[results stringForColumn:@"good_point"] forKey:@"good_point"];
        [dic setValue:[results stringForColumn:@"bad_point"] forKey:@"bad_point"];
        [dic setValue:[results stringForColumn:@"try_point"] forKey:@"try_point"];
        [dic setValue:[results stringForColumn:@"work_category"] forKey:@"work_category"];
        [dic setValue:[results stringForColumn:@"work_info"] forKey:@"work_info"];
        [dic setValue:[results stringForColumn:@"start_time"] forKey:@"start_time"];
    }
    
    if ([db hadError]) {
        [db close];
        return nil;
    }
    
    [db close];
    
    return dic;
}

// テーブル削除
+(void)testDrop {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *sql = @"DROP TABLE tbr_work_info;";
    
    [db open]; //DB開く
    BOOL ret = [db executeUpdate:sql]; // execute 実行
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
    NSLog(@"テーブル削除：%@", ret ? @"YES" :@"NO");
}

// 入力情報の上書き
+(BOOL)upDateInputData:(NSString *) inputDate goodPoint:(NSString *) goodPoint badPoint:(NSString *) badPoint tryPoint:(NSString *)tryPoint workInfo:(NSString *)workInfo {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
        
        NSString *update = [[NSString alloc] initWithFormat:
                            @"UPDATE tbr_work_info SET good_point = '%@', bad_point = '%@', try_point = '%@', work_info = '%@' WHERE input_date = '%@'",
                            goodPoint, badPoint, tryPoint, workInfo, inputDate];

        [db open];
        [db executeUpdate:update];
        
        if ([db hadError]) {
            [db close];
            return NO;
        }
        
        [db close];
    }
    
    return YES;
}

/**
 * TODOリストの入力情報の取得
 * @param outMonth 取得月
 */
+(NSMutableArray *)selectTodoList:(NSString *)outMonth {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *select =
    [[NSString alloc] initWithFormat:
     @"SELECT "
     "td.input_date, "
     "td.todo_text "
     "from tbr_todo_info as td "
     "inner join tbr_out_time as ot "
     "on ot.out_date_info = td.input_date "
     "where ot.out_month = '%@'"
     ,outMonth];
    NSLog(@"*****%@", select);
    [db open];
    
    FMResultSet *results = [db executeQuery:select];
    NSMutableArray *array = [NSMutableArray array];
    while ([results next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[results stringForColumn:@"input_date"] forKey:@"input_date"];
        [dic setValue:[results stringForColumn:@"todo_text"] forKey:@"todo_text"];
        [array addObject:dic];
    }
    
    if ([db hadError]) {
        [db close];
        return nil;
    }
    
    [db close];
    
    return array;
}

// カラム追加
+(void)addColumnTodoFinish { // add 20170127
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
    
    NSString *sql =
    @"ALTER TABLE tbr_todo_info ADD todo_clear_flg TEXT";
    
    [db open]; //DB開く
    BOOL ret = [db executeUpdate:sql]; // execute 実行
    if ([db hadError]) {
        [db close];
        return;
    }
    [db close]; //DB閉じる
    NSLog(@"カラム追加：%@", ret ? @"YES" :@"NO");
}


/**
 TODOデータのアップデート add 20170127
 @param inputDate TODO設定日
 @param actionText したこと
 @param clearFlg TODOクリアフラグ
 @return <#return value description#>
 */
+(BOOL)updateTodoData:(NSString *)inputDate
           actionText:(NSString *)actionText
             clearFlg:(NSString *)clearFlg
             todoText:(NSString *)todoText {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];
        NSString *update = [[NSString alloc] initWithFormat:
                            @"UPDATE tbr_todo_info "
                            "SET action_text = '%@',"
                            " todo_clear_flg = '%@',"
                            " WHERE input_date = '%@'"
                            " AND todo_text = '%@'",
                            actionText, clearFlg, inputDate, todoText];
        NSLog(@"******キタコレ*****");
        [db open];
        [db executeUpdate:update];
        
        if ([db hadError]) {
            [db close];
            return NO;
        }
        [db close];
        
    }
    return YES;
}


/**
 入力済みかどうかチェック(DBにフラグ持つように最初からすればよかった。。。というか今からでもそうするべき)

 @param outMonthStr 取得する月 add 20180131
 @return 入力済み日の入った配列
 */
+(NSMutableArray *)checkInputtedTextData: (NSString *)outMonthStr {
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    if ([fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]])
    {
        FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_NAME_WORK_INFO]];

        NSString *select = [[NSString alloc] initWithFormat:
                            @"SELECT OT.out_date "
                             "FROM tbr_out_time AS OT "
                             "INNER JOIN tbr_work_info AS WI "
                             "ON WI.input_date = OT.out_date_info "
                             "WHERE OT.out_month = '%@'",outMonthStr];

        [db open];
        
        FMResultSet *results = [db executeQuery:select];
        while ([results next]) {
            [resultArr addObject:[results stringForColumn:@"out_date"]];
        }
        
        if ([db hadError]) {
            [db close];
            return nil;
        }
        [db close];
    }
    return resultArr;
}

@end
