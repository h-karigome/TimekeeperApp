//
//  TodoListViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/11/26.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "TodoListViewController.h"
#import "TodoListTableViewCell.h"
#import "TextDataManager.h"
#import "OutTimeObject.h"
#import "DotaskForTodoViewController.h"

@interface TodoListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (copy) NSString *sendInputDateStr; // 次の画面に送る日付
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastMonthBarButtonItem;// 20170131
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextMonthBarButtonItem;// 20170131
@property (copy) NSString *displayMonthStr; // 表示する月

@end

@implementation TodoListViewController{
    NSMutableArray *todoList; // 表示に使うTODOリスト
    NSMutableArray *todoArray; // 取得したTODOリストと日付
    NSMutableArray *todoTextArray; // FIXME: 1210即興で追加
    NSMutableArray *inputDateArray; // 入力日付
    NSMutableArray *displayInputDateArray; // 表示する入力日付
    NSMutableDictionary *todoDic; // 表示する辞書型
    NSMutableDictionary *sectionCountDic; // セクション数
}

- (void)viewDidLoad {
    NSLog(@"*******viewDidLoad");
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"TodoListTableViewCell" bundle:nil];
    [self.todoTableView registerNib:nib forCellReuseIdentifier:@"TodoListTableViewCell"];

    _todoTableView.delegate = self;
    _todoTableView.dataSource = self;

    _displayMonthStr = [OutTimeObject getNowMonthForTab];
    self.navigationItem.title = _displayMonthStr;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"*******viewWillAppear");
    
    [self getTodoListData];
}

/**
 TODOリストデータの取得
 */
-(void)getTodoListData {
    // TODOリストの取得
    todoArray = [self getTodoArray:_displayMonthStr];
    
    todoTextArray = [NSMutableArray array];
    inputDateArray = [NSMutableArray array];
    for (int i= 0; i< todoArray.count; i++) {
        NSString * todoStr = [todoArray[i] objectForKey:@"todo_text"];
        NSString *inputDateStr = [todoArray[i] objectForKey:@"input_date"];
        [todoTextArray addObject:todoStr];
        [inputDateArray addObject:inputDateStr];
    }
    
    // TODOリストのセクション(日付)の取得
    [self getDateForSection];
    
    todoList = [NSMutableArray array];
    for (int i = 0; i < displayInputDateArray.count; i++) {
        todoDic = [NSMutableDictionary dictionary];
        NSMutableArray *todoDataArray = [NSMutableArray array];
        for (int r = 0; r < todoArray.count; r++) {
            if ([displayInputDateArray[i] isEqualToString:inputDateArray[r]]) {
                [todoDataArray addObject:todoTextArray[r]];
            }
        }
        [todoDic setObject:todoDataArray forKey:displayInputDateArray[i]];
        [todoList addObject:todoDic];
    }
}

/**
 * DBからTODOリストを取得
 * @param monthStr 取得月
 */
-(NSMutableArray *)getTodoArray:(NSString *)monthStr{
    
   return [TextDataManager selectTodoList:monthStr];
}

/**
 セクション表示用の日付を取得
 */
-(void)getDateForSection {
    displayInputDateArray = [NSMutableArray array];
    sectionCountDic = [NSMutableDictionary dictionary];
    NSInteger sectionCount = 0;
    for (int i = 0; i < inputDateArray.count; i++) {
        if (i == 0) {
            [displayInputDateArray addObject:inputDateArray[i]];
            //セクション数を+1
            sectionCount++;
            // 登録日付をキーにして辞書型にセット
            [sectionCountDic setObject:[NSString stringWithFormat:@"%ld",(long)sectionCount] forKey:inputDateArray[i]];
            // setObjectはNSIntegerは変換しないと入らない
        } else {
            if ([inputDateArray[i] isEqualToString:inputDateArray[i-1]]) {
                //セクション数を+1
                sectionCount++;
                // 登録日付をキーにして辞書型にセット
                [sectionCountDic setObject:[NSString stringWithFormat:@"%ld",(long)sectionCount] forKey:inputDateArray[i]];
            } else {
                sectionCount = 0; // セクション数をリセット
                //セクション数を+1
                sectionCount++;
                // 登録日付をキーにして辞書型にセット
                [sectionCountDic setObject:[NSString stringWithFormat:@"%ld",(long)sectionCount] forKey:inputDateArray[i]];
                [displayInputDateArray addObject:inputDateArray[i]];
            }
        }
    }
}

#pragma mark - UITableView
/*! テーブル全体のセクション数を取得する。*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return displayInputDateArray.count;
}
/*! 指定されたセクションのセクション名を取得する。*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [displayInputDateArray objectAtIndex:section];
}

/**
 * 指定されたセクションの件数を取得する
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString *sectionName = [displayInputDateArray objectAtIndex:section];
    return [[sectionCountDic objectForKey:sectionName ] integerValue];
}

/**
 * 指定された箇所のセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TodoListTableViewCell *cell = [_todoTableView
                                   dequeueReusableCellWithIdentifier:@"TodoListTableViewCell" forIndexPath:indexPath];
        if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[TodoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"TodoListTableViewCell"];
    }
    cell.todoText.text =
    [todoList[indexPath.section] objectForKey
     :[displayInputDateArray objectAtIndex:indexPath.section]][indexPath.row];
    return cell;
}

// Cell が選択された時
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath{
    NSLog(@"********indexPath.row:%ld",(long)indexPath.row);
    // toViewController
    
    _sendInputDateStr = displayInputDateArray[indexPath.section];
    [self performSegueWithIdentifier:@"toDotaskForTodoViewController" sender:self];
    
}
#pragma mark - Segue
// Segue で次の SubViewController へ移行するときに情報を渡す
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // identifier が toViewController であることの確認
    if ([[segue identifier] isEqualToString:@"toDotaskForTodoViewController"]) {
        DoTaskForTodoViewController *svc = segue.destinationViewController;
        svc.inputDate = _sendInputDateStr;
        NSLog(@"*********svc.inputDate:%@",svc.inputDate);
    }
}

#pragma mark - BarButtonItem

- (IBAction)pushLastMonthBarButtonItem:(UIBarButtonItem *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate *nowDate = [formatter dateFromString:_displayMonthStr];
    
    // タイトルラベルの前月のデータを取得
    _displayMonthStr = [OutTimeObject getLastMonth:nowDate];
    [self getTodoListData];
    [_todoTableView reloadData];
    self.navigationItem.title = _displayMonthStr;
}
- (IBAction)pushNextMonthBarButtonItem:(UIBarButtonItem *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate *nowDate = [formatter dateFromString:_displayMonthStr];
    
    // タイトルラベルの翌月のデータを取得
    _displayMonthStr = [OutTimeObject getNextMonth:nowDate];
    
    [self getTodoListData];
    [_todoTableView reloadData];
    self.navigationItem.title = _displayMonthStr;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

