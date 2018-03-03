//
//  SelectTimeViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/09.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "SelectTimeViewController.h"
#import "OutTimeObject.h"
#import "OutTimeDataManager.h"
#import "PopupDatePickerViewController.h"
#import "SelectTimePopupViewController.h"

@interface SelectTimeViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDateFormatter *formatter;

@property (weak, nonatomic) IBOutlet UIButton *dateOKbutton;
@property (weak, nonatomic) IBOutlet UIButton *saveDateButton;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;// add 29171121
//@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSelectSeg;// add 29171125

@end

@implementation SelectTimeViewController {
    NSDateFormatter *dateFormat;
    NSDateFormatter *timeFormat;
    NSString *selectedDateString;
    NSString *selectedTimeString;
    NSString *selectedMonthString;
    NSString *selectedDateForTabString;
    UISegmentedControl *timeSelectSeg;// add 29171125
}
@synthesize selectedDateString;
@synthesize selectedTimeString;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退勤時間入力画面";
//    self.view.backgroundColor = [UIColor yellowColor];
    // 入力時間設定セグメント
    NSArray *setTimeArray = [NSArray arrayWithObjects:@"退社時間", @"出勤時間", @"有給",nil];
//    timeSelectSeg = [timeSelectSeg initWithItems:setTimeArray];
    timeSelectSeg = [[UISegmentedControl alloc] initWithItems:setTimeArray];
    timeSelectSeg.frame = CGRectMake(40, 50, 300, 50);
    [self.view addSubview:timeSelectSeg];
    UIColor *themeColer = [UIColor colorWithRed:142.0/255.0 green:232.0/255.0 blue:115.0/255.0 alpha:1.0];
    [timeSelectSeg setTintColor:themeColer]; // 黄緑
//    [_timeSelectSeg addTarget:self
//                         action:@selector(setStartTime:)
//               forControlEvents:UIControlEventValueChanged];
    
    timeSelectSeg.selectedSegmentIndex = 0;

    // eb3c52 赤
//    UIColor *themeColer2 = [UIColor colorWithRed:235.0/255.0 green:60.0/255.0 blue:82.0/255.0 alpha:1.0];
    
    _dateLabel.layer.borderWidth = 3.0f; //枠線
    _dateLabel.layer.borderColor = themeColer.CGColor;
    _dateLabel.layer.cornerRadius = 10.0f; //角丸
    
    _timeLabel.layer.borderWidth = 3.0f; //枠線
    _timeLabel.layer.borderColor = themeColer.CGColor;
    _timeLabel.layer.cornerRadius = 10.0f; //角丸
    
    self.dateLabel.text = [OutTimeObject getNowDate];
    self.timeLabel.text = [OutTimeObject getNowTime];
    // 機種の暦法に依存する事なく、西暦で処理する設定
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //日付の表示形式を設定
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.calendar = calendar;
    //Localeを指定。ここでは日本を設定。
    [_formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    _formatter.dateFormat = @"yyyy/MM/dd(E) HH:mm";
    
    //DatePickerのカレンダーも西暦で指定
    _datePicker.calendar = calendar;
    //10分刻み
    _datePicker.minuteInterval = 10;
    
    [self.dateOKbutton addTarget:self action:@selector(DatePickerViewOK:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveDateButton addTarget:self action:@selector(seveSelectedDate) forControlEvents: UIControlEventTouchUpInside];
    
}

-(void) viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 日付更新時
- (IBAction)updateDateTimeLabel:(UIDatePicker *)sender {

}

#pragma mark -


//- (IBAction)openStDatePickerView:(id)sender {
//    
//    [self openDatePickerView:sender];
//}
// 「選択」ボタンがタップされたときに呼び出されるメソッド
- (void)DatePickerViewOK:(id)sender {
    
    NSDateFormatter* deteFormatter = [[NSDateFormatter alloc] init];
    [deteFormatter setDateFormat:@"yyyy/MM/dd(E)"];
    selectedDateString = [deteFormatter stringFromDate:self.datePicker.date];
    
    NSDateFormatter* timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    selectedTimeString = [timeFormatter stringFromDate:self.datePicker.date];
    
    NSDateFormatter* monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"yyyy年MM月"];
    selectedMonthString = [monthFormatter stringFromDate:self.datePicker.date];
    
    NSDateFormatter* deteForTabFormatter = [[NSDateFormatter alloc] init];
    [deteForTabFormatter setDateFormat:@"dd(E)"];
    selectedDateForTabString = [deteForTabFormatter stringFromDate:self.datePicker.date];
    
    _datePicker.minuteInterval = 10;
    
    self.dateLabel.text = selectedDateString;
    self.timeLabel.text = selectedTimeString;

}

#pragma mark date picker
// PickerViewのある行が選択されたときに呼び出されるDatePickerViewControllerDelegateプロトコルのデリゲートメソッド
//- (void)applySelectedString:(NSDate *)date
//{
//    NSString *strDate;
//    //    if (_daySwitch.on == YES) {
//    //        strDate = [common dateToString:date formatString:@"MM月dd日(EEE)"];
//    //    } else {
//    strDate = [common dateToString:date formatString:@"MM月dd日(EEE)\n HH:mm"];
//    //    }
//    
//    strDate = date;
//    _dateLabel.text = strDate;
//    
//}

// datePickerViewController上にある透明ボタンがタップされたときに呼び出されるPickerViewControllerDelegateプロトコルのデリゲートメソッド
//- (void)closePickerView:(PickerViewController *)controller
//{
//    // PickerViewをアニメーションを使ってゆっくり非表示にする
//    UIView *pickerView = controller.view;
//    
//    // アニメーション完了時のPickerViewの位置を計算
//    CGSize offSize = [UIScreen mainScreen].bounds.size;
//    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
//    
//    [UIView beginAnimations:nil context:(void *)pickerView];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelegate:self];
//    // アニメーション終了時に呼び出す処理を設定
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    pickerView.center = offScreenCenter;
//    [UIView commitAnimations];
//    
//}

// 単位のPickerViewを閉じるアニメーションが終了したときに呼び出されるメソッド
//- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//{
//    // PickerViewをサブビューから削除
//    UIView *pickerView = (__bridge UIView *)context;
//    [pickerView removeFromSuperview];
//}


- (IBAction)tapCloseBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)saveOutDateTimeButton:(UIButton *)sender {
//    // 退勤時間の保存
//    NSString *outMonthStingForTab = [OutTimeObject getNowMonthForTab];
//    NSString *outDateStingForTab = [OutTimeObject getNowDateForTab];
////    [OutTimeDataManager insertOutDateTime: outTime: outMonth: outDateForTab:];
//}

-(void)seveSelectedDate {
//    // コントローラを生成
//    UIAlertController * ac =
//    [UIAlertController alertControllerWithTitle:@"確認"
//                                        message:@"退勤時間を保存しますか？"
//                                 preferredStyle:UIAlertControllerStyleAlert];
//
//    // Cancel用のアクションを生成
//    UIAlertAction * cancelAction =
//    [UIAlertAction actionWithTitle:@"Cancel"
//                             style:UIAlertActionStyleCancel
//                           handler:^(UIAlertAction * action) {
//                               // ボタンタップ時の処理
//                               NSLog(@"Cancel button tapped.");
//                           }];
//
//    // OK用のアクションを生成
//    UIAlertAction * okAction =
//    [UIAlertAction actionWithTitle:@"OK"
//                             style:UIAlertActionStyleDefault
//                           handler:^(UIAlertAction * action) {
//                               // ボタンタップ時の処理
//                               NSLog(@"OK button tapped.");
////                               [self saveTargetData];
//                               NSLog(@"***引数:%@%@%@%@", selectedDateString, selectedTimeString, selectedMonthString, selectedDateForTabString);
//                               // FIXME: 一旦10:00に
//                               [OutTimeDataManager insertOutDateTime:selectedDateString inTime:@"10:00" outTime:selectedTimeString outMonth:selectedMonthString outDateForTab:selectedDateForTabString];
//                               // キーボードを閉じる
////                               [self.view endEditing:YES];
////                               [self dismissViewControllerAnimated:YES completion:nil];
//                           }];
//
//    // コントローラにアクションを追加
//    [ac addAction:cancelAction];
//    [ac addAction:okAction];
//
//    // アラート表示処理
//    [self presentViewController:ac animated:YES completion:nil];
    // 上書きチェック
    if ([OutTimeDataManager checkOutDateTime:selectedDateString]) {
        NSLog(@"上書き");
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"確認"
                                            message:@"退勤時間を上書きしますか？"
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
                                   NSLog(@"****selectedDateForTabString:%@", selectedDateForTabString);
                                   // ボタンタップ時の処理
                                   BOOL result = [OutTimeDataManager upDateOutDateTime:selectedDateString inTime:@"10:00" outTime:selectedTimeString outMonth:selectedMonthString outDateForTab:selectedDateForTabString];
                                   
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
                                                                  [self dismissViewControllerAnimated:YES completion:nil];

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
        
        // アラート表示処理
        [self presentViewController:ac animated:YES completion:nil];
        
        return;
        
    } else {
        NSLog(@"上書きじゃない");
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
                                   // add 20180131
                                   NSString *lastInputStr = [OutTimeDataManager selectLastInputDateStr:selectedMonthString];
                                   
                                   // FIXME:新規登録処理(一旦)
                                   BOOL result = [OutTimeDataManager insertOutDateTime:selectedDateString inTime:@"10:00" outTime:selectedTimeString outMonth:selectedMonthString outDateForTab:selectedDateForTabString];
                                   // add 20180131
                                   NSMutableArray *resultArr = [NSMutableArray array];
//                                   if (![lastInputStr isEqualToString:selectedDateString]) {
//                                       resultArr = [OutTimeDataManager getInsertDateArray
//                                        :lastInputStr inputDateStr:selectedDateString outMonthStr:selectedMonthString outDateStr:selectedDateForTabString];
//                                   }
//
                                   NSLog(@"************:%@",resultArr);
                                   for (int i = 0; i < resultArr.count; i++) {
                                      result = [OutTimeDataManager insertDateForNotWorkday
                                        :[resultArr[i] objectForKey:@"out_date_info"]
                                        outMonth:[resultArr[i] objectForKey:@"out_month"]
                                        outDateForTab:[resultArr[i] objectForKey:@"out_date"]];
                                   }
                                   
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
                                                                  [self dismissViewControllerAnimated:YES completion:nil];

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

# pragma ポップアップ画面の表示
/**
 * 時間の選択
 */
- (IBAction)pushSelectTimeBtn:(UIButton *)sender {
    UIColor *color = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    
    SelectTimePopupViewController* vc = [[SelectTimePopupViewController alloc] initWithNibName:@"SelectTimePopupViewController" bundle:nil];
    vc.stDelegate = self;// これえええちゃんとデリゲートして！！
    vc.title = @"時間入力";
    //    [inputVC addSubview:sv];
//    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    // Popoverの領域の大きさを設定
    vc.preferredContentSize = CGSizeMake(100, 100);
    vc.modalInPopover = YES;
    
    [[vc.view layer] setMasksToBounds:YES];
//    [vc setCornerRadius:10];
//    [[vc.view layer] setBorderWidth:1.2f];
//    [[vc.view layer] setBorderColor:color.CGColor];
//    vc.navigationBar.barTintColor = color;
//    vc.navigationBar.tintColor = [UIColor whiteColor];
//    vc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
//    [vc setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [vc popoverPresentationController];
    
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = self.view.bounds;
    popPresenter.delegate = (id)self;
//    popPresenter.permittedArrowDirections = 0;  // リファレンスに載っていないが強制的に矢印方向をなしに設定する
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
    
    
    
}
//- (IBAction)selectTimeButton:(UIButton *)sender {
//
////    self.datePickerViewController = [[PopupDatePickerViewController alloc] init];
////    [self addChildViewController:self.datePickerViewController];
////    [self.datePickerViewController didMoveToParentViewController:self];
////    [self.view addSubview:self.datePickerViewController.view];
//    // DatePickerViewControllerのインスタンスをStoryboardから取得し
////    self.datePickerViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PopupDatePickerViewController"];
//}

@end
