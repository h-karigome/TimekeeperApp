//
//  InputDataViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/10.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "InputDataViewController.h"
#import "TextDataManager.h"
#import "AppDelegate.h"

@interface InputDataViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *inputDataTableView;
//@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *workInfoTextField;
@property (weak, nonatomic) IBOutlet UITextView *badPointTextView;
@property (weak, nonatomic) IBOutlet UITextView *goodPointTextView;
@property (weak, nonatomic) IBOutlet UITextField *try1TextField;
@property (weak, nonatomic) IBOutlet UITextField *try2TextField;
@property (weak, nonatomic) IBOutlet UITextField *try3TextField;
@property (weak, nonatomic) IBOutlet UIButton *inputDataSaveButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDataBarButton;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *startTimeSegment;
@end

@implementation InputDataViewController {
    NSString *workInfoTextString;
    //    NSString *workCategoryString;
    NSString *badPointString;
    NSString *goodPointString;
    NSString *startTimeString;
    NSString *tryPointStr; // add 20171117
    UISegmentedControl *startTimeSegment;
    UIBarButtonItem *editDataBarButton;
}
BOOL isSavedDataFlg; // すでにデータありの場合
BOOL isEditTappedFlg = NO; // 編集ボタン押下時

@synthesize inputDateString;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = inputDateString;
    NSLog(@"********inputDateString:%@", inputDateString);
    self.inputDataTableView.allowsSelection = false;
    // 出社時間設定セグメント
    NSArray *startTimeArray = [NSArray arrayWithObjects:@"10:00", @"9:00", @"その他",nil];
    startTimeSegment = [[UISegmentedControl alloc] initWithItems:startTimeArray];
    startTimeSegment.frame = CGRectMake(160, 8, 200, 30);
//    UIColor *defaultColor = [UIColor colorWithRed:142.0 green:232.0 blue:115.0 alpha:1.0];
    [startTimeSegment addTarget:self
                         action:@selector(setStartTime:)
               forControlEvents:UIControlEventValueChanged];
    // AppDelegate *__strong' from incompatible type 'id<UIApplicationDelegate> _Nullableのエラーを解消 20171125
//    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [startTimeSegment setBackgroundColor:appDelegate.themeColer]; // 黄緑
    UIColor *themeColer = [UIColor colorWithRed:142.0/255.0 green:232.0/255.0 blue:115.0/255.0 alpha:1.0];
    [startTimeSegment setTintColor:themeColer]; // 黄緑
    
    if ([@"10:00" isEqualToString:startTimeString]) {
        startTimeSegment.selectedSegmentIndex = 0;
    }
    else if ([@"9:00" isEqualToString:startTimeString]) {
        startTimeSegment.selectedSegmentIndex = 1;
    }
    else if (!startTimeString) {
        // デフォルトは10:00表示にする
        startTimeSegment.selectedSegmentIndex = 0;
        startTimeString = @"10:00";
    }
    else {
        startTimeSegment.selectedSegmentIndex = 2;
        startTimeString = @"9:00";
    }
    
    [self.view addSubview:startTimeSegment];
    
    // 業務ないようはポップアップで追加するようにする、追加するとセルの幅が広くなる
    [self.inputDataSaveButton addTarget:self action:@selector(saveInputData) forControlEvents:UIControlEventTouchUpInside];
    [_workInfoTextField setDelegate:self];
    editDataBarButton = [editDataBarButton initWithTitle:@"編集"
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(editWorkInfo)];
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // 入力済みだったら入力情報を取得する
    NSDictionary *inputtedDataDic = [TextDataManager selectInputData:inputDateString];
    
    if ([inputtedDataDic objectForKey:@"good_point"]) { // 仕方なくこの条件にしてる
        goodPointString = [inputtedDataDic objectForKey:@"good_point"];
        badPointString = [inputtedDataDic objectForKey:@"bad_point"];
        tryPointStr = [inputtedDataDic objectForKey:@"try_point"];
        workInfoTextString = [inputtedDataDic objectForKey:@"work_info"];
        //        workCategoryString = [inputtedDataDic objectForKey:@"work_category"];
        startTimeString = [inputtedDataDic objectForKey:@"start_time"];
        isSavedDataFlg = YES;
        isEditTappedFlg = YES;
    } else {
        isSavedDataFlg = NO;
    }
    
    self.goodPointTextView.text = goodPointString;
    self.badPointTextView.text = badPointString;
    self.workInfoTextField.text = workInfoTextString;
    //    self.categoryButton.titleLabel.text = startTimeString;
    // 分割した結果を保持する変数
    NSMutableDictionary *tryPointDict = [[NSMutableDictionary alloc] init];
    NSArray *tryPointArray = [tryPointStr componentsSeparatedByString:@"＊"];// ＊で文字列を分割
    
    for (int i = 0; i < tryPointArray.count; i++) {
        [tryPointDict setValue:[tryPointArray objectAtIndex:i]
                        forKey:[NSString stringWithFormat:@"%d", i]];
    }
    self.try1TextField.text = [tryPointDict objectForKey:@"0"];
    self.try2TextField.text = [tryPointDict objectForKey:@"1"];
    self.try3TextField.text = [tryPointDict objectForKey:@"2"];
    
    // 開始時間も調整に入れる
    if (isSavedDataFlg) {
        [self holdWorkInfo];
    }else {
        self.goodPointTextView.textColor = [UIColor blackColor];
        self.badPointTextView.textColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField canResignFirstResponder] )
        [textField resignFirstResponder];
    
    return YES;
}
// キーボードを隠す処理
- (void)closeKeyboard {
    [self.view endEditing: YES];
}

# pragma SavedWorkInfo
/**
 * 保存データのセット
 */
-(void) setSavedWorkInfo {
    //    workCategoryString = self.categoryButton.titleLabel.text; //業務カテゴリ
    workInfoTextString = self.workInfoTextField.text; // 業務内容
    badPointString = self.badPointTextView.text; // 反省点
    goodPointString = self.goodPointTextView.text; // よかった点
    tryPointStr = [self getTryPoint:tryPointStr]; // 次にすること(3項目まとめて) add 20171117
}

-(void) saveInputData {
    // FIXME: あとで処理まとめる
    if (isSavedDataFlg) {
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"確認"
                                            message:@"入力情報を上書きしますか？"
                                     preferredStyle:UIAlertControllerStyleAlert];
        // Cancel用のアクションを生成
        UIAlertAction * cancelAction =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                               }];
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self setSavedWorkInfo]; // 保存データをセット
                                   // 保存データを上書き
                                   BOOL result = [TextDataManager
                                          upDateInputData:inputDateString
                                                goodPoint:goodPointString
                                              badPoint:badPointString
                                                  tryPoint:tryPointStr
                                                  workInfo:workInfoTextString];
                                   // FIXME: TODOリストにインサート あとでUPDATEに書き換える
                                   BOOL resultTodo = [TextDataManager insertTodoData:inputDateString tryPoint1:_try1TextField.text tryPoint2:_try2TextField.text tryPoint3:_try3TextField.text];
                                   if (result && resultTodo) {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"確認"
                                                                           message:@"保存しました。"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction * action =
                                       [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  // ボタンタップ時の処理
                                                                  [self.inputDataTableView reloadData];
                                                              }];
                                       isSavedDataFlg = YES;
                                       
                                       [self holdWorkInfo];
                                       
                                       // コントローラにアクションを追加
                                       [ac addAction:action];
                                       // アラート表示処理
                                       [self presentViewController:ac animated:YES completion:nil];
                                       
                                   } else {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"注意"
                                                                           message:@"保存に失敗しました。"
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
        
    } else {
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"確認"
                                            message:@"入力情報を保存しますか？"
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
                                   [self setSavedWorkInfo]; // 保存データをセット
                                   // データのインサート
                                   BOOL result = [TextDataManager insertTextData:self.inputDateString goodPoint:goodPointString badPoint:badPointString tryPoint: tryPointStr workInfo:workInfoTextString startTime:startTimeString];
                                   
                                   // TODOリストにインサート
                                   BOOL resultTodo = [TextDataManager insertTodoData:inputDateString tryPoint1:_try1TextField.text tryPoint2:_try2TextField.text tryPoint3:_try3TextField.text];
                                   
                                   if (result && resultTodo) {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"確認"
                                                                           message:@"保存しました。"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction * action =
                                       [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  // ボタンタップ時の処理
                                                                  [self.inputDataTableView reloadData];
                                                              }];
                                       isSavedDataFlg = YES;
                                       
                                       [self holdWorkInfo];
                                       
                                       // コントローラにアクションを追加
                                       [ac addAction:action];
                                       // アラート表示処理
                                       [self presentViewController:ac animated:YES completion:nil];
                                   } else {
                                       // コントローラを生成
                                       UIAlertController * ac =
                                       [UIAlertController alertControllerWithTitle:@"注意"
                                                                           message:@"保存に失敗しました。"
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
    }
}

# pragma EditWorkInfo
/**
 * 編集
 */
-(void) editWorkInfo {
    // 編集モード
    if (isEditTappedFlg) {
        startTimeSegment.enabled = YES;
        //        self.categoryButton.enabled = YES;
        self.workInfoTextField.enabled = YES;
        self.goodPointTextView.editable = YES;
        self.badPointTextView.editable = YES;
        self.try1TextField.enabled = YES;
        self.try2TextField.enabled = YES;
        self.try3TextField.enabled = YES;
        self.workInfoTextField.textColor = [UIColor blackColor];
        self.goodPointTextView.textColor = [UIColor blackColor];
        self.badPointTextView.textColor = [UIColor blackColor];
        self.try1TextField.textColor = [UIColor blackColor];
        self.try2TextField.textColor = [UIColor blackColor];
        self.try3TextField.textColor = [UIColor blackColor];
        
        [editDataBarButton setTitle:@"キャンセル"];// FIXME: 編集ボタンの切り替えここうまくできてない
        isEditTappedFlg = NO;
        
    } else {
        // 編集モード解除
        [self holdWorkInfo];
        isEditTappedFlg = YES; // 編集可能フラグ
        [editDataBarButton setTitle:@"編集"];
    }
}


/**
 * 保存直後の処理
 */
-(void) holdWorkInfo {
    startTimeSegment.enabled = NO;
    self.workInfoTextField.enabled = NO;
    self.goodPointTextView.editable = NO;
    self.badPointTextView.editable = NO;
    self.workInfoTextField.textColor = [UIColor grayColor];
    self.goodPointTextView.textColor = [UIColor grayColor];
    self.badPointTextView.textColor = [UIColor grayColor];
    self.try1TextField.textColor = [UIColor grayColor];
    self.try2TextField.textColor = [UIColor grayColor];
    self.try3TextField.textColor = [UIColor grayColor];
    self.try1TextField.enabled = NO;
    self.try2TextField.enabled = NO;
    self.try3TextField.enabled = NO;
    [self.inputDataTableView reloadData];// FIXME:これきく？？
    isEditTappedFlg = YES; // 編集可能モードにする
}

/**
 * Tryの三項目をまとめる
 */
-(NSString *)getTryPoint:(NSString *)savedTryPoint {
    NSString * tryPoint = @"";
    // 入力情報がない時
    if (savedTryPoint.length == 0 || !savedTryPoint) {
        tryPoint = [NSString stringWithFormat:@"%@＊%@＊%@", _try1TextField.text,_try2TextField.text, _try3TextField.text];
    } else {
        NSArray *tryPointArray = [savedTryPoint componentsSeparatedByString:@"＊"];
        _try1TextField.text = tryPointArray[0];
        _try2TextField.text = tryPointArray[1];
        _try3TextField.text = tryPointArray[2];
    }
    
    
    return tryPoint;
}

// 出社時間設定
-(void)setStartTime: (UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        startTimeString = @"10:00";
    }
    else if (sender.selectedSegmentIndex == 1) {
        startTimeString = @"9:00";
    }
    else {
        startTimeString = @"その他";
    }
    
}

@end

