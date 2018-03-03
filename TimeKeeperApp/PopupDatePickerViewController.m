//
//  PopupDatePickerViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/31.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "PopupDatePickerViewController.h"
#import "SelectTimeViewController.h"
#import "OutTimeObject.h"

@interface PopupDatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDateFormatter *formatter;                               //NSDateFormatter

@end

@implementation PopupDatePickerViewController {
    NSDateFormatter *dateFormat;
    NSDateFormatter *timeFormat;
    SelectTimeViewController *selectTimeViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.dateLabel.text = [OutTimeObject getNowDate];
//    self.timeLabel.text = [OutTimeObject getNowTime];
    // 機種の暦法に依存する事なく、西暦で処理する設定


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOKBarButtonItem:(UIBarButtonItem *)sender {
    
 
    selectTimeViewController.dateLabel.text = _outDateString;
    selectTimeViewController.timeLabel.text = _outTimeString;
    
}
- (IBAction)tapOkButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //NSDateFormatterクラスを出力する。
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd(E)"];
    _outDateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:_datePicker.date]];
    NSLog(@"%@",_outDateString);
    
    timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    _outTimeString = [NSString stringWithFormat:@"%@", [timeFormat stringFromDate:_datePicker.date]];
    NSLog(@"%@",_outTimeString);

    selectTimeViewController = [[SelectTimeViewController alloc] init];// ←SelectTimeViewController *selectTimeViewController = [[SelectTimeViewController alloc] init];じゃなくしたら Local declaration of 'selectTimeViewController' hides instance variableのエラーが消えた
    [selectTimeViewController setSelectedDateString:self.outDateString];
    NSLog(@"****self.outDateString:%@", self.outDateString);
    NSLog(@"****self.outTimeString:%@", self.outTimeString);
    [selectTimeViewController setSelectedTimeString:self.outTimeString];
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
