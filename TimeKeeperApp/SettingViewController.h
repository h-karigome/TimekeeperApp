//
//  SettingViewController.h
//  TimeKeeperApp
//
//  Created by 苅米春奈 on 2017/07/11.
//  Copyright © 2017年 Haruna Karigome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController
@end

// 設定スイッチ(月別/15日締め)
// TODO: 名前どうしたらいいかわからない。名前考える。
static NSString *const keyMonthSettingSwitch = @"keyMonthSetting";
static NSString *const byMonthSetting = @"byMonthSetting"; // 月別
static NSString *const monthSettingEndDayIs15 = @"monthSettingEndDayIs15"; // 15日締め
