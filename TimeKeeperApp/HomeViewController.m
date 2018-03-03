//
//  HomeViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/02.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "HomeViewController.h"
#import "OutTimeListViewController.h"
#import "OutTimeObject.h"
#import "OutTimeDataManager.h"
#import "SelectTimeViewController.h"
#import "AppDelegate.h"
#import "TextDataManager.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *homeToolBar;
@property (weak, nonatomic) IBOutlet UIButton *lookListHomeButton;
@property UIButton *nowTimeHomeButton;
@property UIButton *selectDateHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *todoListBtn; // add 20171121
@property (weak, nonatomic) IBOutlet UIButton *openWebBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [TextDataManager selectTodoList:@"2017年11月"];
//    [TextDataManager testCreateTodoDBfile];
//    [TextDataManager addColumnTest]; // add 20171117
//    [OutTimeObject test];
//    [OutTimeObject lastDayOfMonth];
//    [OutTimeObject lastDayOfMonth2];
//    [TextDataManager testDrop];
//    [TextDataManager testCreateInpuDataDBfile];
//    [OutTimeDataManager addColumnTest];
//    [OutTimeDataManager updateColumnTest];

    [OutTimeDataManager deleteOutDateTime:@"2018/02/17(土)"];
    [OutTimeDataManager deleteOutDateTime:@"2018/02/18(日)"];
    UIImage *image = [UIImage imageNamed:@"ringo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(-15, 220, 400, 400);
    
    // 現在時刻取得ボタン
    UIImage *nowTimeimage = [UIImage imageNamed:@"now_time_home_button2.png"];
    _nowTimeHomeButton = [[UIButton alloc] init];
//    [_nowTimeHomeButton setTitle:@"現在時刻で退勤" forState:UIControlStateNormal];
    [_nowTimeHomeButton setTintColor:[UIColor blackColor]];
//    _nowTimeHomeButton.titleLabel.textColor = [UIColor blackColor];
//    _nowTimeHomeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    _nowTimeHomeButton.backgroundColor = [UIColor whiteColor];
//    _nowTimeHomeButton.layer.borderWidth = 3.0f;
//    _nowTimeHomeButton.layer.borderColor = [UIColor redColor].CGColor;
//    _nowTimeHomeButton.layer.cornerRadius = 10; // 角の丸み
    _nowTimeHomeButton.frame = CGRectMake(20, 80, 150, 80);
    [_nowTimeHomeButton setImage:nowTimeimage forState:UIControlStateNormal];
    [_nowTimeHomeButton addTarget:self action:@selector(getNowTimeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _nowTimeHomeButton];
    
    // リストに遷移ボタン
    UIImage *lookListimage = [UIImage imageNamed:@"list_home_button2.png"];
    _lookListHomeButton.frame = CGRectMake(30, 200, 150, 100);
//    [_lookListHomeButton setTitle:@"退勤リスト" forState:UIControlStateNormal];
    [_lookListHomeButton setTintColor:[UIColor blackColor]];
//    _lookListHomeButton.titleLabel.textColor = [UIColor blackColor];
//    _lookListHomeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    _lookListHomeButton.backgroundColor = [UIColor whiteColor];
//    _lookListHomeButton.layer.borderWidth = 3.0f;
//    _lookListHomeButton.layer.borderColor = [UIColor blueColor].CGColor;
    [_lookListHomeButton setImage:lookListimage forState:UIControlStateNormal];
    [_lookListHomeButton addTarget:self action:@selector(pushOutTimeList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _lookListHomeButton];
    
    // 退勤時刻選択ボタン
    UIImage *selectDateimage = [UIImage imageNamed:@"select_date_home_button2.png"];
    _selectDateHomeButton = [[UIButton alloc] init];
    _selectDateHomeButton.frame = CGRectMake(180, 100, 100, 100);
    [_selectDateHomeButton setImage:selectDateimage forState:UIControlStateNormal];
    [_selectDateHomeButton addTarget:self action:@selector(pushSelectDateButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _selectDateHomeButton];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 現在時刻取得ボタン押下時
 */
- (void)getNowTimeButton {
    NSString *outDateSting = [OutTimeObject getNowDate]; // 現在日
    NSString *outTimeSting = [OutTimeObject getNowTime]; // 現在時刻
    NSString *outMonthStingForTab = [OutTimeObject getNowMonthForTab];
    NSString *outDateStingForTab = [OutTimeObject getNowDateForTab];
    NSString *outDate = [OutTimeObject getNowDateForNowTime];
    
    // 上書きチェック(同じ日付の退勤時刻がすでに入力されている時)
    if ([OutTimeDataManager checkOutDateTime:outDateSting]) {
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"確認"
                                            message:@"退勤時間を上書きしますか？"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   // 処理なし
                               }];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                   NSLog(@"***引数:%@%@%@%@", outDateSting, outTimeSting, outMonthStingForTab, outDate);
                                   
                                   BOOL result = [OutTimeDataManager upDateOutDateTime:outDateSting inTime:@"10:00" outTime:outTimeSting outMonth:outMonthStingForTab outDateForTab:outDate];
                                   
                                   if (result) {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"確認"
                                                                           message:@"退勤時間を上書きしました。"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
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
                                   } else {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"注意"
                                                                           message:@"上書き処理に失敗しました。"
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
        
        [self presentViewController:ac animated:YES completion:nil];
        
    } else {
        
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"確認"
                                            message:@"退勤時間を保存しますか？"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        // Cancel用のアクションを生成
        UIAlertAction * cancelAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"Cancel button tapped.");
                               }];
        
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"OK button tapped.");
                                   NSLog(@"***引数:%@%@%@%@", outDateSting, outTimeSting, outMonthStingForTab, outDate);
                                   // FIXME:新規登録処理(一旦)
                                   BOOL result = [OutTimeDataManager insertOutDateTime:outDateSting inTime:@"10:00" outTime:outTimeSting outMonth:outMonthStingForTab outDateForTab:outDate];
                                   if (result) {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"確認"
                                                                           message:@"退勤時間を保存しました。"
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
    }
    
    
    
}
-(void)pushOkButton {
}


- (void)pushOutTimeList {
    //    OutTimeListViewController *outTimeListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"outTimeListViewController"];
    //
    //    [self presentViewController:outTimeListViewController animated:YES completion:nil];
}

/**
 * 時刻選択ボタン押下時
 */
- (void)pushSelectDateButton {
    SelectTimeViewController *selectTimeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTimeViewController"];
    [self presentViewController:selectTimeViewController animated:YES completion:nil];
}

/**
 * TKPボタン押下時
 */
- (IBAction)pushOpenWebBtn:(UIButton *)sender {
    // URLを入れる
    NSString *webPage = @"http://white-raven.hatenablog.com/entry/2015/03/10/015010";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: webPage]
                                       options:@{}
                             completionHandler:nil];
    
}




@end
