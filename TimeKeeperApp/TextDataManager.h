//
//  TextDataManager.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/12.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextDataManager : NSObject
+(void)testCreateTodoDBfile; // TODOメモ
+(void)testCreateInpuDataDBfile; // 業務内容メモ
+(void)addColumnTest; // カラム追加
+(BOOL)insertTextData:(NSString *)inputDate goodPoint:(NSString *) goodPoint badPoint:(NSString *) badPoint tryPoint:(NSString *)tryPoint workInfo:(NSString *)workInfo startTime:(NSString *) startTime;// 取り込み
+(BOOL)insertTodoData:(NSString *)inputDate tryPoint1:(NSString *)tryPoint1 tryPoint2:(NSString *) tryPoint2 tryPoint3:(NSString *)tryPoint3; // TODOリストの作成
+(void)testDrop; // テーブル削除
+(NSMutableArray *)selectTodoList: (NSString *)outMonth; // TODOメモの取得
+(NSDictionary *)selectInputData: (NSString *)inputDate; // 入力情報の取得
+(BOOL)upDateInputData:(NSString *) inputDate goodPoint:(NSString *) goodPoint badPoint:(NSString *) badPoint tryPoint:(NSString *)tryPoint workInfo:(NSString *)workInfo; // 入力情報の上書き
+(void)addColumnTodoFinish; // add 20170127
+(BOOL)updateTodoData:(NSString *)inputDate
           actionText:(NSString *)actionText
             clearFlg:(NSString *)clearFlg
             todoText:(NSString *)todoText; // add 20170127
+(NSMutableArray *)checkInputtedTextData: (NSString *)outMonthStr; // 入力済みかどうか
@end
