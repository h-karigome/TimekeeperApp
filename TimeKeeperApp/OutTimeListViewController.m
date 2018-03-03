//
//  OutTimeListViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "OutTimeListViewController.h"
#import "OutTimeDataManager.h"
#import "OutTimeListTableViewCell.h"
#import "InputDataViewController.h"
#import "PopupDatePickerViewController.h"
#import "OutTimeObject.h"
#import "TextDataManager.h"

@interface OutTimeListViewController()<UITableViewDelegate, UITableViewDataSource>

@property (copy)NSString *sumWorkingTimeString; // 総勤務時間
@property (nonatomic, retain) NSMutableArray *inputtedDataArray; // 入力済み日

@end

@implementation OutTimeListViewController {
    NSMutableArray *outDateInfoArray;
    NSMutableArray *outTimeArray;
    NSMutableArray *selectOutArray;
    NSMutableArray *inTimeArray;
    NSMutableArray *workingTimeArray;
    NSMutableArray *displayIconArray; // りんご
    NSString *nowMonthString; // 今月分の退勤データ表示用
    NSString *outMonthString;// 各月の退勤データ表示用
    BOOL isDisplayedIcon; //アイコン表示画面フラグ

}

-(void) viewDidLoad {
    [super viewDidLoad];
    nowMonthString = [OutTimeObject getNowDateForTab];
    // TODO:タブに表示する月を取得だったけどタブに表示しなくなったので名前要変更
    outMonthString = nowMonthString;// 初期表示時は現在の月のデータを表示
    [self getOutTimeDataList]; // 退勤データ一覧情報の取得
    NSLog(@"viewDidLoad*******");
    
    isDisplayedIcon = NO; // 初期遷移時はアイコン表示でない
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear****");

    self.outTimeListTableView.delegate = self;
    self.outTimeListTableView.dataSource = self;
    
    self.navigationItem.title = outMonthString;
    self.navigationItem.rightBarButtonItem.title = @"";
    
    // 各月の総勤務時間の取得 add 20170131
    _sumWorkingTimeString = [[NSString alloc]init];
    _sumWorkingTimeString = [OutTimeObject getSumWoringTime:workingTimeArray];
    NSLog(@"*******各月の総勤務時間の取得%@", _sumWorkingTimeString);
    
    _inputtedDataArray = [TextDataManager checkInputtedTextData:outMonthString];
    NSLog(@"********_inputtedDataArray：%@" , _inputtedDataArray); // add 20180131
    
//    [OutTimeDataManager test:@"2018/02/09(金)" inputDateStr:@"2018/02/12(月)"];
    
    [_outTimeListTableView reloadData]; // add 20180131
    // ハイライト解除 add 20180131
    [self.outTimeListTableView deselectRowAtIndexPath:[self.outTimeListTableView indexPathForSelectedRow] animated:YES];
}

/**
 * セルの生成
 */
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutTimeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.iconLabel.frame = CGRectMake(80, 13, 300, 20); // りんご(退勤時間アイコン)
    
    // 入力済みスタンプ
    [cell.inputtedImageView setImage:[UIImage imageNamed:@"check_stamp_40.png"]];
    
    // アイコン表示以外の時 // add 20180131
    if (!isDisplayedIcon) {
        // 最後の行に、営業日数と総勤務時間を表示
        if (indexPath.row == _outDateArray.count) {
            
            cell.outTimeDateLabel.hidden = YES;
            cell.inTimeLabel.hidden = YES;
            cell.outTimeLabel.hidden = YES;
            cell.workingTimeLabel.hidden = YES;
            cell.sumWorkingDayLabel.hidden = NO;
            cell.sumWoringTimeLabel.hidden = NO;
            cell.iconLabel.hidden = YES;
            cell.sumWoringTimeLabel.frame = CGRectMake(20, 13, 200, 20); // 各月の総勤務時間
            cell.sumWorkingDayLabel.frame = CGRectMake(200, 13, 200, 20); // 各月の営業日数
            cell.sumWoringTimeLabel.text = [NSString stringWithFormat:@"総勤務時間：%@時間",_sumWorkingTimeString];
            cell.sumWorkingDayLabel.text = [NSString stringWithFormat:@"総勤務日数：%lu日",_outDateArray.count];
            
            cell.inputtedImageView.hidden = YES; // add 20180131
            
            // セルの選択不可にする// add 20180131
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            // add 20180131
            cell.outTimeDateLabel.hidden = NO;
            cell.inTimeLabel.hidden = NO;
            cell.outTimeLabel.hidden = NO;
            cell.workingTimeLabel.hidden = NO;
            cell.sumWorkingDayLabel.hidden = YES;
            cell.sumWoringTimeLabel.hidden = YES;
            cell.iconLabel.hidden = YES;
            
            // 退勤日
            cell.outTimeDateLabel.text = _outDateArray[indexPath.row];
            cell.inTimeLabel.frame = CGRectMake(60, 13, 150, 20); // 出勤時間
            cell.workingTimeLabel.frame = CGRectMake(200, 13, 60, 20); // 勤務時間
            // 出社時間
            [cell.contentView addSubview:cell.inTimeLabel];// contentViewを忘れないこと
            
            if (![@""isEqualToString:inTimeArray[indexPath.row]]) {
                cell.inTimeLabel.text = [NSString stringWithFormat:@"%@〜", inTimeArray[indexPath.row]];
            } else {
                cell.inTimeLabel.text = @"";
            }
            
            // 退勤時間
            cell.outTimeLabel.text = outTimeArray[indexPath.row];
            // 勤務時間
            [cell.contentView addSubview:cell.workingTimeLabel];// contentViewを忘れないこと
            cell.workingTimeLabel.textAlignment = NSTextAlignmentRight;
            
            if (![@"" isEqualToString:workingTimeArray[indexPath.row]]) {
                cell.workingTimeLabel.text = [NSString stringWithFormat:@"%@H", workingTimeArray[indexPath.row]];
            } else {
                cell.workingTimeLabel.text = @"";
            }
           
            if (_inputtedDataArray.count == 0) {
                cell.inputtedImageView.hidden = YES;
            }
            
            for (int i = 0; i < _inputtedDataArray.count; i++) { // add 20180131
                if ([cell.outTimeDateLabel.text isEqualToString: _inputtedDataArray[i]]) {
                    cell.inputtedImageView.hidden = NO;
                    break;
                } else {
                    cell.inputtedImageView.hidden = YES;
                }
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else {
        // アイコン表示時
        cell.inTimeLabel.hidden = YES;
        cell.outTimeLabel.hidden = YES;
        cell.workingTimeLabel.hidden = YES;
        cell.iconLabel.hidden = NO;
        cell.sumWorkingDayLabel.hidden = YES; // add 20180131
        cell.sumWoringTimeLabel.hidden = YES; // add 20180131
        
        cell.inputtedImageView.hidden = YES; // add 20180131
        // りんご(退勤時間アイコン)
        cell.iconLabel.text = displayIconArray[indexPath.row];
        cell.iconLabel.textAlignment = NSTextAlignmentLeft;
        // 9時間以上の勤務で赤文字にする
        if (8 < cell.iconLabel.text.length) {
            cell.iconLabel.textColor = [UIColor redColor];
        } else {
            cell.iconLabel.textColor = [UIColor greenColor];
        }
        NSLog(@"***displayIconArray:%@", displayIconArray);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[OutTimeListTableViewCell alloc] initWithStyle
                :UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}

/**
 * セルの個数
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // アイコン表示以外の時 add 20180131
    if (!isDisplayedIcon) {
        return selectOutArray.count+1;
    }
    return selectOutArray.count;
}

/**
 * セルをタップした時 add 20180131
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == _outDateArray.count) {
        return;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InputDataViewController *inputDataViewController = [storyboard instantiateViewControllerWithIdentifier:@"inputDataViewController"];
        
        NSIndexPath *indexPath = self.outTimeListTableView.indexPathForSelectedRow;
        // こんな宣言できるのかー！！
        inputDataViewController.inputDateString = outDateInfoArray[indexPath.row];

        // Pushで遷移
        [self.navigationController pushViewController:inputDataViewController animated:YES];
    }
}

/**
 * なんぞや // add 20180131
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
          title:@"削除"
        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 先にデータソースを削除する
        [selectOutArray removeObjectAtIndex:indexPath.row];
        // UITableViewの行を削除する
        NSArray *deleteArray = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
            // add 2017/11/28
            // コントローラを生成
            UIAlertController * ac =
            [UIAlertController alertControllerWithTitle:@"確認"
                                                message:@"入力データを削除しますか？"
                                         preferredStyle:UIAlertControllerStyleAlert];
            // Cancel用のアクションを生成
            UIAlertAction * cancelAction =
            [UIAlertAction actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"Cancel button tapped.");
                                   return;
                                   }];
            // OK用のアクションを生成
            UIAlertAction * okAction =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"OK button tapped.");
                                   BOOL result = NO;
                if (result) {
                    // コントローラを生成
                    UIAlertController * ac =
                    [UIAlertController alertControllerWithTitle:@"確認"
                                                        message:@"入力データを削除しました。"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * action)
                    {
                                                                    
                                                                }];
 
                    // コントローラにアクションを追加
                    [ac addAction:action];
                
                    // アラート表示処理
                    [self presentViewController:ac animated:YES completion:nil];
                    return;
                    
                } else {
                    // コントローラを生成
                    UIAlertController * ac =
                    [UIAlertController alertControllerWithTitle:@"注意"
                                                        message:@"登録処理に失敗しました。"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    // Cancel用のアクションを生成
                    UIAlertAction * action =
                    [UIAlertAction actionWithTitle:@"OK"
                                             style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * action) {
                    // ボタンタップ時の処理
                    NSLog(@"Cancel button tapped.");
                    }];
                    // コントローラにアクションを追加
                    [ac addAction:action];
                    
                    // アラート表示処理
                    [self presentViewController:ac animated:YES completion:nil];
                    return;
                }
        }];
                                                  
                        // コントローラにアクションを追加
                        [ac addAction:cancelAction];
                        [ac addAction:okAction];
                        // アラート表示処理
                        [self presentViewController:ac animated:YES completion:nil];
                        return;
            
        }],
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                           title:@"キャンセル"
                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         [tableView setEditing:NO animated:YES];
                                         NSLog(@"***処理なし***");
        }],
        ];
}

/**
 * 退勤リスト表示用のデータ取得
 */
-(void) getOutTimeDataList {
    selectOutArray = [[NSMutableArray alloc] init];
    selectOutArray = [OutTimeDataManager selectOutDateTime:nowMonthString];
    outDateInfoArray = [[NSMutableArray alloc] init]; //情報入力画面に渡すよう
    _outDateArray = [[NSMutableArray alloc] init];
    inTimeArray = [[NSMutableArray alloc] init];
    outTimeArray = [[NSMutableArray alloc] init];
    workingTimeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < selectOutArray.count ; i++) {
        outMonthString = [selectOutArray[0] objectForKey:@"out_month"];
        [outDateInfoArray addObject:[selectOutArray[i] objectForKey:@"out_date_info"]];
        [_outDateArray addObject: [selectOutArray[i] objectForKey:@"out_date"]];
        [outTimeArray addObject: [selectOutArray[i] objectForKey:@"out_time"]];
        [inTimeArray addObject:[selectOutArray[i] objectForKey:@"in_time"]];
        [workingTimeArray addObject:[selectOutArray[i] objectForKey:@"work_time"]];
    }
    // りんご(退勤時間アイコン)の取得
    displayIconArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [self countApple];
    for (int i = 0; i < selectOutArray.count ; i++) {
        [displayIconArray addObject:[dic objectForKey:[NSString stringWithFormat:@"%ld", (long)i]]];
    }
}

/**
 * りんご(アイコン)生成 add 20180131
 */
- (NSMutableDictionary *)countApple {

    NSMutableDictionary *iconDic = [NSMutableDictionary dictionary];
    // 時間の長さだけfor文回して追加
    for (int i = 0; i < selectOutArray.count ; i++) {
        NSString *displayIcon = workingTimeArray[i];
        NSInteger displayIconInt= [displayIcon intValue];
        NSMutableArray *iconArray = [[NSMutableArray alloc] init];
        NSString * icon = @"";
        for (int i = 0; i < displayIconInt; i++) {
            [iconArray addObject:@""];
        }
        icon = [iconArray componentsJoinedByString:@""]; //配列の文字化
        [iconDic setObject:icon forKey:[NSString stringWithFormat:@"%d", i]];
    }
    NSLog(@"****iconDic:%@",iconDic);
    return iconDic;
}

- (IBAction)pushCloseOutTimeListButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///**
// * 入力画面にタップした日付を渡す セグエあんまり使わないほうがいいらしい
// */
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//        InputDataViewController *inputDataViewController = segue.destinationViewController;
//        NSIndexPath *indexPath = self.outTimeListTableView.indexPathForSelectedRow;
//        // こんな宣言できるのかー！！
//    inputDataViewController.inputDateString = outDateInfoArray[indexPath.row];
//}

- (IBAction)popupBarButton:(UIBarButtonItem *)sender {
}

/**
 * 翌月の退勤データを取得
 */
- (IBAction)getNextMonthData:(UIBarButtonItem *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate *nowDate = [formatter dateFromString:outMonthString];
    outMonthString = [OutTimeObject getNextMonth:nowDate];// タイトルラベルの翌月のデータを取得
    
    selectOutArray = [[NSMutableArray alloc] init];
    selectOutArray = [OutTimeDataManager selectOutDateTime:outMonthString];
    
    outDateInfoArray = [[NSMutableArray alloc] init]; //情報入力画面に渡すよう
    _outDateArray = [[NSMutableArray alloc] init];
    inTimeArray = [[NSMutableArray alloc] init];
    outTimeArray = [[NSMutableArray alloc] init];
    workingTimeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < selectOutArray.count ; i++) {
        
        outMonthString = [selectOutArray[0] objectForKey:@"out_month"];
        [outDateInfoArray addObject:[selectOutArray[i] objectForKey:@"out_date_info"]];
        [_outDateArray addObject: [selectOutArray[i] objectForKey:@"out_date"]];
        [outTimeArray addObject: [selectOutArray[i] objectForKey:@"out_time"]];
        [inTimeArray addObject:[selectOutArray[i] objectForKey:@"in_time"]];
        [workingTimeArray addObject:[selectOutArray[i] objectForKey:@"work_time"]];
    }
    // りんご(退勤時間アイコン)の取得
    displayIconArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [self countApple];
    for (int i = 0; i < selectOutArray.count ; i++) {
        [displayIconArray addObject:[dic objectForKey:[NSString stringWithFormat:@"%ld", (long)i]]];
    }
    
    [self.outTimeListTableView reloadData];
    self.navigationItem.title = outMonthString;
    // 各月の総勤務時間の取得
    _sumWorkingTimeString = [[NSString alloc]init];// add 20180131
    _sumWorkingTimeString = [OutTimeObject getSumWoringTime:workingTimeArray];
    
    _inputtedDataArray = [TextDataManager checkInputtedTextData:outMonthString];
    NSLog(@"********_inputtedDataArray：%@" , _inputtedDataArray); // add 20180131
    
    NSLog(@"*******各月の総勤務時間の取得%@", _sumWorkingTimeString);
}

/**
 * 前月の退勤データを取得
 */
- (IBAction)getLastMonthData:(UIBarButtonItem *)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate *nowDate = [formatter dateFromString:outMonthString];
    outMonthString = [OutTimeObject getLastMonth:nowDate];// タイトルラベルの前月のデータを取得
    
    selectOutArray = [[NSMutableArray alloc] init];
    selectOutArray = [OutTimeDataManager selectOutDateTime:outMonthString];
    
    outDateInfoArray = [[NSMutableArray alloc] init]; //情報入力画面に渡すよう
    _outDateArray = [[NSMutableArray alloc] init];
    inTimeArray = [[NSMutableArray alloc] init];
    outTimeArray = [[NSMutableArray alloc] init];
    workingTimeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < selectOutArray.count ; i++) {
        
        outMonthString = [selectOutArray[0] objectForKey:@"out_month"];
        [outDateInfoArray addObject:[selectOutArray[i] objectForKey:@"out_date_info"]];
        [_outDateArray addObject: [selectOutArray[i] objectForKey:@"out_date"]];
        [outTimeArray addObject: [selectOutArray[i] objectForKey:@"out_time"]];
        [inTimeArray addObject:[selectOutArray[i] objectForKey:@"in_time"]];
        [workingTimeArray addObject:[selectOutArray[i] objectForKey:@"work_time"]];
    }
    // りんご(退勤時間アイコン)の取得
    displayIconArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [self countApple];
    for (int i = 0; i < selectOutArray.count ; i++) {
        [displayIconArray addObject:[dic objectForKey:[NSString stringWithFormat:@"%ld", (long)i]]];
    }
    
    [self.outTimeListTableView reloadData];
    self.navigationItem.title = outMonthString;
    // 各月の総勤務時間の取得
    _sumWorkingTimeString = [[NSString alloc]init]; // add 20180131
    _sumWorkingTimeString = [OutTimeObject getSumWoringTime:workingTimeArray];
    
    _inputtedDataArray = [TextDataManager checkInputtedTextData:outMonthString];
    NSLog(@"********_inputtedDataArray：%@" , _inputtedDataArray); // add 20180131
    
    NSLog(@"*******各月の総勤務時間の取得%@", _sumWorkingTimeString);
}

/**
 * りんごアイコンページの表示
 */
- (IBAction)showOutTimeIcon:(UIBarButtonItem *)sender {
    
    if (!isDisplayedIcon) {
        isDisplayedIcon = YES;
    } else {
        isDisplayedIcon = NO;
    }
    
    [self.outTimeListTableView reloadData];
}



@end
