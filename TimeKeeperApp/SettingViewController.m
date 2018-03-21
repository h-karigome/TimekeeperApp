//
//  SettingViewController.m
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/11.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
/**
 月別or15日締め設定スイッチ
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *displayMonthSettingSegment;



@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"設定画面";
    
    // 15日締め表示の時
    if ([monthSettingEndDayIs15 isEqualToString:
         [[NSUserDefaults standardUserDefaults] objectForKey:keyMonthSettingSwitch]]) {
        self.displayMonthSettingSegment.selectedSegmentIndex = 1;
    } else {
        // 月別表示の時
        self.displayMonthSettingSegment.selectedSegmentIndex = 0;
    }
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapCloseBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 セグメントの切り替え

 @param sender ここって何書くんだろ
 */
- (IBAction)changeMonthDisplaySetting:(UISegmentedControl *)sender {
    
    switch (self.displayMonthSettingSegment.selectedSegmentIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:monthSettingEndDayIs15 forKey:keyMonthSettingSwitch];
            break;
            
        default:
            [[NSUserDefaults standardUserDefaults] setObject:byMonthSetting forKey:keyMonthSettingSwitch];
            break;
    }
    
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
